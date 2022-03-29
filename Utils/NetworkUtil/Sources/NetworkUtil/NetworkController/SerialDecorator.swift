import Foundation
import Combine

public typealias Serial = SerialDecorator

public class SerialDecorator: NetworkControllerProtocol {
	private let semaphore: DispatchSemaphore
	
	public let controller: NetworkController
	public let source: [String]
	public let identificationInfo: IdentificationInfo
	
	public init (
		_ controller: NetworkController,
		semaphore: DispatchSemaphore? = nil,
		source: [String] = [],
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.semaphore = semaphore ?? DispatchSemaphore(value: 1)
		self.controller = controller
		self.source = source
		self.identificationInfo = IdentificationInfo(
			module: Info.moduleName,
			type: String(describing: Self.self),
			file: file,
			line: line,
			label: label
		)
	}

    public func send <RD: RequestDelegate> (_ requestDelegate: RD, label: String? = nil) -> AnyPublisher<RD.ContentType, RD.ErrorType> {
		let requestInfo = RequestInfo(
			uuid: UUID(),
			label: label,
			delegate: requestDelegate.name,
			source: source,
			controllers: [identificationInfo]
		)
        
		return Just(requestDelegate)
			.wait(for: semaphore)
            .mapError{ requestDelegate.error(NetworkError.preprocessing(error: $0), requestInfo) }
            .flatMap { self.controller._send($0, requestInfo).eraseToAnyPublisher() }
			.release(semaphore)
            .mapError{ requestDelegate.error(NetworkError.postprocessing(error: $0), requestInfo) }
			.eraseToAnyPublisher()
	}
}
