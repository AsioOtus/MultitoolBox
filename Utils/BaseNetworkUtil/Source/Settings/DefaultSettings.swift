var defaultSettings = Settings()



public struct Settings {
	public static var global: Settings { defaultSettings }
	
	@InheritedSetting public var controllers: Controllers
	
	public init (parent: Settings = .global, controllers: Setting<Controllers>) {
		self._controllers = .init(controllers.inherited(from: parent.controllers))
	}
	
	public init (controllers: Controllers = .init()) {
		self._controllers = .init(.value(controllers))
	}
}



extension Settings {
	public struct Controllers {
		public static var global: Settings.Controllers { defaultSettings.controllers }
		
		@InheritedSetting public var logger: BaseNetworkUtil.Controllers.Logger
		
		public init (parent: Settings.Controllers = .global, logger: Setting<BaseNetworkUtil.Controllers.Logger>) {
			self._logger = .init(logger.inherited(from: parent.logger))
		}
		
		public init (logger: BaseNetworkUtil.Controllers.Logger = .init(StandardLoggingProvider())) {
			self._logger = .init(.value(logger))
		}
	}
}
