public protocol LogExporter {
	associatedtype Message
	
	func log (metaInfo: MetaInfo, message: Message)
}
