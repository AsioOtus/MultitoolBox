import Foundation
import Combine

extension Publisher {
	func wait(
		for semaphore: DispatchSemaphore,
		timeout: DispatchTime = .distantFuture
	) -> Publishers.SemaphorePublisher<Self> {
		.init(
			upstream: self,
			semaphore: semaphore,
			action: .wait(timeout)
		)
	}
	
	func release(
		_ semaphore: DispatchSemaphore
	) -> Publishers.SemaphorePublisher<Self> {
		.init(
			upstream: self,
			semaphore: semaphore,
			action: .signal
		)
	}
}

extension Publishers.SemaphorePublisher {
	enum Action {
		case wait(DispatchTime = .distantFuture)
		case signal
	}
	
	enum Error: Swift.Error {
		case timedOut(DispatchTime)
	}
}

extension Publishers {
	class SemaphorePublisher <Upstream: Publisher>: Publisher {
		typealias Output = Upstream.Output
		typealias Failure = Swift.Error
		
		let upstream: Upstream
		let semaphore: DispatchSemaphore
		let action: Action
		
		init (
			upstream: Upstream,
			semaphore: DispatchSemaphore,
			action: Action
		) {
			self.upstream = upstream
			self.semaphore = semaphore
			self.action = action
		}
		
		public func receive <Downstream: Subscriber> (subscriber: Downstream)
		where
		Downstream.Input == Output,
		Downstream.Failure == Swift.Error
		{
			let inner = Inner(
				downstream: subscriber,
				semaphore: semaphore,
				action: action
			)
			
			upstream.subscribe(inner)
		}
	}
}

extension Publishers.SemaphorePublisher {
	final class Inner <Downstream: Subscriber>: Subscriber, Subscription
	where Downstream.Input == Output, Downstream.Failure == Swift.Error
	{
		typealias Input = Upstream.Output
		typealias Failure = Upstream.Failure
		
		let downstream: Downstream
		let semaphore: DispatchSemaphore
		let action: Action
		var state = SubscriptionStatus.awaitingSubscription
		
		init (
			downstream: Downstream,
			semaphore: DispatchSemaphore,
			action: Action
		) {
			self.downstream = downstream
			self.semaphore = semaphore
			self.action = action
		}
		
		func receive (subscription: Subscription) {
			state = .subscribed(subscription)
			downstream.receive(subscription: self)
		}
		
		func receive (_ input: Input) -> Subscribers.Demand {
			guard case .subscribed = state else { return .none }
			
			if case .wait(let timeout) = action {
				let timeoutResult = semaphore.wait(timeout: timeout)
				
				switch timeoutResult {
				case .success:
					_receive(input)
					
				case .timedOut:
					downstream.receive(completion: .failure(Error.timedOut(timeout)))
				}
			} else {
				semaphore.signal()
				_receive(input)
			}
			
			return .none
		}
		
		private func _receive (_ input: Input) {
			guard let subscription = state.subscription else { return }
			
			let newDemand = downstream.receive(input)
			
			guard newDemand != .none else { return }
			
			subscription.request(newDemand)
		}
		
		func receive (completion: Subscribers.Completion<Failure>) {
			state = .terminal
			
			semaphore.signal()
			
			switch completion {
			case .finished: downstream.receive(completion: .finished)
			case .failure(let error): downstream.receive(completion: .failure(error))
			}
			
			// Possible alternative
			// downstream.receive(completion: completion.eraseError())
		}
		
		func request (_ demand: Subscribers.Demand) {
			guard case let .subscribed(subscription) = state else { return }
			subscription.request(demand)
		}
		
		func cancel () {
			guard case let .subscribed(subscription) = state else { return }
			state = .terminal
			subscription.cancel()
		}
	}
}

extension Publishers.SemaphorePublisher {
	enum SubscriptionStatus {
		case awaitingSubscription
		case subscribed(Subscription)
		case pendingTerminal(Subscription)
		case terminal
		
		var isAwaitingSubscription: Bool {
			switch self {
			case .awaitingSubscription:
				return true
			default:
				return false
			}
		}
		
		var subscription: Subscription? {
			switch self {
			case .awaitingSubscription, .terminal:
				return nil
			case let .subscribed(subscription), let .pendingTerminal(subscription):
				return subscription
			}
		}
	}
}

extension Subscribers.Completion {
	/// Erases the `Failure` type to `Swift.Error`. This function exists
	/// because in Swift user-defined generic types are always
	/// [invariant](https://en.wikipedia.org/wiki/Covariance_and_contravariance_(computer_science)).
	internal func eraseError() -> Subscribers.Completion<Swift.Error> {
		switch self {
		case .finished:
			return .finished
		case .failure(let error):
			return .failure(error)
		}
	}
}
