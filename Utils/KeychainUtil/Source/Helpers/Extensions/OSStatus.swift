import Foundation

extension OSStatus {
	var message: String? {
		if #available(iOS 11.3, *) {
			let message = (SecCopyErrorMessageString(self, nil) as String?)
			return message
		} else {
			return self.description
		}
	}
}



extension OSStatus: KeychainDescribable {
	public var keychainDescription: String {
		var log = "OSStatus – \(self)"
		
		if let statusMessage = self.message {
			log += " – \(statusMessage)"
		}
		
		return log
	}
}
