systemctl --user daemon-reload
systemctl --user enable --now rclone-mount@0xd00f00.service
systemctl --user enable --now rclone-mount@artem1999k.service
systemctl --user enable --now rclone-mount@azedugo105.service
sudo loginctl enable-linger "$USER"
