struct Network { }





extension Network {
	struct Settings { }
	struct Constants { }
}





extension Network {
	struct Requests { }
}

extension Network.Requests {
	struct Concretes { }
}

// Пространства имен
extension Network.Requests.Concretes {
	// Общие данные для всех запросов с этим названием
	// Name
	// Path
	// Method
	// Scheme
	// Port (probably)
	struct ConcreteName {
		struct Request: ConcreteRequest {
			init (_ content: Content) { }
			
			struct Content: ConcreteRequestContent { }
		}
		
		struct Response: ConcreteResponse {
			var content: Content { return Content() }
			
			struct Content: ConcreteResponseContent { }
		}
	}
}

// Network.Requests.Core.DeviceRegistrationFlow.ActivateUser.Request.Content
extension Network {
	typealias ConcreteName = Network.Requests.Concretes.ConcreteName
}





// Network.Requests.Core.Controller
extension Network.Requests.Concretes {
	struct Controller { }
}

extension Network.Requests.Concretes.Controller {
	struct Log { }
}





extension Network.Requests {
	struct Controller { }
}

extension Network.Requests.Controller {
	struct Log { }
}





protocol Request: Encodable { }
protocol ConcreteRequest: Request {
	associatedtype Content: ConcreteRequestContent
	
	init (_ content: Content)
}

protocol Response: Decodable { }
protocol ConcreteResponse: Response {
	associatedtype Content: ConcreteResponseContent
	
	var content: Content { get }
}

protocol RequestContent { }
protocol ConcreteRequestContent: RequestContent { }

protocol ResponseContent { }
protocol ConcreteResponseContent: ResponseContent { }
