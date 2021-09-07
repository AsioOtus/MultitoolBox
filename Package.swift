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
		.library(name: "KeychainUtil", type: .dynamic, targets: ["KeychainUtil"]),
	],
	targets: [
		.target(
			name: "Multitool",
			dependencies: [],
			path: "Base/Source/Core"
		),
		.target(
			name: "KeychainUtil",
			dependencies: [],
			path: "Utils/KeychainUtil/Source"
		),
		.target(
			name: "UIKitExtensions",
			dependencies: [],
			path: "UIKitExtensions/Source"
		)
	],
	swiftLanguageVersions: [.v5]
)
