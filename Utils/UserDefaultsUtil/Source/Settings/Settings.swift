import Foundation
import os



public var globalSettings: Settings = .default



public struct Settings {
	public static var global: Settings { globalSettings }
	
	public let parent: (() -> Settings)?
	
	public let items: Setting<Items>.Derived
	@InheritedSetting public var logging: Logging
	
	public init (
		items: Items,
		logging: Logging = .default
	) {
		self.parent = nil
		self.items = .value(items)
		self._logging = .init(.value(logging))
	}
	
	public init (
		parent: @escaping @autoclosure () -> Settings = .global,
		items: Setting<Items> = .prototype,
		logging: Setting<Logging> = .prototype
	) {
		self.parent = parent
		self.items = items.derive(from: parent().items.value)
		self._logging = .init(logging.derive(from: parent().logging))
	}
	
	internal static let `default` = Settings()
	private init () {
		self.parent = nil
		self.items = .value(.default)
		self._logging = .init(.value(.default))
	}
}



extension Settings {
	public struct Items {
		public static var global: Items { globalSettings.items.value }
		
		public let parent: (() -> Items)?
		
		public let prefix: Setting<String?>.Derived
		
		public init (prefix: String) {
			self.parent = nil
			self.prefix = .value(prefix)
		}
		
		public init (parent: @escaping @autoclosure () -> Items = .global, prefix: Setting<String?> = .prototype) {
			self.parent = parent
			self.prefix = prefix.derive(from: parent().prefix.value)
		}
		
		internal static let `default` = Items()
		private init () {
			self.parent = nil
			self.prefix = .value(nil)
		}
	}
}



extension Settings {
	public struct Logging {
		public static var global: Logging { globalSettings.logging }
		
		public let parent: (() -> Logging)?
		
		@InheritedSetting public var enable: Bool
		@InheritedSetting public var enableValuesLogging: Bool
		@InheritedSetting public var level: OSLogType
				
		@InheritedSetting public var loggingProvider: UserDefaultsUtilLoggingProvider?
		
		public static let `default` = Logging()
		public init (
			enable: Bool = true,
			enableValuesLogging: Bool = false,
			level: OSLogType = .default,
			loggingProvider: UserDefaultsUtilLoggingProvider? = nil
		) {
			self.parent = nil
			
			self._enable = .init(.value(enable))
			self._enableValuesLogging = .init(.value(enableValuesLogging))
			self._level = .init(.value(level))
			
			self._loggingProvider = .init(.value(loggingProvider))
		}
		
		public init (
			parent: @escaping @autoclosure () -> Logging = .global,
			enable: Setting<Bool> = .prototype,
			enableValuesLogging: Setting<Bool> = .prototype,
			level: Setting<OSLogType> = .prototype,
			loggingProvider: Setting<UserDefaultsUtilLoggingProvider?> = .prototype
		) {
			self.parent = parent
			
			self._enable = .init(enable.derive(from: parent().enable))
			self._enableValuesLogging = .init(enableValuesLogging.derive(from: parent().enableValuesLogging))
			self._level = .init(level.derive(from: parent().level))
			
			self._loggingProvider = .init(loggingProvider.derive(from: parent().loggingProvider))
		}
	}
}
