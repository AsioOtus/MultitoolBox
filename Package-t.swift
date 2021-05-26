// swift-tools-version:5.3

import PackageDescription

let package = Package(
	name: "Multitool",
	platforms: [
		.iOS(.v13),
		.macOS(.v10_15)
	],
	products: [
		//.library(name: "MultitoolBase", targets: ["MultitoolBaseCore"]),
		.library(name: "MultitoolBase", type: .dynamic, targets: ["MultitoolBase"]),
		//.library(name: "BaseNetworkUtil", targets: ["BaseNetworkUtil"]),
		.library(name: "BaseNetworkUtil", type: .dynamic, targets: ["BaseNetworkUtil"]),
		//.library(name: "KeychainUtil", targets: ["KeychainUtil"]),
		.library(name: "KeychainUtil", type: .dynamic, targets: ["KeychainUtil"]),
		//.library(name: "LoggingUtil", targets: ["LoggingUtil"]),
		.library(name: "LoggingUtil", type: .dynamic, targets: ["LoggingUtil"]),
		//.library(name: "UserDefaultsUtil", targets: ["UserDefaultsUtil"]),
		.library(name: "UserDefaultsUtil", type: .dynamic, targets: ["UserDefaultsUtil"]),
		//.library(name: "UIKitExtensions", targets: ["UIKitExtensions"]),
		.library(name: "UIKitExtensions", type: .dynamic, targets: ["UIKitExtensions"])
	],
	targets: [
		.target(
			name: "MultitoolBase",
			dependencies: [],
			path: "Base/Source/Core"
		),
		.target(
			name: "BaseNetworkUtil",
			dependencies: [],
			path: "Utils/BaseNetworkUtil/Source"
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
