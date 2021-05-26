import Foundation



open class Item <Value: Codable> {
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
		label: String = "\(Item.self) – \(#file):\(#line)"
	) {
		self.key = key
		self.label = label
		self.storage = storage
		
		self.accessQueue = queue ?? DispatchQueue(label: "\(label).\(key).accessQueue")
		self.logger = Logger(info: .init(key: key, itemLabel: label, storageLabel: storage.label, storageKeyPrefix: storage.keyPrefix), logHandler: logHandler ?? storage.logHandler)
	}
}



extension Item {
	@discardableResult
	public func save (_ value: Value) -> Bool {
		accessQueue.sync {
			var details = LogRecord<Value>.Details(operation: "save")
			details.newValue = value
			
			do {
				let oldValue = try storage.save(key, value)
				
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
	
	public func load () -> Value? {
		accessQueue.sync {
			var details = LogRecord<Value>.Details(operation: "load")
			
			do {
				let value = try storage.load(key, Value.self)
				
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
	
	public func delete () {
		accessQueue.sync {
			var details = LogRecord<Value>.Details(operation: "delete")
			
			let value = storage.delete(key, Value.self)
			
			details.oldValue = value
			details.existance = value != nil
			logger.log(details)
		}
	}
	
	public func isExists () -> Bool {
		accessQueue.sync {
			var details = LogRecord<Value>.Details(operation: "is exists")
			
			do {
				let value = try storage.load(key, Value.self)
				
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
