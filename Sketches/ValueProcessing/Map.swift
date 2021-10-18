struct Map <Output, Ancestor: ProcessorProtocol>: ProcessorProtocol {
	static var name: String { "Map" }
	
	typealias Input = Ancestor.Output
	typealias Failure = Ancestor.Failure
	
	let ancestor: Ancestor
	let mapping: (Input) -> Output
	
	let label: String?
	
	init (ancestor: Ancestor, label: String? = nil, mapping: @escaping (Input) -> Output) {
		self.ancestor = ancestor
		self.mapping = mapping
		self.label = label
	}
	
	func process () -> Progress<Input, MapResult<Input, Output>, Failure> {
		let progress = ancestor.process()
		guard progress.resume else { return progress.add(input: progress.output, output: nil) }
		
		let output = mapping(progress.output)
		
		return progress.add(input: progress.output, output: output, result: .single(.init(.success, Self.name, label)))
	}
}


struct TryMap <Output, Ancestor: ProcessorProtocol>: ProcessorProtocol {
	static var name: String { "TryMap" }
	
	typealias Input = Ancestor.Output
	typealias Failure = Ancestor.Failure
	
	let ancestor: Ancestor
	let mapping: (Input) -> Output?
	
	let failure: Failure
	
	let label: String?
	
	init (ancestor: Ancestor, failure: Failure, label: String? = nil, mapping: @escaping (Input) -> Output?) {
		self.ancestor = ancestor
		self.failure = failure
		self.mapping = mapping
		self.label = label
	}
	
	func process () -> Progress<Input, Output?, Failure> {
		let progress = ancestor.process()
		guard progress.resume else { return progress }
		
		if let output = mapping(progress.output) {
			return progress.add(input: progress.output, output: output, result: .single(.init(.success, Self.name, label)))
		} else {
			return progress.add(input: progress.output, output: nil, result: .single(.init(.failure(failure), Self.name, label)))
		}
	}
}
