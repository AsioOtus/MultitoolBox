import Foundation

//public enum BaseNetworkError: BaseNetworkUtilError {
//	case connectionFailure(Error)
//	case processingFailure(ProcessingError)
//	
//	init (_ error: Self?, or networkError: Self) {
//		if let error = error {
//			self = error
//		} else {
//			self = networkError
//		}
//	}
//	
//	public enum ProcessingError {
//		case pre(Error)
//		case post(Error)
//	}
//}


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
	
	
	
	public struct Response {
		let urlRequest: URLRequest
		let urlResponse: URLResponse
		let category: Category
		
		public enum Category {
			case connection(Error)
			case postprocessing(Error)
		}
	}
}
