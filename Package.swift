// swift-tools-version: 5.10
import PackageDescription

// Standalone Elgato Prompter helpers. Keep the library product and module name
// stable so existing apps can continue to import PrompterKit.
let package = Package(
    name: "prompter-kit",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(name: "PrompterKit", targets: ["PrompterKit"])
    ],
    targets: [
        .target(
            name: "PrompterKit",
            path: "Sources/PrompterKit"
        ),
        .testTarget(
            name: "PrompterKitTests",
            dependencies: ["PrompterKit"],
            path: "tests/PrompterKitTests"
        )
    ]
)
