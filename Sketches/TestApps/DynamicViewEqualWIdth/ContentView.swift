import SwiftUI

var values = Array(0..<5).map { _ in Int.random(in: 10000...99999) }

struct ContentView: View {
	@State var leadingColumnWidth: CGFloat = .zero
	
	var body: some View {
		VStack {
			Text("\(leadingColumnWidth )")
			List {
				ForEach(values, id: \.self) { value in
					CustomView(leadingColumnWidth: $leadingColumnWidth, value: value)
				}
			}
		}
	}
}

struct CustomView: View {
	@Binding var leadingColumnWidth: CGFloat
	let value: Int
	
	var body: some View {
		HStack {
			Text("\(value)")
				.background(
					GeometryReader { g in
						Color.clear.preference(key: WidthPreferenceKey.self, value: g.size.width)
					}
					.scaledToFill())
				.onPreferenceChange(WidthPreferenceKey.self) {
					print(value, $0)
					self.leadingColumnWidth = $0
				}
				.frame(width: self.leadingColumnWidth)
			Divider() 
		}
	}
	
	struct Geometry: View {
		var body: some View {
			GeometryReader { geometry in
				Color.clear
					.preference(key: WidthPreferenceKey.self, value: geometry.size.width)
			}
			.scaledToFill()
		}
	}
}





struct WidthPreferenceKey: PreferenceKey {
	static var defaultValue: CGFloat = 0
	static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
		value = max(value, nextValue())
	}
}

struct StringPreferenceKey: PreferenceKey {
	static var defaultValue = ""
	static func reduce (value: inout String, nextValue: () -> String) { value = nextValue() }
}








//struct ScrollView<Content: View>: View {
//	let content: Content
//
//	@GestureState private var translation: CGSize = .zero
//	@State private var contentSize: CGSize = .zero
//	@State private var offset: CGSize = .zero
//
//	private var dragGesture: some Gesture {
//		DragGesture(minimumDistance: 0)
//			.updating($translation) { value, state, _ in
//				state = value.translation
//			}.onEnded { value in
//				self.offset = value.translation
//			}
//	}
//
//	init(@ViewBuilder content: () -> Content) {
//		self.content = content()
//	}
//
//	var body: some View {
//		GeometryReader { geometry in
//			self.content
//				.fixedSize()
//				.offset(self.offset)
//				.offset(self.translation)
//
//				.onPreferenceChange(SizePreferenceKey.self) { self.contentSize = $0 }
//				.gesture(self.isScrollable(geometry.size) ? self.dragGesture : nil)
//		}.clipped()
//	}
//
//	private func isScrollable(_ size: CGSize) -> Bool {
//		contentSize.width > size.width || contentSize.height > size.height
//	}
//}
