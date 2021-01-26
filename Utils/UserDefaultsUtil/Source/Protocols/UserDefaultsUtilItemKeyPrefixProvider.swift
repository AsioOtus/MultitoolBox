public protocol UserDefaultsUtilItemKeyPrefixProvider {
	var userDefaultsUtilItemPrefix: String { get }
}



extension String: UserDefaultsUtilItemKeyPrefixProvider {
	public var userDefaultsUtilItemPrefix: String { self }
}
