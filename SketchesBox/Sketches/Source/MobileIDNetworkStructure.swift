Requests.Core.DeviceRegistrationFlow.InitOAuthFlow

struct Requests {
	struct Core {
		struct DeviceRegistrationFlow {
			struct InitOAuthFlow: DeviceRegistrationFlowRequest {
				struct Request: DeviceRegistrationFlowRequestModel {
					struct Content { }
				}
				
				struct Response: DeviceRegistrationFlowRequestModel {
					struct Model: DeviceRegistrationFlowResponseModel { }
					
					struct Content { }
				}
			}
		}
	}
}


protocol Request { }

protocol CoreRequest: Request { }

protocol DeviceRegistrationFlowRequest: CoreRequest { }




protocol RequestModel: Encodable { }

protocol CoreRequestModel: RequestModel { }

protocol DeviceRegistrationFlowRequestModel : RequestModel { }



protocol Response: Decodable { }

protocol CoreResponse: Response { }

protocol DeviceRegistrationFlowRequestModel: CoreResponse { }



protocol ResponseModel: Decodable { }

protocol CoreResponseModel: ResponseModel { }

protocol DeviceRegistrationFlowResponseModel: CoreResponseModel { }
