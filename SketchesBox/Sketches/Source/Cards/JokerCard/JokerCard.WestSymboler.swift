extension JokerCard {
	struct WestSymboler {
		static let `default` = Self(short: true)
		
		var short: Bool
		
		func symbol (of joker: JokerCard) -> String {
			let symbol: String
			
			switch joker {
			case .red:
				symbol = short ? "JR" : "Joker Red"
			case .black:
				symbol = short ? "JB" : "Joker Black"
			case .color:
				symbol = short ? "JC" : "Joker Color"
			}
			
			return symbol
		}
	}
}
