public struct EnablingConfig {
	public var timestamp: Bool
	public var level: Bool
	public var source: Bool
	
	public init (
		timestamp: Bool = true,
		level: Bool = true,
		source: Bool = true
	) {
		self.timestamp = timestamp
		self.level = level
		self.source = source
	}
}
