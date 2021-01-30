import Foundation

open class GenericPassword<Value: Codable> {
	let logger: Logger
	
	public let accessQueue: DispatchQueue
	
	public final let baseIdentifier: String
	public final let identifier: String
	
	public let savingQuery: [CFString: Any]
	public let loadingQuery: [CFString: Any]
	public let accessability: CFString
	
	private static var commonAtributes: [CFString: Any] {
		[kSecClass: kSecClassGenericPassword]
	}
	

	
	public init (
		_ baseIdentifier: String,
		savingQuery: [CFString: Any]? = nil,
		loadingQuery: [CFString: Any]? = nil,
		accessability: CFString = kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
		queue: DispatchQueue? = nil,
		enableValueLogging: Bool = false
	) {
		let baseIdentifier = baseIdentifier.trimmingCharacters(in: .whitespacesAndNewlines)
		let identifier = settings.genericPasswords.createIdentifier(baseIdentifier)
		
		self.baseIdentifier = baseIdentifier
		self.identifier = identifier
		
		self.savingQuery = (savingQuery ?? [:])
			.merging([kSecAttrAccessible: accessability]) { (current, _) in current }
			.merging(Self.commonAtributes) { (current, _) in current }
		
		self.loadingQuery =	(loadingQuery ?? [:])
			.merging(Self.commonAtributes) { (current, _) in current }
		self.accessability = accessability
					
		self.logger = Logger("\(Self.self)", enableValueLogging)
		self.accessQueue = queue ?? DispatchQueue(label: "\(Self.self).\(identifier).accessQueue")
	}
	
	
	
	public final func postfixedIdentifier (_ postfixProvider: KeychainGenericPasswordsItemIdentifierPostfixProvider?) -> String {
		guard
			let postfix = postfixProvider?.keychainGenericPasswordsPostfix.trimmingCharacters(in: .whitespacesAndNewlines),
			!postfix.isEmpty
		else { return identifier }
		
		return "\(self.identifier).\(postfix)"
	}
}




public extension GenericPassword {
	func overwrite (_ value: Value) throws {
		try accessQueue.sync {
			try overwrite(value, nil)
		}
	}
	
	func save (_ value: Value) throws {
		try accessQueue.sync {
			try save(value, nil)
		}
	}
	
	func load () throws -> Value {
		try accessQueue.sync {
			try load(nil)
		}
	}
	
	func loadOptional () throws -> Value? {
		try accessQueue.sync {
			try loadOptional(nil)
		}
	}
	
	func delete () throws {
		try accessQueue.sync {
			try delete(nil)
		}
	}
	
	func isExists () throws -> Bool {
		try accessQueue.sync {
			try isExists(nil)
		}
	}
}



internal extension GenericPassword {
	func overwrite (_ value: Value, _ identifierPostfixProvider: KeychainGenericPasswordsItemIdentifierPostfixProvider? = nil) throws {
		let identifier = postfixedIdentifier(identifierPostfixProvider)
		let savingQuery = self.savingQuery.merging([kSecAttrService: identifier]){ (current, _) in current }
		
		let logRecord = Logger.Record(.overwriting(value), identifier, savingQuery)
		
		do {
			let deletingQuery = Self.commonAtributes.merging([kSecAttrService: identifier]){ (current, _) in current }
			try KeychainAccessFunctions.delete(deletingQuery)
		}
		catch CommonError.itemNotFound { }
		catch {
			logger.log(logRecord.commit(.genericError(error)))
			throw GenericPasswordError(identifier, .error(error))
		}
		
		do {
			let data = try Coder.encode(value)
			try KeychainAccessFunctions.save(savingQuery, data)
			
			logger.log(logRecord.commit(.overwriting))
		} catch {
			let (error, resolution) = Self.convert(error)
			
			logger.log(logRecord.commit(resolution))
			throw GenericPasswordError(identifier, error)
		}
	}
	
	func save (_ value: Value, _ identifierPostfixProvider: KeychainGenericPasswordsItemIdentifierPostfixProvider? = nil) throws {
		let identifier = postfixedIdentifier(identifierPostfixProvider)
		let savingQuery = self.savingQuery.merging([kSecAttrService: identifier]){ (current, _) in current }
		
		let logRecord = Logger.Record(.saving(value), identifier, savingQuery)
		
		do {
			let data = try Coder.encode(value)
			try KeychainAccessFunctions.save(savingQuery, data)
			
			logger.log(logRecord.commit(.saving))
		} catch {
			let (error, resolution) = Self.convert(error)
			
			logger.log(logRecord.commit(resolution))
			throw GenericPasswordError(identifier, error)
		}
	}
	
	func load (_ identifierPostfixProvider: KeychainGenericPasswordsItemIdentifierPostfixProvider? = nil) throws -> Value {
		let identifier = postfixedIdentifier(identifierPostfixProvider)
		let loadingQuery = self.loadingQuery.merging([kSecAttrService: identifier]){ (current, _) in current }
		
		let logRecord = Logger.Record(.loading, identifier, loadingQuery)
		
		do {
			let anyItem = try KeychainAccessFunctions.load(loadingQuery)
			guard let data = anyItem as? Data else { throw GenericPasswordError.Category.Coding.valueIsNotData }
			let item = try Coder.decode(data, Value.self)
			
			logger.log(logRecord.commit(.loading(item)))
			
			return item
		} catch {
			let (error, resolution) = Self.convert(error)
			
			logger.log(logRecord.commit(resolution))
			throw GenericPasswordError(identifier, error)
		}
	}
	
	func loadOptional (_ identifierPostfixProvider: KeychainGenericPasswordsItemIdentifierPostfixProvider? = nil) throws -> Value? {
		let identifier = postfixedIdentifier(identifierPostfixProvider)
		let loadingQuery = self.loadingQuery.merging([kSecAttrService: identifier]){ (current, _) in current }
		
		let logRecord = Logger.Record(.loadingOptional, identifier, loadingQuery)
		
		do {
			do {
				let encodedValue = try KeychainAccessFunctions.load(loadingQuery)
				guard let data = encodedValue as? Data else { throw GenericPasswordError.Category.Coding.valueIsNotData }
				let value = try Coder.decode(data, Value.self)
				
				logger.log(logRecord.commit(.loadingOptional(value)))
				
				return value
			}
			catch CommonError.itemNotFound {
				logger.log(logRecord.commit(.loadingOptional(nil)))
				return nil
			}
			catch { throw error }
		} catch {
			let (error, resolution) = Self.convert(error)
			
			logger.log(logRecord.commit(resolution))
			throw GenericPasswordError(identifier, error)
			
		}
	}
	
	func delete (_ identifierPostfixProvider: KeychainGenericPasswordsItemIdentifierPostfixProvider? = nil) throws {
		let identifier = postfixedIdentifier(identifierPostfixProvider)
		let deletingQuery = Self.commonAtributes.merging([kSecAttrService: identifier]){ (current, _) in current }
		
		let logRecord = Logger.Record(.deletion, identifier, deletingQuery)
		
		do {
			try KeychainAccessFunctions.delete(deletingQuery)
			
			logger.log(logRecord.commit(.deletion))
		} catch {
			let (error, resolution) = Self.convert(error)
			
			logger.log(logRecord.commit(resolution))
			throw GenericPasswordError(identifier, error)
		}
	}
	
	func isExists (_ identifierPostfixProvider: KeychainGenericPasswordsItemIdentifierPostfixProvider? = nil) throws -> Bool {
		let identifier = postfixedIdentifier(identifierPostfixProvider)
		let loadingQuery = self.loadingQuery.merging([kSecAttrService: identifier]){ (current, _) in current }
		
		let logRecord = Logger.Record(.existance, identifier, loadingQuery)
		
		do {
			guard try KeychainAccessFunctions.isExists(loadingQuery) else {
				logger.log(logRecord.commit(.existance(false)))
				return false
			}
			
			let anyItem = try KeychainAccessFunctions.load(loadingQuery)
			guard let data = anyItem as? Data else { throw GenericPasswordError.Category.Coding.valueIsNotData }
			let value = try Coder.decode(data, Value.self)
			
			logger.log(logRecord.commit(.existance(true, value)))
			return true
		} catch {
			let (error, resolution) = Self.convert(error)
			
			logger.log(logRecord.commit(resolution))
			throw GenericPasswordError(identifier, error)
		}
	}
}



private extension GenericPassword {	
	static func convert (_ error: Swift.Error) -> (GenericPasswordError.Category, Logger.Resolution) {
		let result: (GenericPasswordError.Category, Logger.Resolution)
		
		switch error {
		case let error as GenericPasswordError.Category.Coding:
			result = (.codingError(error), .codingError(error))
		case let error as CommonError:
			result = (.keychainError(error), .keychainError(error))
		default:
			result = (.error(error), .genericError(error))
		}
		
		return result
	}
}
