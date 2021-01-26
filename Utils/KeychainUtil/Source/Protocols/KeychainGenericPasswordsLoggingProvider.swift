public protocol KeychainGenericPasswordsLoggingProvider {
	func log <T> (_: KeychainUtil.GenericPassword<T>.Logger.Record.Info) 
}
