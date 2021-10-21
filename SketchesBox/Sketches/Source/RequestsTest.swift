struct Requests {
	struct Core {
		struct Flow {
			struct ActivateUser: FlowRequest {
				struct Request {
					let id: Int
					let name: String
					
					struct Content: FlowRequestContent {
						let name: String
						
						var request: Request {
							Request()
						}
					}
				}
				
				struct Response {
					let isActivated: Bool
					let sessionId: String
				}
			}
		}
	}
}



typealias ActivateUser = Requests.Core.Flow.ActivateUser
typealias CoreRequestController = Requests.Core.Controller


extension Requests {
	struct Controller {
		static func send (_ content: RequestContent) {
			do {
				let request = content.request
				let encodedRequest = try encode(request)
				
				sessionManager.request(request).responseJSON(handleResponse)
			} catch {
				
			}
		}
		
		static func handleResponse (_ response: DataResponse<Any>) {
			
		}
	}
}

extension Re

extension Requests.Core {
	struct Controller {
		static func send (_ content: CoreRequestContent, _ resultHandler: (Result<Response.Content>) -> ()) {
			
		}
	}
}


Requests.Core.Controller.send(ActivateUser.Requests.Content(), handleResult)


protocol Request {
	static var method: String { get }
	static var name: String { get }
}

protocol CoreRequest: Request {
	static var scheme: String { get }
	static var address: String { get }
	static var port: Int { get }
}

protocol FlowRequest: CoreRequest {
	static var flowName: String
}

extension FlowRequest {
	static func send (_ content: Content, _ resultHandler: (Result<Response.Content>) -> ()) {
		
	}
}


protocol RequestContent {
	associatedtype Request
	var request: Request { get }
}
protocol CoreRequestContent: RequestContent { }
protocol FlowRequestContent: CoreRequestContent { }
