open class ParametricGenericPassword<Value: Codable, ItemIdentifierPostfixProviderType: KeychainGenericPasswordsItemIdentifierPostfixProvider>: GenericPassword<Value> {
	public func postfixedKey (_ identifierPostfixProvider: ItemIdentifierPostfixProviderType?) -> String {
		let postfixedKey = super.postfixedIdentifier(identifierPostfixProvider)
		return postfixedKey
	}
	
	public final func overwrite (_ value: Value, _ postfixProvider: ItemIdentifierPostfixProviderType) throws {
		try accessQueue.sync {
			try super.overwrite(value, postfixProvider)
		}
	}
	
	public final func save (_ object: Value, _ postfixProvider: ItemIdentifierPostfixProviderType) throws {
		try accessQueue.sync {
			try super.save(object, postfixProvider)
		}
	}
	
	public final  func load (_ postfixProvider: ItemIdentifierPostfixProviderType) throws -> Value {
		try accessQueue.sync {
			let value = try super.load(postfixProvider)
			return value
		}
	}
	
	public final func loadOptional (_ item: Value, _ postfixProvider: ItemIdentifierPostfixProviderType) throws -> Value? {
		try accessQueue.sync {
			let value = try super.loadOptional(postfixProvider)
			return value
		}
	}
	
	public final  func delete (_ postfixProvider: ItemIdentifierPostfixProviderType) throws {
		try accessQueue.sync {
			try super.delete(postfixProvider)
		}
	}
	
	public final  func isExists (_ postfixProvider: ItemIdentifierPostfixProviderType) throws -> Bool {
		try accessQueue.sync {
			let isExists = try super.isExists(postfixProvider)
			return isExists
		}
	}
}
