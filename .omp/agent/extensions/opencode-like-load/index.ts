import type { ExtensionAPI } from "@oh-my-pi/pi-coding-agent";
import { existsSync, readFileSync, readdirSync } from "node:fs";
import { basename, dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

type Frontmatter = {
	model?: string;
	description?: string;
};

type CommandSpec = {
	name: string;
	path: string;
	description: string;
};

const THIS_FILE = fileURLToPath(import.meta.url);
const THIS_DIR = dirname(THIS_FILE);
const USER_COMMANDS_DIR = join(THIS_DIR, "..", "..", "commands");

function parseFrontmatter(source: string): { frontmatter: Frontmatter; body: string } {
	const match = source.match(/^---\r?\n([\s\S]*?)\r?\n---\r?\n?/);
	if (!match) {
		return { frontmatter: {}, body: source };
	}

	const frontmatterRaw = match[1];
	const body = source.slice(match[0].length);
	const frontmatter: Frontmatter = {};

	for (const line of frontmatterRaw.split(/\r?\n/)) {
		const keyValue = line.match(/^([a-zA-Z0-9_-]+):\s*(.*)$/);
		if (!keyValue) continue;

		const [, key, value] = keyValue;
		const normalizedValue = value.trim();

		if (key === "model") frontmatter.model = normalizedValue;
		if (key === "description") frontmatter.description = normalizedValue;
	}

	return { frontmatter, body };
}

function discoverCommands(commandsDir: string): CommandSpec[] {
	if (!existsSync(commandsDir)) return [];

	const entries = readdirSync(commandsDir, { withFileTypes: true })
		.filter(entry => entry.isFile() && entry.name.endsWith(".md"))
		.sort((a, b) => a.name.localeCompare(b.name));

	const seen = new Set<string>();
	const commands: CommandSpec[] = [];

	for (const entry of entries) {
		const name = basename(entry.name, ".md");
		if (!name || seen.has(name)) continue;
		seen.add(name);

		const path = join(commandsDir, entry.name);
		let description = `Expand shell macros from ${entry.name} and send prompt`;
		try {
			const raw = readFileSync(path, "utf8");
			const { frontmatter } = parseFrontmatter(raw);
			if (frontmatter.description) {
				description = frontmatter.description;
			}
		} catch {
			// Keep fallback description.
		}

		commands.push({ name, path, description });
	}

	return commands;
}

function normalizeArgs(args: unknown): string[] {
	if (Array.isArray(args)) {
		return args.filter((value): value is string => typeof value === "string");
	}
	if (typeof args === "string") {
		return args.length > 0 ? [args] : [];
	}
	if (args && typeof args === "object" && "args" in args) {
		const nested = (args as { args?: unknown }).args;
		if (Array.isArray(nested)) {
			return nested.filter((value): value is string => typeof value === "string");
		}
	}

	return [];
}

function applyArguments(template: string, args: string[]): string {
	const joinedArgs = args.join(" ");
	let rendered = template.replace(/\$ARGUMENTS|\$@/g, joinedArgs);

	rendered = rendered.replace(/\$(\d+)/g, (_match, indexText: string) => {
		const index = Number.parseInt(indexText, 10) - 1;
		if (!Number.isFinite(index) || index < 0) return "";
		return args[index] ?? "";
	});

	return rendered;
}

async function replaceAllAsync(
	input: string,
	regex: RegExp,
	replacer: (capture: string) => Promise<string>,
): Promise<string> {
	const matches = [...input.matchAll(regex)];
	if (matches.length === 0) return input;

	let output = input;
	for (const match of matches.reverse()) {
		const fullMatch = match[0];
		const capture = match[1] ?? "";
		const start = match.index ?? 0;
		const replacement = await replacer(capture);
		output = output.slice(0, start) + replacement + output.slice(start + fullMatch.length);
	}

	return output;
}

async function runShell(command: string, cwd: string): Promise<string> {
	const process = Bun.spawn(["bash", "-lc", command], {
		cwd,
		stdout: "pipe",
		stderr: "pipe",
	});

	const [stdout, stderr, exitCode] = await Promise.all([
		new Response(process.stdout).text(),
		new Response(process.stderr).text(),
		process.exited,
	]);

	if (exitCode !== 0) {
		const details = stderr.trim() || stdout.trim();
		throw new Error(`Shell command failed (${exitCode}): ${command}${details ? `\n${details}` : ""}`);
	}

	return stdout.trimEnd();
}

async function expandShellMacros(template: string, cwd: string): Promise<string> {
	let expanded = await replaceAllAsync(
		template,
		/!```(?:bash|sh)?\r?\n([\s\S]*?)```/g,
		async command => runShell(command.trim(), cwd),
	);

	expanded = await replaceAllAsync(expanded, /!`([^`]+)`/g, async command =>
		runShell(command.trim(), cwd),
	);

	return expanded;
}

export default function opencodeLikeLoad(pi: ExtensionAPI): void {
	const commandSpecs = discoverCommands(USER_COMMANDS_DIR);

	if (commandSpecs.length === 0) {
		pi.logger.warn(`No user command templates found in ${USER_COMMANDS_DIR}`);
		return;
	}

	let commandsRegistered = false;
	const registerCommands = () => {
		if (commandsRegistered) return;
		commandsRegistered = true;

		for (const spec of commandSpecs) {
			pi.registerCommand(spec.name, {
				description: spec.description,
				handler: async (args, ctx) => {
					try {
						const raw = readFileSync(spec.path, "utf8");
						const { frontmatter, body } = parseFrontmatter(raw);
						const positionalArgs = normalizeArgs(args);
						const withArguments = applyArguments(body, positionalArgs);

						if (frontmatter.model) {
							await pi.setModel(frontmatter.model);
						}

						const renderedPrompt = await expandShellMacros(withArguments, ctx.cwd);
						await pi.sendUserMessage(renderedPrompt, { deliverAs: "steer" });
					} catch (error) {
						const message = error instanceof Error ? error.message : String(error);
						ctx.ui.notify(`[/${spec.name}] ${message}`, "error");
					}
				},
			});
		}
	};

	// Register slash handlers after runtime initialization.
	// This keeps native markdown commands as the single autocomplete entry, while
	// extension handlers still take precedence at execution time.
	pi.on("session_start", () => {
		registerCommands();
	});
}
