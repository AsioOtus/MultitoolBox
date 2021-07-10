import Combine

public protocol NetworkControllerProtocol {
	func send <RequestDelegateType: RequestDelegate> (_ requestDelegate: RequestDelegateType) -> AnyPublisher<RequestDelegateType.ContentType, NetworkController.Error>
}
