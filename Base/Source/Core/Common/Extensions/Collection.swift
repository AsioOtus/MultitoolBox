extension Collection {
    subscript (safe index: Self.Index) -> Element? {
        get {
            guard index < self.endIndex else { return nil }
            return self[index]
        }
    }
}

extension Collection where Index == Int {
	func split (size: Int) -> [[Element]] {
		stride(from: 0, to: self.count, by: size).map {
			Array(self[$0..<Swift.min($0 + size, self.count)])
		}
	}
}
