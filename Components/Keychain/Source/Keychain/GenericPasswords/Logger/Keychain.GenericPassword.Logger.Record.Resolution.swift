import os.log

extension Keychain.GenericPassword.Logger.Record {
	enum Resolution {
		case saving
		case loading(ItemType)
		case deletion
		case existance(Bool, ItemType? = nil)
		
		case codingError(Keychain.GenericPassword<ItemType>.Error.Coding)
		case keychainError(Keychain.Error)
		case genericError(Error)
		
		
		
		var value: ItemType? {
			let value: ItemType?
			
			switch self {
			case .loading(let item):
				value = item
			case .existance(_, let item):
				value = item
			default:
				value = nil
			}
			
			return value
		}
		
		var isExists: Bool? {
			let isExists: Bool?
			
			switch self {
			case .existance(let existance, _):
				isExists = existance
			default:
				isExists = nil
			}
			
			return isExists
		}
		
		var errorType: String? {
			let errorType: String?
			
			switch self {
			case .codingError:
				errorType = "CODING ERROR"
			case .keychainError:
				errorType = "KEYCHAIN ERROR"
			case .genericError:
				errorType = "ERROR"
			default:
				errorType = nil
			}
			
			return errorType
		}
		
		var error: Error? {
			let error: Error?
			
			switch self {
			case .codingError(let codingError):
				error = codingError
			case .keychainError(let keychainError):
				error = keychainError
			case .genericError(let genericError):
				error = genericError
			default:
				error = nil
			}
			
			return error
		}
		
		var level: OSLogType {
			let level: OSLogType
			
			switch self {
			case .saving:
				level = .info
			case .loading:
				level = .default
			case .deletion:
				level = .info
			case .existance:
				level = .default
			case .codingError:
				level = .error
			case .keychainError:
				level = .error
			case .genericError:
				level = .error
			}
			
			return level
		}
	}
}