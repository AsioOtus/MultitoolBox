import Foundation



open class ParametrizableItem <Value: Codable, KeyPostfixProviderType: KeyPostfixProvider> {
	internal let accessQueue: DispatchQueue
	internal let logger: Logger<Value>
	
	public let key: String
	public let storage: Storage
	public let label: String
	
	public init (
		_ key: String,
		storage: Storage = StandardStorage.default,
		logHandler: LogHandler? = nil,
		queue: DispatchQueue? = nil,
		label: String = "\(ParametrizableItem.self) – \(#file):\(#line)"
	) {
		self.key = key
		self.label = label
		self.storage = storage
		
		self.accessQueue = queue ?? DispatchQueue(label: "\(label).\(key).accessQueue")
		self.logger = Logger(info: .init(key: key, itemLabel: label, storageLabel: storage.label, storageKeyPrefix: storage.keyPrefix), logHandler: logHandler ?? storage.logHandler)
	}
}



extension ParametrizableItem {
	@discardableResult
	public func save (_ value: Value, _ keyPostfixProvider: KeyPostfixProviderType) -> Bool {
		accessQueue.sync {
			let keyPostfix = keyPostfixProvider.keyPostfix
			let postfixedKey = KeyBuilder.build(key: key, postfix: keyPostfix)
			
			var details = LogRecord<Value>.Details(operation: "save")
			details.newValue = value
			details.keyPostfix = keyPostfix
			
			do {
				let oldValue = try storage.save(postfixedKey, value)
				
				details.oldValue = oldValue
				details.existance = oldValue != nil
				logger.log(details)
				
				return true
			} catch {
				details.error = StandardStorage.Error(.unexpectedError(error))
				logger.log(details)
				
				return false
			}
		}
	}
	
	public func load (_ keyPostfixProvider: KeyPostfixProviderType) -> Value? {
		accessQueue.sync {
			let keyPostfix = keyPostfixProvider.keyPostfix
			let postfixedKey = KeyBuilder.build(key: key, postfix: keyPostfix)
			
			var details = LogRecord<Value>.Details(operation: "load")
			details.keyPostfix = keyPostfix
			
			do {
				let value = try storage.load(postfixedKey, Value.self)
				
				details.oldValue = value
				details.existance = value != nil
				logger.log(details)
				
				return value
			} catch {
				details.existance = false
				details.error = StandardStorage.Error(.unexpectedError(error))
				logger.log(details)
				
				return nil
			}
		}
	}
	
	public func delete (_ keyPostfixProvider: KeyPostfixProviderType) {
		accessQueue.sync {
			let keyPostfix = keyPostfixProvider.keyPostfix
			let postfixedKey = KeyBuilder.build(key: key, postfix: keyPostfix)
			
			var details = LogRecord<Value>.Details(operation: "delete")
			details.keyPostfix = keyPostfix
			
			let value = storage.delete(postfixedKey, Value.self)
			
			details.oldValue = value
			details.existance = value != nil
			logger.log(details)
		}
	}
	
	public func isExists (_ keyPostfixProvider: KeyPostfixProviderType) -> Bool {
		accessQueue.sync {
			let keyPostfix = keyPostfixProvider.keyPostfix
			let postfixedKey = KeyBuilder.build(key: key, postfix: keyPostfix)
			
			var details = LogRecord<Value>.Details(operation: "is exists")
			details.keyPostfix = keyPostfix
			
			do {
				let value = try storage.load(postfixedKey, Value.self)
				
				details.oldValue = value
				details.existance = value != nil
				logger.log(details)
				
				return value != nil
			} catch {
				details.existance = false
				details.error = StandardStorage.Error(.unexpectedError(error))
				logger.log(details)
				
				return false
			}
		}
	}
}
