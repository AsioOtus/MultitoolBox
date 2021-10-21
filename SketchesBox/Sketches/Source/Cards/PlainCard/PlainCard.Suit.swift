extension PlainCard {
	enum Suit: Int, CaseIterable {
		case spades
		case hearts
		case diamonds
		case clubs
		
		static var random: Self { Self(rawValue: Int.random(in: 0..<count)) ?? .spades }
		static let count = 4
	}
}
