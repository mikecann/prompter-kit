# prompter-kit

Find an Elgato Prompter display and switch it through DisplayLink Manager.

macOS 13 or newer

<!-- media: hero -->
<!--
![prompter-kit](docs/hero.png)
-->
<!-- /media: hero -->

## What it is

I use an Elgato Prompter with a few of my Mac apps, so I pulled the shared
display helpers into a small Swift package. It finds the prompter screen,
calculates a window frame that leaves room for my taskbar, and uses
DisplayLink Manager's Accessibility controls to enable or disable the display.

This is a library for your app to use. The Swift product and import are still
`PrompterKit`.

This used to live in the mikerosoft repo at `tools/lib/PrompterKit`.

## Get it

Paste this into your AI coding agent (Claude Code, Codex, Cursor...):

> Clone https://github.com/mikecann/prompter-kit and make it my own. It's one of Mike
> Cann's personal tools, so read the README first, change anything specific to his
> setup to suit mine, then help me get it running.

### Or set it up by hand

You need macOS 13 or newer and Xcode or Command Line Tools with Swift 5.10 or
newer. For display switching, you also need an Elgato Prompter and DisplayLink
Manager installed at `/Applications/DisplayLink Manager.app`.

```bash
git clone https://github.com/mikecann/prompter-kit.git
cd prompter-kit
bash install.sh
swift test
```

The setup script builds the library in the clone. There is no command or app
to install globally, and no API keys or `.env` file to configure.

Add it to your app's `Package.swift` dependencies:

```swift
.package(url: "https://github.com/mikecann/prompter-kit.git", from: "1.0.0")
```

Then add this product to the target that uses it:

```swift
.product(name: "PrompterKit", package: "prompter-kit")
```

The version dependency requires a published `1.0.0` tag. Before that release,
or while making local changes, use
`.package(path: "/path/to/prompter-kit")` instead of the URL dependency.

## Using it

Find the screen from the main actor and calculate your window's frame:

```swift
import AppKit
import PrompterKit

@MainActor
func prompterFrame() -> CGRect? {
    guard let screen = PrompterDisplay.prompterScreen() else { return nil }
    return PrompterDisplay.fillFrame(in: screen.visibleFrame)
}
```

The screen lookup returns `nil` when the prompter is disconnected or disabled.
It matches full and shortened names such as `Elgato Prompter` and `Elgato Prom.`.

To enable the display through DisplayLink Manager:

```swift
DisplayLinkTeleprompterController.shared.setEnabled(true) { result in
    switch result {
    case .success:
        print("Prompter enabled")
    case .failure(let error):
        print(error.localizedDescription)
    }
}
```

Pass `false` to disable it. Work runs on a serial background queue and the
completion runs on the main queue. You can point the controller's `log`
closure at your app's logger.

## Settings and permissions

`fillFrame(in:)` reserves up to 32 points at the bottom for my taskbar and
avoids reducing the frame below 240 points when possible. If your setup
doesn't need that space, use the screen's `visibleFrame` directly or change
the reservation in `PrompterDisplay.swift`.

For switching, allow your consuming app in System Settings > Privacy &
Security > Accessibility. The library checks permission but does not show a
permission prompt. It stores no settings of its own.

## Troubleshooting

- If DisplayLink Manager is unavailable, check its installation path. The
  controller launches it if it is installed but isn't running.
- If the menu or switch is unavailable, open DisplayLink Manager and check
  whether it exposes an Elgato Prompter toggle. Its UI can vary by version.
- If the switch did not change, check the actual display state and the app's
  logs. The controller presses the switch and checks for a state change;
  writing an Accessibility value can return success without changing it.

## Development

```bash
swift test
```

The six tests cover display names, taskbar spacing, switch selection and
whether a press is needed. They use synthetic data, so they run without a
connected prompter or Accessibility permission. CI runs them on macOS.
Actual display switching still needs a check in a consuming app with hardware.

`PrompterDisplay.swift` handles screen lookup and frame calculations.
`DisplayLinkPrompter.swift` walks DisplayLink's Accessibility tree, chooses the
prompter's switch and checks the result after pressing it.

## More tools

You can find my other tools at [mikerosoft.app](https://mikerosoft.app).

MIT licensed.
