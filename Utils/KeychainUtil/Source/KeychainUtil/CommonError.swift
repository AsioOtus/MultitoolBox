import Foundation

public enum CommonError: KeychainError {
	case itemNotFound
	case nilItem
	case itemIsNotData
	case savingFailed(OSStatus)
	case existingItemFound
	case loadingFailed(OSStatus)
	case deletingFailed(OSStatus)
	case existanceCheckFailed(OSStatus)
	case classClearingFailed(KeychainClass, OSStatus)
}

extension CommonError: CustomStringConvertible {
	public var description: String {
		let log: String
		
		switch self {
		case .itemNotFound:
			log = "Item not found"
		case .nilItem:
			log = "Item is nil"
		case .itemIsNotData:
			log = "Item is not data"
		case .savingFailed(let status):
			log = "Saving failed: \(status.keychainDescription)"
		case .existingItemFound:
			log = "Existing item found"
		case .loadingFailed(let status):
			log = "Loading failed: \(status.keychainDescription)"
		case .deletingFailed(let status):
			log = "Deletion failed: \(status.keychainDescription)"
		case .existanceCheckFailed(let status):
			log = "Existance check failed: \(status.keychainDescription)"
		case .classClearingFailed(let keychainClass, let status):
			log = "Class clearing failed: \(keychainClass.name) – \(status.keychainDescription)"
		}
		
		return log
	}
}
