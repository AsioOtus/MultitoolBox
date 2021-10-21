struct Network {
	struct Requests {
		struct Concretes {
			struct ConcreteName: ConcreteRequest {
				struct Request: ConcreteRequestModel { }
				struct Response: ConcreteResponseModel { }
			}
		}
	}
}



protocol Request { }
protocol ConcreteRequest: Request { }

protocol RequestModel: Encodable { }
protocol ConcreteRequestModel: RequestModel { }

protocol Response: Decodable { }
protocol ConcreteResponse: ResponseModel { }

func a () {
	Network.Requests.Concretes.ConcreteName.Request()
	Network.Requests.Concretes.ConcreteName.Response()
}
