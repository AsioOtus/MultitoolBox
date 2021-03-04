import os.log

public struct StandardLoggingProvider: BaseNetworkUtilControllersLoggingProvider {
	public var prefix: String?
	
	public init (prefix: String? = nil) {
		self.prefix = prefix
	}
	
	public func baseNetworkUtilControllersLog <Request: BaseNetworkUtil.Request> (_ info: Controllers.Logger.Info<Request>) {
		
		let prefix = self.prefix ?? ""
		let preparedPrefix = !info.category.logMessage().isEmpty && !prefix.isEmpty
			? "\(prefix)."
			: ""
		
		let message = "\(preparedPrefix) – \(info.category.logMessage())"
		
		os_log("%{public}@", message)
	}
}
