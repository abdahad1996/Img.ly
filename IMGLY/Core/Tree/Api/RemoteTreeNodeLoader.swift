//
//  RemoteTreeNodeLoader.swift
//  Core
//
//  Created by macbook abdul on 25/03/2024.
//

import Foundation

public class RemoteTreeNodeLoader: TreeNodeLoader {

    public let url: URL
    public let client: HTTPClient

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public func load() async throws -> [TreeNode] {
        let url = TreeNodeEndpoint.get.url(baseURL: url)
        guard let (data, response) = try? await self.client.get(from: url)
        else {
            throw Error.connectivity
        }
        return try RemoteTreeMapper.mapToTreeNodes(
            from: data, response: response)
    }

}
