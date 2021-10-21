import Foundation
import Combine

func a () {
	let a = Future<Int, Error> { promise in
		promise(.success(1))
	}
	
	a.sink(receiveCompletion: { _ in }, receiveValue: { _ in })
}

extension String: Error { }
struct NetworkController {
	func send () {
		let a = Just(0)
		let b = Future<Int, String> { promise in }
	}
}
