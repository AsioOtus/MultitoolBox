public enum Setting<Value> {
	case value(Value)
	case prototype
	case copy
	
	public func derive (from prototype: @escaping @autoclosure () -> Value) -> Derived {
		let derived: Derived
		
		switch self {
		case .value(let value):
			derived = .value(value)
		case .prototype:
			derived = .prototype(prototype)
		case .copy:
			derived = .value(prototype())
		}
		
		return derived
	}
}



extension Setting {
	public enum Derived {
		case value(Value)
		case prototype(() -> Value)
		
		public var value: Value {
			switch self {
			case .value(let value):
				return value
			case .prototype(let prototype):
				return prototype()
			}
		}
	}
}



@propertyWrapper
public struct DerivedSetting<Value> {
	public var value: Setting<Value>.Derived
	
	public var wrappedValue: Value {
		get {
			switch value {
			case .value(let value):
				return value
			case .prototype(let prototype):
				return prototype()
			}
		}
		set {
			value = .value(newValue)
		}
	}
	
	public var projectedValue: Setting<Value>.Derived {
		get { value }
		set { value = newValue }
	}
	
	init (_ value: Setting<Value>.Derived) {
		self.value = value
	}
}
