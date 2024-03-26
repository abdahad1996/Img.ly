//
//  TreeViewModel.swift
//  SwiftHeroes
//
//  Created by macbook abdul on 23/03/2024.
//

import Foundation
import Core
import SwiftUI

class TreeViewModel: ObservableObject {
	var nodes: [TreeNode] = []
	public enum LoadingTreeError: String, Swift.Error {
		case serverError = "Server connection failed. Please try again!"
	}

	enum State: Equatable {
		case idle
		case isLoading
		case failure(LoadingTreeError)
		case success([TreeNode])
	}

	@Published public var state: State = .idle

	let loader: TreeNodeLoader

	init(loader: TreeNodeLoader) {
		self.loader = loader
	}

	@MainActor func load() async {
		do {
			state = .isLoading
			nodes = try await loader.load()
			state = .success(nodes)
		} catch {
			state = .failure(.serverError)
		}
	}

	func move(
		fromOffsets source: IndexSet,
		toOffset destination: Int) {
		nodes.move(fromOffsets: source, toOffset: destination)
		state = .success(nodes)
	}

	func deleteNode(at offsets: IndexSet) {
		nodes.remove(atOffsets: offsets)
		state = .success(nodes)
	}
}
