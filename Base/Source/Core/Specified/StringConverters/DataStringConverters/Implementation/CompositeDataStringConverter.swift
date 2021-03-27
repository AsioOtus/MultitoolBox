import Foundation

struct CompositeDataStringConverter: DataStringConverter {
    static let `default` = Self(
        converters: [
            JSONDataStringConverter.default,
            RawDataStringConverter.default
        ],
        lastResortConverter: Base64DataStringConverter.default
    )
    
    let converters: [OptionalDataStringConverter]
    let lastResortConverter: DataStringConverter
    
    func convert (_ data: Data) -> String {
        for converter in converters {
            if let string = converter.convert(data) {
                return string
            }
        }
        
        let string = lastResortConverter.convert(data)
        return string
    }
}
