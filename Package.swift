// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "PKHUD",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "PKHUD",
            targets: ["PKHUD"]
        ),
    ],
    targets: [
        .target(
            name: "PKHUD",
            path: "PKHUD",
            exclude: [
                "Info.plist",
            ],
            resources: [
                .process("Resources"),
            ]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
