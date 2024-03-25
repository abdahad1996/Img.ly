//
//  TreeNodeLoader.swift
//  Core
//
//  Created by macbook abdul on 25/03/2024.
//

import Foundation

public protocol TreeNodeLoader {
    func load() async throws -> [TreeNode]
}
