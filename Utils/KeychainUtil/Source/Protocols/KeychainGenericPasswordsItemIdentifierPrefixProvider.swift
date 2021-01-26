public protocol KeychainGenericPasswordsItemIdentifierPrefixProvider {
	var keychainGenericPasswordsPrefix: String { get }
}



extension String: KeychainGenericPasswordsItemIdentifierPrefixProvider {
	public var keychainGenericPasswordsPrefix: String { self }
}
