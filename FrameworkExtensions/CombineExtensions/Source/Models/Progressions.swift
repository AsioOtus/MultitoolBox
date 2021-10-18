import Combine

public enum Progressions {
	public static func constant (_ constant: Double) -> (Double) -> Double {
		{ _ in constant }
	}
	
	public static func exponent (base: Double) -> (Double) -> Double {
		{ iteration in pow(base, iteration) }
	}
	
	public static func geometric (initial: Double, scaleFactor: Double) -> (Double) -> Double {
		{ iteration in initial * pow(scaleFactor, iteration - 1) }
	}
}
