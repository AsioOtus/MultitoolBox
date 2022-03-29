public struct StandardRequestInfoStringConverter: RequestInfoStringConverter {
	public let componentSeparator: String
	
	public init (componentSeparator: String = "\n") {
		self.componentSeparator = componentSeparator
	}
	
	public func convert (_ requestInfo: RequestInfo) -> String {
		let message = "REQUEST UUID – \(requestInfo.uuid.uuidString)"
		return message
	}
}

fileprivate extension Array where Element == String {
	func combine (with separator: String) -> String {
		let preparedSources = self.compactMap{ $0 }.filter { !$0.isEmpty }
		return preparedSources.joined(separator: separator)
	}
}
