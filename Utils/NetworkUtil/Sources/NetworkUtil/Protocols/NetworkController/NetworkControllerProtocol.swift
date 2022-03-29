import Combine

public protocol NetworkControllerProtocol {
    func send <RD: RequestDelegate> (_ requestDelegate: RD, label: String?) -> AnyPublisher<RD.ContentType, RD.ErrorType>
}
