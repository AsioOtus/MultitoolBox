import Foundation
import Combine

public struct Serial: ControllerProtocol {
	public let controller: Controller
	private let semaphore = DispatchSemaphore(value: 1)
	
	public init (_ controller: Controller) {
		self.controller = controller
	}
	
	public func send <RequestDelegateType: RequestDelegate> (_ requestDelegate: RequestDelegateType) -> AnyPublisher<RequestDelegateType.ContentType, Controller.Error> {
		semaphore.wait()
		
		let requestPublisher = controller
			._send(requestDelegate, source: ["Serial"])
			.map { content -> RequestDelegateType.ContentType in
				DispatchQueue.global().sync { _ = semaphore.signal() }
				return content
			}
		
		return requestPublisher.eraseToAnyPublisher()
	}
}
