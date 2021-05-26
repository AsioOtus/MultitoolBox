public protocol LogHandler {
	func log <Value> (_: LogRecord<Value>)
}
