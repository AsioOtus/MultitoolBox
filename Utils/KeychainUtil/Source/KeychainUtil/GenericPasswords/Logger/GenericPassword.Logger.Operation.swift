extension GenericPassword.Logger {
	enum Operation {
		case overwriting(Value)
		case saving(Value)
		case loading
		case loadingOptional
		case deletion
		case existance
		
		var name: String {
			let name: String
			
			switch self {
			case .overwriting:
				name = "SAVING"
			case .saving:
				name = "SAVING"
			case .loading:
				name = "LOADING"
			case .loadingOptional:
				name = "LOADING OPTIONAL"
			case .deletion:
				name = "DELETION"
			case .existance:
				name = "EXISTANCE"
			}
			
			return name
		}
		
		var value: Value? {
			let value: Value?
			
			if case .overwriting(let item) = self {
				value = item
			}
			else if case .saving(let item) = self {
				value = item
			} else {
				value = nil
			}
			
			return value
		}
	}
}
