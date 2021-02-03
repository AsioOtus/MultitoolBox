public class DefaultLogger: Logger, LogHandler {
	public var level: LoggingLevel
	public var source: [String]
	public var tags: Set<String>
	public var details: [String: Any]
	public var comment: String
	public var logHandler: LogHandler
	
	public init (
		level: LoggingLevel = .info,
		source: [String] = [],
		tags: Set<String> = [],
		details: [String: Any] = [:],
		comment: String = "",
		logHandler: LogHandler
	) {
		self.source = source
		self.level = level
		self.tags = tags
		self.details = details
		self.comment = comment
		self.logHandler = logHandler
	}
	
	
	
	public func log (
		level: LoggingLevel,
		message: @autoclosure () -> String,
		source: @autoclosure () -> [String] = [],
		tags: @autoclosure () -> Set<String> = [],
		details: @autoclosure () -> [String: Any] = [:],
		comment: @autoclosure () -> String = "",
		file: String = #file, function: String = #function, line: UInt = #line
	) {
		guard level >= self.level else { return }
		
		let source = (self.source + source()).combine()
		let tags = self.tags.union(tags())
		let details = self.details.merging(details(), uniquingKeysWith: { _, detail in detail })
		let comment = !comment().isEmpty ? comment() : self.comment
		
		logHandler.log(level: level, message: message(), source: [source], tags: tags, details: details, comment: comment, file: file, function: function, line: line)
	}
	
	
	
	public func trace (
		_ message: @autoclosure () -> String,
		source: @autoclosure () -> [String] = [],
		tags: @autoclosure () -> Set<String> = [],
		details: @autoclosure () -> [String: Any] = [:],
		comment: @autoclosure () -> String = "",
		file: String = #file, function: String = #function,	line: UInt = #line
	) {
		self.log(level: .trace, message: message(), source: source(), tags: tags(), details: details(), comment: comment(), file: file, function: function, line: line)
	}
	
	public func debug (
		_ message: @autoclosure () -> String,
		source: @autoclosure () -> [String] = [],
		tags: @autoclosure () -> Set<String> = [],
		details: @autoclosure () -> [String: Any] = [:],
		comment: @autoclosure () -> String = "",
		file: String = #file, function: String = #function,	line: UInt = #line
	) {
		self.log(level: .debug, message: message(), source: source(), tags: tags(), details: details(), comment: comment(), file: file, function: function, line: line)
	}
	
	public func info (
		_ message: @autoclosure () -> String,
		source: @autoclosure () -> [String] = [],
		tags: @autoclosure () -> Set<String> = [],
		details: @autoclosure () -> [String: Any] = [:],
		comment: @autoclosure () -> String = "",
		file: String = #file, function: String = #function,	line: UInt = #line
	) {
		self.log(level: .info, message: message(), source: source(), tags: tags(), details: details(), comment: comment(), file: file, function: function, line: line)
	}
	
	public func notice (
		_ message: @autoclosure () -> String,
		source: @autoclosure () -> [String] = [],
		tags: @autoclosure () -> Set<String> = [],
		details: @autoclosure () -> [String: Any] = [:],
		comment: @autoclosure () -> String = "",
		file: String = #file, function: String = #function,	line: UInt = #line
	) {
		self.log(level: .notice, message: message(), source: source(), tags: tags(), details: details(), comment: comment(), file: file, function: function, line: line)
	}
	
	public func warning (
		_ message: @autoclosure () -> String,
		source: @autoclosure () -> [String] = [],
		tags: @autoclosure () -> Set<String> = [],
		details: @autoclosure () -> [String: Any] = [:],
		comment: @autoclosure () -> String = "",
		file: String = #file, function: String = #function,	line: UInt = #line
	) {
		self.log(level: .warning, message: message(), source: source(), tags: tags(), details: details(), comment: comment(), file: file, function: function, line: line)
	}
	
	public func fault (
		_ message: @autoclosure () -> String,
		source: @autoclosure () -> [String] = [],
		tags: @autoclosure () -> Set<String> = [],
		details: @autoclosure () -> [String: Any] = [:],
		comment: @autoclosure () -> String = "",
		file: String = #file, function: String = #function,	line: UInt = #line
	) {
		self.log(level: .fault, message: message(), source: source(), tags: tags(), details: details(), comment: comment(), file: file, function: function, line: line)
	}
	
	public func error (
		_ message: @autoclosure () -> String,
		source: @autoclosure () -> [String] = [],
		tags: @autoclosure () -> Set<String> = [],
		details: @autoclosure () -> [String: Any] = [:],
		comment: @autoclosure () -> String = "",
		file: String = #file, function: String = #function,	line: UInt = #line
	) {
		self.log(level: .error, message: message(), source: source(), tags: tags(), details: details(), comment: comment(), file: file, function: function, line: line)
	}
	
	public func critical (
		_ message: @autoclosure () -> String,
		source: @autoclosure () -> [String] = [],
		tags: @autoclosure () -> Set<String> = [],
		details: @autoclosure () -> [String: Any] = [:],
		comment: @autoclosure () -> String = "",
		file: String = #file, function: String = #function,	line: UInt = #line
	) {
		self.log(level: .critical, message: message(), source: source(), tags: tags(), details: details(), comment: comment(), file: file, function: function, line: line)
	}
}
