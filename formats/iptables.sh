#!/bin/bash
# ReportedIP Blacklist - iptables Script
# https://reportedip.de
#
# IMPORTANT: Data is delayed by 48 hours.
# For real-time threat intelligence via API, contact: 1@reportedip.de
#
# Generated: 2026-02-28T21:23:08+00:00
# Total IPs: 0
#


# Create or flush chain
iptables -N REPORTEDIP_BLOCK 2>/dev/null || iptables -F REPORTEDIP_BLOCK


# Add chain to INPUT if not already present
iptables -C INPUT -j REPORTEDIP_BLOCK 2>/dev/null || iptables -I INPUT -j REPORTEDIP_BLOCK
