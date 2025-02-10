//
//  TreeCellViewModel.swift
//  SwiftHeroes
//
//  Created by macbook abdul on 25/03/2024.
//

import Core
import Foundation
import SwiftUI

public class TreeCellViewModel {
    let node: TreeNode

    public init(node: TreeNode) {
        self.node = node
    }

    var isLeafChild: Bool {
        return node.children == nil
    }

    var label: String {
        return node.label
    }

    var level: Int {
        return node.level
    }
}
