public protocol ModelableRequest: Request {
	associatedtype Model: RequestModel
	
	var model: Model { get }
	
	init (_ model: Model)
}

public protocol RequestModel: Encodable { }
