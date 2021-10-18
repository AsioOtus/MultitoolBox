import SwiftUI
import SwiftUIPager
import DequeModule

struct EndlessPagerView: View {
	static let itemCount = 10
	static let treshold = 3
	static let newItemsCount = 1
	
	@State var items = Deque(1...itemCount)
	@StateObject var page: Page = .withIndex(itemCount / 2)
	
	var body: some View {
		Pager(page: page, data: items, id: \.self) { index in
			Text("Page: \(index)")
				.frame(minWidth: 0,
					   maxWidth: .infinity,
					   minHeight: 0,
					   maxHeight: .infinity,
					   alignment: .center
				)
				.foregroundColor(.white)
				.background(Color(hue: .random(in: 0...0.99), saturation: .random(in: 0...0.99), brightness: 0.5))
		}
		.onPageChanged { pageIndex in
			if pageIndex <= Self.treshold {
				withAnimation {
					page.index += Self.newItemsCount
					
					items.prepend(items.first! - Self.newItemsCount)
					items.removeLast()
				}
			} else if pageIndex >= items.count - Self.treshold {
				withAnimation {
					page.index -= Self.newItemsCount
					
					items.append(items.last! + Self.newItemsCount)
					items.removeFirst()
				}
			}
		}
	}
}

struct EndlessPagerView: View {
	@State var items = Deque(1...itemCount)
	@StateObject var page: Page = .withIndex(itemCount / 2)
	
	var body: some View {
		
	}
}
