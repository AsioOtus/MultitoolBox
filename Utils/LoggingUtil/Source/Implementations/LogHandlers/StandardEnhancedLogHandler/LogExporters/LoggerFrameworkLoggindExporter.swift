import os.log

@available(iOS 14.0, macOS 11.0, *)
public extension LoggerFrameworkLogExporter {
	struct Config {
		public static let `default` = Self(logger: .init())
		
		public let logger: os.Logger
	}
}

@available(iOS 14.0, macOS 11.0, *)
public class LoggerFrameworkLogExporter: StringLogExporter {
	public var configuration: Config
	
	public init (_ configuration: Config = .default) {
		self.configuration = configuration
	}
	
	public func log (_ level: LoggingLevel, _ message: String, _: Void? = nil) {
		let logger = configuration.logger
		
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
