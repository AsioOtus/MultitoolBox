protocol LoggableRequest: Request {
    func logMessage () -> String
}

extension LoggableRequest {
    func logMessage () -> String {
        
    }
}
