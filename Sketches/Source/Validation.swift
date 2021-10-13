extension Validation {
	enum Result<Failure> {
		case or([Self])
		case any([Self])
		case and([Self])
		case all([Self])
		case failure(Failure?)
		case success
		
		var isValid: Bool {
			let isValid: Bool
			
			switch self {
			case .or(let validationResults):
				isValid = validationResults.contains{ $0.isValid }
			case .any(let validationResults):
				isValid = validationResults.contains{ $0.isValid }
			case .and(let validationResults):
				isValid = validationResults.allSatisfy{ $0.isValid }
			case .all(let validationResults):
				isValid = validationResults.allSatisfy{ $0.isValid }
			case .failure:
				isValid = false
			case .success:
				isValid = true
			}
			
			return isValid
		}
		
		var failures: Self {
			let result: Self
			
			switch self {
			case .or(let validationResults):
				result = validationResults.contains{ $0.isValid }
					? .success
					: .or(validationResults.map{ $0.failures }.filter{ !$0.isValid })
				
			case .any(let validationResults):
				result = validationResults.contains{ $0.isValid }
					? .success
					: .any(validationResults.map{ $0.failures }.filter{ !$0.isValid })
				
			case .and(let validationResults):
				result = .and(validationResults.map{ $0.failures }.filter{ !$0.isValid })
				
			case .all(let validationResults):
				let validationResult = validationResults.map{ $0.failures }.first{ !$0.isValid } ?? .success
				result = .all([validationResult].filter{ !$0.isValid })
				
			case .failure(let failure):
				result = .failure(failure)
				
			case .success:
				result = .success
			}
			
			return result
		}
	}
}

enum Validation<Value, Failure> {
	case rule((Value) -> Bool, Failure? = nil)
	case inner((Value) -> Result<Failure>)
	
	case or([Self])
	case any([Self])
	case and([Self])
	case all([Self])
	
	indirect case not(Self, Failure? = nil)
	indirect case `if`((Value) -> Bool, Self)
	
	case success
	case failure(Failure? = nil)
	
	func validate (_ value: Value) -> Result<Failure> {
		let validationResult: Result<Failure>
		
		switch self {
		case .rule(let condition, let failure):
			validationResult = condition(value) ? .success : .failure(failure)
			
		case .inner(let rule):
			validationResult = rule(value)
			
			
			
		case .or(let validations):
			var validationResults = [Validation<Value, Failure>.Result<Failure>]()
			
			for validation in validations {
				let validationResult = validation.validate(value)
				validationResults.append(validationResult)
				
				guard !validationResult.isValid else { break }
			}
			
			validationResult = .or(validationResults)
			
		case .any(let validations):
			let validationResults = validations.map{ $0.validate(value) }
			validationResult = .any(validationResults)
			
		case .and(let validations):
			var validationResults = [Validation<Value, Failure>.Result<Failure>]()
			
			for validation in validations {
				let validationResult = validation.validate(value)
				validationResults.append(validationResult)
				
				guard validationResult.isValid else { break }
			}
			
			validationResult = .and(validationResults)
			
		case .all(let validations):
			let validationResults = validations.map{ $0.validate(value) }
			validationResult = .all(validationResults)
			
			
			
		case .not(let validation, let failure):
			validationResult = validation.validate(value).isValid ? .failure(failure) : .success
			
		case .if(let condition, let validation):
			validationResult = condition(value) ? validation.validate(value) : .success
			
			
			
		case .success:
			validationResult = .success
			
		case .failure(let failure):
			validationResult = .failure(failure)
		}
		
		return validationResult
	}
}





extension Validation where Value == String {
	static func isShorterThan (_ length: Int, _ failure: Failure) -> Self {
		.rule({ value in value.count <= length }, failure)
	}
	
	static func isLongerOrEqualThan (_ length: Int, _ failure: Failure) -> Self {
		.rule({ value in value.count >= length }, failure)
	}
	
	static func isNotEmpty (_ failure: Failure) -> Self {
		.rule({ value in !value.isEmpty }, failure)
	}
}

let passwordValidation: Validation<String, String> =
	.and([
		.isLongerOrEqualThan(8, ""),
		.if({ _ in true },
			.and([
				.failure("")
			])
		),
		.or([
			.not(.isLongerOrEqualThan(8, ""), ""),
			.failure(""),
			.success
		])
	])

let aaaa: Validation<String, String> =
	.and([
		.and([
			.success,
			.failure("")
		]),
		.and([
			.success,
			.failure("")
		]),
		.or([
			.success,
			.failure("")
		]),
		.inner{ Validation<String, String>.isNotEmpty("").validate($0) }
	])
