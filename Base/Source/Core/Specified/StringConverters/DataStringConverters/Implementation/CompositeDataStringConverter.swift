import Foundation

public struct CompositeDataStringConverter: DataStringConverter {
	public static let `default` = Self(
        converters: [
            JSONDataStringConverter.default,
            RawDataStringConverter.default
        ],
        lastResortConverter: Base64DataStringConverter.default
    )
    
	public let converters: [OptionalDataStringConverter]
	public let lastResortConverter: DataStringConverter
    
	public func convert (_ data: Data) -> String {
        for converter in converters {
            if let string = converter.convert(data) {
                return string
            }
        }
        
        let string = lastResortConverter.convert(data)
        return string
    }
}
