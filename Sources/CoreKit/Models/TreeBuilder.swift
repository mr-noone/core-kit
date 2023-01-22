import Foundation

@resultBuilder public struct TreeBuilder {
    public static func buildBlock<Item>(_ children: TreeNode<Item>...) -> [TreeNode<Item>] {
        return children
    }
    
    public static func buildBlock<Item>(_ children: [TreeNode<Item>]) -> [TreeNode<Item>] {
        return children
    }
}
