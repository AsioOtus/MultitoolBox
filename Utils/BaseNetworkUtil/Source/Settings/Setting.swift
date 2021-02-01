public enum Setting<Value> {
	case value(Value)
	case inherit
	
	public func inherited (from parent: @escaping @autoclosure () -> Value) -> Inherited {
		let inherited: Inherited
		
		switch self {
		case .value(let value):
			inherited = .value(value)
		case .inherit:
			inherited = .parent(parent)
		}
		
		return inherited
	}
}



extension Setting {
	public enum Inherited {
		case value(Value)
		case parent(() -> Value)
		
		public var value: Value {
			switch self {
			case .value(let value):
				return value
			case .parent(let parent):
				return parent()
			}
		}
	}
}



@propertyWrapper
public struct InheritedSetting<Value> {
	public var value: Setting<Value>.Inherited
	
	public var wrappedValue: Value {
		get {
			switch value {
			case .value(let value):
				return value
			case .parent(let parent):
				return parent()
			}
		}
		set {
			value = .value(newValue)
		}
	}
	
	public var projectedValue: Self { self }
	
	init (_ value: Setting<Value>.Inherited) {
		self.value = value
	}
}
