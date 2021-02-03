public struct LoggerInfo {
	@InheritedSetting public var level: LoggingLevel
	@InheritedSetting public var source: [String]
	@InheritedSetting public var tags: Set<String>
	@InheritedSetting public var details: [String: Any]
	@InheritedSetting public var comment: String
	
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
		level: Setting<LoggingLevel> = .inherit,
		source: Setting<[String]> = .inherit,
		tags: Setting<Set<String>> = .inherit,
		details: Setting<[String : Any]> = .inherit,
		comment: Setting<String> = .inherit
	) {
		self._level = .init(level.inherited(from: parent.level))
		self._source = .init(source.inherited(from: parent.source))
		self._tags = .init(tags.inherited(from: parent.tags))
		self._details = .init(details.inherited(from: parent.details))
		self._comment = .init(comment.inherited(from: parent.comment))
	}
}
