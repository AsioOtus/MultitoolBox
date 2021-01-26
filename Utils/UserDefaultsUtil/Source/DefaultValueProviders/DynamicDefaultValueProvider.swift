public struct DynamicDefaultValueProvider <DefaultValueType>: UserDefaultsUtilDefaultValueProvider {
	private let defaultValueSource: () -> DefaultValueType
	
	public var userDefaultsUtilDefaultValue: DefaultValueType {
		defaultValueSource()
	}
	
	public init (_ defaultValueSource: @autoclosure @escaping () -> DefaultValueType) {
		self.defaultValueSource = defaultValueSource
	}
}
