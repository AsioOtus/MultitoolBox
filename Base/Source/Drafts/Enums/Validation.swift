extension Validation {
	enum Result<Failure> {
		case and([Self])
		case or([Self])
		case sequence([Self])
		case failure(Failure?)
		case success
		
		var isValid: Bool {
			let isValid: Bool
			
			switch self {
			case .and(let validationResults):
				isValid = validationResults.allSatisfy{ $0.isValid }
			case .or(let validationResults):
				isValid = validationResults.contains{ $0.isValid }
			case .sequence(let validationResults):
				isValid = validationResults.allSatisfy{ $0.isValid }
			case .failure:
				isValid = false
			case .success:
				isValid = true
			}
			
			return isValid
		}
	}
}

enum Validation<Value, Failure> {
	case rule((Value) -> Bool, Failure? = nil)
	
	case or([Self])
	case and([Self])
	case sequence([Self])
	
	indirect case not(Self, Failure? = nil)
	indirect case `if`((Value) -> Bool, Self)
	
	case success
	case failure(Failure? = nil)
	case empty
	
	func validate (_ value: Value) -> Result<Failure> {
		let validationResult: Result<Failure>
		
		switch self {
		case .rule(let rule, let failure):
			validationResult = rule(value) ? .success : .failure(failure)
			
			
			
		case .or(let validations):
			var validationResults = [Result<Failure>]()
			
			for validation in validations {
				let validationResult = validation.validate(value)
				
				if validationResult.isValid {
					validationResults = []
					break
				}
				
				validationResults.append(validationResult)
			}
			
			validationResult = validationResults.isEmpty ? .success : .or(validationResults)
			
		case .and(let validations):
			var validationResults = [Result<Failure>]()
			
			for validation in validations {
				let validationResult = validation.validate(value)
				
				if !validationResult.isValid {
					validationResults.append(validationResult)
				}
			}
			
			validationResult = validationResults.isEmpty ? .success : .and(validationResults)
			
		case .sequence(let validations):
			var validationResults = [Result<Failure>]()
			
			for validation in validations {
				let validationResult = validation.validate(value)
				
				if !validationResult.isValid {
					validationResults.append(validationResult)
					break
				}
			}
			
			validationResult = validationResults.isEmpty ? .success : .sequence(validationResults)
			
			
			
		case .not(let validation, let failure):
			validationResult = validation.validate(value).isValid ? .failure(failure) : .success
			
		case .if(let condition, let validation):
			validationResult = condition(value) ? validation.validate(value) : .success
			
			
			
		case .success:
			validationResult = .success
			
		case .failure(let failure):
			validationResult = .failure(failure)
			
		case .empty:
			validationResult = .success
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
			.sequence([
				.failure("")
			])
		),
		.or([
			.not(.isLongerOrEqualThan(8, ""), ""),
			.failure(""),
			.success
		])
	])

let a: Validation<String, String> =
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
		])
	])
