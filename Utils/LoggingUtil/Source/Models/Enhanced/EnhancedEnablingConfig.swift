public struct EnhancedEnablingConfig {
	public var timestamp: Bool
	public var level: Bool
	public var source: Bool
	public var tags: Bool
	public var details: Bool
	public var comment: Bool
	public var codeInfo: Bool
	public var labels: Bool
	
	public init (
		timestamp: Bool = true,
		level: Bool = true,
		source: Bool = true,
		tags: Bool = false,
		details: Bool = false,
		comment: Bool =  false,
		codeInfo: Bool = false,
		labels: Bool = false
	) {
		self.timestamp = timestamp
		self.level = level
		self.source = source
		self.tags = tags
		self.details = details
		self.comment = comment
		self.codeInfo = codeInfo
		self.labels = labels
	}
}
