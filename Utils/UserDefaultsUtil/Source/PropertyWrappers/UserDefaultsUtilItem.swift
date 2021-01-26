import Foundation

@propertyWrapper
public struct UserDefaultsUtilItem<Value: Codable> {
	public let item: Item<Value>
	
	public var wrappedValue: Value? {
		get { item.load() }
		set {
			if let newValue = newValue {
				item.save(newValue)
			} else {
				item.delete()
			}
		}
	}
	
	public var projectedValue: Item<Value> { item }
	
	public init (wrappedValue: Value, key: String, instance: UserDefaults = .standard) {
		item = .init(key, instance)
	}
}
