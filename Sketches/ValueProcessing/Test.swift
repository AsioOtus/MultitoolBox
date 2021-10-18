@main
struct App {
	static func main () {
		
	}
}




protocol PProcessor {
	associatedtype Value
	
	func process () -> Progress<Value>
}



struct Progress <Value> {
	let value: Value
}





struct Start<Value>: PProcessor {
	let value: Value
	
	init (_ value: Value) {
		self.value = value
	}
	
	func process () -> Progress<Value> {
		.init(value: value)
	}
}





struct Map <Value, Ancestor: PProcessor>: PProcessor {
	let ancestor: Ancestor
	let mapping: () -> Value
	
	init (ancestor: Ancestor, _ mapping: @escaping () -> Value) {
		self.ancestor = ancestor
		self.mapping = mapping
	}
	
	func process () -> Progress<Value> {
		
	}
}
