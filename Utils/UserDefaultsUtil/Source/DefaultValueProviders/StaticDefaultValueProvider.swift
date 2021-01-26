public struct StaticDefaultValueProvider<DefaultValueType>: UserDefaultsUtilDefaultValueProvider {
	public let userDefaultsUtilDefaultValue: DefaultValueType
	
	public init (_ defaultValue: DefaultValueType) {
		self.userDefaultsUtilDefaultValue = defaultValue
	}
}
