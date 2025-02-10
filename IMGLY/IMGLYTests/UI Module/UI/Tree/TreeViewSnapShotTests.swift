import Core
import SnapshotTesting
import SwiftUI
//
//  TreeViewSnapShotTests.swift
//  IMGLYTests
//
//  Created by macbook abdul on 26/03/2024.
//
import XCTest

@testable import IMGLY

final class TreeViewSnapshotTests: XCTestCase {

    func test_treeViewIdleState() {
        let sut = makeSUT(getTreeViewrState: .idle)

        assertLightAndDarkSnapshot(matching: sut)
    }

    func test_treeViewIsLoadingState() {
        let sut = makeSUT(getTreeViewrState: .isLoading)

        assertLightAndDarkSnapshot(matching: sut)
    }

    func test_treeViewFailureState() {
        let sut = makeSUT(getTreeViewrState: .failure(.serverError))

        assertLightAndDarkSnapshot(matching: sut)
    }

    func test_treeViewSuccessState() {
        let sut = makeSUT(
            getTreeViewrState: .success(
                StubbedReponses.buildTreeNodeHierarchy()))

        assertLightAndDarkSnapshot(matching: sut)
    }

    func test_TreeViewSuccessState_DifferentTheme() {
        let sut = makeSUT(
            getTreeViewrState: .success(
                StubbedReponses.buildTreeNodeHierarchy()),
            designLibrary: DesignLibraryAlternative())

        assertLightAndDarkSnapshot(matching: sut)
    }

    // MARK: - Helpers

    private func makeSUT(
        getTreeViewrState: TreeViewModel.State,
        designLibrary: DesignLibraryProvider = DesignLibrary()
    ) -> some View {
        let treeViewModel = TreeViewModel(loader: EmptyStubTreeNodeLoader())
        treeViewModel.state = getTreeViewrState

        return TreeView(
            treeViewModel: treeViewModel,
            treeViewCell: { node in
                TreeCell(
                    treeCellViewModel: TreeCellViewModel(node: node),
                    designLibrary: designLibrary)
            }, goToDetail: { _ in }, designLibrary: designLibrary)

    }

    private class EmptyStubTreeNodeLoader: TreeNodeLoader {
        func load() async throws -> [TreeNode] { return [] }
    }

}
