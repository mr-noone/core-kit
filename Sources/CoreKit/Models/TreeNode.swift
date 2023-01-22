import Foundation

open class TreeNode<Element>: Sequence {
    public typealias Element = Element
    public typealias Index = IndexPath
    
    public enum CodingKeys: CodingKey {
        case element, children
    }
    
    // MARK: - Properties
    
    public private(set) var element: Element
    public private(set) var children: [TreeNode]
    public private(set) weak var parent: TreeNode?
    
    // MARK: - Inits
    
    public required init(element: Element, children: [TreeNode] = []) {
        self.element = element
        self.children = children
        self.children.forEach {
            $0.removeFromParent()
            $0.parent = self
        }
    }
    
    public required init(from decoder: Decoder) throws where Element: Decodable {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        element = try container.decode(Element.self, forKey: .element)
        children = try container.decode([Self].self, forKey: .children)
        children.forEach { $0.parent = self }
    }
    
    public convenience init(element: Element, @TreeBuilder builder: () -> [TreeNode]) {
        self.init(element: element, children: builder())
    }
    
    // MARK: - Encodable
    
    open func encode(to encoder: Encoder) throws where Element: Encodable {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(element, forKey: .element)
        try container.encode(children, forKey: .children)
    }
    
    // MARK: - Subscripts
    
    open subscript(element index: Index) -> Element {
        get { self[node: index].element }
        set { self[node: index].element = newValue }
    }
    
    open subscript(node index: Index) -> TreeNode {
        get { index == startIndex ? self : children[index[0]][node: index.dropFirst()] }
        set {
            switch index {
            case startIndex:
                if self !== newValue {
                    fatalError("Index must not be start index")
                }
            case _ where index.count == 1:
                newValue.removeFromParent()
                newValue.parent = self
                children[index[0]].parent = nil
                children[index[0]] = newValue
            default:
                children[index[0]][node: index.dropFirst()] = newValue
            }
        }
    }
    
    // MARK: - Sequence
    
    open func makeIterator() -> TreeIterator<Element> {
        TreeIterator(tree: self, index: startIndex)
    }
    
    // MARK: - Parent
    
    open func removeFromParent() {
        if let index = parent?.children.firstIndex(where: { $0 === self }) {
            parent?.remove(nodeAt: [index])
        }
    }
    
    // MARK: - Count
    
    open var hasChildren: Bool {
        children.isEmpty == false
    }
    
    open var countOfChildren: Int {
        children.count
    }
    
    open func countOfChildren(at index: Index) -> Int {
        self[node: index].countOfChildren
    }
    
    // MARK: - Indices
    
    open var index: Index {
        guard let parent = parent, let index = parent.children.firstIndex(where: {
            $0 === self
        }) else { return startIndex }
        return parent.index.appending(index)
    }
    
    open var startIndex: Index { [] }
    open var endIndex: Index { [children.endIndex] }
    
    open func index(after index: Index) -> Index {
        guard hasChildren else { return [children.endIndex] }
        guard index != startIndex else { return [children.startIndex] }
        
        let childIndex = index[0]
        let nextIndex = children[childIndex].index(after: index.dropFirst())
        
        if nextIndex[0] >= children[childIndex].countOfChildren {
            return [children.index(after: childIndex)]
        }
        
        return index[0...0].appending(nextIndex)
    }
    
    open func firstIndex(where predicate: (Element) throws -> Bool) rethrows -> Index? {
        var index = startIndex
        while index < endIndex {
            if try predicate(self[element: index]) {
                return index
            }
            index = self.index(after: index)
        }
        return nil
    }
    
    open func firstIndex(of element: Element) -> Index? where Element: Equatable {
        firstIndex { $0 == element }
    }
    
    // MARK: - Insert
    
    open func insert(_ node: TreeNode, at index: Index) {
        switch index {
        case startIndex:
            fatalError("Index must not be start index")
        case _ where index.count == 1:
            node.removeFromParent()
            node.parent = self
            children.insert(node, at: index[0])
        default:
            self[node: index.dropLast()].insert(node, at: [index.last!])
        }
    }
    
    open func insert(_ element: Element, at index: Index) {
        insert(Self(element: element, children: []), at: index)
    }
    
    // MARK: - Append
    
    open func append(_ node: TreeNode) {
        insert(node, at: endIndex)
    }
    
    open func append(_ node: TreeNode, toNodeAt index: Index) {
        self[node: index].append(node)
    }
    
    open func append(_ element: Element) {
        insert(element, at: endIndex)
    }
    
    open func append(_ element: Element, toNodeAt index: Index) {
        self[node: index].append(element)
    }
    
    // MARK: - Remove
    
    open func remove(nodeAt index: Index) {
        switch index {
        case startIndex:
            fatalError("Index must not be start index")
        case _ where index.count == 1:
            children[index[0]].parent = nil
            children.remove(at: index[0])
        default:
            self[node: index.dropLast()].remove(nodeAt: [index.last!])
        }
    }
    
    open func removeFirst(where predicate: (Element) throws -> Bool) rethrows {
        if let index = try firstIndex(where: predicate), index != startIndex {
            remove(nodeAt: index)
        }
    }
    
    // MARK: - Sort
    
    open func sorted(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Self {
        Self(element: element, children: try children.map {
            try $0.sorted(by: areInIncreasingOrder)
        }.sorted {
            try areInIncreasingOrder($0.element, $1.element)
        })
    }
    
    open func sorted() -> Self where Element: Comparable {
        sorted { $0 < $1 }
    }
    
    // MARK: - Find
    
    open func firstNode<T: TreeNode>(where predicate: (T) throws -> Bool) rethrows -> T? {
        var iterator = makeIterator()
        while let node = iterator.nextNode() {
            guard let node = node as? T,
                  try predicate(node)
            else { continue }
            return node
        }
        return nil
    }
    
    // MARK: - Map
    
    open func map<E, T: TreeNode<E>>(_ transform: (Element) throws -> E) rethrows -> T {
        let element = try transform(element)
        let children: [T] = try children.map { try $0.map(transform) }
        return T(element: element, children: children)
    }
    
    // MARK: - Hashable
    
    open func hash(into hasher: inout Hasher) where Element: Hashable {
        hasher.combine(element)
        hasher.combine(children)
    }
    
    // MARK: - Equatable
    
    public static func == (lhs: TreeNode, rhs: TreeNode) -> Bool where Element: Equatable {
        lhs.element == rhs.element && lhs.children == rhs.children
    }
}

// MARK: - Hashable

extension TreeNode: Hashable where Element: Hashable {}

// MARK: - Equatable

extension TreeNode: Equatable where Element: Equatable {}

// MARK: - Decodable

extension TreeNode: Decodable where Element: Decodable {}

// MARK: - Encodable

extension TreeNode: Encodable where Element: Encodable {}
