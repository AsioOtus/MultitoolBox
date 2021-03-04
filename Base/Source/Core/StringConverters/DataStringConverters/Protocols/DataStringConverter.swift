protocol DataStringConverter: OptionalDataStringConverter {
    func convert (_ data: Data) -> String
}

extension DataStringConverter {
    func convert (_ data: Data) -> String? {
        let string: String = convert(data)
        return string
    }
}
