extension KeychainUtil.GenericPassword.Logger.Record {
	enum Operation {
		case overwriting(Item)
		case saving(Item)
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
		
		var value: Item? {
			let value: Item?
			
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
