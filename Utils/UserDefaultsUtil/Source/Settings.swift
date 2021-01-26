import Foundation
import os



public var settings: Settings = .default



public struct Settings {
	public let items: Items
	public var logging: Logging
	
	public init (
		items: Items,
		logging: Logging = .default
	) {
		self.items = items
		self.logging = logging
	}
	
	internal static let `default` = Settings()
	private init () {
		self.items = .default
		self.logging = .default
	}
}



extension Settings {
	public struct Items {
		public let itemKeyPrefixProvider: UserDefaultsUtilItemKeyPrefixProvider?
		
		public init (itemKeyPrefixProvider: UserDefaultsUtilItemKeyPrefixProvider) {
			self.itemKeyPrefixProvider = itemKeyPrefixProvider
		}
		
		internal static let `default` = Items()
		private init () {
			self.itemKeyPrefixProvider = nil
		}
	}
}



extension Settings {
	public struct Logging {
		public var enable: Bool
		public var level: OSLogType
		public var enableValuesLogging: Bool
				
		public var loggingProvider: UserDefaultsUtilLoggingProvider?
		
		public static let `default` = Logging()
		public init (
			enable: Bool = true,
			level: OSLogType = .default,
			enableValuesLogging: Bool = false,
			
			loggingProvider: UserDefaultsUtilLoggingProvider? = nil
		) {
			self.enable = enable
			self.level = level
			self.enableValuesLogging = enableValuesLogging
			
			self.loggingProvider = loggingProvider
		}
	}
}
