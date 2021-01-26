import Foundation



extension KeychainUtil {
	public enum Class: CaseIterable {
		case genericPassword
		case internetPassword
		case certificate
		case key
		case identity
		
		public var keychainIdentifier: CFString {
			let identifier: CFString
			
			switch self {
			case .genericPassword:
				identifier = kSecClassGenericPassword
			case .internetPassword:
				identifier = kSecClassInternetPassword
			case .certificate:
				identifier = kSecClassCertificate
			case .key:
				identifier = kSecClassKey
			case .identity:
				identifier = kSecClassIdentity
			}
			
			return identifier
		}
		
		public var name: String {
			let name: String
			
			switch self {
			case .genericPassword:
				name = "Generic password"
			case .internetPassword:
				name = "Internet password"
			case .certificate:
				name = "Certificate"
			case .key:
				name = "Key"
			case .identity:
				name = "Identity"
			}
			
			return name
		}
	}
}
