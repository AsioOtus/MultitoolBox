import os.log

public struct StandardLoggingProvider: BaseNetworkUtilControllersLoggingProvider {
	public var prefix: String?
	
	public init (prefix: String? = nil) {
		self.prefix = prefix
	}
	
	public func baseNetworkUtilControllersLog (_ info: Controllers.Logger.Info) {
		
		let prefix = self.prefix ?? ""
		let preparedPrefix = !info.category.defaultMessage.isEmpty && !prefix.isEmpty
			? "\(prefix)."
			: ""
		
		let message = "\(preparedPrefix) – \(info.category.defaultMessage)"
		
		os_log("%{public}@", message)
	}
}
