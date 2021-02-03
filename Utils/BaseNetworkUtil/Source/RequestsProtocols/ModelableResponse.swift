public protocol ModelableResponse: Response {
	associatedtype Model: ResponseModel
	
	var model: Model { get }
	
	init (_ model: Model)
}

public protocol ResponseModel: Decodable { }
