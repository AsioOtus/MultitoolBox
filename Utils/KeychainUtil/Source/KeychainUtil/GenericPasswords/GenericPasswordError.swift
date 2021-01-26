extension KeychainUtil {
	public struct GenericPasswordError: KeychainError {
		public let category: Category
		public let identifier: String
		
		internal init (_ identifier: String, _ category: Category) {
			self.identifier = identifier
			self.category = category
		}
		
		public enum Category {
			case codingError(Coding)
			case keychainError(KeychainUtil.Error)
			case error(Swift.Error)
			
			public enum Coding: KeychainError {
				case itemIsNotData
				case encodingFailed(Swift.Error)
				case decodingFailed(Swift.Error)
			}
		}
	}
}



extension KeychainUtil.GenericPasswordError: CustomStringConvertible {
	public var description: String { "\(identifier) – \(category.description)" }
}



extension KeychainUtil.GenericPasswordError.Category: CustomStringConvertible {
	public var description: String {
		let description: String
		
		switch self {
		case .codingError(let error):
			description = "Coding error: \(error)"
		case .keychainError(let error):
			description = "KeychainUtil error: \(error)"
		case .error(let error):
			description = "Error: \(error)"
		}
		
		return description
	}
}



extension KeychainUtil.GenericPasswordError.Category.Coding: CustomStringConvertible {
	public var description: String {
		let description: String
		
		switch self {
		case .itemIsNotData:
			description = "Item cannot be interpreted as Data"
		case .encodingFailed(let error):
			description = "Encoding failed: \(error)"
		case .decodingFailed(let error):
			description = "Decoding failed: \(error)"
		}
		
		return description
	}
}
