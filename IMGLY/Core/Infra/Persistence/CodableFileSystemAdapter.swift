//
//  CodableFileSystemAdapter.swift
//  Core
//
//  Created by macbook abdul on 25/03/2024.
//

import Foundation

public class CodableFileSystemAdapter: LocalStore {
	private struct Cache: Codable {
		let codableLeafNode: CodableLeafNode
		let timestamp: Date
		let id: String

		var localLeafNode: LocalLeafNode {
			return codableLeafNode.localLeafNode
		}
	}

	public struct CodableLeafNode: Codable {
		public let id: String
		public let createdAt: String
		public let createdBy: String
		public let lastModifiedAt: String
		public let lastModifiedBy: String
		public let description: String

		init(node: LocalLeafNode) {
			self.id = node.id
			self.createdAt = node.createdAt
			self.createdBy = node.createdBy
			self.lastModifiedAt = node.lastModifiedAt
			self.lastModifiedBy = node.lastModifiedBy
			self.description = node.description
		}

		var localLeafNode: LocalLeafNode {
			return LocalLeafNode(id: id, createdAt: createdAt, createdBy: createdBy, lastModifiedAt: lastModifiedAt, lastModifiedBy: lastModifiedBy, description: description)
		}
	}

	private struct CacheMissError: Error {}

	private let storeURL: URL

	public init(storeURL: URL) {
		self.storeURL = storeURL
	}

	public func read(id: String) async throws -> LocalLeafNode {
		let storeURL = self.storeURL

		guard let data = try? Data(contentsOf: storeURL) else {
			throw CacheMissError()
		}
		do {
			let decoder = JSONDecoder()
			let cacheArr = try decoder.decode([Cache].self, from: data)

			guard let cache = cacheArr.first(where: { $0.id == id }) else {
				throw CacheMissError()
			}

			return cache.localLeafNode
		} catch {
			throw CacheMissError()
		}
	}

    fileprivate func saveFirstTime(_ object: LocalLeafNode, _ timestamp: Date, _ id: String) throws {
        let encoder = JSONEncoder()
        let cache = Cache(codableLeafNode: CodableLeafNode(node: object), timestamp: timestamp, id: id)
        var cacheArr = [Cache]()
        cacheArr.append(cache)
        let encoded = try encoder.encode(cacheArr)
        try encoded.write(to: storeURL)
    }
    
    public func write(_ id: String, _ object: LocalLeafNode, timestamp: Date) async throws {
		do {
			guard let data = try? Data(contentsOf: storeURL) else {
                try saveFirstTime(object, timestamp, id)
				throw CacheMissError()
			}

			let decoder = JSONDecoder()
			var cacheArr = try? decoder.decode([Cache].self, from: data)

			let encoder = JSONEncoder()
			let cache = Cache(codableLeafNode: CodableLeafNode(node: object), timestamp: timestamp, id: id)

			//append and save back
			if var cacheArr = cacheArr {
				cacheArr.append(cache)
				let encoded = try encoder.encode(cacheArr)
				try encoded.write(to: storeURL)
			} else {
				var cacheArr = [Cache]()
				cacheArr.append(cache)
				let encoded = try encoder.encode(cacheArr)
				try encoded.write(to: storeURL)
			}

		} catch {
			throw CacheMissError()
		}
	}
}
