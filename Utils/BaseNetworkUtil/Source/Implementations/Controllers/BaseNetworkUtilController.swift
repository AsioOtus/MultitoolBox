import Combine

public protocol BaseNetworkUtilController {
    func send <RequestDelegate: BaseNetworkUtil.RequestDelegate> (_ requestDelegate: RequestDelegate) -> AnyPublisher<RequestDelegate.Content, BaseNetworkError<RequestDelegate.Request>>
}
