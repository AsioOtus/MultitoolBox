import os.log



extension Logger {
	struct Record<Value> {
		let key: String
		let operation: Operation
		let newValue: Value?
		let level: OSLogType
		
		init (_ level: OSLogType, _ key: String, _ operation: Operation, _ newValue: Value? = nil) {
			self.level = level
			self.key = key
			self.operation = operation
			self.newValue = newValue
		}
		
		func commit (_ oldValue: Value? = nil, error: Error? = nil) -> Commit<Value> {
			Commit<Value>(
				key: key,
				level: level,
				operation: operation.name,
				newValue: newValue,
				oldValue: oldValue,
				existance: oldValue != nil,
				additional: nil,
				error: error
			)
		}
	}
}
