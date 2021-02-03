public extension Array where Element == String? {
	func combine (with separator: String = ".") -> String {
		let preparedSources = self.compactMap{ $0 }.map{ $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
		return preparedSources.joined(separator: separator)
	}
}
