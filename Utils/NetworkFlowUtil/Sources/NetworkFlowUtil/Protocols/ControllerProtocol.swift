import Combine

public protocol ControllerProtocol {
	func send <RequestDelegateType: RequestDelegate> (_ requestDelegate: RequestDelegateType) -> AnyPublisher<RequestDelegateType.ContentType, Controller.Error>
}
