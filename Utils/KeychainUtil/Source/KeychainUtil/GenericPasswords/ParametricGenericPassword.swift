extension KeychainUtil {
	open class ParametricGenericPassword<Item: Codable, ItemIdentifierPostfixProviderType: KeychainGenericPasswordsItemIdentifierPostfixProvider>: GenericPassword<Item> {
		public func postfixedKey (_ identifierPostfixProvider: ItemIdentifierPostfixProviderType?) -> String {
			let postfixedKey = super.postfixedIdentifier(identifierPostfixProvider)
			return postfixedKey
		}
		
		public final func overwrite (_ item: Item, _ postfixProvider: ItemIdentifierPostfixProviderType) throws {
			try super.overwrite(item, postfixProvider)
		}
		
		public final func save (_ object: Item, _ postfixProvider: ItemIdentifierPostfixProviderType) throws {
			try super.save(object, postfixProvider)
		}
		
		public final  func load (_ postfixProvider: ItemIdentifierPostfixProviderType) throws -> Item {
			let item = try super.load(postfixProvider)
			return item
		}
		
		public final func loadOptional (_ item: Item, _ postfixProvider: ItemIdentifierPostfixProviderType) throws -> Item? {
			let item = try super.loadOptional(postfixProvider)
			return item
		}
		
		public final  func delete (_ postfixProvider: ItemIdentifierPostfixProviderType) throws {
			try super.delete(postfixProvider)
		}
		
		public final  func isExists (_ postfixProvider: ItemIdentifierPostfixProviderType) throws -> Bool {
			let isExists = try super.isExists(postfixProvider)
			return isExists
		}
	}
}
