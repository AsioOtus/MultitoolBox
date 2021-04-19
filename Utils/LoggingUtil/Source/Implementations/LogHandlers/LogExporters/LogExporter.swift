public protocol LogExporter {
	associatedtype Message
	associatedtype Configuration
	
	func log (metaInfo: EnhancedMetaInfo, message: Message, configuration: Configuration?)
}
