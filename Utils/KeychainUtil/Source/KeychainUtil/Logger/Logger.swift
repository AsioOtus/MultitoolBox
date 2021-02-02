import Foundation

public struct Logger {
	static func log (_ commit: Commit) {
		let commitInfo = commit.info(keychainIdentifier: "KeychainUtil")
		
		if
			let commitInfo = commitInfo,
			let loggingProvider = KeychainAccessor.default.settings.logging.loggingProvider
		{
			loggingProvider.log(commitInfo)
		}
	}
}
