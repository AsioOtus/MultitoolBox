KeychainUtil.settings = .init(
	logging:
		.init(
			enable: true,
			level: .default,
			enableQueryLogging: true,
			enableValuesLogging: true,
			loggingProvider: DefaultKeychainLoggingProvider(prefix: "MT.KU")
		),
	genericPasswords:
		.init(
			itemIdentifierPrefixProvider: "com.multitool.keychainutil.testground",
			logging:
				.init(
					enable: true,
					level: .default,
					enableKeychainIdentifierLogging: true,
					enableQueryLogging: true,
					enableValuesLogging: true,
					loggingProvider: DefaultKeychainGenericPasswordsLoggingProvider(prefix: "MT.KU.GP")
				)
		)
)

let a = KeychainUtil.GenericPassword<Int>("test", enableValueLogging: true)

do {
	try a.overwrite(0)
	try a.save(1)
	
//	try a.delete()
//	_ = try a.load()
} catch let error as KeychainUtil.GenericPasswordError {
	print(error)
}
