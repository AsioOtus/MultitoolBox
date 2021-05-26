import Foundation



open class DefaultableItem <Value: Codable>: Item<Value> {
	public var defaultValue: () -> Value
	
	public init (
		_ key: String,
		defaultValue: Value,
		storage: Storage = StandardStorage.default,
		logHandler: LogHandler? = nil,
		queue: DispatchQueue? = nil,
		label: String = "\(DefaultableItem.self) – \(#file):\(#line)"
	) {
		self.defaultValue = { defaultValue }
		
		super.init(key, storage: storage, logHandler: logHandler, queue: queue, label: label)
	}
	
	public init (
		_ key: String,
		defaultValue: @escaping () -> Value,
		storage: Storage = StandardStorage.default,
		logHandler: LogHandler? = nil,
		queue: DispatchQueue? = nil,
		label: String = "\(DefaultableItem.self) – \(#file):\(#line)"
	) {
		self.defaultValue = defaultValue
		
		super.init(key, storage: storage, logHandler: logHandler, queue: queue, label: label)
	}
}



extension DefaultableItem {
	public func loadOrDefault () -> Value {
		accessQueue.sync {
			var details = LogRecord<Value>.Details(operation: "load or default")
			
			do {
				if let value = try storage.load(key, Value.self) {
					details.oldValue = value
					details.existance = true
					logger.log(details)
					
					return value
				} else {
					let defaultValue = self.defaultValue()
					
					details.existance = false
					details.comment = "default value used – \(defaultValue)"
					logger.log(details)
					
					return defaultValue
				}
			} catch {
				let defaultValue = self.defaultValue()
				
				details.existance = false
				details.error = StandardStorage.Error(.unexpectedError(error))
				details.comment = "default value used – \(defaultValue)"
				logger.log(details)
				
				return defaultValue
			}
		}
	}
	
	@discardableResult
	public func saveDefault () -> Bool {
		accessQueue.sync {
			var details = LogRecord<Value>.Details(operation: "save default")
			
			do {
				let defaultValue = self.defaultValue()
				
				details.newValue = defaultValue
				
				let oldValue = try storage.save(key, defaultValue)
				
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
	
	@discardableResult
	public func saveDefaultIfNotExist () -> Bool {
		accessQueue.sync {
			var details = LogRecord<Value>.Details(operation: "save default if not exist")
			
			do {
				if let value = try? storage.load(key, Value.self) {
					details.oldValue = value
					details.existance = true
					details.comment = "old value preserved"
					logger.log(details)
					
					return true
				} else {
					let defaultValue = self.defaultValue()
					
					details.newValue = defaultValue
					
					let oldValue = try storage.save(key, defaultValue)
					
					details.oldValue = oldValue
					details.existance = oldValue != nil
					details.comment = "default value saved"
					logger.log(details)
					
					return true
				}
			} catch {
				details.error = StandardStorage.Error(.unexpectedError(error))
				logger.log(details)
				
				return false
			}
		}
	}
}
