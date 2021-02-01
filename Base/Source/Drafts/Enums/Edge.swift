public enum Edge: CaseIterable {
	case start
	case end
}

extension Edge: CaseIterable, CreatableByInt, Randomable { }
