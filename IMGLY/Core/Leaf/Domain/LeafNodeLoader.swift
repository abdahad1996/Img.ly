//
//  TreeNodeLoader.swift
//  Core
//
//  Created by macbook abdul on 23/03/2024.
//

import Foundation

public protocol LeafNodeLoader {
	func load(id: String) async throws -> LeafNode
}
