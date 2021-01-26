import Foundation



public extension KeychainUtil.GenericPassword.Logger {
	struct Record {
		let identifier: String
		let query: [CFString: Any]
		let operation: Operation
		
		init (_ operation: Operation, _ identifier: String, _ query: [CFString: Any]) {
			self.operation = operation
			self.identifier = identifier
			self.query = query
		}
		
		func commit (_ resolution: Resolution) -> Commit {
			let commit = Commit(
				record: self,
				resolution: resolution
			)
			
			return commit
		}
	}
}
