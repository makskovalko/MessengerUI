import Foundation
import Chatto

enum InsertPosition {
    case top
    case bottom
}

final class SlidingDataSource<Element> {
    private var pageSize: Int
    private var windowOffset: Int
    private var windowCount: Int
    private var itemGenerator: (() -> Element)?
    private var items = [Element]()
    private var itemsOffset: Int
    
    var itemsInWindow: [Element] {
        let offset = windowOffset - itemsOffset
        return Array(items[offset ..< offset + windowCount])
    }

    init(count: Int, pageSize: Int, itemGenerator: (() -> Element)?) {
        self.windowOffset = count
        self.itemsOffset = count
        self.windowCount = 0
        self.pageSize = pageSize
        self.itemGenerator = itemGenerator
        self.generateItems(min(pageSize, count), position: .top)
    }

    convenience init(items: [Element], pageSize: Int) {
        var iterator = items.makeIterator()
        self.init(
            count: items.count,
            pageSize: pageSize
        ) { iterator.next()! }
    }

    private func generateItems(_ count: Int, position: InsertPosition) {
        guard count > 0 else { return }
        guard let itemGenerator = self.itemGenerator else {
            fatalError("Can't create messages without a generator")
        }
        
        (0 ..< count).forEach { _ in
            insertItem(itemGenerator(), position: .top)
        }
    }

    func insertItem(_ item: Element, position: InsertPosition) {
        switch position {
        case .top:
            items.insert(item, at: 0)
            let shouldExpandWindow = itemsOffset == windowOffset
            itemsOffset -= 1
            guard shouldExpandWindow else { return }
            windowOffset -= 1
            windowCount += 1
        case .bottom:
            let shouldExpandWindow = itemsOffset
                + items.count == windowOffset
                + windowCount
            if shouldExpandWindow { windowCount += 1 }
            items += [item]
        }
    }

    func hasPrevious() -> Bool { return windowOffset > 0 }

    func hasMore() -> Bool {
        return windowOffset
            + windowCount < itemsOffset
            + items.count
    }

    func loadPrevious() {
        let previousWindowOffset = windowOffset
        let previousWindowCount = windowCount
        let nextWindowOffset = max(0, windowOffset - pageSize)
        let messagesNeeded = itemsOffset - nextWindowOffset
      
        if messagesNeeded > 0 {
            generateItems(
                messagesNeeded,
                position: .top
            )
        }
        
        let newItemsCount = previousWindowOffset - nextWindowOffset
        windowOffset = nextWindowOffset
        windowCount = previousWindowCount + newItemsCount
    }

    func loadNext() {
        guard !items.isEmpty else { return }
        
        let itemCountAfterWindow = itemsOffset
            + items.count
            - windowOffset
            - windowCount
        
        windowCount += min(
            pageSize,
            itemCountAfterWindow
        )
    }

    @discardableResult
    func adjustWindow(focusPosition: Double, maxWindowSize: Int) -> Bool {
        assert(0 <= focusPosition && focusPosition <= 1, "")
        
        guard 0 <= focusPosition && focusPosition <= 1 else {
            assert(false, "focus should be in the [0, 1] interval")
            return false
        }
        
        let sizeDiff = windowCount - maxWindowSize
        guard sizeDiff > 0 else { return false }
        
        windowOffset +=  Int(focusPosition * Double(sizeDiff))
        windowCount = maxWindowSize
        
        return true
    }

    @discardableResult
    func replaceItem(
        withNewItem item: Element,
        where predicate: (Element) -> Bool
    ) -> Bool {
        guard let index = items.firstIndex(
            where: predicate
        ) else { return false }
        items[index] = item
        return true
    }
}
