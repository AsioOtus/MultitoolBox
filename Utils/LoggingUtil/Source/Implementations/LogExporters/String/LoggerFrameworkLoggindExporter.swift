import os.log

@available(iOS 14.0, macOS 11.0, *)
public extension LoggerFrameworkLogExporter {
	struct Config {
		public static let `default` = Self(logger: .init())
		
		public let logger: os.Logger
	}
}

@available(iOS 14.0, macOS 11.0, *)
public class LoggerFrameworkLogExporter: EnhancedLogExporter {
	public typealias Message = String
	public typealias Configuration = Void
	
	public var isDisabled: Bool
	public var configuration: Config
	
	public init (_ configuration: Config = .default, isDisabled: Bool = false) {
		self.configuration = configuration
		self.isDisabled = isDisabled
	}
	
	public func log (metaInfo: EnhancedMetaInfo, message: String, configuration: Void? = nil) {
		guard !isDisabled else { return }
		
		let logger = self.configuration.logger
		
		switch metaInfo.level {
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
