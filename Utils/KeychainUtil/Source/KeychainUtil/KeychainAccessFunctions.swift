import Foundation

public var settings: Settings = .default

struct KeychainAccessFunctions {
	public static func save (_ query: [CFString: Any], _ value: Data) throws {
		let logRecord = Logger.Record(.saving(value), query)
		
		do {
			let query = query.merging([kSecValueData: value]) { (current, _) in current }
			
			let status = SecItemAdd(query as CFDictionary, nil)
			guard status != errSecDuplicateItem else { throw CommonError.existingItemFound }
			guard status == errSecSuccess else { throw CommonError.savingFailed(status) }
			
			Logger.log(logRecord.commit(.saving))
		} catch {
			Logger.log(logRecord.commit(.error(error)))
			throw error
		}
	}
	
	public static func load (_ query: [CFString: Any]) throws -> AnyObject {
		let logRecord = Logger.Record(.loading, query)
		
		do {
			let loadingAttributes: [CFString: Any] = [
				kSecReturnData: kCFBooleanTrue as Any,
				kSecMatchLimit: kSecMatchLimitOne
			]
			let query = query.merging(loadingAttributes) { (current, _) in current }
			
			var value: AnyObject?
			let status = SecItemCopyMatching(query as CFDictionary, &value)
			guard status != errSecItemNotFound else { throw CommonError.itemNotFound }
			guard status == errSecSuccess else { throw CommonError.loadingFailed(status) }
			guard let unwrappedValue = value else { throw CommonError.nilItem }
			
			Logger.log(logRecord.commit(.loading(unwrappedValue)))
			return unwrappedValue
		} catch {
			Logger.log(logRecord.commit(.error(error)))
			throw error
		}
	}
	
	public static func delete (_ query: [CFString: Any]) throws {
		let logRecord = Logger.Record(.deletion, query)
		
		do {
			let status = SecItemDelete(query as CFDictionary)
			guard status != errSecItemNotFound else { throw CommonError.itemNotFound }
			guard status == errSecSuccess else { throw CommonError.deletingFailed(status) }
			
			Logger.log(logRecord.commit(.deletion))
		} catch {
			Logger.log(logRecord.commit(.error(error)))
			throw error
		}
	}
	
	public static func isExists (_ query: [CFString: Any]) throws -> Bool {
		let logRecord = Logger.Record(.existance, query)
		let isExists: Bool
		
		do {
			let loadingAttributes: [CFString: Any] = [
				kSecReturnData: kCFBooleanTrue as Any,
				kSecMatchLimit: kSecMatchLimitOne
			]
			let query = query.merging(loadingAttributes){ (current, _) in current }
			
			var item: AnyObject?
			let status = SecItemCopyMatching(query as CFDictionary, &item)
			guard status != errSecItemNotFound else { throw CommonError.itemNotFound }
			guard status == errSecSuccess else { throw CommonError.existanceCheckFailed(status) }
			guard item != nil else { throw CommonError.nilItem }
			
			isExists = true
			Logger.log(logRecord.commit(.existance(isExists, item)))
			return isExists
		} catch CommonError.itemNotFound {
			isExists = false
			Logger.log(logRecord.commit(.existance(isExists)))
			return isExists
		} catch CommonError.nilItem {
			isExists = false
			Logger.log(logRecord.commit(.existance(isExists)))
			return isExists
		} catch {
			Logger.log(logRecord.commit(.error(error)))
			throw error
		}
	}
	
	
	
	@discardableResult
	public static func clear () -> [KeychainClass: OSStatus] {
		let logRecord = Logger.Record(.clearing, [:])
		
		var deleteResults = [KeychainClass: OSStatus]()
		
		for keychainClass in KeychainClass.allCases {
			let logRecord = Logger.Record(.clearingClass(keychainClass), [:])
			
			let query = [kSecClass: keychainClass.keychainIdentifier]
			let status = SecItemDelete(query as CFDictionary)
			
			Logger.log(logRecord.commit(.clearingClass(keychainClass, status)))
			
			deleteResults[keychainClass] = status
		}
		
		Logger.log(logRecord.commit(.clearing(deleteResults)))
		
		return deleteResults
	}
	
	public static func clear (_ keychainClass: KeychainClass) throws {
		let logRecord = Logger.Record(.clearingClass(keychainClass), [:])
		
		do {
			let query = [kSecClass: keychainClass.keychainIdentifier]
			let status = SecItemDelete(query as CFDictionary)
			
			guard status == errSecSuccess else { throw CommonError.classClearingFailed(keychainClass, status) }
			
			Logger.log(logRecord.commit(.clearingClass(keychainClass, status)))
		} catch {
			Logger.log(logRecord.commit(.error(error)))
			throw error
		}
	}
}
