public protocol KeychainGenericPasswordsLoggingProvider {
	func log <Value> (_: GenericPassword<Value>.Logger.Info) 
}
