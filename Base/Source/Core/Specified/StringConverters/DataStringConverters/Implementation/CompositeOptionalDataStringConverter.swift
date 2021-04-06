import Foundation

public struct CompositeOptionalDataStringConverter: OptionalDataStringConverter {
	public static let `default` = Self(
        converters: [
            JSONDataStringConverter.default,
            RawDataStringConverter.default,
            Base64DataStringConverter.default
        ]
    )
    
    let converters: [OptionalDataStringConverter]
    
	public func convert (_ data: Data) -> String? {
        for converter in converters {
            if let string = converter.convert(data) {
                return string
            }
        }
        
        return nil
    }
}
