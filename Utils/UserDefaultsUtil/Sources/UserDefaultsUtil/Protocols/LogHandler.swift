public protocol LogHandler {
	func log <Value> (_ logRecord: LogRecord<Value>)
}
