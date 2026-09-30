# Agent guidance for prompter-kit

This is a macOS Swift package for finding an Elgato Prompter display and
switching it through DisplayLink Manager. It is a library, not a desktop app
or CLI. Work from this repo's root.

## Key rules

- Use test-first development for non-trivial changes. Write or update the
  automated test first, then implement the change until the test passes. If
  there is no clean test seam, extract one first and add the test.
- When behaviour changes, update affected expectations and rerun the relevant
  tests. This includes display matching, frame layout and switch selection.
- Test before committing. Run `swift test`, check its exit code, then verify
  changed hardware behaviour through a consuming app when the device and
  permissions are available. Unit tests alone do not prove the display toggles.
- Keep build output out of version control. Do not commit binaries or caches.
- Keep the `PrompterKit` product, module, source target and public API names
  compatible. The repo and package name are `prompter-kit`.
- No em dashes in writing. Explain unusual implementation choices in comments.
- Start PR descriptions with `## Why`, explaining what prompted the change.

## Shared library specifics

The library is consumed by [Taskbar](https://github.com/mikecann/taskbar),
[Video HQ](https://github.com/mikecann/video-hq) and
[Telemprompit](https://github.com/mikecann/telemprompit).
After changes to shared behaviour, run `swift test` here and each affected
consumer's tests from its own clone. Record any consumer checks you cannot run.

```bash
swift test
bash install.sh
```

- `Sources/PrompterKit/PrompterDisplay.swift` handles display-name matching,
  screen lookup and frame calculation. The 32-point taskbar reservation is
  specific to Mike's setup. Keep its existing behaviour unless asked to change it.
- `Sources/PrompterKit/DisplayLinkPrompter.swift` uses macOS Accessibility APIs.
  Keep switch presses serialized and completions on the main queue. Verify the
  resulting state after a press, because successful AX calls can be ignored.
- Tests in `tests/PrompterKitTests/` use synthetic accessibility trees and frame
  values. They require neither hardware nor Accessibility permission and must
  remain safe for `swift test` on CI.
- Hardware checks require an Elgato Prompter, DisplayLink Manager and
  Accessibility permission for the consuming app. Never report hardware
  behaviour as verified from the synthetic tests alone.
- `install.sh` builds in this clone; it creates no global launcher or shortcut.
  There are no API keys, `.env` inputs or persisted settings to migrate.
