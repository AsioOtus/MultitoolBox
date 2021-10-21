protocol AppError: Error { }
protocol InnerError: AppError { }

protocol DisplayableError: AppError { }



struct DisplayUIError: DisplayableError { }



struct ErrorController {
	func convert (_ innerError: InnerError) -> DisplayUIError {
		let displayUIError: DisplayUIError
		
		switch innerError {
		case error as ...:
			displayUIError = ...
		case error as ...:
			displayUIError = ...
		default:
			displayUIError = ...
		}
		
		return displayUIError
	}
}
