import Foundation



extension KeychainUtil.Logger.Record {
	enum Operation {
		case saving(Data)
		case loading
		case deletion
		case existance
		
		case clearingClass(KeychainUtil.Class)
		case clearing
		
		var name: String {
			let name: String
			
			switch self {
			case .saving:
				name = "SAVING"
			case .loading:
				name = "LOADING"
			case .deletion:
				name = "DELETION"
			case .existance:
				name = "EXISTANCE"
			case .clearingClass:
				name = "CLEARING CLASS"
			case .clearing:
				name = "CLEARING"
			}
			
			return name
		}
		
		var value: String? {
			if case .saving(let data) = self {
				return data.base64EncodedString()
			} else {
				return nil
			}
		}
	}
}
