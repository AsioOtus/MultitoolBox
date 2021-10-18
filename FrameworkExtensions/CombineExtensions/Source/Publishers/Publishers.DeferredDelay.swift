import Foundation
import Combine

extension Publisher {
	func deferredDelay <S: Scheduler> (
		after throughputInterval: S.SchedulerTimeType.Stride,
		for interval: S.SchedulerTimeType.Stride,
		scheduler: S,
		tolerance: S.SchedulerTimeType.Stride? = nil,
		options: S.SchedulerOptions? = nil
	) -> Publishers.DeferredDelay<Self, S> {
		.init(
			upstream: self,
			throughputInterval: throughputInterval,
			delayInterval: interval,
			scheduler: scheduler,
			tolerance: tolerance ?? scheduler.minimumTolerance,
			options: options
		)
	}
}

extension Publishers.DeferredDelay {
	enum Action {
		case wait(DispatchTime = .distantFuture)
		case signal
	}
}

extension Publishers {
	class DeferredDelay <Upstream: Publisher, S: Scheduler>: Publisher {
		typealias Output = Upstream.Output
		typealias Failure = Upstream.Failure
		
		let upstream: Upstream
				
		let throughputInterval: S.SchedulerTimeType.Stride
		let delayInterval: S.SchedulerTimeType.Stride
		
		let scheduler: S
		let tolerance: S.SchedulerTimeType.Stride
		let options: S.SchedulerOptions?

		init (
			upstream: Upstream,
			throughputInterval: S.SchedulerTimeType.Stride,
			delayInterval: S.SchedulerTimeType.Stride,
			scheduler: S,
			tolerance: S.SchedulerTimeType.Stride,
			options: S.SchedulerOptions? = nil
		) {
			self.upstream = upstream
			
			self.throughputInterval = throughputInterval
			self.delayInterval = delayInterval
			
			self.scheduler = scheduler
			self.tolerance = tolerance
			self.options = options
		}
		
		public func receive <Downstream: Subscriber> (subscriber: Downstream)
		where
		Downstream.Input == Output,
		Downstream.Failure == Failure
		{
			let inner = Inner(
				downstream: subscriber,
				throughputInterval: throughputInterval,
				delayInterval: delayInterval,
				origin: scheduler.now,
				scheduler: scheduler,
				tolerance: tolerance,
				options: options
			)
			
			upstream.subscribe(inner)
		}
	}
}

extension Publishers.DeferredDelay {
	final class Inner <Downstream: Subscriber>: Subscriber, Subscription
	where Downstream.Input == Output, Downstream.Failure == Failure
	{
		typealias Input = Upstream.Output
		typealias Failure = Upstream.Failure
		
		let downstream: Downstream
		
		var state = SubscriptionStatus.awaitingSubscription
		
		let throughputInterval: S.SchedulerTimeType.Stride
		let delayInterval: S.SchedulerTimeType.Stride
		var origin: S.SchedulerTimeType
		
		let scheduler: S
		let tolerance: S.SchedulerTimeType.Stride
		let options: S.SchedulerOptions?

		var throughputIntervalEndMoment: S.SchedulerTimeType { origin.advanced(by: throughputInterval) }
		var delayEndMoment: S.SchedulerTimeType { origin.advanced(by: delayInterval) }
		
		init (
			downstream: Downstream,
			throughputInterval: S.SchedulerTimeType.Stride,
			delayInterval: S.SchedulerTimeType.Stride,
			origin: S.SchedulerTimeType,
			scheduler: S,
			tolerance: S.SchedulerTimeType.Stride,
			options: S.SchedulerOptions? = nil
		) {
			self.downstream = downstream
			
			self.throughputInterval = throughputInterval
			self.delayInterval = delayInterval
			self.origin = origin
			
			self.scheduler = scheduler
			self.tolerance = tolerance
			self.options = options
		}
		
		private func delay (_ action: @escaping () -> ()) {
			let currentMoment = scheduler.now
			let throughputIntervalEndMoment = throughputIntervalEndMoment
			let delayEndMoment = delayEndMoment
			
			if currentMoment <= throughputIntervalEndMoment || currentMoment > delayEndMoment {
				action()
			} else {
				scheduler
					.schedule(
						after: origin.advanced(by: delayInterval),
						tolerance: tolerance,
						options: options
					) {
						action()
					}
			}
			
			origin = currentMoment
		}
		
		func receive (subscription: Subscription) {
			state = .subscribed(subscription)
			downstream.receive(subscription: self)
		}
		
		func receive (_ input: Input) -> Subscribers.Demand {
			guard case .subscribed = state else { return .none }
			
			delay { self._receive(input) }
			
			return .none
		}
		
		private func _receive (_ input: Input) {
			guard let subscription = state.subscription else { return }
			
			let newDemand = downstream.receive(input)
			
			guard newDemand != .none else { return }
			
			subscription.request(newDemand)
		}
		
		func receive (completion: Subscribers.Completion<Failure>) {
			guard case let .subscribed(subscription) = state else { return }
			
			state = .pendingTerminal(subscription)
			
			scheduler
				.schedule(
					after: origin.advanced(by: delayInterval),
					tolerance: tolerance,
					options: options
				) {
					self.state = .terminal
					self.downstream.receive(completion: .finished)
				}
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

extension Publishers.DeferredDelay {
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
