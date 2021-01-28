public enum Edge {
	case start
	case end
}

extension Edge: CaseIterable, CreatableByInt, Randomable { }
