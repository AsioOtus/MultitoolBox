// swift-tools-version:5.5

import PackageDescription

let package = Package(
	name: "MultitoolEnhanced",
	products: [
		.library(
			name: "MultitoolEnhanced",
			targets: ["MultitoolEnhanced"]
		)
	],
	targets: [
		.target(
			name: "MultitoolEnhanced",
			path: "Sources/Core"
		),
		.target(
			name: "Drafts",
			path: "Sources/Drafts"
		),
	]
)
