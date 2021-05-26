public extension StandardLogRecordDetails {
	enum Enabling {
		case disable
		case enabled(
			source: Bool = true,
			tags: Bool = false,
			keyValue: Bool = false,
			comment: Bool = false,
			codeInfo: Bool = false
		 )
	}
}



public struct StandardLogRecordDetails: LogRecordDetails {
	public let source: [String]?
	public let tags: Set<String>?
	public let keyValue: [String: String]?
	public let comment: String?
	public let file: String?
	public let function: String?
	public let line: UInt?
	
	public init (
		source: [String]? = nil,
		tags: Set<String>? = nil,
		keyValue: [String: String]? = nil,
		comment: String? = nil,
		file: String? = #file,
		function: String? = #function,
		line: UInt? = #line
	) {
		self.source = source
		self.tags = tags
		self.keyValue = keyValue
		self.comment = comment
		self.file = file
		self.function = function
		self.line = line
	}
	
	public func combined (with another: Self?) -> Self {
		let comment = self.comment != nil && self.comment?.isEmpty == false
			? self.comment
			: nil
		
		let logRecord = Self(
			source: (another?.source ?? []) + (source ?? []),
			tags: (another?.tags ?? []).union(tags ?? []),
			keyValue: (another?.keyValue ?? [:]).merging(keyValue ?? [:], uniquingKeysWith: { _, detail in detail }),
			comment: comment ?? another?.comment,
			file: file,
			function: function,
			line: line
		)
		
		return logRecord
	}
	
	public func moderated (_ enabling: Enabling) -> Self? {
		guard case let .enabled(source, tags, keyValue, comment, codeInfo) = enabling else { return nil }
		
		return .init(
			source:   source   ? self.source : nil,
			tags:     tags     ? self.tags : nil,
			keyValue: keyValue ? self.keyValue : nil,
			comment:  comment  ? self.comment : nil,
			file:     codeInfo ? self.file : nil,
			function: codeInfo ? self.function : nil,
			line:     codeInfo ? self.line : nil
		)
	}
}
