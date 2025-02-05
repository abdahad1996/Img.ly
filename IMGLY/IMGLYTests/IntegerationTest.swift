//
//  IntegerationTest.swift
//  IMGLYTests
//
//  Created by macbook abdul on 10/04/2024.
//

import Core
import Foundation
import IMGLY
import SwiftUI
import ViewInspector
import XCTest

final class AcceptanceTests: XCTestCase {

  func test_canInit() throws {

    let nodes = makeTreeNodes()
    let sut = try XCTUnwrap(
      TreeFlowView(designLibrary: DesignLibrary()).makeTreeView(
        flow: Flow<TreeRoute>(), treeLoader: MockTreeNodeLoader()) as? TreeView<TreeCell>)
    //      let sut =  TreeView(treeViewModel: TreeViewModel(loader: MockTreeNodeLoader()), treeViewCell: { node in
    //            TreeCell(treeCellViewModel: TreeCellViewModel(node: node), designLibrary: DesignLibrary())
    //        }, goToDetail: {_ in}, designLibrary: DesignLibrary())
    ////
    let list = try sut.inspect().navigationStack().list()

    //        try inspect().find(viewWithAccessibilityIdentifier: "list")
    //        let count = try sut.listCount()

    XCTAssertEqual(list.count, 1)

  }

}

extension TreeView {

  fileprivate func listCount() throws -> Int {
    try inspect().find(viewWithAccessibilityIdentifier: "list").count
  }

  fileprivate func getApprovalSuccessfulButton() -> InspectableView<ViewType.Button>? {
    try? inspect().find(button: "Approval was Successful")
  }

}
public class MockTreeNodeLoader: TreeNodeLoader {
  public func load() async throws -> [TreeNode] {
    // Return sample data
    return makeTreeNodes()
  }
}

public func makeTreeNodes() -> [TreeNode] {
  return [
    TreeNode(id: "1", label: "Node 1"),
    TreeNode(id: "2", label: "Node 2"),
    TreeNode(id: "3", label: "Node 3"),
  ]
}
