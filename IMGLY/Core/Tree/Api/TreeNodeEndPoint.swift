//
//  TreeNodeEndPoint.swift
//  Core
//
//  Created by macbook abdul on 25/03/2024.
//

import Foundation
public enum TreeNodeEndpoint {
    case get

    public func url(baseURL: URL) -> URL {
        switch self {
        case .get:
            return baseURL.appendingPathComponent("/data.json")
        }
    }
}
