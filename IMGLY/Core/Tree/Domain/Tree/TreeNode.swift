//
//  TreeNode.swift
//  Core
//
//  Created by macbook abdul on 25/03/2024.
//

import Foundation

public struct TreeNode: Identifiable, Equatable {
    public let id: String
    public let label: String
    public var children: [TreeNode]?
    public var parentId: String?
    public var level: Int = 0

    public init(id: String, label: String, children: [TreeNode]? = nil, parentId: String? = nil, level: Int) {
        self.id = id
        self.label = label
        self.children = children
        self.parentId = parentId
        self.level = level
    }
}
