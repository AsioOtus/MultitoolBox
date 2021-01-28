public protocol ModelableResponse: Response {
	associatedtype Model: ResponseModel
	
	var model: Model { get }
}

public protocol ResponseModel: Decodable { }
