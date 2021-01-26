import os.log

extension Logger {
	struct Commit<Value> {
		let key: String
		
		var level: OSLogType
		var operation: String
		
		var newValue: Value?
		var oldValue: Value?
		var existance: Bool
		
		var additional: String?
		var error: Error?
	}
}
