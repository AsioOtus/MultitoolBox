func compare (_ cardA: Durak.Card, _ cardB: Durak.Card, trumpSuit: PlainCard.Suit) {
	print(cardA)
	print(cardB)
	print(trumpSuit)
	
	let comparator = Durak.Comparator()
	let comparisonResult = comparator.compare(cardA, cardB, trumpSuit: trumpSuit)
	
	
	
	print(comparisonResult)
	print()
}

for _ in 0..<10 {
	let cardA = Durak.Card.random
	let cardB = Durak.Card.random
	let trumpSuit = PlainCard.Suit.random
	
	compare(cardA, cardB, trumpSuit:  trumpSuit)
}

compare(PlainCard(suit: .hearts, rank: .four).durakCard, .random, trumpSuit: .random)
