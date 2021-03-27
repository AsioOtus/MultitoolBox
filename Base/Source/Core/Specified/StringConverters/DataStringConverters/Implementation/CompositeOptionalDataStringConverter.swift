import Foundation

struct CompositeOptionalDataStringConverter: OptionalDataStringConverter {
    static let `default` = Self(
        converters: [
            JSONDataStringConverter.default,
            RawDataStringConverter.default,
            Base64DataStringConverter.default
        ]
    )
    
    let converters: [OptionalDataStringConverter]
    
    func convert (_ data: Data) -> String? {
        for converter in converters {
            if let string = converter.convert(data) {
                return string
            }
        }
        
        return nil
    }
}
