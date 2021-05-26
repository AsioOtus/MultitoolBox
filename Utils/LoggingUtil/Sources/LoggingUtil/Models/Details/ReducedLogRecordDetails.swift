struct ReducedLogRecordDetails: LogRecordDetails {
	let source: [String]?
	
	func combined (with another: Self?) -> Self {
		.init(source: another?.source ?? [] + (source ?? []))
	}
	
	func moderated (_ isEnabled: Bool) -> Self? {
		guard isEnabled else { return .init(source: []) }
		return self
	}
}
