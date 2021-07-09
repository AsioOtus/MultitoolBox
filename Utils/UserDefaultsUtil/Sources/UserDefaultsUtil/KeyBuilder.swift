struct KeyBuilder {
	static func build (prefix: String? = nil, key: String, postfix: String? = nil) -> String { [prefix, key, postfix].compactMap{ $0 }.joined(separator: ".") }
}
