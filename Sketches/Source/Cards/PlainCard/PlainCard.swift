struct PlainCard: PlayingCard, CaseIterable {
	let suit: Suit
	let rank: Rank
	
	static var random: Self { Self(suit: .random, rank: .random) }
	static var allCases: [Self] { Suit.allCases.flatMap { suit in Rank.allCases.map{ rank in Self(suit: suit, rank: rank) } } }
	static var count = Suit.count * Rank.count
}



extension PlainCard: CustomStringConvertible {
	var description: String { PlainCard.WestSymboler.default.symbol(of: self) }
}

extension PlainCard.Suit: CustomStringConvertible {
	var description: String { PlainCard.WestSymboler.default.symbol(of: self) }
}

extension PlainCard.Rank: CustomStringConvertible {
	var description: String { PlainCard.WestSymboler.default.symbol(of: self) }
}
