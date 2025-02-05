//
//  RemoteTreeNodeMapper.swift
//  Core
//
//  Created by macbook abdul on 23/03/2024.
//

import Foundation

public enum LocalLeafNodeMapper {
	static func toLocal(node: LeafNode) -> LocalLeafNode {
		return LocalLeafNode(node: node)
	}

	static func toDomain(node: LocalLeafNode) -> LeafNode {
		return LeafNode(id: node.id, createdAt: node.createdAt, createdBy: node.createdAt, lastModifiedAt: node.lastModifiedAt, lastModifiedBy: node.lastModifiedBy, description: node.description)
	}
}
