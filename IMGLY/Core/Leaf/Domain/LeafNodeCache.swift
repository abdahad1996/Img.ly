//
//  LeafNodeSaver.swift
//  Core
//
//  Created by macbook abdul on 24/03/2024.
//

import Foundation

public protocol LeafNodeCache {
	func save(id: String, node: LeafNode) async throws
}
