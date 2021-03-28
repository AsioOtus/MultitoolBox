public protocol ModelableResponse: Response {
	associatedtype Model: Decodable
	
	var model: Model { get }
}
