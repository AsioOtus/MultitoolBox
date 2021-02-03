public var globalSettings = Settings()



public struct Settings {
	public static var global: Settings { globalSettings }
	
	public let parent: (() -> Settings)?
	
	@InheritedSetting public var controllers: Controllers
	
	public init (parent: @escaping @autoclosure () -> Settings = .global, controllers: Setting<Controllers>) {
		self.parent = parent
		self._controllers = .init(controllers.inherited(from: parent().controllers))
	}
	
	public init (controllers: Controllers = .init()) {
		self.parent = nil
		self._controllers = .init(.value(controllers))
	}
}



extension Settings {
	public struct Controllers {
		public static var global: Controllers { globalSettings.controllers }
		
		public let parent: (() -> Controllers)?
		
		@InheritedSetting public var loggingProvider: BaseNetworkUtilControllersLoggingProvider
		
		public init (parent: @escaping @autoclosure () -> Controllers = .global, loggingProvider: Setting<BaseNetworkUtilControllersLoggingProvider>) {
			self.parent = parent
			self._loggingProvider = .init(loggingProvider.inherited(from: parent().loggingProvider))
		}
		
		public init (loggingProvider: BaseNetworkUtilControllersLoggingProvider = StandardLoggingProvider()) {
			self.parent = nil
			self._loggingProvider = .init(.value(loggingProvider))
		}
	}
}
