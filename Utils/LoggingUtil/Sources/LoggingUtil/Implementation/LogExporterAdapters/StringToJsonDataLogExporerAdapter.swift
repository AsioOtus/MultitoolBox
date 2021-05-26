import Foundation

struct StringToJsonDataLogExporerAdapter  <LogExporterType: LogExporter>: StringLogExporterAdapter where LogExporterType.Message == Data {
	public var logExporter: LogExporterType
	public var jsonEncoder: JSONEncoder
	
	public init (_ logExporter: LogExporterType, jsonEncoder: JSONEncoder = JSONEncoder()) {
		self.logExporter = logExporter
		self.jsonEncoder = jsonEncoder
	}
	
	func adapt (logRecord: LogRecord<String, StandardLogRecordDetails>) {
		do {
			let logRecordData = try jsonEncoder.encode(logRecord)
			logExporter.log(metaInfo: logRecord.metaInfo, message: logRecordData)
		} catch {
			print(error.localizedDescription)
		}
	}
}
