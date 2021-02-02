import Foundation



protocol UserDefaultsParametricDefaultableItem: UserDefaultsDefaultableItem {
	associatedtype KeyPostfixProvider
	
	func save (_ object: Value, _ keyPostfixProvider: KeyPostfixProvider) -> Bool
	func load (_ keyPostfixProvider: KeyPostfixProvider) -> Value?
	func delete (_ keyPostfixProvider: KeyPostfixProvider)
	func isExists (_ keyPostfixProvider: KeyPostfixProvider) -> Bool
	func loadOrDefault (_ keyPostfixProvider: KeyPostfixProvider) -> Value
	func saveDefault (_ keyPostfixProvider: KeyPostfixProvider) -> Bool
	func saveDefaultIfNotExists (_ keyPostfixProvider: KeyPostfixProvider) -> Bool
}



open class ParametricDefaultableItem
<
	Value: Codable,
	DefaultValueProvider: UserDefaultsUtilDefaultValueProvider,
	KeyPostfixProvider: UserDefaultsUtilItemKeyPostfixProvider
>
	: DefaultableItem<Value, DefaultValueProvider>, UserDefaultsParametricDefaultableItem
	where DefaultValueProvider.Value == Value
{	
	public func postfixedKey (_ keyPostfixProvider: KeyPostfixProvider?) -> String {
		let postfixedKey = super.postfixedKey(keyPostfixProvider)
		return postfixedKey
	}
}



public extension ParametricDefaultableItem {
	@discardableResult
	func save (_ object: Value, _ keyPostfixProvider: KeyPostfixProvider) -> Bool {
		accessQueue.sync {
			let (isSavingSucceeded, logCommit) = super.save(object, keyPostfixProvider)
			logger.log(logCommit)
			return isSavingSucceeded
		}
	}
	
	func load (_ keyPostfixProvider: KeyPostfixProvider) -> Value? {
		accessQueue.sync {
			let (value, logCommit) = super.load(keyPostfixProvider)
			logger.log(logCommit)
			return value
		}
	}
	
	func delete (_ keyPostfixProvider: KeyPostfixProvider) {
		accessQueue.sync {
			let logCommit = super.delete(keyPostfixProvider)
			logger.log(logCommit)
		}
	}
	
	func isExists (_ keyPostfixProvider: KeyPostfixProvider) -> Bool {
		accessQueue.sync {
			let (isExists, logCommit) = super.isExists(keyPostfixProvider)
			logger.log(logCommit)
			return isExists
		}
	}
	
	func loadOrDefault (_ keyPostfixProvider: KeyPostfixProvider) -> Value {
		accessQueue.sync {
			let (value, logCommit) = super.loadOrDefault(keyPostfixProvider)
			logger.log(logCommit)
			return value
		}
	}
	
	@discardableResult
	func saveDefault (_ keyPostfixProvider: KeyPostfixProvider) -> Bool {
		accessQueue.sync {
			let (isSavingSucceeded, logCommit) = super.saveDefault(keyPostfixProvider)
			logger.log(logCommit)
			return isSavingSucceeded
		}
	}
	
	@discardableResult
	func saveDefaultIfNotExists (_ keyPostfixProvider: KeyPostfixProvider) -> Bool {
		accessQueue.sync {
			let (isSavingSucceeded, logCommit) = super.saveDefaultIfNotExists(keyPostfixProvider)
			logger.log(logCommit)
			return isSavingSucceeded
		}
	}
}
