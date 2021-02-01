public protocol TestRequest: Request where Response: TestResponse { }
public protocol TestResponse: Response { }



public struct Test { }
public extension Test {
	struct Requests { }
}



public extension Test.Requests {
	struct Example: TestRequest {
		public let value: String
		
		public func urlRequest () throws -> URLRequest {
			var components = URLComponents()
			components.scheme = "https"
			components.path = "postman-echo.com/get"
			components.queryItems = [URLQueryItem(name: value, value: nil)]
			return URLRequest(url: components.url!)
		}
		
		public struct Response: TestResponse {
			public let postman: Postman
			
			public init (_ urlResponse: URLResponse, _ data: Data) throws {
				postman = try JSONDecoder().decode(Postman.self, from: data)
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
			Test.Requests.Example(value: value)
		}
		
		public func content (_ response: Test.Requests.Example.Response) throws -> String {
			response.postman.args.first!.key
		}
	}
}

