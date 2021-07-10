public struct StandardRequestInfoStringConverter: RequestInfoStringConverter {
	public init () { }
	
	public func convert (_ requestInfo: NetworkController.RequestInfo) -> String {
		let message = "\(requestInfo.controllerLabel) – \(requestInfo.source.combine(with: "."))\nREQUEST UUID – \(requestInfo.requestUuid.uuidString)"
		return message
	}
}

fileprivate extension Array where Element == String {
	func combine (with separator: String) -> String {
		let preparedSources = self.compactMap{ $0 }.filter { !$0.isEmpty }
		return preparedSources.joined(separator: separator)
	}
}
