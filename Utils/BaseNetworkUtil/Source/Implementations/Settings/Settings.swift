public var globalSettings = Settings()



public struct Settings {
	public static var global: Self { globalSettings }
	
	public var controllers: Controllers
	
	public init (controllers: Controllers = .init()) {
		self.controllers = controllers
	}
}



extension Settings {
	public struct Controllers {
		public static var global: Self { globalSettings.controllers }
				
		public var logging: Logging
		
		public init (logging: Logging = .init()) {
			self.logging = logging
		}
	}
}



extension Settings.Controllers {
	public struct Logging {
		public static var global: Self { globalSettings.controllers.logging }
				
		public var loggingProvider: BaseNetworkUtilControllersLoggingProvider
		
		public init (loggingProvider: BaseNetworkUtilControllersLoggingProvider = StandardLoggingProvider()) {
			self.loggingProvider = loggingProvider
		}
	}
}
