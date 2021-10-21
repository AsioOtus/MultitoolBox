enum JokerCard: Int, PlayingCard, CaseIterable {
	case red
	case black
	case color
	
	static var random: Self { Self(rawValue: Int.random(in: 0..<count)) ?? .color }
	static let count = 3
}

extension JokerCard: CustomStringConvertible {
	var description: String { JokerCard.WestSymboler.default.symbol(of: self) }
}
