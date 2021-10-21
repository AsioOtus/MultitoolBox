import Foundation

enum Progressions {
	static func exponent (initial: Double) -> (Double) -> (TimeInterval) {
		{ iteration in pow(initial, iteration) }
	}
	
	static func geometric (initial: Double, scaleFactor: Double) -> (Double) -> (TimeInterval) {
		{ iteration in initial * pow(scaleFactor, iteration - 1) }
	}
}



for i in 1...10 {
	let geometricProgression = Progressions.geometric(initial: 1.5, scaleFactor: 2)
	print(geometricProgression(Double(i)))
	
	let exponentialProgression = Progressions.exponent(initial: 1.75)
	print(exponentialProgression(Double(i)))
	
	print()
}
