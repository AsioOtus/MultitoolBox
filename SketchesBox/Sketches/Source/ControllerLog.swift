protocol ControllerLog {
	static var appIdentifierType: AppIdentifierType { get }
	
	enum AppIdentifierType {
		case none
		case long
		case short
		
		var value: String {
			let value: String
			
			switch self {
			case .none:
				value = String()
			case .long:
				value = Bundle.main.bundleIdentifier
			case .short:
				value = ""
			}
			
			return value
		}
	}
}



extension ControllerLog {
	static func compileIdentifierAction (_ controllerName: String, _ action: String) -> String {
		let identifier = compileIdentifier(controllerName)
		let logRecordStart = "\(identifier) – \(action.uppercased())"
		return logRecordStart
	}
	
	static func compileIdentifier (_ controllerName: String) -> String {
		var identifier = appIdentifierType.value
		
		if !identifier.isEmpty {
			identifier += "."
		}
		
		identifier += controllerName

		return identifier
	}
}


// Identifier - Action{ - Info}{ - ERROR - ErrorInfo} - Parameters
