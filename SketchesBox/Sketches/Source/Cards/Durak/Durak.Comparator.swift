extension Durak {
	struct Comparator {
		static let `default` = Self()
		
		func compare (_ cardA: PlainCard, _ cardB: PlainCard, trumpSuit: PlainCard.Suit) -> Bool {
			let result: Bool
			
			switch (cardA.suit, cardB.suit) {
			case (trumpSuit, trumpSuit): result = cardA.rank.rawValue > cardB.rank.rawValue
			case (trumpSuit, _): result = true
			case (_, trumpSuit): result = false
			case let (suitA, suitB) where suitA == suitB: result = cardA.rank.rawValue > cardB.rank.rawValue
			default: result = false
			}
			
			return result
		}
		
		func compare (_ cardA: Card, _ cardB: Card, trumpSuit: PlainCard.Suit) -> Bool? {
			let result: Bool?
			
			switch (cardA, cardB) {
			case let (.plain(plainCardA), .plain(plainCardB)):
				result = compare(plainCardA, plainCardB, trumpSuit: trumpSuit)
				
			case (.joker, .plain): result = true
			case (_, .joker): result = nil
			}
			
			return result
		}
	}
}
