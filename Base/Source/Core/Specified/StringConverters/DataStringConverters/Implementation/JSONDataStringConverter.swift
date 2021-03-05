struct JSONDataStringConverter: OptionalDataStringConverter {
    static let `default` = Self()
    
    func convert (_ data: Data) -> String? {
        guard
            let object = try? JSONSerialization.jsonObject(with: data, options: []),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let string = String(data: data, encoding: .utf8)
        else { return nil }
        
        return string
    }
}
