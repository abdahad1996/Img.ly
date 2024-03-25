//
//  RemoteTreeNode.swift
//  Core
//
//  Created by macbook abdul on 23/03/2024.
//

import Foundation

public final class RemoteLeafNodeLoader: LeafNodeLoader {
	private let url: URL
	private let client: HTTPClient

	public enum Error: Swift.Error {
		case connectivity
		case invalidData
	}

	public init(url: URL, client: HTTPClient) {
		self.url = url
		self.client = client
	}

	public func load(id: String) async throws -> LeafNode {
		let (data, response) = try await self.client.get(from: url)
		return try RemoteLeafMapper.mapToLeafNode(from: data, response: response)
	}
}
