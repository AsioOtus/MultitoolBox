// swift-tools-version:5.3

import PackageDescription

let package = Package(
	name: "Multitool",
	platforms: [
		.iOS(.v13),
		.macOS(.v10_15)
	],
	products: [
		.library(
			name: "MultitoolBase",
			targets: ["MultitoolBaseCore"]
		),
		.library(
			name: "KeychainUtil",
			targets: ["KeychainUtil"]
		),
		.library(
			name: "LoggingUtil",
			targets: ["LoggingUtil"]
		),
		.library(
			name: "UserDefaultsUtil",
			targets: ["UserDefaultsUtil"]
		),
		.library(
			name: "UIKitExtension",
			targets: ["UIKitExtension"]
		)
	],
	targets: [
		.target(
			name: "MultitoolBaseCore",
			dependencies: [],
			path: "Base/Source/Core"
		),
		.target(
			name: "KeychainUtil",
			dependencies: [],
			path: "Utils/KeychainUtil/Source"
		),
		.target(
			name: "LoggingUtil",
			dependencies: [],
			path: "Utils/LoggingUtil/Source"
		),
		.target(
			name: "UserDefaultsUtil",
			dependencies: [],
			path: "Utils/UserDefaultsUtil/Source"
		),
		.target(
			name: "UIKitExtensions",
			dependencies: [],
			path: "UIKitExtensions/Source"
		)
	],
	swiftLanguageVersions: [.v5]
)
