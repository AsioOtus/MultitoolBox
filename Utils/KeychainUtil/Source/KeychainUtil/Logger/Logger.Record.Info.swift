import Foundation
import os

public extension KeychainUtil.Logger.Record {
	struct Info {
		public let operation: String
		public let existance: Bool?
		public let value: AnyObject?
		public let errorType: String?
		public let error: Error?
		public let query: [CFString: Any]?
		
		public let keychainIdentifier: String
		public let level: OSLogType
		
		public var defaultMessage: String {
			var message = operation
			
			if let existance = existance {
				message += " – \(existance)"
			}
			
			if let value = value {
				message += " – \(value)"
			}
			
			if let errorType = errorType {
				message += " – \(errorType)"
			}
			
			if let error = error {
				message += " – \(error)"
			}
			
			if let query = query {
				message += " – \(query)"
			}
			
			return message
		}
	}
}
