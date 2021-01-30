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
		public let prefix: String?
		
		public init (prefix: String) {
			self.prefix = prefix
		}
		
		internal static let `default` = Items()
		private init () {
			self.prefix = nil
		}
	}
}



extension Settings.Items {
	public func createKey (_ baseKey: String) -> String {
		guard !baseKey.isEmpty else { fatalError("UserDefaultsUtil – baseKey is empty") }
		
		var key = prefix ?? ""
		key += (key.isEmpty ? "" : ".") + baseKey
		
		return key
	}
}




extension Settings {
	public struct Logging {
		public var enable: Bool
		public var enableValuesLogging: Bool
		public var level: OSLogType
				
		public var loggingProvider: UserDefaultsUtilLoggingProvider?
		
		public static let `default` = Logging()
		public init (
			enable: Bool = true,
			enableValuesLogging: Bool = false,
			level: OSLogType = .default,
			loggingProvider: UserDefaultsUtilLoggingProvider? = nil
		) {
			self.enable = enable
			self.enableValuesLogging = enableValuesLogging
			self.level = level
			
			self.loggingProvider = loggingProvider
		}
	}
}
