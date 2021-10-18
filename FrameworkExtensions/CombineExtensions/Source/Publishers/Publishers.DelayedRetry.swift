import Combine

extension Publisher {
	public func delayedRetry <Context: Scheduler> (
		retries: Int? = nil,
		progression: @escaping Progression,
		timeUnit: @escaping (Double) -> Context.SchedulerTimeType.Stride,
		scheduler: Context,
		tolerance: Context.SchedulerTimeType.Stride? = nil,
		options: Context.SchedulerOptions? = nil
	) -> Publishers.DelayedRetry<Self, Context> {
		.init(
			upstream: self,
			retries: retries,
			progression: progression,
			timeUnit: timeUnit,
			scheduler: scheduler,
			tolerance: tolerance ?? scheduler.minimumTolerance,
			options: options
		)
	}
}

extension Publishers {
	public struct DelayedRetry<Upstream: Publisher, Context: Scheduler>: Publisher {
		public typealias Output = Upstream.Output
		public typealias Failure = Upstream.Failure
		
		public let upstream: Upstream
		public let retries: Int?
		
		public let progression: Progression
		public let scheduler: Context
		public let timeUnit: (Double) -> Context.SchedulerTimeType.Stride
		public let tolerance: Context.SchedulerTimeType.Stride
		public let options: Context.SchedulerOptions?
		
		public init (
			upstream: Upstream,
			retries: Int?,
			progression: @escaping Progression,
			timeUnit: @escaping (Double) -> Context.SchedulerTimeType.Stride,
			scheduler: Context,
			tolerance: Context.SchedulerTimeType.Stride,
			options: Context.SchedulerOptions? = nil
		
		) {
			self.upstream = upstream
			self.retries = retries
			
			self.progression = progression
			self.timeUnit = timeUnit
			self.scheduler = scheduler
			self.tolerance = tolerance
			self.options = options
		}
		public func receive <Downstream: Subscriber> (subscriber: Downstream)
		where Downstream.Input == Output, Downstream.Failure == Failure
		{
			upstream.subscribe(
				Inner(
					parent: self,
					downstream: subscriber,
					progression: progression,
					timeUnit: timeUnit,
					scheduler: scheduler,
					tolerance: tolerance,
					options: options
				)
			)
		}
	}
}

extension Publishers.DelayedRetry {
	private final class Inner<Downstream: Subscriber>
	: Subscriber,
	  Subscription,
	  CustomStringConvertible,
	  CustomReflectable,
	  CustomPlaygroundDisplayConvertible
	where Downstream.Failure == Failure, Downstream.Input == Output
	{
		typealias Input = Upstream.Output
		typealias Failure = Upstream.Failure
		
		private enum State {
			case ready(Publishers.DelayedRetry<Upstream, Context>, Downstream)
			case terminal
		}
		
		private enum Chances {
			case finite(Int)
			case infinite
		}
		
		private var state: State
		private var upstreamSubscription: Subscription?
		private var remaining: Chances
		private var downstreamNeedsSubscription = true
		private var downstreamDemand = Subscribers.Demand.none
		private var completionRecursion = false
		private var needsSubscribe = false
		private var attempt = 0
		
		private let progression: Progression
		private let timeUnit: (Double) -> Context.SchedulerTimeType.Stride
		private let scheduler: Context
		private let tolerance: Context.SchedulerTimeType.Stride
		private let options: Context.SchedulerOptions?
		
		init (
			parent: Publishers.DelayedRetry<Upstream, Context>,
			downstream: Downstream,
			progression: @escaping Progression,
			timeUnit: @escaping (Double) -> Context.SchedulerTimeType.Stride,
			scheduler: Context,
			tolerance: Context.SchedulerTimeType.Stride,
			options: Context.SchedulerOptions?
		) {
			state = .ready(parent, downstream)
			remaining = parent.retries.map(Chances.finite) ?? .infinite
			
			self.progression = progression
			self.timeUnit = timeUnit
			self.scheduler = scheduler
			self.tolerance = tolerance
			self.options = options
		}
		
		func receive (subscription: Subscription) {
			guard case let .ready(_, downstream) = state, upstreamSubscription == nil
			else {
				subscription.cancel()
				return
			}
			
			upstreamSubscription = subscription
			
			let downstreamDemand = self.downstreamDemand
			let downstreamNeedsSubscription = self.downstreamNeedsSubscription
			
			self.downstreamNeedsSubscription = false
			
			if downstreamNeedsSubscription {
				downstream.receive(subscription: self)
			}
			
			if downstreamDemand != .none {
				subscription.request(downstreamDemand)
			}
		}
		
		func receive(_ input: Input) -> Subscribers.Demand {
			guard case let .ready(_, downstream) = state else {
				return .none
			}
			
			downstreamDemand -= 1
			
			let newDemand = downstream.receive(input)
			if newDemand == .none { return .none }
			
			downstreamDemand += newDemand
			
			if let upstreamSubscription = self.upstreamSubscription {
				upstreamSubscription.request(newDemand)
			}
			
			return .none
		}
		
		func receive (completion: Subscribers.Completion<Failure>) {
			guard case let .ready(parent, downstream) = state else { return }
			
			if case .failure = completion {
				upstreamSubscription = nil
				
				switch remaining {
				case .finite(0):
					break
					
				case .finite(let attempts):
					remaining = .finite(attempts - 1)
					attempt += 1
					fallthrough
					
				case .infinite:
					if completionRecursion {
						needsSubscribe = true
						return
					}
					
					repeat {
						completionRecursion = true
						needsSubscribe = false
						schedule {
							parent.upstream.subscribe(self)
						}
						completionRecursion = false
					} while needsSubscribe
					
					return
				}
			}
			
			state = .terminal
			downstream.receive(completion: completion)
		}
		
		func request(_ demand: Subscribers.Demand) {
			guard case .ready = state else { return }
			
			downstreamDemand += demand
			
			if let upstreamSubscription = self.upstreamSubscription {
				upstreamSubscription.request(demand)
			}
		}
		
		func cancel() {
			guard case .ready = state else {
				return
			}
			
			state = .terminal
			
			if let upstreamSubscription = self.upstreamSubscription {
				upstreamSubscription.cancel()
			}
		}
		
		private func schedule (_ work: @escaping () -> Void) {
			scheduler
				.schedule(
					after: scheduler.now.advanced(by: timeUnit(progression(Double(attempt)))),
					tolerance: tolerance,
					options: options,
					work
				)
		}
		
		var description: String { return "Retry" }
		var customMirror: Mirror { .init(self, children: EmptyCollection()) }
		var playgroundDescription: Any { return description }
	}
}
