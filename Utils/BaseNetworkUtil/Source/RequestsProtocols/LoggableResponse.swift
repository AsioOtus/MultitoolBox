protocol LoggableResponse: Response {
    func logMessage () -> String
}

extension LoggableResponse {
    func logMessage () -> String {
        
    }
}
