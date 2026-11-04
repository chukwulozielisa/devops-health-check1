#!/bin/bash

############################################################
# Name: Lisa
# Date: 04/11/2026
# Script: devops-health-check.sh
# Version: V1
# Purpose: Linux server health monitoring
# ##############################################################

set -e
set -o pipefail

set -x #debugging 

trap 'echo ""; echo ==========================================================";   HEALTH CHECK COMPLETED SUCCESSFULLY"; echo "========================================================";' EXIT

echo "================================================="
echo "      DEVOPS NODE HEALTH REPORT                  "
echo "================================================="
echo ""
#Display Hostname
hostname
echo "Hostname:"
echo ""

# Display current user
whoami
echo "Current user:"
echo ""

# Display date
echo "DATE AND TIME"
date
echo ""

echo "============================================="
echo "     SYSTEM RESOURCE USAGE                   "
echo "============================================="


# Display disk usage
echo "Disk usage:"
df -h 
echo ""

# Display memory usage
echo "Memory usage"
free -h
echo ""

# Display CPU count
nproc
echo "CPU Count:"
echo ""

# Display system uptime
echo "SYSTEM UPTIME"
uptime
echo ""

echo "==============================================="
echo "       PROCESS & SERVICE                       "
echo "==============================================="


# Running process while using pipe
echo "SSH SERVICE PROCESS CHECK"
if ps -ef | grep -v grep | grep -q ssh; then
    echo "SSH SERVICE is active"
else 
    echo "SSH SERVICE is inactive"
fi 
echo ""

# for this example ps -e gives output of all process while head -n 10 gets only the first 10 lines 

echo "TOP MEMORY-CONSUMING PROCESSES:"
ps aux | head -n 6
echo ""


# ps aux is used to generate a complete list of every single process currently running on the OS. I piped grep root to search through the text and filter everything except processes associated with roots.

# using if else statement
THRESHOLD=80
CURRENT_USAGE=$(df / | awk 'NR ==2 {print $5}' | tr -d '%')

if [ "$CURRENT_USAGE" -gt "THRESHOLD" ]; then
    echo "Disk is too high"
else 
    echo "Disk is healthy"
fi
echo ""

# for loop to check services
SERVICES="ssh cron ufw"
for service in $SERVICES; do
    echo -n "checking $service..."
    if systemctl is-active --quiet "$service" 2>/dev/null; then
        echo "$service is running"
    else
        echo "$service is not running"
    fi
done

# REmote check with curl

TARGET_URL="https://example.com"
if curl -I --silent --head --fail "$TARGET_URL" >/dev/null; then
    echo "Remote website responded successfully"
else
    echo "Failed"
fi

# using find 
find /etc -name "*.conf" 2>/dev/null |head -n 3
