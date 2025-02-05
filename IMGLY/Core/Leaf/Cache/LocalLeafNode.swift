//
//  LocalLeafNode.swift
//  Core
//
//  Created by macbook abdul on 25/03/2024.
//

import Foundation

public struct LocalLeafNode {
	public let id: String
	public let createdAt: String
	public let createdBy: String
	public let lastModifiedAt: String
	public let lastModifiedBy: String
	public let description: String

	init(node: LeafNode) {
		self.init(id: node.id, createdAt: node.createdAt, createdBy: node.createdBy, lastModifiedAt: node.lastModifiedAt, lastModifiedBy: node.lastModifiedBy, description: node.description)
	}

	init(id: String, createdAt: String, createdBy: String, lastModifiedAt: String, lastModifiedBy: String, description: String) {
		self.id = id
		self.createdAt = createdAt
		self.createdBy = createdBy
		self.lastModifiedAt = lastModifiedAt
		self.lastModifiedBy = lastModifiedBy
		self.description = description
	}
}
