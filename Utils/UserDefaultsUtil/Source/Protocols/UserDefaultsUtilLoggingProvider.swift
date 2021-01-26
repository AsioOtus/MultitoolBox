public protocol UserDefaultsUtilLoggingProvider {
	func userDefaultsUtilLog <ValueType> (_: Logger.Info<ValueType>)
}
