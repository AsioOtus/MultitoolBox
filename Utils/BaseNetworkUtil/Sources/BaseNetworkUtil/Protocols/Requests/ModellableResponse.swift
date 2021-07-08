import Foundation



public protocol ModellableResponse: Response {
	associatedtype Model: ResponseModel
	
	var model: Model { get }
	
	init (_ model: Model) throws
}



public protocol ResponseModel: Decodable {
	init (_ data: Data) throws
}
