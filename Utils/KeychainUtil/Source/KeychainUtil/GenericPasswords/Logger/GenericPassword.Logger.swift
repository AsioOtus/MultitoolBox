import Foundation

extension GenericPassword {
	public class Logger {
		private let keychainIdentifier: String
		private let enableValueLogging: Bool
		
		init (_ keychainIdentifier: String, _ enableValueLogging: Bool) {
			self.keychainIdentifier = "KeychainUtil.\(keychainIdentifier)"
			self.enableValueLogging = enableValueLogging
		}
		
		func log (_ commit: Commit) {
			let commitInfo = commit.info(keychainIdentifier: keychainIdentifier, enableValueLogging: enableValueLogging)
			
			if
				let commitInfo = commitInfo,
				let loggingProvider = KeychainAccessor.default.settings.genericPasswords.logging.loggingProvider
			{
				loggingProvider.log(commitInfo)
			}
		}
	}
}
