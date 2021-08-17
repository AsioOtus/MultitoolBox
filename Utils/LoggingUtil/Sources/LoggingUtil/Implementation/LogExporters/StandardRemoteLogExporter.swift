import Foundation

public class StandardRemoteLogExporter: LogExporter {
	public var isEnabled = true
	public var url: URL
	public var urlSession = URLSession.shared
	
	public init (url: URL) {
		self.url = url
	}
	
	public func log (metaInfo: MetaInfo, message: Data) {
		guard isEnabled else { return }
		
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

extension StandardRemoteLogExporter {
	func isEnabled (_ isEnabled: Bool) -> Self {
		self.isEnabled = isEnabled
		return self
	}
	
	func urlSession (_ urlSession: URLSession) -> Self {
		self.urlSession = urlSession
		return self
	}
}
