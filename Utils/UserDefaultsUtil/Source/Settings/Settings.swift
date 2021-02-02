import Foundation
import os



public var globalSettings: Settings = .default



public struct Settings {
	public static var global: Settings { globalSettings }
	
	public let parent: (() -> Settings)?
	
	public let items: Setting<Items>.Inherited
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
		items: Setting<Items> = .inherit,
		logging: Setting<Logging> = .inherit
	) {
		self.parent = parent
		self.items = items.inherited(from: parent().items.value)
		self._logging = .init(logging.inherited(from: parent().logging))
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
		
		public let prefix: Setting<String?>.Inherited
		
		public init (prefix: String) {
			self.parent = nil
			self.prefix = .value(prefix)
		}
		
		public init (parent: @escaping @autoclosure () -> Items = .global, prefix: Setting<String?> = .inherit) {
			self.parent = parent
			self.prefix = prefix.inherited(from: parent().prefix.value)
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
			enable: Setting<Bool> = .inherit,
			enableValuesLogging: Setting<Bool> = .inherit,
			level: Setting<OSLogType> = .inherit,
			loggingProvider: Setting<UserDefaultsUtilLoggingProvider?> = .inherit
		) {
			self.parent = parent
			
			self._enable = .init(enable.inherited(from: parent().enable))
			self._enableValuesLogging = .init(enableValuesLogging.inherited(from: parent().enableValuesLogging))
			self._level = .init(level.inherited(from: parent().level))
			
			self._loggingProvider = .init(loggingProvider.inherited(from: parent().loggingProvider))
		}
	}
}
