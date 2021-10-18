import Combine

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
