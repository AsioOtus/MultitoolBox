import os



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



extension Settings {
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


	
extension Settings {
	public final class GenericPasswords {
		public var logging: Logging
		
		public let prefix: String?
		
		public init (
			prefix: String,
			logging: Logging = .default
		) {
			self.prefix = prefix
			self.logging = logging
		}
		
		internal static let `default` = GenericPasswords()
		private init () {
			self.prefix = nil
			self.logging = .default
		}
	}
}



extension Settings.GenericPasswords {
	public func createIdentifier (_ baseIdentifier: String) -> String {
		guard let prefix = settings.genericPasswords.prefix else { fatalError("KeychainUtil – prefix is nil") }
		guard !prefix.isEmpty else { fatalError("KeychainUtil – prefix is empty") }
		guard !baseIdentifier.isEmpty else { fatalError("KeychainUtil – baseIdentifier is empty") }
		
		let identifier = "\(prefix).\(baseIdentifier)"
		return identifier
	}
}



extension Settings.GenericPasswords {
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
