#!/bin/bash
# Example PreToolUse hook for validating Bash commands
# This script demonstrates bash command validation patterns
#
# Permission decisions travel on stdout with exit 0. Exit 2 is a blocking error
# whose stderr is fed to Claude as text, so JSON written there is never parsed --
# an "ask" decision emitted that way would hard-block instead of prompting.

set -euo pipefail

# Read input from stdin
input=$(cat)

# Extract command
command=$(echo "$input" | jq -r '.tool_input.command // empty')

# Validate command exists
if [ -z "$command" ]; then
  echo '{"continue": true}' # No command to validate
  exit 0
fi

# SECURITY: Check for command chaining/injection patterns FIRST
# These checks must run before the "safe command" allowlist to prevent bypasses
# like: echo $(rm -rf /), ls; malicious, pwd && evil, whoami | exfil
# Note: This is not exhaustive - production hooks should consider additional
# patterns like newlines (\n), null bytes (\x00), and shell-specific syntax
# shellcheck disable=SC2016 # Single quotes intentional - matching literal $( and ` characters
if [[ "$command" == *";"* ]] || [[ "$command" == *"|"* ]] ||
  [[ "$command" == *'$('* ]] || [[ "$command" == *'`'* ]] ||
  [[ "$command" == *"&&"* ]] || [[ "$command" == *"||"* ]]; then
  echo '{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "ask", "permissionDecisionReason": "Command chaining detected - requires review"}}'
  exit 0
fi

# Check for obviously safe commands (quick approval)
# IMPORTANT: This check is only safe because chaining patterns are caught above
if [[ "$command" =~ ^(ls|pwd|echo|date|whoami)(\s|$) ]]; then
  exit 0
fi

# Check for destructive operations
if [[ "$command" == *"rm -rf"* ]] || [[ "$command" == *"rm -fr"* ]]; then
  echo '{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "deny", "permissionDecisionReason": "Dangerous command detected: rm -rf"}}'
  exit 0
fi

# Check for other dangerous commands
if [[ "$command" == *"dd if="* ]] || [[ "$command" == *"mkfs"* ]] || [[ "$command" == *"> /dev/"* ]]; then
  echo '{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "deny", "permissionDecisionReason": "Dangerous system operation detected"}}'
  exit 0
fi

# Check for privilege escalation
if [[ "$command" == sudo* ]] || [[ "$command" == su* ]]; then
  echo '{"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "ask", "permissionDecisionReason": "Command requires elevated privileges"}}'
  exit 0
fi

# Approve the operation
exit 0
