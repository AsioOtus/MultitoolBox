import Foundation

public class StandardStorage: Storage {
	public static let `default` = StandardStorage(keyPrefix: nil)
	
	public let keyPrefix: String?
	public let userDefaults: UserDefaults
	public let label: String
	
	public var logHandler: LogHandler? = nil
	public var enableStorageLogging: Bool = false
	
	public init (
		keyPrefix: String?,
		userDefaults: UserDefaults = .standard,
		label: String = "\(Storage.self) – \(#file):\(#line)"
	) {
		self.keyPrefix = keyPrefix
		self.userDefaults = userDefaults
		self.label = label
	}
	
	public func prefixKey (_ key: String) -> String { KeyBuilder.build(prefix: keyPrefix, key: key) }
}

extension StandardStorage {
	@discardableResult
	public func logHandler (_ logHandler: LogHandler) -> StandardStorage {
		self.logHandler = logHandler
		return self
	}
	
	@discardableResult
	public func enableStorageLogging (_ enableStorageLogging: Bool) -> StandardStorage {
		self.enableStorageLogging = enableStorageLogging
		return self
	}
}

extension StandardStorage {
	@discardableResult
	public func save <Value: Codable> (_ key: String, _ value: Value) throws -> Value? {
		var details = LogRecord<Value>.Details(operation: "save")
		details.newValue = value
		defer {
			if enableStorageLogging {
				logHandler?.log(LogRecord<Value>(info: .init(key: key, itemLabel: nil, storageLabel: label, storageKeyPrefix: keyPrefix), details: details))
			}
		}
		
		do {
			let prefixedKey = prefixKey(key)
			
			let oldValue = try? load(key, Value.self)
			
			details.oldValue = oldValue
			details.existance = oldValue != nil
			
			let valueJsonString = try Coder.encode(value)
			userDefaults.set(valueJsonString, forKey: prefixedKey)
			
			return oldValue
		} catch {
			details.error = StandardStorage.Error(.unexpectedError(error))
			
			throw error
		}
	}
	
	public func load <Value: Codable> (_ key: String, _ type: Value.Type) throws -> Value? {
		var details = LogRecord<Value>.Details(operation: "load")
		defer {
			if enableStorageLogging {
				logHandler?.log(LogRecord<Value>(info: .init(key: key, itemLabel: nil, storageLabel: label, storageKeyPrefix: keyPrefix), details: details))
			}
		}
		
		do {
			let prefixedKey = prefixKey(key)
			
			guard let valueJsonString = userDefaults.string(forKey: prefixedKey) else { return nil }
			let value = try Coder.decode(valueJsonString, type)
			
			details.oldValue = value
			details.existance = true
			
			return value
		} catch {
			details.existance = false
			details.error = StandardStorage.Error(.unexpectedError(error))
			
			throw error
		}
	}
	
	public func delete <Value: Codable> (_ key: String, _ type: Value.Type) -> Value? {
		var details = LogRecord<Value>.Details(operation: "delete")
		defer {
			if enableStorageLogging {
				logHandler?.log(LogRecord<Value>(info: .init(key: key, itemLabel: nil, storageLabel: label, storageKeyPrefix: keyPrefix), details: details))
			}
		}
		
		let prefixedKey = prefixKey(key)
		
		let oldValue = try? load(key, type)
		userDefaults.removeObject(forKey: prefixedKey)
		
		details.oldValue = oldValue
		details.existance = oldValue != nil
		
		return oldValue
	}
}
