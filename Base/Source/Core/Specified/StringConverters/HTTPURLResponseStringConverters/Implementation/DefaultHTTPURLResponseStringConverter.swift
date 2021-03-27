import Foundation

struct DefaultHTTPURLResponseStringConverter: HTTPURLResponseStringConverter {
    static let `default` = Self()
    
    let dataStringConverter: OptionalDataStringConverter
    let dictionaryStringConverter: DictionaryStringConverter
    
    init (
        dataStringConverter: OptionalDataStringConverter = CompositeOptionalDataStringConverter.default,
        dictionaryStringConverter: DictionaryStringConverter = MultilineDictionaryStringConverter.default
    ) {
        self.dataStringConverter = dataStringConverter
        self.dictionaryStringConverter = dictionaryStringConverter
    }
    
    func convert (_ httpUrlResponse: HTTPURLResponse, body: Data?) -> String {
        var components = [String]()
        
        let firstLine = ShortHTTPURLResponseStringConverter().convert(httpUrlResponse, body: body)
        components.append(firstLine)
        
        let headers = dictionaryStringConverter.convert(httpUrlResponse.allHeaderFields)
        if !headers.isEmpty {
            components.append("")
            components.append(headers)
        }
        
        if let body = body, let bodyString = dataStringConverter.convert(body), !bodyString.isEmpty {
            components.append("")
            components.append(bodyString)
        }
        
        let string = components.joined(separator: "\n")
        return string
    }
}
