struct MultilineDictionaryStringConverter: DictionaryStringConverter {
    static let `default` = Self()
    
    func convert (_ dictionary: Dictionary<AnyHashable, Any>) -> String {
        dictionary.map{ "\($0.key): \($0.value)" }.joined(separator: "\n")
    }
}
