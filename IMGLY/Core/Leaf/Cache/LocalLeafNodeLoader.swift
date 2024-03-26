////
////  LocalLeafLoader.swift
////  Core
////
////  Created by macbook abdul on 24/03/2024.
////
//
import Foundation
//
public final class LocalLeafNodeLoader: LeafNodeLoader, LeafNodeCache {
	private let store: LocalStore
	private let currentDate: () -> Date

	private struct CacheMissError: Error {}

	public init(store: LocalStore, currentDate: @escaping () -> Date) {
		self.store = store
		self.currentDate = currentDate
	}

	public func load(id: String) async throws -> LeafNode {
		do {
			let loader = try await store.read(id: id)
			return LocalLeafNodeMapper.toDomain(node: loader)
		} catch {
			throw CacheMissError()
		}
	}

	public func save(id: String, node: LeafNode) async throws {
		try await store.write(id, LocalLeafNodeMapper.toLocal(node: node), timestamp: currentDate())
	}
}
