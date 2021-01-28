public protocol RequestDelegate {
	associatedtype Request: NetworkUtil_macOS.Request
	associatedtype Content
	
	func request () throws -> Request
	func content (_: Request.Response) throws -> Content
}
