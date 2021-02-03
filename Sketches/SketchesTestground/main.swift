//struct Settings {
//	let controllers: Controllers
//}
//
//extension Settings {
//	struct Controllers { }
//}
//
//struct Settings {
//	let controllers: Controllers
//}
//
//extension Settings {
//	struct Controllers { }
//}


struct AA {
	let a: Int
	
	init (_ a: Int) {
		self.a = a
	}
}


let aa = AA(1)

struct A {
	let a: InheritedSetting<Int>
	
	init (_ a: Setting<Int>) {
		self.a = .init(a, parent: aa.a)
	}
}


let aaa = \A.a

public enum Setting<Value> {
	case value(Value)
	case inherit
	
	public init (_ value: Value) {
		self = .value(value)
	}
}

enum InheritedSetting<Value> {
	case value(Value)
	case parent(() -> Value)
	
	init (_ setting: Setting<Value>, parent: @escaping @autoclosure () -> Value) {
		switch setting {
		case .value(let value):
			self = .value(value)
		case .inherit:
			self = .parent(parent)
		}
	}
	
	func get (_ parent: Value) -> Value {
		switch self {
		case .value(let value):
			return value
		case .parent(let parent):
			return parent()
		}
	}
}


