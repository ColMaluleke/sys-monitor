# Linux System Monitor

A modular Bash monitoring solution built on Ubuntu WSL2.

## Features

- Root filesystem monitoring
- RAM utilization monitoring
- SSH authentication log analysis
- Journalctl error parsing
- Structured JSON reports
- Cron automation every 15 minutes

## Technologies

- Bash
- awk
- grep
- df
- journalctl
- cron
- VS Code
- WSL2

## Sample Output

{
  "timestamp": "2026-09-22T16:00:00",
  "system": {
    "disk_usage_percent": 41,
    "memory_usage_percent": 63
  }
}
