import os.log

extension Logger {
	public struct Info<Value> {
		public let key: String
		public let operation: String
		
		public let existance: Bool
		public let oldValue: Value?
		public let newValue: Value?
		
		public let error: Error?
		
		public let userDefaultsItemTypeName: String
		public let level: OSLogType
		
		public let additional: String?
		
		public var defaultMessage: String {
			var message = "\(key) | \(operation)"
			
			message += " | \(existance)"
			
			if let oldValue = oldValue {
				message += " | \(oldValue)"
			}
			
			if let newValue = newValue {
				message += " | \(newValue)"
			}
			
			if let error = error {
				message += " – ERROR: \(error)"
			}
			
			return message
		}
	}
}
