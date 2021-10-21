extension Durak {
	enum Card: PlayingCard, CaseIterable {
		typealias AllCases = [Self]
		
		case plain(PlainCard)
		case joker(JokerCard)
		
		static var random: Self {
			let randomCard: Self
			
			switch Int.random(in: 0..<(JokerCard.count + PlainCard.count)) {
			case 0..<JokerCard.count: randomCard = .joker(JokerCard.random)
			default: randomCard = .plain(PlainCard.random)
			}
			
			return randomCard
		}
		
		static var allCases = PlainCard.allCases.map{ Self.plain($0) } + JokerCard.allCases.map { Self.joker($0) }
		static let count = PlainCard.count + JokerCard.count
	}
}

extension Durak.Card: CustomStringConvertible {
	var description: String {
		let description: String
		
		switch self {
		case .plain(let plainCard):
			description = plainCard.description
		case .joker(let joker):
			description = joker.description
		}
		
		return description
	}
}

extension Durak.Card {
	func isStronger (than card: Self, trumpSuit: PlainCard.Suit) -> Bool? {
		Durak.Comparator.default.compare(self, card, trumpSuit: trumpSuit)
	}
}

extension PlainCard {
	var durakCard: Durak.Card { .plain(self) }
}

extension JokerCard {
	var durakCard: Durak.Card { .joker(self) }
}
