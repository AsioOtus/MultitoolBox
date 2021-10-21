extension PlainCard {
	enum Rank: Int, CaseIterable {
		case two
		case three
		case four
		case five
		case six
		case seven
		case eight
		case nine
		case ten
		
		case jack
		case queen
		case king
		
		case ace
		
		static var random: Self { Self(rawValue: Int.random(in: 0..<count)) ?? .ace }
		static let count = 13
	}
}
