import Foundation



open class ParametricItem<Value: Codable, KeyPostfixProviderType: UserDefaultsUtilItemKeyPostfixProvider>: Item<Value> {
	func postfixedKey (_ keyPostfixProvider: KeyPostfixProviderType?) -> String {
		let postfixedKey = super.postfixedKey(keyPostfixProvider)
		return postfixedKey
	}
}



extension ParametricItem {
	@discardableResult
	public func save (_ object: Value, _ keyPostfixProvider: KeyPostfixProviderType) -> Bool {
		accessQueue.sync {
			let (isSavingSucceeded, logCommit) = super.save(object, keyPostfixProvider)
			logger.log(logCommit)
			return isSavingSucceeded
		}
	}
	
	public func load (_ keyPostfixProvider: KeyPostfixProviderType) -> Value? {
		accessQueue.sync {
			let (value, logCommit) = super.load(keyPostfixProvider)
			logger.log(logCommit)
			return value
		}
	}
	
	public func delete (_ keyPostfixProvider: KeyPostfixProviderType) {
		accessQueue.sync {
			let logCommit = super.delete(keyPostfixProvider)
			logger.log(logCommit)
		}
	}
	
	public func isExists (_ keyPostfixProvider: KeyPostfixProviderType) -> Bool {
		accessQueue.sync {
			let (isItemExists, logCommit) = super.isExists(keyPostfixProvider)
			logger.log(logCommit)
			return isItemExists
		}
	}
}
