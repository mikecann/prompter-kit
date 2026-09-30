#!/usr/bin/env bash
# This is a Swift library, so setup builds it in the clone. There is no
# executable to put on PATH. Apps consume the PrompterKit product via SwiftPM.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "prompter-kit requires macOS 13 or newer." >&2
  exit 1
fi

if ! command -v swift >/dev/null 2>&1; then
  echo "Install Xcode or its Command Line Tools with Swift 5.10 or newer." >&2
  exit 1
fi

# Forward SwiftPM options, including alternate build/cache paths for sandboxes.
swift build --package-path "$ROOT" "$@"
echo "prompter-kit built. Add the PrompterKit library product to your app with SwiftPM."
