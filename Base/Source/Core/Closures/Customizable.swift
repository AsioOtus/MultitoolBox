protocol Customizable { }

extension Customizable {
	func use (in block: (Self) throws -> Void) rethrows {
		try block(self)
	}
	
	func useCopy (in block: (inout Self) throws -> Void) rethrows {
		var selfCopy = self
		try block(&selfCopy)
	}
	
	mutating func useSelf (in block: (inout Self) throws -> Void) rethrows {
		try block(&self)
	}
}

extension Customizable {
	func setCopy (in block: (inout Self) throws -> Void) rethrows -> Self {
		var selfCopy = self
		try block(&selfCopy)
		return selfCopy
	}
	
	mutating func set (in block: (inout Self) throws -> Void) rethrows -> Self {
		try block(&self)
		return self
	}
	
	mutating func set (in block: (Self) throws -> Self) rethrows -> Self {
		let result = try block(self)
		return result
	}
}

extension Customizable {
	func transform <T> (in block: (Self) throws -> T) rethrows -> T {
		let result = try block(self)
		return result
	}
}
