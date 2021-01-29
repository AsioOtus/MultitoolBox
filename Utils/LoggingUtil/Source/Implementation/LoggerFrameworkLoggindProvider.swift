import os.log

@available(iOS 14.0, macOS 11.0, *)
class LoggerFrameworkLoggindProvider: LoggingProvider {
	private let logger = os.Logger()
	
	func log (_ level: LogLevel, _ message: String) {
		switch level {
		case .trace:
			logger.trace("\(message)")
		case .debug:
			logger.debug("\(message)")
		case .info:
			logger.info("\(message)")
		case .notice:
			logger.notice("\(message)")
		case .warning:
			logger.warning("\(message)")
		case .error:
			logger.error("\(message)")
		case .critical:
			logger.critical("\(message)")
		case .fault:
			logger.fault("\(message)")
		}
	}
}
