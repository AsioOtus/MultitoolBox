extension JokerCard {
	struct EastSymboler {
		func symbol (of joker: JokerCard) -> String {
			let symbol: String
			
			switch joker {
			case .red:
				symbol = "Джокер красный"
			case .black:
				symbol = "Джокер черный"
			case .color:
				symbol = "Джокер цветной"
			}
			
			return symbol
		}
	}
}
