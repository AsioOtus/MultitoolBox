import Foundation

public enum NetworkError: NetworkUtilError {
    case preprocessingFailure(Swift.Error)
    case networkFailure(URLSession, URLRequest, URLError)
    case postprocessingFailure(Swift.Error)
    
    public var error: Swift.Error {
        let resultError: Swift.Error
        
        switch self {
        case .preprocessingFailure(let error): fallthrough
        case .postprocessingFailure(let error):
            resultError = error
        case .networkFailure(_, _, let error):
            resultError = error
        }
        
        return resultError
    }
}

internal extension NetworkError {
    static func preprocessing (error: Swift.Error) -> Self {
        if let innerError = error as? Self {
            return innerError
        } else {
            return .preprocessingFailure(error)
        }
    }
    
    static func postprocessing (error: Swift.Error) -> Self {
        if let innerError = error as? Self {
            return innerError
        } else {
            return .postprocessingFailure(error)
        }
    }
}
