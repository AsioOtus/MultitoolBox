public protocol KeychainGenericPasswordsItemIdentifierPostfixProvider {
	var keychainGenericPasswordsPostfix: String { get }
}



extension String: KeychainGenericPasswordsItemIdentifierPostfixProvider {
	public var keychainGenericPasswordsPostfix: String { self }
}
