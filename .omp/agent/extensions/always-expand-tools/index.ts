import type { ExtensionAPI } from "@oh-my-pi/pi-coding-agent";

/**
 * Keep tool output expanded for the whole session.
 *
 * - Enables expanded mode when the session starts
 * - Re-enables it before every tool execution (if a user toggled it off)
 */
export default function (pi: ExtensionAPI) {
	const ensureExpanded = (expanded: boolean, setExpanded: (next: boolean) => void) => {
		if (expanded !== true) {
			setExpanded(true);
		}
	};

	pi.on("session_start", async (_event, ctx) => {
		ensureExpanded(ctx.ui.getToolsExpanded(), ctx.ui.setToolsExpanded);
	});

	pi.on("tool_execution_start", async (_event, ctx) => {
		ensureExpanded(ctx.ui.getToolsExpanded(), ctx.ui.setToolsExpanded);
	});
}
