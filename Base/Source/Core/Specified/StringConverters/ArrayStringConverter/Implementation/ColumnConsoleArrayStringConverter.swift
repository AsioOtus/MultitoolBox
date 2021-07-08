import Foundation

public struct ColumnConsoleArrayStringConverter: ArrayStringConverter {
	public static let `default` = Self()
	
	public func convert <T> (_ array: Array<T>) -> String {
		
		let valueMaxLength = array.map{ String(describing: $0).count }.max()
		return array.map{ String(describing: $0) }.joined(separator: "\n")
	}
}
