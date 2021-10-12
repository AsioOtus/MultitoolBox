extension Collection {
    subscript (safe index: Index) -> Element? {
		indices.contains(index) ? self[index] : nil
    }
}

extension Collection where Index == Int {
	func split (size: Int) -> [[Element]] {
		stride(from: 0, to: self.count, by: size).map {
			Array(self[$0..<Swift.min($0 + size, self.count)])
		}
	}
}
