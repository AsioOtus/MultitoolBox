public protocol UserDefaultsUtilDefaultValueProvider {
	associatedtype Value
	
	var userDefaultsUtilDefaultValue: Value { get }
}



public extension UserDefaultsUtilDefaultValueProvider {
	var userDefaultsUtilDefaultValue: Self { self }
}
