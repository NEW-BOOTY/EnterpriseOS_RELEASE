#!/usr/bin/env bash
# /*
#  * Copyright © 2025 Devin B. Royal.
#  * All Rights Reserved.
#  */
#
# AI-assist module for: Project Clarity (OpenAI) (clarity)
# Responsibilities:
#   - Real OpenAI Responses API integration
#   - Multi-model support (gpt-4.1, gpt-4.1-mini, gpt-4o, gpt-4o-mini, gpt-5*)
#   - Parallel multi-LLM orchestration
#   - Governance-friendly logging and error handling
#
# NOTE:
#   - Requires OPENAI_API_KEY to be set in the environment.
#   - Requires: curl, jq
#
# Example usage:
#   ./ai_assist.sh "Explain what this Enterprise Meta-Builder does."
#
# Or source it from a higher-level orchestrator:
#   source ./ai_assist.sh
#   run_openai_task "Summarize today's risk posture."
#   run_parallel_multi_llm "Compare MBOM vs SBOM in cloud-native supply chain."

set -Eeuo pipefail

SCRIPT_NAME="$(basename "${0}")"
VERSION="1.0.0"
PROJECT_ID="clarity"
PROJECT_NAME="Project Clarity (OpenAI)"

LOG_DIR="${HOME}/.logs/meta_builder_v2/clarity_ai"
LOG_FILE="${LOG_DIR}/ai_$(date -u +%Y%m%dT%H%M%SZ).log"

# ---------- Colors ----------

if [[ -t 1 ]] && [[ -z "${NO_COLOR:-}" ]]; then
  BOLD="\033[1m"
  GREEN="\033[0;32m"
  YELLOW="\033[0;33m"
  RED="\033[0;31m"
  RESET="\033[0m"
else
  BOLD=""
  GREEN=""
  YELLOW=""
  RED=""
  RESET=""
fi

# ---------- Logging Helpers ----------

timestamp() {
  date -u +"%Y-%m-%dT%H:%M:%SZ"
}

_ai_log_raw() {
  local level="$1"; shift || true
  local msg="$*"
  mkdir -p "${LOG_DIR}" || true
  printf "%s [%s] %s\n" "$(timestamp)" "${level}" "${msg}" | tee -a "${LOG_FILE}" >&2
}

_ai_info()  { _ai_log_raw "INFO"  "$*"; }
_ai_warn()  { _ai_log_raw "WARN"  "$*"; }
_ai_error() { _ai_log_raw "ERROR" "$*"; }
_ai_debug() {
  if [[ "${DEBUG:-0}" == "1" ]]; then
    _ai_log_raw "DEBUG" "$*"
  fi
}

_ai_fatal() {
  _ai_error "$*"
  exit 1
}

# ---------- Error Handling & Cleanup ----------

_ai_error_handler() {
  local exit_code="$?"
  local line_no="${BASH_LINENO[0]:-0}"
  local cmd="${BASH_COMMAND:-unknown}"
  _ai_error "AI module failure."
  _ai_error "  Exit code: ${exit_code}"
  _ai_error "  Line: ${line_no}"
  _ai_error "  Command: ${cmd}"
  _ai_error "  Script: ${SCRIPT_NAME} v${VERSION}"
  exit "${exit_code}"
}

_ai_cleanup() {
  _ai_info "AI module session finished (status=${?})."
}

trap _ai_error_handler ERR
trap _ai_cleanup EXIT

# ---------- Preconditions ----------

_ai_require_cmd() {
  local cmd="$1"
  if ! command -v "${cmd}" >/dev/null 2>&1; then
    _ai_error "Required command '${cmd}' not found on PATH."
    return 1
  fi
  _ai_debug "Command '${cmd}' is available."
  return 0
}

_ai_check_prereqs() {
  local ok=0

  if [[ -z "${OPENAI_API_KEY:-}" ]]; then
    _ai_error "OPENAI_API_KEY is not set. Export it in your shell environment."
    ok=1
  fi

  _ai_require_cmd "curl" || ok=1
  _ai_require_cmd "jq"   || ok=1

  if [[ "${ok}" -ne 0 ]]; then
    _ai_fatal "Prerequisite check failed. See errors above."
  fi
}

# ---------- Core OpenAI Call Helper ----------

# _ai_call_openai MODEL PROMPT
# Prints plain text response to stdout. Logs JSON to LOG_FILE if DEBUG=1.
_ai_call_openai() {
  local model="$1"
  local prompt="$2"

  _ai_check_prereqs

  _ai_info "Calling OpenAI model='${model}' for project='${PROJECT_NAME}'"

  # Use the Responses API (modern unified interface). :contentReference[oaicite:0]{index=0}
  # We prioritize output_text; fall back to output[0].content[0].text if needed.
  local response http_status
  local tmp_response
  tmp_response="$(mktemp "/tmp/clarity_ai_${model//./_}_XXXXXX.json")"

  # shellcheck disable=SC2064
  trap "rm -f '${tmp_response}' || true" RETURN

  # Perform the actual API call.
  # --fail makes curl exit non-zero on 4xx/5xx so our ERR trap fires if unhandled.
  http_status="$(
    curl -sS \
      -w "%{http_code}" \
      -o "${tmp_response}" \
      -X POST "https://api.openai.com/v1/responses" \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer ${OPENAI_API_KEY}" \
      -d @- <<EOF
{
  "model": "${model}",
  "input": "${prompt}",
  "store": false
}
EOF
  )"

  # Validate HTTP status
  if [[ "${http_status}" -lt 200 || "${http_status}" -ge 300 ]]; then
    _ai_error "OpenAI API returned HTTP ${http_status} for model='${model}'."
    if [[ -s "${tmp_response}" ]]; then
      _ai_error "Response body:"
      sed 's/^/  /' "${tmp_response}" >&2
    fi
    _ai_fatal "OpenAI call failed for model='${model}'."
  fi

  if [[ "${DEBUG:-0}" == "1" ]]; then
    _ai_debug "Raw OpenAI JSON response for model=${model}:"
    sed 's/^/  /' "${tmp_response}" >&2
  fi

  # Extract text using multiple fallbacks.
  local text
  text="$(jq -r '
    .output_text
    // (.output[0].content[0].text // empty)
    // ""
  ' "${tmp_response}" 2>/dev/null || echo "")"

  if [[ -z "${text}" ]]; then
    _ai_warn "Could not extract output_text; returning raw JSON."
    cat "${tmp_response}"
  else
    printf "%s\n" "${text}"
  fi
}

# ---------- Public API Functions (OpenAI + stubs for others) ----------

# run_openai_task PROMPT
# Default: use gpt-4.1 as primary model.
run_openai_task() {
  local prompt="${1:-}"
  if [[ -z "${prompt}" ]]; then
    _ai_fatal "run_openai_task requires a prompt argument."
  fi

  _ai_info "run_openai_task using gpt-4.1"
  _ai_call_openai "gpt-4.1" "${prompt}"
}

# run_openai_task_model MODEL PROMPT
# Generalized model selector.
run_openai_task_model() {
  local model="${1:-}"
  shift || true
  local prompt="${*:-}"

  if [[ -z "${model}" || -z "${prompt}" ]]; then
    _ai_fatal "run_openai_task_model requires MODEL and PROMPT."
  fi

  _ai_call_openai "${model}" "${prompt}"
}

# --- Stubs for other AI providers (to be wired later) ---

run_gemini_task() {
  local prompt="${1:-}"
  echo "[AI:${PROJECT_ID}] Gemini integration not yet implemented. Prompt was: ${prompt}" >&2
}

run_grok_task() {
  local prompt="${1:-}"
  echo "[AI:${PROJECT_ID}] Grok integration not yet implemented. Prompt was: ${prompt}" >&2
}

run_copilot_task() {
  local prompt="${1:-}"
  echo "[AI:${PROJECT_ID}] Microsoft Copilot integration not yet implemented. Prompt was: ${prompt}" >&2
}

run_meta_ai_task() {
  local prompt="${1:-}"
  echo "[AI:${PROJECT_ID}] Meta AI integration not yet implemented. Prompt was: ${prompt}" >&2
}

# ---------- Parallel Multi-LLM Runner (OpenAI models only for now) ----------

# run_parallel_multi_llm PROMPT
# Hits multiple OpenAI models in parallel and prints labeled outputs.
#
# Models used (if available to your account):
#   - gpt-4.1
#   - gpt-4.1-mini
#   - gpt-4o
#   - gpt-4o-mini
#   - gpt-5   (will fail gracefully if not provisioned)
#
run_parallel_multi_llm() {
  local prompt="${1:-}"
  if [[ -z "${prompt}" ]]; then
    _ai_fatal "run_parallel_multi_llm requires a prompt argument."
  fi

  _ai_check_prereqs

  local models=(
    "gpt-4.1"
    "gpt-4.1-mini"
    "gpt-4o"
    "gpt-4o-mini"
    "gpt-5"
  )

  _ai_info "Starting parallel multi-LLM run for ${#models[@]} models."

  local tmp_root
  tmp_root="$(mktemp -d "/tmp/clarity_multi_XXXXXX")"

  # Cleanup temp dir when this function returns
  # shellcheck disable=SC2064
  trap "rm -rf '${tmp_root}' || true" RETURN

  local pids=()
  local model
  for model in "${models[@]}"; do
    (
      local out_file="${tmp_root}/${model}.out"
      local err_file="${tmp_root}/${model}.err"

      {
        _ai_info "Launching model='${model}' in background."
        if ! _ai_call_openai "${model}" "${prompt}" >"${out_file}" 2>"${err_file}"; then
          echo "[ERROR] Model ${model} failed. See logs." >"${out_file}"
          _ai_error "Model '${model}' failed. stderr:"
          sed 's/^/  /' "${err_file}" >&2 || true
        fi
      } || {
        echo "[ERROR] Model ${model} encountered an unexpected error." >"${out_file}"
      }
    ) &
    pids+=("$!")
  done

  # Wait for all
  local pid
  for pid in "${pids[@]}"; do
    if ! wait "${pid}"; then
      _ai_warn "One of the parallel model jobs (pid=${pid}) exited non-zero."
    fi
  done

  _ai_info "Parallel multi-LLM run complete. Aggregating outputs."

  echo ""
  echo "================== PARALLEL MULTI-LLM OUTPUT =================="
  for model in "${models[@]}"; do
    local out_file="${tmp_root}/${model}.out"
    echo ""
    echo "----- MODEL: ${model} -----"
    if [[ -s "${out_file}" ]]; then
      cat "${out_file}"
    else
      echo "[NO OUTPUT] Model '${model}' produced no output or failed prematurely."
    fi
  done
  echo "==============================================================="
}

# ---------- CLI Entry Point (optional) ----------

_ai_show_help() {
  cat <<EOF
${BOLD}${SCRIPT_NAME}${RESET} v${VERSION} - ${PROJECT_NAME} AI Assist Module

Usage:
  ${SCRIPT_NAME} "your prompt here"
  ${SCRIPT_NAME} --model MODEL "your prompt here"
  ${SCRIPT_NAME} --multi "your prompt here"

Options:
  --model MODEL   Use a specific OpenAI model (e.g., gpt-4.1, gpt-4o).
  --multi         Run parallel multi-LLM across several models.
  --debug         Enable debug logging.
  --help          Show this help.

Examples:
  ${SCRIPT_NAME} "Summarize our current cloud risk posture."
  ${SCRIPT_NAME} --model gpt-4o "Generate a SOC 2 evidence checklist."
  ${SCRIPT_NAME} --multi "Compare NIST 800-53 vs SOC 2 mapping."
EOF
}

_ai_main() {
  if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    # Sourced, not executed: don't run CLI mode.
    return 0
  fi

  local mode="single"
  local model=""
  local args=()

  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      --model)
        shift || _ai_fatal "--model requires an argument."
        model="${1:-}";;
      --multi)
        mode="multi";;
      --debug)
        DEBUG=1;;
      --help|-h)
        _ai_show_help
        exit 0;;
      *)
        args+=("$1");;
    esac
    shift || true
  done

  local prompt="${args[*]:-}"
  if [[ -z "${prompt}" ]]; then
    _ai_show_help
    _ai_fatal "A prompt string is required."
  fi

  case "${mode}" in
    single)
      if [[ -n "${model}" ]]; then
        run_openai_task_model "${model}" "${prompt}"
      else
        run_openai_task "${prompt}"
      fi
      ;;
    multi)
      run_parallel_multi_llm "${prompt}"
      ;;
    *)
      _ai_fatal "Unknown mode: ${mode}"
      ;;
  esac
}

_ai_main "$@"

# /*
#  * Copyright © 2025 Devin B. Royal.
#  * All Rights Reserved.
#  */
