import Foundation

public protocol TestRequest: Request where Response: TestResponse { }
public protocol TestResponse: Response { }



public struct Test { }
public extension Test {
	struct Requests { }
}



public extension Test.Requests {
    struct Example: TestRequest {
        public let urlRequest: URLRequest
        
		public let value: String
        
        init (value: String) throws {
            self.value = value
            self.urlRequest = {
                var components = URLComponents()
                components.scheme = "https"
                components.path = "postman-echo.com/get"
                components.queryItems = [URLQueryItem(name: value, value: nil)]
                return URLRequest(url: components.url!)
            }()
        }
		
        public struct Response: TestResponse {
            public let urlResponse: URLResponse
            public let data: Data
            
			public let postman: Postman
			
			public init (_ urlResponse: URLResponse, _ data: Data) throws {
                self.urlResponse = urlResponse
                self.data = data
                self.postman = try JSONDecoder().decode(Postman.self, from: data)
			}
			
			public struct Postman: Decodable {
				var args: [String: String]
			}
		}
	}
}



public extension Test.Requests.Example {
	struct Delegate: RequestDelegate {
		let value: String
		
		public init (_ value: String) {
			self.value = value
		}
		
		public func request () throws -> Test.Requests.Example {
			try Test.Requests.Example(value: value)
		}
		
		public func content (_ response: Test.Requests.Example.Response) throws -> String {
			response.postman.args.first!.key
		}
	}
}

