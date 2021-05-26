struct Logger<Value: Codable> {
	let info: LogRecord<Value>.Info
	let logHandler: LogHandler?
	
	func log (_ details: LogRecord<Value>.Details) {
		logHandler?.log(.init(info: info, details: details))
	}
}
