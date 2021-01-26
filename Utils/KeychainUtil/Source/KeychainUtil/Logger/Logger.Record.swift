import Foundation



public extension KeychainUtil.Logger {
	struct Record {
		let operation: Operation
		let query: [CFString: Any]
		
		init (_ operation: Operation, _ query: [CFString: Any]) {
			self.operation = operation
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
