import Foundation



public class StandardStorage: Storage {
	public static let `default` = StandardStorage(keyPrefix: nil)
	
	public let keyPrefix: String?
	public let userDefaults: UserDefaults
	public let logHandler: LogHandler?
	public let label: String
	
	public init (
		keyPrefix: String?,
		userDefaults: UserDefaults = .standard,
		logHandler: LogHandler? = nil,
		label: String = "\(Storage.self) – \(#file):\(#line)"
	) {
		self.keyPrefix = keyPrefix
		self.userDefaults = userDefaults
		self.logHandler = logHandler
		self.label = label
	}
	
	public func prefixKey (_ key: String) -> String { KeyBuilder.build(prefix: keyPrefix, key: key) }
}



extension StandardStorage {
	@discardableResult
	public func save <Value: Codable> (_ key: String, _ value: Value) throws -> Value? {
		let prefixedKey = prefixKey(key)
		
		let oldValue = try? load(key, Value.self)
		let valueJsonString = try Coder.encode(value)
		userDefaults.set(valueJsonString, forKey: prefixedKey)
		
		return oldValue
	}
	
	public func load <Value: Codable> (_ key: String, _ type: Value.Type) throws -> Value? {
		let prefixedKey = prefixKey(key)
		
		guard let valueJsonString = userDefaults.string(forKey: prefixedKey) else { return nil }
		let value = try Coder.decode(valueJsonString, type)
		
		return value
	}
	
	public func delete <Value: Codable> (_ key: String, _ type: Value.Type) -> Value? {
		let prefixedKey = prefixKey(key)
		
		let oldValue = try? load(key, type)
		userDefaults.removeObject(forKey: prefixedKey)
		
		return oldValue
	}
}
