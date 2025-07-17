#!/usr/bin/env bash
# Copyright The Conforma Contributors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0

# Debug script for KIND cluster issues with Sealights integration

set -o errexit
set -o pipefail
set -o nounset

echo "=== KIND Cluster Debug Information ==="
echo "Timestamp: $(date)"
echo ""

echo "=== System Resources ==="
echo "Available memory:"
free -h
echo ""
echo "Available disk space:"
df -h
echo ""
echo "System load:"
uptime
echo ""

echo "=== Docker/Podman Status ==="
if command -v podman &> /dev/null; then
    echo "Podman version:"
    podman version
    echo ""
    echo "Podman containers:"
    podman ps -a || echo "No containers or podman not running"
    echo ""
    echo "Podman system info:"
    podman system info || echo "Podman system info failed"
elif command -v docker &> /dev/null; then
    echo "Docker version:"
    docker version
    echo ""
    echo "Docker containers:"
    docker ps -a || echo "No containers or docker not running"
    echo ""
    echo "Docker system info:"
    docker system info || echo "Docker system info failed"
else
    echo "Neither podman nor docker found"
fi
echo ""

echo "=== KIND Clusters ==="
if command -v kind &> /dev/null; then
    echo "KIND version:"
    kind version
    echo ""
    echo "KIND clusters:"
    kind get clusters || echo "No KIND clusters found"
    echo ""
    echo "KIND nodes (if clusters exist):"
    kind get nodes || echo "No KIND nodes found"
else
    echo "KIND not found"
fi
echo ""

echo "=== System Limits ==="
echo "Inotify watches limit:"
cat /proc/sys/fs/inotify/max_user_watches || echo "Cannot read inotify limit"
echo ""
echo "Kernel keys limit:"
cat /proc/sys/kernel/keys/maxkeys || echo "Cannot read kernel keys limit"
echo ""
echo "File descriptors limit:"
ulimit -n || echo "Cannot read file descriptor limit"
echo ""

echo "=== Process Information ==="
echo "Processes using port 5000 (common registry port):"
lsof -i :5000 || echo "No processes using port 5000"
echo ""
echo "Processes using port 6443 (common k8s API port):"
lsof -i :6443 || echo "No processes using port 6443"
echo ""

echo "=== Sealights Environment ==="
echo "Sealights environment variables:"
env | grep -i sealights || echo "No Sealights environment variables found"
echo ""

echo "=== Network Information ==="
echo "Network interfaces:"
ip addr show || echo "Cannot show network interfaces"
echo ""
echo "Routing table:"
ip route show || echo "Cannot show routing table"
echo ""

echo "=== Debug Complete ===" 