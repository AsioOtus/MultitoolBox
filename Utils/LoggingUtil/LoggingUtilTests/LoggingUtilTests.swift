import XCTest

class LoggingUtilTests: XCTestCase {
	func testDefaultLogHandlerTextOutput () {
		let loggerInfo = LoggerInfo(
			level: .trace,
			source: ["LoggingUtil", "LoggingUtilTests"],
			tags: ["Logging test", "Test", "Logging", "Testing tag"],
			details: ["inf": "Some additional info"],
			comment: "Extra comment"
		)
		
		let logHandler = DefaultLogHandler(
			sourcePrefix: "LUT",
			levelPadding: false,
			logExporter: LoggerFrameworkLogExporter(),
			loggerInfo: loggerInfo,
			enabling: .init(
				level: true,
				source: true,
				tags: true,
				details: true,
				comment: true,
				codeInfo: true
			)
		)
		
		let logger = DefaultLogger(logHandler: logHandler, loggerInfo: .init(level: loggerInfo.level, source: ["testTextOutput"]))
		
		logger.trace("Test message")
	}
}
