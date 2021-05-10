public protocol EnhancedLogExporter: LogExporter {	
	func log (metaInfo: EnhancedMetaInfo, message: Message, configuration: Configuration?)
}

public extension EnhancedLogExporter {
	func log (metaInfo: MetaInfo, message: Message, configuration: Configuration?) {
		let metaInfo = EnhancedMetaInfo(timestamp: metaInfo.timestamp, level: metaInfo.level, labels: [])
		
		log(metaInfo: metaInfo, message: message, configuration: configuration)
	}
}
