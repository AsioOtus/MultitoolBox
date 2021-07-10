public struct StandardRequestInfoStringConverter: RequestInfoStringConverter {
	public let componentSeparator: String
	
	public init (componentSeparator: String = "\n") {
		self.componentSeparator = componentSeparator
	}
	
	public func convert (_ requestInfo: NetworkController.RequestInfo) -> String {
		let message = "\(requestInfo.controllerLabel)\(componentSeparator)\(requestInfo.source.combine(with: "."))\(componentSeparator)REQUEST UUID – \(requestInfo.requestUuid.uuidString)"
		return message
	}
}

fileprivate extension Array where Element == String {
	func combine (with separator: String) -> String {
		let preparedSources = self.compactMap{ $0 }.filter { !$0.isEmpty }
		return preparedSources.joined(separator: separator)
	}
}
