public protocol LogExporter {
	associatedtype Message
	associatedtype Configuration
	
	func log (metaInfo: MetaInfo, message: Message, configuration: Configuration?)
}
