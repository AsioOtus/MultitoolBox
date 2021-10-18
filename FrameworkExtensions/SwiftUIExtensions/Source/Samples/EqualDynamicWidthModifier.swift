struct EqualWidthPreferenceKey: PreferenceKey {
	static var defaultValue: CGFloat = 0
	static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
		value = max(value, nextValue())
	}
}



struct EqualWidthModifier: ViewModifier {
	@Binding var width: CGFloat?
	
	func body (content: Content) -> some View {
		content
			.frame(width: width)
			.background(
				GeometryReader { g in
					Color.clear
						.preference(key: EqualWidthPreferenceKey.self, value: g.size.width)
				}
			)
			.onPreferenceChange(EqualWidthPreferenceKey.self) { (value) in
				self.width = value
			}
	}
}

extension View {
	func equalWidth (_ width: Binding<CGFloat?>) -> some View {
		return modifier(EqualWidthModifier(width: width))
	}
}
