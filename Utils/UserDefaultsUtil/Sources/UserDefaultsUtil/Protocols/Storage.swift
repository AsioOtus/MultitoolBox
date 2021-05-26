public protocol Storage {
	var keyPrefix: String? { get }
	var logHandler: LogHandler? { get }
	var label: String { get }
	
	func save <Value: Codable> (_ key: String, _ value: Value) throws -> Value?
	func load <Value: Codable> (_ key: String, _ type: Value.Type) throws -> Value?
	func delete <Value: Codable> (_ key: String, _ type: Value.Type) -> Value?
}
