public protocol RequestDelegate {
	associatedtype Request: BaseNetworkUtil.Request
	associatedtype Content
	
	func request () throws -> Request
	func content (_: Request.Response) throws -> Content
}
