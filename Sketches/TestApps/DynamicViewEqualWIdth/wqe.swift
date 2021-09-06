import SwiftUI

struct ContentView: View {
	@State private var textMinWidth: CGFloat?
	
	var body: some View {
		VStack(spacing: 16) {
			List {
			TextBubble(text: "First", minTextWidth: $textMinWidth)
				.equalWidth($textMinWidth)
				.background(Color.red)
			TextBubble(text: "Second longer", minTextWidth: $textMinWidth)
				.equalWidth($textMinWidth)
				.background(Color.red)
			TextBubble(text: "Secondqew ", minTextWidth: $textMinWidth)
				.equalWidth($textMinWidth)
				.background(Color.red)
			}
		}
	}
}
struct TextBubble: View {
	let text: String
	@Binding var minTextWidth: CGFloat?
	
	var body: some View {
		HStack {
		VStack {
		Text(text)
			.foregroundColor(Color.white)
			.padding()
			.background(Color.blue)
			.cornerRadius(8)
			Text("qweqwqe")
		}
		
		Divider()
		}
	}
}

struct EqualWidthPreferenceKey: PreferenceKey {
	static var defaultValue: CGFloat = 0
	static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
		value = nextValue()
	}
}
struct EqualWidth: ViewModifier {
	@Binding var width: CGFloat?
	
	func body (content: Content) -> some View {
		content.frame(width: width, alignment: .leading)
			.background(
				GeometryReader { proxy in
					Color.clear.preference(key: EqualWidthPreferenceKey.self, value: proxy.size.width)
				}
			)
			.onPreferenceChange(EqualWidthPreferenceKey.self) { (value) in
				self.width = max(self.width ?? 0, value)
			}
	}
}
extension View {
	func equalWidth (_ width: Binding<CGFloat?>) -> some View {
		return modifier(EqualWidth(width: width))
	}
}
