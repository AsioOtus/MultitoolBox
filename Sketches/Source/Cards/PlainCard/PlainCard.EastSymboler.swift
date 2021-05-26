extension PlainCard {
	struct EastSymboler {
		static let `default` = Self()
		
		func symbol (of suit: PlainCard.Suit) -> String {
			let symbol: String
			
			switch suit {
			case .spades:
				symbol = "♠"
			case .hearts:
				symbol = "♥"
			case .diamonds:
				symbol = "♣"
			case .clubs:
				symbol = "♦"
			}
			
			return symbol
		}
		
		func symbol(of rank: PlainCard.Rank) -> String {
			let symbol: String
			
			switch rank {
			case .two:
				symbol = "2"
			case .three:
				symbol = "3"
			case .four:
				symbol = "4"
			case .five:
				symbol = "5"
			case .six:
				symbol = "6"
			case .seven:
				symbol = "7"
			case .eight:
				symbol = "8"
			case .nine:
				symbol = "9"
			case .ten:
				symbol = "10"
			case .jack:
				symbol = "В"
			case .queen:
				symbol = "Д"
			case .king:
				symbol = "К"
			case .ace:
				symbol = "Т"
			}
			
			return symbol
		}
		
		func symbol (of card: PlainCard) -> String { symbol(of: card.suit) + symbol(of: card.rank) }
	}
}
