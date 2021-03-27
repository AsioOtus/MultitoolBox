import Foundation

struct RawDataStringConverter: OptionalDataStringConverter {
    static let `default` = Self()
    
    let encoding: String.Encoding
    
    init (encoding: String.Encoding = .utf8) {
        self.encoding = encoding
    }
    
    func convert (_ data: Data) -> String? {
        String(data: data, encoding: encoding)
    }
}
