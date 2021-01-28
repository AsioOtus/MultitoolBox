import Foundation
import os.log

public extension GenericPassword.Logger {
	struct Info {
		public let identifier: String
		public let operation: String
		public let existance: Bool?
		public let value: Value?
		public let errorType: String?
		public let error: Error?
		public let query: [CFString: Any]?
		
		public let keychainIdentifier: String
		public let level: OSLogType
		
		public var defaultMessage: String {
			var message = "\(identifier) – \(operation)"
			
			if let existance = existance {
				message += " | \(existance)"
			}
			
			if let value = value {
				message += " | \(value)"
			}
			
			if let errorType = errorType {
				message += " – ERROR: \(errorType)"
			}
			
			if let error = error {
				message += " | \(error)"
			}
			
			if let query = query {
				message += " – QUERY: \(query)"
			}
			
			return message
		}
	}
}
