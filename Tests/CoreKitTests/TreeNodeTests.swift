import XCTest
import CoreKit

final class TreeNodeTests: XCTestCase {
    typealias TreeNode = CoreKit.TreeNode<Int>
    
    // MARK: - Inits
    
    func testInit() {
        let tree = TreeNode(element: 0, children: [
            .init(element: 1),
            .init(element: 2)
        ])
        XCTAssertEqual(tree.children[0].parent, tree)
        XCTAssertEqual(tree.children[1].parent, tree)
    }
    
    // MARK: - Subscripts
    
    func testGetByIndex() {
        let tree = TreeNode(element: 0, children: [
            .init(element: 1), .init(element: 2)
        ])
        XCTAssertEqual(tree[element: []], 0)
        XCTAssertEqual(tree[element: [1]], 2)
    }
    
    func testSetByIndex() {
        let tree = TreeNode(element: 0, children: [
            .init(element: 1), .init(element: 2)
        ])
        tree[element: [1]] = 3
        XCTAssertEqual(tree, .init(element: 0, children: [
            .init(element: 1), .init(element: 3)
        ]))
    }
    
    func testGetNodeByIndex() {
        let tree = TreeNode(element: 0) {
            TreeNode(element: 1)
            TreeNode(element: 2)
        }
        XCTAssertEqual(tree[node: [1]], .init(element: 2))
    }
    
    func testSetNodeByIndex() {
        let tree = TreeNode(element: 0) {
            TreeNode(element: 1)
            TreeNode(element: 2) {
                TreeNode(element: 3)
            }
        }
        tree[node: [1, 0]] = .init(element: 4)
        XCTAssertEqual(tree, .init(element: 0) {
            TreeNode(element: 1)
            TreeNode(element: 2) {
                TreeNode(element: 4)
            }
        })
    }
    
    // MARK: - Count
    
    func testCountOfChildren() {
        let tree = TreeNode(element: 0, children: [
            .init(element: 1), .init(element: 2), .init(element: 3)
        ])
        XCTAssertEqual(tree.countOfChildren, 3)
    }
    
    func testCountOfChildrenAtIndex() {
        let tree = TreeNode(element: 0, children: [
            .init(element: 1, children: [
                .init(element: 2),
                .init(element: 3)
            ])
        ])
        XCTAssertEqual(tree.countOfChildren(at: [0]), 2)
        XCTAssertEqual(tree.countOfChildren(at: [0, 1]), 0)
    }
    
    // MARK: - Indices
    
    func testIndex() {
        let tree = TreeNode(element: 0) {
            TreeNode(element: 1) {
                TreeNode(element: 2)
                TreeNode(element: 3)
            }
        }
        XCTAssertEqual(tree.index, [])
        XCTAssertEqual(tree[node: [0, 1]].index, [0, 1])
    }
    
    func testStartIndex() {
        let tree = TreeNode(element: 0, children: [])
        XCTAssertEqual(tree.startIndex, [])
    }
    
    func testEndIndex() {
        let tree = TreeNode(element: 0, children: [
            .init(element: 1), .init(element: 2)
        ])
        XCTAssertEqual(tree.endIndex, [2])
    }
    
    func testEmptyEndIndex() {
        let tree = TreeNode(element: 0, children: [])
        XCTAssertEqual(tree.endIndex, [0])
    }
    
    func testIndexAfterIndex() {
        let tree = TreeNode(element: 0) {
            TreeNode(element: 1) {
                TreeNode(element: 2)
                TreeNode(element: 3)
            }
            TreeNode(element: 4)
            TreeNode(element: 5) {
                TreeNode(element: 6) {
                    TreeNode(element: 7)
                    TreeNode(element: 8)
                    TreeNode(element: 9)
                }
            }
        }
        XCTAssertEqual(tree.index(after: []),        [0])
        XCTAssertEqual(tree.index(after: [0]),       [0, 0])
        XCTAssertEqual(tree.index(after: [0, 0]),    [0, 1])
        XCTAssertEqual(tree.index(after: [0, 1]),    [1])
        XCTAssertEqual(tree.index(after: [1]),       [2])
        XCTAssertEqual(tree.index(after: [2]),       [2, 0])
        XCTAssertEqual(tree.index(after: [2, 0]),    [2, 0, 0])
        XCTAssertEqual(tree.index(after: [2, 0, 0]), [2, 0, 1])
        XCTAssertEqual(tree.index(after: [2, 0, 1]), [2, 0, 2])
        XCTAssertEqual(tree.index(after: [2, 0, 2]), [3])
    }
    
    func testIndexAfterIndexEmptyTree() {
        let tree = TreeNode(element: 0)
        XCTAssertEqual(tree.index(after: [1, 1]), tree.endIndex)
    }
    
    func testFirstIndexWhere() {
        let tree = TreeNode(element: 0) {
            TreeNode(element: 1)
            TreeNode(element: 2)
        }
        XCTAssertEqual(tree.firstIndex(where: { $0 == 2 }), [1])
        XCTAssertNil(tree.firstIndex(where: { $0 == 3 }))
    }
    
    // MARK: - Insert
    
    func testInsertNodeAtIndex() {
        let tree = TreeNode(element: 0)
        let node1 = TreeNode(element: 1)
        let node2 = TreeNode(element: 2)
        tree.insert(node1, at: [0])
        tree.insert(node2, at: [0, 0])
        XCTAssertEqual(node1.parent, tree)
        XCTAssertEqual(node2.parent, node1)
        XCTAssertEqual(tree, TreeNode(element: 0) {
            TreeNode(element: 1) {
                TreeNode(element: 2)
            }
        })
    }
    
    func testInsertElementAtIndex() {
        let tree = TreeNode(element: 0) {
            TreeNode(element: 2) {
                TreeNode(element: 3)
            }
        }
        tree.insert(1, at: [0])
        tree.insert(4, at: [1, 0, 0])
        XCTAssertEqual(tree, TreeNode(element: 0) {
            TreeNode(element: 1)
            TreeNode(element: 2) {
                TreeNode(element: 3) {
                    TreeNode(element: 4)
                }
            }
        })
    }
    
    // MARK: - Remove
    
    func testRemoveNodeAtIndex() {
        let tree = TreeNode(element: 0) {
            TreeNode(element: 1)
            TreeNode(element: 2) {
                TreeNode(element: 3)
                TreeNode(element: 4) {
                    TreeNode(element: 5)
                }
            }
        }
        let node1 = tree[node: [1, 1]]
        let node2 = tree[node: [0]]
        
        tree.remove(nodeAt: [1, 1])
        tree.remove(nodeAt: [0])
        
        XCTAssertNil(node1.parent)
        XCTAssertNil(node2.parent)
        XCTAssertEqual(tree, TreeNode(element: 0) {
            TreeNode(element: 2) {
                TreeNode(element: 3)
            }
        })
    }
    
    func testRemoveFirstWhere() {
        let tree = TreeNode(element: 0) {
            TreeNode(element: 1)
            TreeNode(element: 2) {
                TreeNode(element: 3)
                TreeNode(element: 4) {
                    TreeNode(element: 5)
                }
            }
        }
        tree.removeFirst { $0 == 4 }
        XCTAssertEqual(tree, TreeNode(element: 0) {
            TreeNode(element: 1)
            TreeNode(element: 2) {
                TreeNode(element: 3)
            }
        })
    }
    
    // MARK: - Sort
    
    func testBortedByOrderClosure() {
        let tree = TreeNode(element: 0, children: [
            .init(element: 2, children: [
                .init(element: 1),
                .init(element: 0)
            ]),
            .init(element: 1),
            .init(element: 4),
            .init(element: 3),
            .init(element: 0)
        ])
        let sorted = TreeNode(element: 0, children: [
            .init(element: 0),
            .init(element: 1),
            .init(element: 2, children: [
                .init(element: 0),
                .init(element: 1)
            ]),
            .init(element: 3),
            .init(element: 4)
        ])
        XCTAssertEqual(tree.sorted { $0 < $1 }, sorted)
    }
}
