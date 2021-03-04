import Foundation









func json (_ data: Data) -> String? {
	let jsonSerializationOptions: JSONSerialization.WritingOptions
		
	if #available(iOS 13.0, *) {
		jsonSerializationOptions = [.prettyPrinted, .withoutEscapingSlashes]
	} else {
		jsonSerializationOptions = [.prettyPrinted, .fragmentsAllowed]
	}
	
	guard let object = try? JSONSerialization.jsonObject(with: data, options: []),
		  let data = try? JSONSerialization.data(withJSONObject: object, options: jsonSerializationOptions),
		  let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
	
	return prettyPrintedString as String
}



struct Test: Codable {
	let a: Int
	let b: String
}

let t = Test(a: 10, b: "qwe")

let aaaa = try JSONEncoder().encode(t)


print(t)
print(aaaa.base64EncodedString())
print(String(data: aaaa, encoding: .utf8)!)
print(json(aaaa)!)

print(["A": "B", "C": "D"])


var urlRequest = URLRequest(url: URL(string: "https://rus.delfi.com/article/100?lang=ru")!)
urlRequest.httpMethod = "POST"
urlRequest.addValue("Connection", forHTTPHeaderField: "keep-alive")
urlRequest.httpBody = aaaa

let rtr = DefaultURLRequestConverter().convert(urlRequest)

print(rtr)
print(urlRequest.description)
