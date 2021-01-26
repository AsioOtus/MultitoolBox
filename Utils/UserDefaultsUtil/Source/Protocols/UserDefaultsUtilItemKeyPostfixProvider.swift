public protocol UserDefaultsUtilItemKeyPostfixProvider {
	var userDefaultsUtilItemPostfix: String { get }
}



extension String: UserDefaultsUtilItemKeyPostfixProvider {
	public var userDefaultsUtilItemPostfix: String { self }
}
