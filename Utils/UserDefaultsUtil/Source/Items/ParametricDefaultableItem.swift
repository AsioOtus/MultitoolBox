import Foundation



open class ParametricDefaultableItem <
	Value: Codable,
	DefaultValueProvider: UserDefaultsUtilDefaultValueProvider,
	KeyPostfixProviderType: UserDefaultsUtilItemKeyPostfixProvider
>
	: DefaultableItem<Value, DefaultValueProvider>
	where DefaultValueProvider.Value == Value
{	
	public func postfixedKey (_ keyPostfixProvider: KeyPostfixProviderType?) -> String {
		let postfixedKey = super.postfixedKey(keyPostfixProvider)
		return postfixedKey
	}
}



extension ParametricDefaultableItem {
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
			let (isExists, logCommit) = super.isExists(keyPostfixProvider)
			logger.log(logCommit)
			return isExists
		}
	}
	
	public func loadOrDefault (_ keyPostfixProvider: KeyPostfixProviderType) -> Value {
		accessQueue.sync {
			let (value, logCommit) = super.loadOrDefault(keyPostfixProvider)
			logger.log(logCommit)
			return value
		}
	}
	
	@discardableResult
	public func saveDefault (_ keyPostfixProvider: KeyPostfixProviderType) -> Bool {
		accessQueue.sync {
			let (isSavingSucceeded, logCommit) = super.saveDefault(keyPostfixProvider)
			logger.log(logCommit)
			return isSavingSucceeded
		}
	}
	
	@discardableResult
	public func saveDefaultIfNotExists (_ keyPostfixProvider: KeyPostfixProviderType) -> Bool {
		accessQueue.sync {
			let (isSavingSucceeded, logCommit) = super.saveDefaultIfNotExists(keyPostfixProvider)
			logger.log(logCommit)
			return isSavingSucceeded
		}
	}
}
