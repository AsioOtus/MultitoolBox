extension GenericPassword.Logger {
	struct Commit {
		let record: GenericPassword<Value>.Logger.Record
		let resolution: Resolution
		
		var value: Value? {
			let value: Value?
			
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
				settings.genericPasswords.logging.enable &&
				self.resolution.level.rawValue >= settings.genericPasswords.logging.level.rawValue
			else { return nil }
			
			let isExists = settings.genericPasswords.logging.enableValuesLogging && enableValueLogging ? resolution.isExists : nil
			let value = settings.genericPasswords.logging.enableValuesLogging && enableValueLogging ? self.value : nil
			let query = settings.genericPasswords.logging.enableQueryLogging ? record.query : nil
			
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
