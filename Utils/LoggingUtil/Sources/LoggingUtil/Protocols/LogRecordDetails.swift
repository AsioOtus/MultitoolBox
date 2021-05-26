public protocol LogRecordDetails: Codable {
	associatedtype Enabling
	
	func combined (with: Self?) -> Self
	func moderated (_: Enabling) -> Self?
}
