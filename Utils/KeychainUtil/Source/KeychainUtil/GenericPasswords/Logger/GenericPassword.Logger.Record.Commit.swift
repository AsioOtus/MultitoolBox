extension KeychainUtil.GenericPassword.Logger.Record {
	struct Commit {
		let record: KeychainUtil.GenericPassword<Item>.Logger.Record
		let resolution: Resolution
		
		var value: Item? {
			let value: Item?
			
			if let operationValue = record.operation.value {
				value = operationValue
			} else if let resolutionValue = resolution.value {
				value = resolutionValue
			} else {
				value = nil
			}
			
			return value
		}
		
		func info (keychainIdentifier: String, enableValueLogging: Bool) -> Info? {
			guard
				KeychainUtil.settings.genericPasswords.logging.enable &&
				self.resolution.level.rawValue >= KeychainUtil.settings.genericPasswords.logging.level.rawValue
			else { return nil }
			
			let isExists = KeychainUtil.settings.genericPasswords.logging.enableValuesLogging && enableValueLogging ? resolution.isExists : nil
			let value = KeychainUtil.settings.genericPasswords.logging.enableValuesLogging && enableValueLogging ? self.value : nil
			let query = KeychainUtil.settings.genericPasswords.logging.enableQueryLogging ? record.query : nil
			
			let info = Info(
				identifier: record.identifier,
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
