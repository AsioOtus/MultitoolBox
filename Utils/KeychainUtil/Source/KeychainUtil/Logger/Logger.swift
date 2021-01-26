import Foundation

extension KeychainUtil {
	public struct Logger {
		static func log (_ commit: Record.Commit) {
			let commitInfo = commit.info(keychainIdentifier: "KeychainUtil")
			
			if
				let commitInfo = commitInfo,
				let loggingProvider = KeychainUtil.settings.logging.loggingProvider
			{
				loggingProvider.log(commitInfo)
			}
		}
	}
}
