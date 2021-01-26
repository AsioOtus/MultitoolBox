import os



extension KeychainUtil {
	public final class Settings {
		public var logging: Logging
		public let genericPasswords: GenericPasswords
		
		public init (
			logging: Logging = .default,
			genericPasswords: GenericPasswords
		) {
			self.logging = logging
			self.genericPasswords = genericPasswords
		}
		
		internal static let `default` = Settings()
		private init () {
			self.logging = .default
			self.genericPasswords = .default
		}
	}
}



extension KeychainUtil.Settings {
	public final class Logging {
		public var enable: Bool
		public var level: OSLogType
		
		public var enableQueryLogging: Bool
		public var enableValuesLogging: Bool
		
		public var loggingProvider: KeychainLoggingProvider?
		
		public static let `default` = Logging()
		public init (
			enable: Bool = true,
			level: OSLogType = .default,
			
			enableQueryLogging: Bool = false,
			enableValuesLogging: Bool = false,
			
			loggingProvider: KeychainLoggingProvider? = nil
		) {
			self.enable = enable
			self.level = level
			
			self.enableQueryLogging = enableQueryLogging
			self.enableValuesLogging = enableValuesLogging
			
			self.loggingProvider = loggingProvider
		}
	}
}


	
extension KeychainUtil.Settings {
	public final class GenericPasswords {
		public var logging: Logging
		
		public let itemIdentifierPrefixProvider: KeychainGenericPasswordsItemIdentifierPrefixProvider?
		
		public init (
			itemIdentifierPrefixProvider: KeychainGenericPasswordsItemIdentifierPrefixProvider,
			logging: Logging = .default
		) {
			self.itemIdentifierPrefixProvider = itemIdentifierPrefixProvider
			self.logging = logging
		}
		
		internal static let `default` = GenericPasswords()
		private init () {
			self.itemIdentifierPrefixProvider = nil
			self.logging = .default
		}
	}
}



extension KeychainUtil.Settings.GenericPasswords {
	public final class Logging {
		public var enable: Bool
		public var level: OSLogType
		
		public var enableKeychainIdentifierLogging: Bool
		public var enableQueryLogging: Bool
		public var enableValuesLogging: Bool
		
		public var loggingProvider: KeychainGenericPasswordsLoggingProvider?
		
		public static let `default` = Logging()
		public init (
			enable: Bool = true,
			level: OSLogType = .default,
			
			enableKeychainIdentifierLogging: Bool = true,
			enableQueryLogging: Bool = false,
			enableValuesLogging: Bool = false,
			
			loggingProvider: KeychainGenericPasswordsLoggingProvider? = nil
		) {
			self.enable = enable
			self.level = level
			
			self.enableKeychainIdentifierLogging = enableKeychainIdentifierLogging
			self.enableQueryLogging = enableQueryLogging
			self.enableValuesLogging = enableValuesLogging
			
			self.loggingProvider = loggingProvider
		}
	}
}
