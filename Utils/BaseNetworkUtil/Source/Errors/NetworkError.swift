enum NetworkError: NetworkUtilError {
	case connectionFailure(Error)
	case processingFailure(ProcessingError)
	
	init (_ error: Self?, or networkError: Self) {
		if let error = error {
			self = error
		} else {
			self = networkError
		}
	}
	
	enum ProcessingError {
		case pre(Error)
		case post(Error)
	}
}
