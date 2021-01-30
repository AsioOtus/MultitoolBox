import Foundation



open class Item<Value: Codable> {
	let logger: Logger
	
	public let userDefaultsInstance: UserDefaults
	public let accessQueue: DispatchQueue
	
	public final let baseKey: String
	public final let key: String
	
	public init (_ baseKey: String, _ userDefaultsInstance: UserDefaults = .standard, queue: DispatchQueue? = nil) {
		let baseKey = baseKey.trimmingCharacters(in: .whitespacesAndNewlines)
		let key = settings.items.createKey(baseKey)
		
		self.logger = Logger(String(describing: Self.self))
		
		self.baseKey = baseKey
		self.key = key
		
		self.userDefaultsInstance = userDefaultsInstance
		self.accessQueue = queue ?? DispatchQueue(label: "\(Self.self).\(key).accessQueue")
	}

	public final func postfixedKey (_ postfixProvider: UserDefaultsUtilItemKeyPostfixProvider?) -> String {
		guard
			let postfix = postfixProvider?.userDefaultsUtilItemPostfix.trimmingCharacters(in: .whitespacesAndNewlines),
			!postfix.isEmpty
		else { return key }
		
		return "\(key).\(postfix)"
	}
}



public extension Item {
	@discardableResult
	func save (_ object: Value) -> Bool {
		accessQueue.sync {
			let (isSuccess, logCommit) = save(object, nil)
			logger.log(logCommit)
			return isSuccess
		}
	}
	
	func load () -> Value? {
		accessQueue.sync {
			let (value, logCommit) = load(nil)
			logger.log(logCommit)
			return value
		}
	}
	
	func delete () {
		accessQueue.sync {
			let logCommit = delete(nil)
			logger.log(logCommit)
		}
	}
	
	func isExists () -> Bool {
		accessQueue.sync {
			let (existance, logCommit) = isExists(nil)
			logger.log(logCommit)
			return existance
		}
	}
}



internal extension Item {
	@discardableResult
	func save (_ value: Value, _ keyPostfixProvider: UserDefaultsUtilItemKeyPostfixProvider? = nil) -> (Bool, Logger.Commit<Value>) {
		let key = postfixedKey(keyPostfixProvider)
		let logRecord = Logger.Record<Value>(.default, key, .save, value)
		
		do {
			let (oldValue, _) = load(keyPostfixProvider)
			let valueJsonString = try Coder.encode(value)
			userDefaultsInstance.set(valueJsonString, forKey: key)
			
			return (true, logRecord.commit(oldValue))
		} catch let error as UserDefaultsUtilError {
			return (false, logRecord.commit(error: error))
		} catch {
			return (false, logRecord.commit(error: Error.unexpectedError(error)))
		}
	}
	
	func load (_ keyPostfixProvider: UserDefaultsUtilItemKeyPostfixProvider? = nil) -> (Value?, Logger.Commit<Value>) {
		let key = postfixedKey(keyPostfixProvider)
		let logRecord = Logger.Record<Value>(.default, key, .load)
		
		do {
			guard let valueJsonString = userDefaultsInstance.string(forKey: key) else { throw Error.itemNotFound }
			let value = try Coder.decode(valueJsonString, Value.self)
			
			return (value, logRecord.commit(value))
		} catch let error as UserDefaultsUtilError {
			return (nil, logRecord.commit(error: error))
		} catch {
			return (nil, logRecord.commit(error: Error.unexpectedError(error)))
		}
	}
	
	func delete (_ keyPostfixProvider: UserDefaultsUtilItemKeyPostfixProvider? = nil) -> Logger.Commit<Value> {
		let key = postfixedKey(keyPostfixProvider)
		let logRecord = Logger.Record<Value>(.default, key, .delete)
		
		let (oldValue, _) = load(keyPostfixProvider)
		userDefaultsInstance.removeObject(forKey: key)
			
		return logRecord.commit(oldValue)
	}
	
	func isExists (_ keyPostfixProvider: UserDefaultsUtilItemKeyPostfixProvider? = nil) -> (Bool, Logger.Commit<Value>) {
		let key = postfixedKey(keyPostfixProvider)
		let logRecord = Logger.Record<Value>(.default, key, .isExists)
		
		let (value, _) = load(keyPostfixProvider)
		let isExists = value != nil
		
		return (isExists, logRecord.commit(value))
	}
}
