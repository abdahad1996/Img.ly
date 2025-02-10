//
//  LocalStore.swift
//  Core
//
//  Created by macbook abdul on 25/03/2024.
//

import Foundation

public protocol LocalStore {
    func read(id: String) async throws -> LocalLeafNode
    func write(_ id: String, _ object: LocalLeafNode, timestamp: Date)
        async throws
}
