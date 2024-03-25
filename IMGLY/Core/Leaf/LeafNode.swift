//
//  TreeNode.swift
//  Core
//
//  Created by macbook abdul on 23/03/2024.
//

import Foundation

public struct LeafNode: Identifiable, Equatable {
	public let id: String
	public let createdAt: String
	public let createdBy: String
	public let lastModifiedAt: String
	public let lastModifiedBy: String
	public let description: String

	public init(id: String, createdAt: String, createdBy: String, lastModifiedAt: String, lastModifiedBy: String, description: String) {
		self.id = id
		self.createdAt = createdAt
		self.createdBy = createdBy
		self.lastModifiedAt = lastModifiedAt
		self.lastModifiedBy = lastModifiedBy
		self.description = description
	}
}
