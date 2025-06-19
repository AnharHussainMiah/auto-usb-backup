# USB Auto Backup Script

As part of my journey to "DeGoogling" and self-hosting, one of the most critical things I needed to take care of was our **personal data**.

Not relying on the cloud means we can’t just offload all responsibilities - especially not **backups**!

I tried numerous solutions, but they all had their own set of quirks, bugs, or unnecessary complexity.

Out of frustration, I did what any sane \*NIX user would do:

**Write a damn bash script!**

Thankfully, the [Unix Philosophy](https://en.wikipedia.org/wiki/Unix_philosophy) came to the rescue — a few simple tools chained together can do the job more reliably and transparently than most bloated backup systems.

This script does one job:

**Automatically back up specified data to a USB drive, whenever it's mounted and detected.**

---

## How It Works

The script runs in a loop, periodically checking for a mounted USB drive matching your configuration (e.g., a specific label, UUID, or mount path). When found, it initiates a backup from your configured source directories.

No udev rules. No overengineering. Just simple detection logic and reliable file sync.

---

## Features

- Runs continuously in the background via `systemd`
- Detects when your USB backup drive is mounted
- Uses `rsync` for efficient incremental backups
- Minimal dependencies — just bash and standard GNU utilities
- Easily configurable paths and backup logic
- Can backup multiple folders!
- Logs actions for debugging and audit
- Easy to extend and add your own custom logic or extra requirements e.g notifications etc

---

## Installation

1. **Clone or copy the script** to a location of your choice, e.g., `/opt/usb-backup/`:

```bash
sudo mkdir -p /opt/usb-backup
sudo cp auto-usb-backup.sh /opt/usb-backup/
sudo chmod +x /opt/usb-backup/auto-usb-backup.sh
```

2. Clone or copy the script to a location of your choice, e.g., `/opt/usb-backup/`:

```bash
sudo cp auto-usb-backup.service.example /etc/systemd/system/auto-usb-backup.service
```

Edit the service file to match your script path or configuration if needed:

```ini
[Unit]
Description=Automatic USB data backup
After=network.target

[Service]
ExecStart=/opt/usb-backup/auto-usb-backup.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

3. Enable and start the service:

```bash
sudo systemctl daemon-reload
sudo systemctl enable auto-usb-backup.service
sudo systemctl start auto-usb-backup.service
```

## Usage

Once installed and enabled, the script runs automatically in the background.

To control or inspect the service:

```bash
# Start manually
sudo systemctl start auto-usb-backup.service

# Check current status
sudo systemctl status auto-usb-backup.service

# View logs
journalctl -u auto-usb-backup.service

```

As long as the service is running, it will detect your USB backup drive when mounted and begin syncing your configured data.

## License

MIT or WTFPL — use, modify, and share as you like.

## Contributions

Issues and PRs welcome. If you've made a cool improvement or added compatibility for more use cases, feel free to contribute!
