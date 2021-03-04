public struct LoggerInfo {
	@DerivedSetting public var level: LoggingLevel
	@DerivedSetting public var source: [String]
	@DerivedSetting public var tags: Set<String>
	@DerivedSetting public var details: [String: Any]
	@DerivedSetting public var comment: String
	
	public init (
		level: LoggingLevel = .info,
		source: [String] = [],
		tags: Set<String> = [],
		details: [String : Any] = [:],
		comment: String = ""
	) {
		self._level = .init(.value(level))
		self._source = .init(.value(source))
		self._tags = .init(.value(tags))
		self._details = .init(.value(details))
		self._comment = .init(.value(comment))
	}
	
	public init (
		parent: Self = .init(),
		level: Setting<LoggingLevel> = .copy,
		source: Setting<[String]> = .copy,
		tags: Setting<Set<String>> = .copy,
		details: Setting<[String : Any]> = .copy,
		comment: Setting<String> = .copy
	) {
		self._level = .init(level.derive(from: parent.level))
		self._source = .init(source.derive(from: parent.source))
		self._tags = .init(tags.derive(from: parent.tags))
		self._details = .init(details.derive(from: parent.details))
		self._comment = .init(comment.derive(from: parent.comment))
	}
}
