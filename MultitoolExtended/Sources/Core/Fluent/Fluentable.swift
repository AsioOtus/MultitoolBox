public protocol Fluentable: UseFluentable, DoFluentable, MutateFluentable, SetFluentable, LetFluentable { }



public protocol UseFluentable { }

public extension UseFluentable {
	@discardableResult
	func use (_ block: (Self) throws -> Void) rethrows -> Self {
		try block(self)
		return self
	}

	@discardableResult
	func use (_ block: () throws -> Void) rethrows -> Self {
		try block()
		return self
	}
}



public protocol DoFluentable { }

public extension DoFluentable {
	@discardableResult
	func `do` (_ block: (inout Self) throws -> Void) rethrows -> Self {
		var selfCopy = self
		try block(&selfCopy)
		return self
	}
}



public protocol MutateFluentable { }

public extension MutateFluentable {
	@discardableResult
	mutating func mutate (_ block: (inout Self) throws -> Void) rethrows -> Self {
		try block(&self)
		return self
	}
}



public protocol SetFluentable { }

public extension SetFluentable {
	func set (_ block: (inout Self) throws -> Void) rethrows -> Self {
		var selfCopy = self
		try block(&selfCopy)
		return selfCopy
	}
}

public extension SetFluentable where Self: AnyObject {
	func set (_ block: (Self) throws -> Void) rethrows -> Self {
		try block(self)
		return self
	}
}



public protocol LetFluentable { }

public extension LetFluentable {
	func `let` <T> (_ block: (Self) throws -> T) rethrows -> T {
		try block(self)
	}

	func `let` <T> (_ block: () throws -> T) rethrows -> T {
		try block()
	}
}
