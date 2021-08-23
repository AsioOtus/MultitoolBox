import os.log
import Foundation

@available(iOS 12.0, macOS 12.0, *)
public class OsLogLogExporter: LogExporter {
	public typealias Message = String
	
	public var isEnabled = true
	
	public init () { }
	
	public func log (metaInfo: MetaInfo, message: String) {
		guard isEnabled else { return }
		
		let osLogType = logLevelToOsLogType(metaInfo.level)
		os_log(osLogType, "%@", message as NSString)
	}
	
	private func logLevelToOsLogType (_ level: LogLevel) -> OSLogType {
		let osLogType: OSLogType
		
		switch level {
		case .trace:
			osLogType = .debug
		case .debug:
			osLogType = .debug
		case .info:
			osLogType = .info
		case .notice:
			osLogType = .default
		case .warning:
			osLogType = .default
		case .error:
			osLogType = .fault
		case .critical:
			osLogType = .fault
		case .fault:
			osLogType = .fault
		}
		
		return osLogType
	}
}

@available(iOS 12.0, macOS 12.0, *)
extension OsLogLogExporter {
	public func isEnabled (_ isEnabled: Bool) -> Self {
		self.isEnabled = isEnabled
		return self
	}
}
