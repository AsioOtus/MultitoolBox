public protocol BaseNetworkUtilControllersLoggingProvider {
    func baseNetworkUtilControllersLog <Request: BaseNetworkUtil.Request> (_ info: Controllers.Logger.Info<Request>)
}
