struct Logger {
	func log (commit: Commit) {
		let info = Filter.filter(commit, settings)
		log(info)
	}
}

struct Filter {
	func filter (_ commit: Commit, _ settings: Settings) {
		
	}
}



protocol LogRecord {
	associatedtype LogResolution
	
	func resolution ()
}



protocol NamedOperation {
	var name: String
}



extension Logger {
	struct Record {
		let key: String
		
		var level: OSLogType
		var operation: String
		
		var newValue: ItemType?
		var oldValue: ItemType?
		var existance: Bool
		
		var extra: String?
		var error: Error?
		
		init (key: String, level: OSLogType, operation: String, newValue: ItemType? = nil) {
			self.key = key
			self.level = level
			self.operation = operation
			self.newValue = newValue
		}
		
		func commit (oldValue: ItemType? = nil, existance: Bool, error: Error? = nil) -> Self {
			self.oldValue = key
			self.existance = existance
			self.error = error
		}
		
		func set (action: (Self) -> Void) -> Self {
			block(self)
			return self
		}
	}
	
	struct Record {
		let key: String
		let operation: Operation
		let newValue: ItemType?
	}
	
	struct Resolution {
		let oldValue: ItemType?
		let existance: Bool?
	}
	
	struct Commit {
		let record: Record
		let result: Result<Resolution>
	}
	
	struct Info {
		let level: OSLogType
		
		let itemTypeName: String
		
		let key: String
		let operation: String
		let oldValue: ItemType?
		let newValue: ItemType?
		let existance: Bool?
		let error: Error?
		
		let extra: String?
		
		public var defaultMessage: String {
			var message = "\(key) – \(operation)"
			
			if let existance = existance {
				message += " – \(existance)"
			}
			
			if let value = value {
				message += " – \(value)"
			}
			
			if let error = error {
				message += " – ERROR: \(error)"
			}
			
			return message
			"prefix.key – LOADING – oldValue"
			"prefix.key – LOADING OR DEFAULT – oldValue – default used"
			"prefix.key – SAVE DEFAULT – oldValue – newValue"
			"prefix.key – SAVE DEFAULT IF NOT EXIST – true – oldValue – newValue"
		}
	}
	
	
	
	enum Operation {
		case loading
		case saving
		case deleting
		case existance
		
		var name: String {
			let name: String
			
			switch self {
			case .saving:
				name = "SAVING"
			case .loading:
				name = "LOADING"
			case .deletion:
				name = "DELETION"
			case .existance:
				name = "EXISTANCE"
			}
			
			return name
		}
	}
}

extension Logger {
	struct Resolution { }
}

extension Logger {
	struct Info {
		let level: OSLogType
		
		let itemTypeName: String
		
		let key: String
		let operation: String
		let value: ItemType?
		let existance: Bool?
		let error: Error?
	}
}

extension Logger {
	struct Record<Initial, Completive> {
		let key: String
		let initialValue: Initial
		
		init (initialValue: Initial) {
			self.initialValue = initialValue
		}
		
		func commit (_ resolution: Resolution<Completive>) -> Commit<Initial, Completive> {
			Commit(self, resolution)
		}
	}
	
	struct Commit<Initial, Completive> {
		let record: Record<Initial, Completive>
		let resolution: Resolution<Completive>
	}
	
	enum Operation {
		case loading(Record<Void, ItemType?>)
		case saving(Record<ItemType, Void>)
		case deleting(Record<Void, ItemType?>)
		case existance(Record<Void, (Bool, ItemType?)>)
	}
	
	enum Resolution<T> {
		case success(T)
		case error(Error)
	}
}





extension Logger {
	struct Rules { }
}

extension Logger {
	struct Filter {
		func info (commit: Commit, rules: Rules) -> Info {
			
		}
	}
}

struct Item {
	func load (id: String, logRecord: Logger.Record<T>) {
		do {
			try logRecord.commit(.success(T()))
		} catch {
			logRecord.commit(.failure)
		}
	}
}

struct DefautableItem {
	func loadOrDefault (id: String) {
		let logRecord = Logger.Record()
		
		Item().load(id: id, logRecord: logRecord)
		
		logger.log(logRecord)
	}
}
