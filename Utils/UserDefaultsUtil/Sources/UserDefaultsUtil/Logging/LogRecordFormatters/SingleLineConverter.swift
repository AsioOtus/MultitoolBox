public struct SingleLineLogRecordStringConverter: LogRecordStringConverter {
	public init () { }
	
	public func convert <Value> (_ record: LogRecord<Value>) -> String {
		var messageComponents = [String]()
		
		messageComponents.append(KeyBuilder.build(prefix: record.info.storageKeyPrefix, key: record.info.key, postfix: record.details.keyPostfix))
		messageComponents.append(record.details.operation.uppercased())
		messageComponents.append(String(describing: record.details.existance))
		
		if let oldValue = record.details.oldValue {
			messageComponents.append(String(describing: oldValue))
		}
		
		if let newValue = record.details.newValue {
			messageComponents.append(String(describing: newValue))
		}
		
		if let error = record.details.error {
			messageComponents.append(" – ERROR: \(error)")
		}
		
		let messsage = messageComponents.joined(separator: " | ")
		return messsage
	}
}
