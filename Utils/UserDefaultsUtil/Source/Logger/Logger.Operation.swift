extension Logger {
	enum Operation {
		case save
		case load
		case delete
		case isExists
		
		var name: String {
			let name: String
			
			switch self {
			case .save:
				name = "SAVE"
			case .load:
				name = "LOAD"
			case .delete:
				name = "DELETE"
			case .isExists:
				name = "IS EXISTS"
			}
			
			return name
		}
	}
}
