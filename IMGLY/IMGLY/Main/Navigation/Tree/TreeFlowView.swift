//
//  TreeRouteView.swift
//  SwiftHeroes
//
//  Created by macbook abdul on 23/03/2024.
//

import Core
import Foundation
import SwiftUI

public struct TreeFlowView {
    let designLibrary: DesignLibraryProvider

    public init(designLibrary: DesignLibraryProvider) {
        self.designLibrary = designLibrary
    }

    @ViewBuilder public func makeTreeView(
        flow: Flow<TreeRoute>,
        treeLoader: TreeNodeLoader
    ) -> some View {
        TreeView(
            treeViewModel: TreeViewModel(loader: treeLoader),
            treeViewCell: makeTreeCell,
            goToDetail: { id in
                flow.append(.leaf(id))
            }, designLibrary: designLibrary)
    }

    @ViewBuilder private func makeTreeCell(_ treeNode: TreeNode) -> some View {
        TreeCell(
            treeCellViewModel: TreeCellViewModel(node: treeNode),
            designLibrary: designLibrary)
    }
}
