struct KeyBuilder {
	static func build (prefix: String?, key: String) -> String { [prefix, key].compactMap{ $0 }.joined(separator: ".") }
	static func build (key: String, postfix: String?) -> String { [key, postfix].compactMap{ $0 }.joined(separator: ".") }
	static func build (prefix: String?, key: String, postfix: String?) -> String { [prefix, key, postfix].compactMap{ $0 }.joined(separator: ".") }
}
