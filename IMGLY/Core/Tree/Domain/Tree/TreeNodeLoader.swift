//
//  TreeNodeLoader.swift
//  Core
//
//  Created by macbook abdul on 25/03/2024.
//

import Foundation

//usecase
public protocol TreeNodeLoader {
  func load() async throws -> [TreeNode]
}
