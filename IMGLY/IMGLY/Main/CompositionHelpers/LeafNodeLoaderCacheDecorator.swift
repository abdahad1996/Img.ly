//
//  LeafNodeLoaderCacheDecorator.swift
//  SwiftHeroes
//
//  Created by macbook abdul on 25/03/2024.
//

import Foundation
import Core
class LeafNodeLoaderCacheDecorator: LeafNodeLoader {
	private let remoteLeafNodeLoader: RemoteLeafNodeLoader
	private let leafNodeCache: LeafNodeCache

	init(remoteLeafNodeLoader: RemoteLeafNodeLoader, leafNodeCache: any LeafNodeCache) {
		self.remoteLeafNodeLoader = remoteLeafNodeLoader
		self.leafNodeCache = leafNodeCache
	}

	func load(id: String) async throws -> LeafNode {
		let node = try await remoteLeafNodeLoader.load(id: id)
		try? await leafNodeCache.save(id: id, node: node)
		return node
	}
}
