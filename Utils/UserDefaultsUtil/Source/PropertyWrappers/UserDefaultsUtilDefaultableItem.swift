import Foundation

@propertyWrapper
public struct UserDefaultsUtilDefaultableItem<Value: Codable, DefaultValueProvider: UserDefaultsUtilDefaultValueProvider> where DefaultValueProvider.Value == Value {
	public let item: DefaultableItem<Value, DefaultValueProvider>
	
	public var wrappedValue: Value {
		get { item.loadOrDefault() }
		set { item.save(newValue) }
	}
	
	public var projectedValue: DefaultableItem<Value, DefaultValueProvider> { item }
	
	public init (wrappedValue: Value, key: String, defaultValue defaultValueProvider: DefaultValueProvider, instance: UserDefaults = .standard, settings: Settings) {
		item = .init(key, defaultValueProvider, instance, settings: settings)
	}
}
