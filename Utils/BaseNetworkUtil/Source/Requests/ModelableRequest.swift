public protocol ModelableRequest: Request {
	associatedtype Model: RequestModel
	
	var model: Model { get }
}

public protocol RequestModel: Encodable { }
