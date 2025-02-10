//
//  LeafNodeLoaderWithFallbackComposite.swift
//  SwiftHeroes
//
//  Created by macbook abdul on 25/03/2024.
//

import Core
import Foundation

class LeafNodeLoaderWithFallbackComposite: LeafNodeLoader {
    private let primaryLoader: LeafNodeLoader
    private let secondaryLoader: LeafNodeLoader

    init(primaryLoader: LeafNodeLoader, secondaryLoader: LeafNodeLoader) {
        self.primaryLoader = primaryLoader
        self.secondaryLoader = secondaryLoader
    }

    func load(id: String) async throws -> LeafNode {
        do {
            return try await primaryLoader.load(id: id)
        } catch {
            return try await secondaryLoader.load(id: id)
        }
    }
}
