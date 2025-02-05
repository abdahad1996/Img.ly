//
//  HTTPClient.swift
//  Core
//
//  Created by macbook abdul on 25/03/2024.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL) async throws -> (Data, HTTPURLResponse)
}
