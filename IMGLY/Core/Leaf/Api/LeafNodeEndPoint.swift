//
//  LeafNodeEndPoint.swift
//  Core
//
//  Created by macbook abdul on 25/03/2024.
//

import Foundation
public enum LeafNodeEndpoint {
    case get(String)
    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(id):
            return baseURL.appendingPathComponent("/entries/\(id).json")
        }
    }
}
