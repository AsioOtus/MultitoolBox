import Foundation

public enum BaseNetworkError<Request: BaseNetworkUtil.Request>: BaseNetworkUtilError {
	case preprocessingFailure(Error)
	case responseFailure(Request, Error)
	case postprocessingError(URLResponse, Data, Error)
	
	init (_ error: Error, or networkError: Self) {
		if let error = error as? Self {
			self = error
		} else {
			self = networkError
		}
	}
}
