import Foundation



protocol UserDefaultsParametricItem: UserDefaultsItem {
	associatedtype KeyPostfixProvider
	
	func save (_ object: Value, _ keyPostfixProvider: KeyPostfixProvider) -> Bool
	func load (_ keyPostfixProvider: KeyPostfixProvider) -> Value?
	func delete (_ keyPostfixProvider: KeyPostfixProvider)
	func isExists (_ keyPostfixProvider: KeyPostfixProvider) -> Bool
}



open class ParametricItem<Value: Codable, KeyPostfixProvider: UserDefaultsUtilItemKeyPostfixProvider>: Item<Value>, UserDefaultsParametricItem {
	func postfixedKey (_ keyPostfixProvider: KeyPostfixProvider?) -> String {
		let postfixedKey = super.postfixedKey(keyPostfixProvider)
		return postfixedKey
	}
}



public extension ParametricItem {
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
			let (isItemExists, logCommit) = super.isExists(keyPostfixProvider)
			logger.log(logCommit)
			return isItemExists
		}
	}
}
