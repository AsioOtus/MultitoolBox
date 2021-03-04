public var globalSettings = Settings()



public struct Settings {
	public static var global: Self { globalSettings }
	
	public let parent: (() -> Settings)?
	
	@DerivedSetting public var controllers: Controllers
	
	public init (parent: @escaping @autoclosure () -> Self = .global, controllers: Setting<Controllers>) {
		self.parent = parent
		self._controllers = .init(controllers.derive(from: parent().controllers))
	}
	
	public init (controllers: Controllers = .init()) {
		self.parent = nil
		self._controllers = .init(.value(controllers))
	}
}



extension Settings {
	public struct Controllers {
		public static var global: Self { globalSettings.controllers }
		
		public let parent: (() -> Self)?
		
		@DerivedSetting public var logging: Logging
		
		public init (
			parent: @escaping @autoclosure () -> Self = .global,
			logging: Setting<Logging> = .copy
		) {
			self.parent = parent
			self._logging = .init(logging.derive(from: parent().logging))
		}
		
		public init (logging: Logging) {
			self.parent = nil
			self._logging = .init(.value(logging))
		}
	}
}



extension Settings.Controllers {
	public struct Logging {
		public static var global: Self { globalSettings.controllers.logging }
		
		public let parent: (() -> Self)?
		
		@DerivedSetting public var loggingProvider: BaseNetworkUtilControllersLoggingProvider
		
		public init (
			parent: @escaping @autoclosure () -> Self = .global,
			loggingProvider: Setting<BaseNetworkUtilControllersLoggingProvider> = .copy
		) {
			self.parent = parent
			self._loggingProvider = .init(loggingProvider.derive(from: parent().loggingProvider))
		}
		
		init (loggingProvider: BaseNetworkUtilControllersLoggingProvider = StandardLoggingProvider()) {
			self.parent = nil
			self._loggingProvider = .init(.value(loggingProvider))
		}
	}
}
