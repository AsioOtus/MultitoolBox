public protocol Logger {
	associatedtype Message: Codable
	associatedtype Details: LogRecordDetails
	
	func log (level: LogLevel, message: Message, details: Details?)
	
	func trace (_ message: Message, details: Details?)
	func debug (_ message: Message, details: Details?)
	func info (_ message: Message, details: Details?)
	func notice (_ message: Message, details: Details?)
	func warning (_ message: Message, details: Details?)
	func fault (_ message: Message, details: Details?)
	func error (_ message: Message, details: Details?)
	func critical (_ message: Message, details: Details?)
}



public extension Logger {
	func trace (_ message: Message, details: Details? = nil) {
		log(level: .trace, message: message, details: details)
	}
	
	func debug (_ message: Message,	details: Details? = nil) {
		log(level: .debug, message: message, details: details)
	}
	
	func info (_ message: Message,	details: Details? = nil) {
		log(level: .info, message: message, details: details)
	}
	
	func notice (_ message: Message, details: Details? = nil) {
		log(level: .notice, message: message, details: details)
	}
	
	func warning (_ message: Message, details: Details? = nil) {
		log(level: .warning, message: message, details: details)
	}
	
	func fault (_ message: Message, details: Details? = nil) {
		log(level: .fault, message: message, details: details)
	}
	
	func error (_ message: Message, details: Details? = nil) {
		log(level: .error, message: message, details: details)
	}
	
	func critical (_ message: Message, details: Details? = nil) {
		log(level: .critical, message: message, details: details)
	}
}
