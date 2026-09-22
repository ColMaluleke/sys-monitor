##Disk Usage
get_disk_usage() {
    df -h | awk '
    NR==2  {
        gsub(/%/, "", $5)
        print $5
    }'
if [ "$disk_usage" -gt 70 ]; then
    echo "Warning: Disk usage is above 70%!"
fi
}

##RAM Usage
get_ram_usage() {
    free -m | awk '
    /Mem:/ {
        printf("%.0f", ($3/$2)*100)
    }'
if [ "$ram_usage" -gt 70 ]; then
    echo "Warning: RAM usage is above 70%!"
fi
}

##Failed SSH Login Attempts
get_failed_ssh_attempts() {
    
    awk '
    /Failed password/ {
            count++
    }
    END {
        print count+0
    }' /var/log/auth.log
}

##Count error-level events in the last hour
get_error_events() {
    journalctl \
     --since "1 hour ago" \
     -p err \
     --no-pager 2>/dev/null | wc -l
}

##Create a JSON writer function for report
write_report() {

    timestamp=$(date -Iseconds)

    disk=$(get_disk_usage)
    ram=$(get_ram_usage)
    failed=$(get_failed_ssh_attempts)
    errors=$(get_error_events)

    file="$OUTPUT_DIR/sys_report-$(date +%Y%m%d-%H%M%S).json"

    echo "Disk Usage: $disk%"
    echo "RAM Usage: $ram%"
    echo "Failed SSH Attempts: $failed"
    echo "Error Events in the Last Hour: $errors"
    echo "Writing report to $file"

    cat <<EOF > "$file"
{
    "timestamp": "$timestamp",
    "system": {
        "disk_usage": "$disk",
        "ram_usage": "$ram",
    },
    "security": {
        "failed_ssh_attempts": "$failed",
    },
    "logs": {
        "recent_errors": "$errors"
    }
}
EOF

    echo "Report written to $file"
}


#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="$SCRIPT_DIR/output"

mkdir -p "$OUTPUT_DIR"

#Function
main() {
    write_report
}

main