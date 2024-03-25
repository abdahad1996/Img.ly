//
//  RemoteTreeNodeMapper.swift
//  Core
//
//  Created by macbook abdul on 23/03/2024.
//

import Foundation

public enum RemoteLeafMapper {
	public struct RemoteLeafNode: Codable {
		public let id: String
		public let createdAt: String
		public let createdBy: String
		public let lastModifiedAt: String
		public let lastModifiedBy: String
		public let description: String
	}

	private static func mapToLeafNode(node: RemoteLeafNode) -> LeafNode {
		return LeafNode(id: node.id, createdAt: node.createdAt, createdBy: node.createdBy, lastModifiedAt: node.lastModifiedAt, lastModifiedBy: node.lastModifiedBy, description: node.description)
	}

	private static var OK_200: Int { return 200 }
	public static func mapToLeafNode(from data: Data, response: HTTPURLResponse) throws -> LeafNode {
		guard response.statusCode == OK_200, let remoteLeafNode = try? JSONDecoder().decode(RemoteLeafNode.self, from: data) else {
			throw RemoteLeafNodeLoader.Error.invalidData
		}
		let result = self.mapToLeafNode(node: remoteLeafNode)
		return result
	}
}
