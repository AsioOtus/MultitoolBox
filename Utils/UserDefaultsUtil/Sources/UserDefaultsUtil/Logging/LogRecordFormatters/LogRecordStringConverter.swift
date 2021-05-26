public protocol LogRecordStringConverter {
	func convert <Value> (_: LogRecord<Value>) -> String
}
