// swift-tools-version:5.3

import PackageDescription

let package = Package(
	name: "Multitool",
	platforms: [
		.iOS(.v13),
		.macOS(.v10_15)
	],
	products: [
		.library(name: "Multitool", type: .dynamic, targets: ["Multitool"]),
	],
	targets: [
		.target(
			name: "Multitool",
			dependencies: [],
			path: "Base/Source/Core"
		),
		.target(
			name: "UIKitExtensions",
			dependencies: [],
			path: "UIKitExtensions/Source"
		)
	],
	swiftLanguageVersions: [.v5]
)
