public protocol KeychainGenericPasswordPrefixProvidable {
	var prefix: String { get }
	var additionalPrefix: String? { get }
}



extension String: KeychainGenericPasswordPrefixProvidable {
	public var prefix: String { self }
	public var additionalPrefix: String? { nil }
}
