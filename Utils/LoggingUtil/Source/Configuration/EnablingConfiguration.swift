public struct EnablingConfiguration {
	public var level: Bool
	public var source: Bool
	public var tags: Bool
	public var details: Bool
	public var comment: Bool
	public var codeInfo: Bool
	
	public init (
		level: Bool = true,
		source: Bool = true,
		tags: Bool = false,
		details: Bool = false,
		comment: Bool =  false,
		codeInfo: Bool = false
	) {
		self.level = level
		self.source = source
		self.tags = tags
		self.details = details
		self.comment = comment
		self.codeInfo = codeInfo
	}
}
