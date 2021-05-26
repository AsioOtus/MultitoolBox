import Foundation

public class StandardRemoteLogExporter: LogExporter {
	public var url: URL
	public var urlSession: URLSession
	public var isDisabled: Bool
	
	public init (
		url: URL,
		urlSession: URLSession = .shared,
		isDisabled: Bool = false
	) {
		self.url = url
		self.urlSession = urlSession
		self.isDisabled = isDisabled
	}
	
	public func log (metaInfo: MetaInfo, message: Data) {
		guard !isDisabled else { return }
		
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = "POST"
		urlRequest.httpBody = message
		
		urlSession.dataTask(with: urlRequest) { (data, urlResponse, error) in
			if let error = error {
				print(error.localizedDescription)
			}
		}.resume()
	}
}
