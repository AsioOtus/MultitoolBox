struct Base64DataStringConverter: DataStringConverter {
    static let `default` = Self()
    
    let options: Data.Base64EncodingOptions
    
    init (options: Data.Base64EncodingOptions = []) {
        self.options = options
    }
    
    func convert(_ data: Data) -> String {
        data.base64EncodedString(options: options)
    }
}
