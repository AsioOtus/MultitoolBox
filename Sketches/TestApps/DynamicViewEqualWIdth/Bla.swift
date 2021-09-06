import SwiftUI

struct DayListItem : View {
	
	// MARK: - Properties
	
	
	
	let date: String
	@Binding var maxLabelWidth: CGFloat?
	
	private let weekdayFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "EEE"
		return formatter
	}()
	
	private let dayNumberFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "d"
		return formatter
	}()
	
	var body: some View {
		HStack {
			VStack(alignment: .center) {
				Text(date)
					.font(.caption)
					.foregroundColor(.secondary)
					.lineLimit(1)
				Text(date)
					.font(.body)
					.foregroundColor(.red)
					.lineLimit(1)
				
			}
			.equalWidth($maxLabelWidth)
//			.background(DayListItemGeometry())
//			.frame(width: self.maxLabelWidth)
//			.onPreferenceChange(MaxWidthPreferenceKey.self) {
//				print(date, $0)
//				self.maxLabelWidth = $0
//			}
			
			Divider()
		}
	}
	
}




struct ContentView : View {
	
	@State var maxLabelWidth: CGFloat? = 20
	
	var values = ["aa", "aaaaa", "aaa", "aa", "a"]
	
	private var navigationBarTitle: String {
		let formatter = DateFormatter()
		formatter.dateFormat = "MMMM YYY"
		return formatter.string(from: Date())
	}
	
//	private var currentMonth: Month {
//		dataProvider.currentMonth
//	}
	
//	private var months: [Month] {
//		return dataProvider.monthsInRelativeYear
//	}
	
	var body: some View {
		NavigationView {
			List(values, id: \.self) { date in
				DayListItem(date: date, maxLabelWidth: self.$maxLabelWidth)
			}
		}
	}
	
}


struct MaxWidthPreferenceKey: PreferenceKey {
	static var defaultValue: CGFloat = 100
	
	static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
		let nextValue = nextValue()
		
		guard nextValue > value else { return }
		
		value = nextValue
	}
}

struct DayListItemGeometry: View {
	var body: some View {
		GeometryReader { geometry in
			Color.clear
				.preference(key: MaxWidthPreferenceKey.self, value: geometry.size.width)
		}
		.scaledToFill()
	}
}




struct EqualWidthPreferenceKey: PreferenceKey {
	typealias Value = CGFloat
	static var defaultValue: CGFloat = 0
	static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
		value = nextValue()
	}
}
struct EqualWidth: ViewModifier {
	let width: Binding<CGFloat?>
	func body(content: Content) -> some View {
		content.frame(width: width.wrappedValue, alignment: .leading)
			.background(GeometryReader { proxy in
				Color.clear.preference(key: EqualWidthPreferenceKey.self, value: proxy.size.width)
			}).onPreferenceChange(EqualWidthPreferenceKey.self) { (value) in
				self.width.wrappedValue = max(self.width.wrappedValue ?? 0, value)
			}
	}
}
extension View {
	func equalWidth(_ width: Binding<CGFloat?>) -> some View {
		return modifier(EqualWidth(width: width))
	}
}
