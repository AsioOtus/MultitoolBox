extension KeychainUtil.Logger.Record {
	struct Commit {
		let record: KeychainUtil.Logger.Record
		let resolution: Resolution
		
		var value: AnyObject? {
			let value: AnyObject?
			
			if let operationValue = record.operation.value {
				value = operationValue as AnyObject
			} else if let resolutionValue = resolution.value {
				value = resolutionValue
			} else {
				value = nil
			}
			
			return value
		}
		
		func info (keychainIdentifier: String) -> Info? {
			guard
				KeychainUtil.settings.logging.enable &&
				resolution.level.rawValue >= KeychainUtil.settings.logging.level.rawValue
			else { return nil }
			
			let isExists = KeychainUtil.settings.logging.enableValuesLogging ? resolution.isExists : nil
			let value = KeychainUtil.settings.logging.enableValuesLogging ? self.value : nil
			let query = KeychainUtil.settings.logging.enableQueryLogging ? record.query : nil
			
			let info = Info(
				operation: record.operation.name,
				existance: isExists,
				value: value,
				errorType: resolution.errorType,
				error: resolution.error,
				query: query,
				keychainIdentifier: keychainIdentifier,
				level: resolution.level
			)
			
			return info
		}
	}
}
