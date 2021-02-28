import Foundation

public enum BaseNetworkError: BaseNetworkUtilError {
	case preprocessingFailure(Error)
	case responseFailure(URLSession, URLRequest, Error)
	case postprocessingError(Data, URLResponse, Error)
	
	init (_ error: Error, or networkError: Self) {
		if let error = error as? Self {
			self = error
		} else {
			self = networkError
		}
	}
}
