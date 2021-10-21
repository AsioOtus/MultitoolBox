import Foundation

typealias ResumePredicate<Failure> = (ProcessingResult<Failure>) -> Bool

protocol ProcessorProtocol {
	associatedtype Input
	associatedtype Output
	associatedtype Failure

	func process () -> Progress<Input, Output, Failure>
}

extension ProcessorProtocol {
	func validate (failure: Failure, label: String? = nil, predicate: @escaping (Output) -> Bool) -> Validation<Self> {
		Validation(ancestor: self, failure: failure, predicate: predicate)
	}
	
	func map <MapOutput> (failure: Failure, label: String? = nil, mapping: @escaping (Output) -> MapOutput?) -> TryMap<MapOutput, Self> {
		TryMap(ancestor: self, failure: failure, label: label, mapping: mapping)
	}
	
	func map <MapOutput> (label: String? = nil, mapping: @escaping (Output) -> MapOutput) -> Map<MapOutput, Self> {
		Map(ancestor: self, label: label, mapping: mapping)
	}
}









extension Progress {
	enum Value {
		case processed(Output)
		case skipped(Input)
	}
}

struct Progress<Input, Output, Failure> {
	let input: Input
	
	let value: Value
	let results: [ProcessingResult<Failure>]
	
	let resumePredicate: (ProcessingResult<Failure>) -> Bool
	
	init (
		value: Value,
		results: [ProcessingResult<Failure>],
		resumePredicate: @escaping (ProcessingResult<Failure>) -> Bool
	) {
		self.value = value
		self.results = results
		self.resumePredicate = resumePredicate
	}
	
	init (input: Input, resumePredicate: @escaping ResumePredicate<Failure>) where Input == Output {
		self.init(value: .processed(input), results: [], resumePredicate: resumePredicate)
	}
	
	func add <NewOutput> (_ newOutput: NewOutput, _ result: ProcessingResult<Failure>.Single) -> Progress<Output, NewOutput, Failure> {
		let result = ProcessingResult<Failure>.single(result)
		
		if resumePredicate(result) {
			return .init(value: .processed(newOutput), results: results + [result], resumePredicate: resumePredicate)
		} else {
			switch value {
			case .processed(let output):
				return .init(value: .skipped(output), results: results + [result], resumePredicate: resumePredicate)
			case .skipped(let input2):
				return .init(value: .skipped(input), results: results + [result], resumePredicate: resumePredicate)
			}
		}
	}
	
	func add (_ result: ProcessingResult<Failure>.Single) -> Progress<Input, Output, Failure> {
		let result = ProcessingResult<Failure>.single(result)
		
		if resumePredicate(result) {
			return .init(value: value, results: results + [result], resumePredicate: resumePredicate)
		} else {
			return .init(value: .skipped(input), results: results + [result], resumePredicate: resumePredicate)
		}
	}
}

struct ValueProcessing <Input, Failure>: ProcessorProtocol {
	static var name: String { "Validation" }
	static var resumePrediacate: ResumePredicate<Failure> {
		{ _ in
			true
		}
	}
	
	typealias Output = Input
	
	let input: Input
	
	let label: String?

	init (_ input: Input, label: String? = nil) {
		self.input = input
		self.label = label
	}

	func process () -> Progress<Input, Output, Failure> {
		.init(
			input: input,
			resumePredicate: Self.resumePrediacate
		)
	}
}









struct Validation <Ancestor: ProcessorProtocol>: ProcessorProtocol {
	static var name: String { "Validation" }

	typealias Input = Ancestor.Input
	typealias Output = Ancestor.Output
	typealias Failure = Ancestor.Failure

	let ancestor: Ancestor
	let predicate: (Output) -> Bool

	let failure: Failure
	
	let label: String?

	init (ancestor: Ancestor, failure: Failure, label: String? = nil, predicate: @escaping (Output) -> Bool) {
		self.ancestor = ancestor
		self.failure = failure
		self.predicate = predicate
		self.label = label
	}

	func process () -> Progress<Input, Output, Failure> {
		let progress = ancestor.process()
		
		guard case .processed(let input) = progress.value else { return progress }

		let isValid = predicate(input)
		return progress.add(.init(isValid ? .success : .failure(failure), Self.name, label))
	}
}

//extension And {
//	struct Progress: ProgressProtocol {
//		let value: Value
//		let results: [ProcessingResult<Failure>]
//		let resume = true
//	}
//}
//
//struct And <Ancestor: ProcessorProtocol, Inner: ProcessorProtocol, Failure>: ProcessorProtocol {
//	typealias Value = Ancestor.Value
//
//	let ancestor: Ancestor
//	let innerProcessors: (Self) -> (Inner)
//
//	init (ancestor: Ancestor, failure: Failure, inner processors: (Self) -> (Inner)) {
//		self.ancestor = ancestor
//	}
//
//	func run () -> Ancestor.Progress {
//		let progress = ancestor.run()
//
//		guard progress.resume else { return progress }
//
//		let innerProgress = innerProcessors(self).run()
//		progress.join(another: innerProgress)
//	}
//}



let processingResult = ValueProcessing<Data, String>("qwe".data(using: .utf8)!)
	.map(failure: "") { String(data: $0, encoding: .utf8)! }
	.validate(failure: "") { $0 == "qwe" }
	.map { $0.dropFirst(1) }
//	.validate(failure: "") { _ in true }
	
//	.tryMap(failure: "") { a in a }

print(processingResult)








public enum ProcessingResult <Failure> {
	case single(ProcessingResult<Failure>.Single)
	indirect case multiple(AnyMultipleProcessingResult<Failure>)

	public var summary: ProcessingResult<Failure>.Single {
		switch self {
		case .single(let singleResult):
			return singleResult

		case .multiple(let multipleResult):
			return multipleResult.summary
		}
	}

	public var description: String {
		switch self {
		case .single(let singleResult):
			return singleResult.description

		case .multiple(let multipleResult):
			return multipleResult.description
		}
	}
}

public extension ProcessingResult {
	struct Single {
		public enum Outcome {
			case success
			case failure(Failure)

			public var isSuccess: Bool {
				switch self {
				case .success: return true
				case .failure: return false
				}
			}

			public var description: String {
				switch self {
				case .success:
					return "SUCCESS"

				case .failure(let failure):
					return "FAILURE(\(String(describing: failure)))"
				}
			}
		}

		public var description: String { "\(name.uppercased())\(label.map{ $0.isEmpty ? "" : " – \($0)" } ?? ""): \(outcome.description)" }

		public let outcome: Outcome
		public let name: String
		public let label: String?

		public init (_ outcome: Outcome, _ name: String, _ label: String? = nil) {
			self.outcome = outcome
			self.name = name
			self.label = label
		}
	}
}

public protocol MultipleProcessingResult {
	associatedtype Failure

	var results: [ProcessingResult<Failure>] { get }
	var summary: ProcessingResult<Failure>.Single { get }
}

public extension MultipleProcessingResult {
	var description: String {
		let resultsDescription = results
			.map{
				$0.description
					.split(separator: "\n")
					.map{ "    " + $0 }
					.joined(separator: "\n")
			}
			.joined(separator: "\n")

		return "\(summary.description) {\(resultsDescription.isEmpty ? " " : "\n\(resultsDescription)\n")}"
	}
}

public struct AnyMultipleProcessingResult <Failure>: MultipleProcessingResult {
	public let results: [ProcessingResult<Failure>]
	public let summary: ProcessingResult<Failure>.Single

	public init <MultipleResult: MultipleProcessingResult> (_ multipleResult: MultipleResult) where MultipleResult.Failure == Failure {
		self.results = multipleResult.results
		self.summary = multipleResult.summary
	}
}

public extension MultipleProcessingResult {
	func eraseToAnyMultipleResult () -> AnyMultipleProcessingResult<Failure> {
		.init(self)
	}
}

