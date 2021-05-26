extension LogRecord {
	public struct Info {
		let key: String
		let itemLabel: String
		let storageLabel: String
		let storageKeyPrefix: String?
	}
}

extension LogRecord {
	public struct Details {
		let operation: String
		
		var newValue: Value? = nil
		var oldValue: Value? = nil
		var existance: Bool? = nil
		var keyPostfix: String? = nil
		
		var error: Error? = nil
		var comment: String? = nil
	}
}

public struct LogRecord<Value: Codable> {
	let info: Info
	let details: Details
	
	func converted (_ converter: LogRecordStringConverter = SingleLineLogRecordStringConverter()) -> String {
		converter.convert(self)
	}
}
