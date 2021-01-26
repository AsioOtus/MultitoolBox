import Foundation



extension Item {
	public enum Error: UserDefaultsUtilError {
		case itemNotFound
		case codingError(CodingError)
		case unexpectedError(Swift.Error)
	}
}



extension Item.Error {
	public enum CodingError: UserDefaultsUtilError {
		case jsonDataDecodingFailed(String)
		case jsonStringEncodingFailed(String)
		
		case encodingFailed(Swift.Error)
		case decodingFailed(Swift.Error)
		
		public var description: String {
			let description: String
			
			switch self {
			case .jsonDataDecodingFailed(let jsonDataBase64):
				description = "JSON data decoding failed – \(jsonDataBase64)"
			case .jsonStringEncodingFailed(let jsonString):
				description = "JSON string encoding failed – \(jsonString)"
				
			case .encodingFailed(let error):
				description = "Encoding error – \(error.localizedDescription)"
			case .decodingFailed(let error):
				description = "Decoding error – \(error.localizedDescription)"
			}
			
			return description
		}
	}
}



extension Item.Error: CustomStringConvertible {
	public var description: String {
		let description: String
		
		switch self {
		case .itemNotFound:
			description = "Item not found"
		case .codingError(let error):
			description = "Coding error – \(error.description)"
		case .unexpectedError(let error):
			description = "Unexpected error - \(error.localizedDescription)"
		}
		
		return description
	}
}
