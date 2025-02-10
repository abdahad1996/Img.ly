//
//  TreeViewModel.swift
//  SwiftHeroes
//
//  Created by macbook abdul on 23/03/2024.
//

import Core
import Foundation
import SwiftUI

public class LeafViewModel: ObservableObject {
    public enum LoadingLeafError: String, Swift.Error {
        case serverError = "Server connection failed. Please try again!"
    }

    public enum State: Equatable {
        case idle
        case isLoading
        case failure(LoadingLeafError)
        case success(LeafNode)
    }

    @Published public var state: State = .idle

    let loader: LeafNodeLoader
    let id: String

    public init(loader: LeafNodeLoader, id: String) {
        self.loader = loader
        self.id = id
    }

    @MainActor public func load() async {
        do {
            state = .isLoading
            let leaf = try await loader.load(id: id)
            state = .success(leaf)
        } catch {
            state = .failure(.serverError)
        }
    }
}
