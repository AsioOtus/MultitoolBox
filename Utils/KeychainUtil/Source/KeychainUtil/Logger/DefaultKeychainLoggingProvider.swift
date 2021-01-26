import os.log

public struct DefaultKeychainLoggingProvider: KeychainLoggingProvider {
	public static let defaultInstance = Self(prefix: nil)
	
	public var prefix: String?
	
	public init (prefix: String?) {
		self.prefix = prefix
	}
	
	public func log (_ info: KeychainUtil.Logger.Record.Info) {
		let log = OSLog(subsystem: info.keychainIdentifier, category: "KeychainUtil")
		
		let prefix = self.prefix ?? ""
		let preparedPrefix = !info.keychainIdentifier.isEmpty && !prefix.isEmpty
			? "\(prefix)."
			: ""
		
		let message = "\(preparedPrefix)\(info.keychainIdentifier) – \(info.defaultMessage)"
		
		os_log("%{public}@", log: log, type: info.level, message)
	}
}
