extension StandardRemoteLogExporter {
	struct TransportModel: Codable {
		public let metaInfo: EnhancedMetaInfo
		public let logRecord: EnhancedLogRecord<Message>
	}
}

public class StandardRemoteLogExporter<Message: Codable>: EnhancedLogExporter {
	public typealias Message = EnhancedLogRecord<Message>
	public typealias Configuration = Void
	
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
	
	public func log (metaInfo: EnhancedMetaInfo, message: EnhancedLogRecord<Message>, configuration: Void? = nil) {
		guard !isDisabled else { return }
		
		do {
			let transportModel = TransportModel(metaInfo: metaInfo, logRecord: message)
			
			var urlRequest = URLRequest(url: url)
			urlRequest.httpMethod = "POST"
			urlRequest.httpBody = try JSONEncoder().encode(transportModel)
			
			urlSession.dataTask(with: urlRequest) { (data, urlResponse, error) in
				if let error = error {
					print(error.localizedDescription)
				}
			}.resume()
		} catch {
			print(error.localizedDescription)
		}
	}
}
