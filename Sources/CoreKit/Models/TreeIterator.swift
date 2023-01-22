import Foundation

public struct TreeIterator<Element>: IteratorProtocol {
    // MARK: - Properties
    
    private let tree: TreeNode<Element>
    private var index: TreeNode<Element>.Index
    
    // MARK: - Inits
    
    public init(tree: TreeNode<Element>, index: TreeNode<Element>.Index) {
        self.tree = tree
        self.index = index
    }
    
    // MARK: - Methods
    
    public mutating func next() -> Element? {
        guard index < tree.endIndex else { return nil }
        defer { index = tree.index(after: index) }
        return tree[element: index]
    }
    
    public mutating func nextNode() -> TreeNode<Element>? {
        guard index < tree.endIndex else { return nil }
        defer { index = tree.index(after: index) }
        return tree[node: index]
    }
}
