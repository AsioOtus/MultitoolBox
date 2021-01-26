import Foundation

extension KeychainUtil {
	open class GenericPassword <Item: Codable> {
		private let logger: Logger
		
		private static var commonAtributes: [CFString: Any] {
			[kSecClass: kSecClassGenericPassword]
		}
		
		private let baseSavingQuery: [CFString: Any]
		private let baseLoadingQuery: [CFString: Any]
		private let accessability: CFString
		
		public var savingQuery: [CFString: Any] {
			let savingQuery = self.baseSavingQuery.merging([kSecAttrAccessible: accessability]){ (current, _) in current }
			let fullSavingQuery = savingQuery.merging(Self.commonAtributes){ (current, _) in current }
			return fullSavingQuery
		}
		
		public var loadingQuery: [CFString: Any] {
			let fullLoadingQuery = baseLoadingQuery.merging(Self.commonAtributes){ (current, _) in current }
			return fullLoadingQuery
		}
		
		
		
		internal final var identifierPrefix: String {
			guard let prefixProvider = KeychainUtil.settings.genericPasswords.itemIdentifierPrefixProvider else { fatalError("KeychainUtil.Settings.current.genericPasswords.prefixProvider is nil") }
			let prefix = prefixProvider.keychainGenericPasswordsPrefix
			return prefix
		}
		public final let itemIdentifier: String
		public final var identifier: String { "\(identifierPrefix).\(itemIdentifier)" }
		public final func postfixedIdentifier (_ postfixProvider: KeychainGenericPasswordsItemIdentifierPostfixProvider?) -> String {
			guard let postfixProvider = postfixProvider else { return identifier }
			
			let postfix = postfixProvider.keychainGenericPasswordsPostfix.trimmingCharacters(in: .whitespacesAndNewlines)
			
			guard !postfix.isEmpty else { return identifier }
			
			return "\(self.identifier).\(postfix)"
		}
		
		
		
		public init (_ shortIdentifier: String, savingQuery: [CFString: Any]? = nil, loadingQuery: [CFString: Any]? = nil, accessability: CFString = kSecAttrAccessibleWhenUnlockedThisDeviceOnly, enableValueLogging: Bool = false) {
			self.itemIdentifier = shortIdentifier
			self.baseSavingQuery = savingQuery ?? [:]
			self.baseLoadingQuery = loadingQuery ?? [:]
			self.accessability = accessability
						
			self.logger = Logger(String(describing: Self.self), enableValueLogging)
		}
	}
}



public extension KeychainUtil.GenericPassword {
	func overwrite (_ item: Item) throws {
		try overwrite(item, nil)
	}
	
	func save (_ item: Item) throws {
		try save(item, nil)
	}
	
	func load () throws -> Item {
		try load(nil)
	}
	
	func loadOptional () throws -> Item? {
		try loadOptional(nil)
	}
	
	func delete () throws {
		try delete(nil)
	}
	
	func isExists () throws -> Bool {
		try isExists(nil)
	}
}



internal extension KeychainUtil.GenericPassword {
	func overwrite (_ item: Item, _ identifierPostfixProvider: KeychainGenericPasswordsItemIdentifierPostfixProvider? = nil) throws {
		try KeychainUtil.accessQueue.sync {
			let identifier = postfixedIdentifier(identifierPostfixProvider)
			let savingQuery = self.savingQuery.merging([kSecAttrService: identifier]){ (current, _) in current }
			
			let logRecord = Logger.Record(.overwriting(item), identifier, savingQuery)
			
			do {
				let deletingQuery = Self.commonAtributes.merging([kSecAttrService: identifier]){ (current, _) in current }
				try KeychainUtil.delete(deletingQuery)
			}
			catch KeychainUtil.Error.itemNotFound { }
			catch {
				logger.log(logRecord.commit(.genericError(error)))
				throw KeychainUtil.GenericPasswordError(identifier, .error(error))
			}
			
			do {
				let data = try Self.encode(item)
				try KeychainUtil.save(savingQuery, data)
				
				logger.log(logRecord.commit(.overwriting))
			} catch {
				let (error, resolution) = Self.convert(error)
				
				logger.log(logRecord.commit(resolution))
				throw KeychainUtil.GenericPasswordError(identifier, error)
			}
		}
	}
	
	func save (_ item: Item, _ identifierPostfixProvider: KeychainGenericPasswordsItemIdentifierPostfixProvider? = nil) throws {
		try KeychainUtil.accessQueue.sync {
			let identifier = postfixedIdentifier(identifierPostfixProvider)
			let savingQuery = self.savingQuery.merging([kSecAttrService: identifier]){ (current, _) in current }
			
			let logRecord = Logger.Record(.saving(item), identifier, savingQuery)
			
			do {
				let data = try Self.encode(item)
				try KeychainUtil.save(savingQuery, data)
				
				logger.log(logRecord.commit(.saving))
			} catch {
				let (error, resolution) = Self.convert(error)
				
				logger.log(logRecord.commit(resolution))
				throw KeychainUtil.GenericPasswordError(identifier, error)
			}
		}
	}
	
	func load (_ identifierPostfixProvider: KeychainGenericPasswordsItemIdentifierPostfixProvider? = nil) throws -> Item {
		try KeychainUtil.accessQueue.sync {
			let identifier = postfixedIdentifier(identifierPostfixProvider)
			let loadingQuery = self.loadingQuery.merging([kSecAttrService: identifier]){ (current, _) in current }

			let logRecord = Logger.Record(.loading, identifier, loadingQuery)

			do {
				let anyItem = try KeychainUtil.load(loadingQuery)
				guard let data = anyItem as? Data else { throw KeychainUtil.GenericPasswordError.Category.Coding.itemIsNotData }
				let item = try Self.decode(data, Item.self)
				
				logger.log(logRecord.commit(.loading(item)))
				
				return item
			} catch {
				let (error, resolution) = Self.convert(error)
				
				logger.log(logRecord.commit(resolution))
				throw KeychainUtil.GenericPasswordError(identifier, error)
			}
		}
	}
	
	func loadOptional (_ identifierPostfixProvider: KeychainGenericPasswordsItemIdentifierPostfixProvider? = nil) throws -> Item? {
		try KeychainUtil.accessQueue.sync {
			let identifier = postfixedIdentifier(identifierPostfixProvider)
			let loadingQuery = self.loadingQuery.merging([kSecAttrService: identifier]){ (current, _) in current }
			
			let logRecord = Logger.Record(.loadingOptional, identifier, loadingQuery)
			
			do {
				do {
					let anyItem = try KeychainUtil.load(loadingQuery)
					guard let data = anyItem as? Data else { throw KeychainUtil.GenericPasswordError.Category.Coding.itemIsNotData }
					let item = try Self.decode(data, Item.self)
					
					logger.log(logRecord.commit(.loadingOptional(item)))
					
					return item
				}
				catch KeychainUtil.Error.itemNotFound {
					logger.log(logRecord.commit(.loadingOptional(nil)))
					return nil
				}
				catch { throw error }
			} catch {
				let (error, resolution) = Self.convert(error)
				
				logger.log(logRecord.commit(resolution))
				throw KeychainUtil.GenericPasswordError(identifier, error)
			}
		}
	}
	
	func delete (_ identifierPostfixProvider: KeychainGenericPasswordsItemIdentifierPostfixProvider? = nil) throws {
		try KeychainUtil.accessQueue.sync {
			let identifier = postfixedIdentifier(identifierPostfixProvider)
			let deletingQuery = Self.commonAtributes.merging([kSecAttrService: identifier]){ (current, _) in current }
			
			let logRecord = Logger.Record(.deletion, identifier, deletingQuery)
			
			do {
				try KeychainUtil.delete(deletingQuery)
				
				logger.log(logRecord.commit(.deletion))
			} catch {
				let (error, resolution) = Self.convert(error)
				
				logger.log(logRecord.commit(resolution))
				throw KeychainUtil.GenericPasswordError(identifier, error)
			}
		}
	}
	
	func isExists (_ identifierPostfixProvider: KeychainGenericPasswordsItemIdentifierPostfixProvider? = nil) throws -> Bool {
		try KeychainUtil.accessQueue.sync {
			let identifier = postfixedIdentifier(identifierPostfixProvider)
			let loadingQuery = self.loadingQuery.merging([kSecAttrService: identifier]){ (current, _) in current }
			
			let logRecord = Logger.Record(.existance, identifier, loadingQuery)
			
			do {
				guard try KeychainUtil.isExists(loadingQuery) else {
					logger.log(logRecord.commit(.existance(false)))
					return false
				}
				
				let anyItem = try KeychainUtil.load(loadingQuery)
				guard let data = anyItem as? Data else { throw KeychainUtil.GenericPasswordError.Category.Coding.itemIsNotData }
				let item = try Self.decode(data, Item.self)
				
				logger.log(logRecord.commit(.existance(true, item)))
				return true
			} catch {
				let (error, resolution) = Self.convert(error)
				
				logger.log(logRecord.commit(resolution))
				throw KeychainUtil.GenericPasswordError(identifier, error)
			}
		}
	}
}



private extension KeychainUtil.GenericPassword {
	static func encode <T: Encodable> (_ object: T) throws -> Data {
		do {
			let data = try JSONEncoder().encode(object)
			return data
		} catch {
			throw KeychainUtil.GenericPasswordError.Category.Coding.encodingFailed(error)
		}
	}
	
	static func decode <T: Decodable> (_ data: Data, _ type: T.Type) throws -> T {
		do {
			let object = try JSONDecoder().decode(type, from: data)
			return object
		} catch {
			throw KeychainUtil.GenericPasswordError.Category.Coding.decodingFailed(error)
		}
	}
	
	static func convert (_ error: Swift.Error) -> (KeychainUtil.GenericPasswordError.Category, Logger.Record.Resolution) {
		let result: (KeychainUtil.GenericPasswordError.Category, Logger.Record.Resolution)
		
		switch error {
		case let error as KeychainUtil.GenericPasswordError.Category.Coding:
			result = (.codingError(error), .codingError(error))
		case let error as KeychainUtil.Error:
			result = (.keychainError(error), .keychainError(error))
		default:
			result = (.error(error), .genericError(error))
		}
		
		return result
	}
}
