//
//  RemoteTreeMapper.swift
//  Core
//
//  Created by macbook abdul on 25/03/2024.
//

import Foundation

public enum RemoteTreeMapper {
    struct RemoteTreeNode: Codable, Identifiable {

        let id: String
        let label: String
        var children: [RemoteTreeNode]?  // Optional children

        // Custom initializer to set depth and parentId recursively
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id =
                try container.decodeIfPresent(String.self, forKey: .id)
                ?? UUID().uuidString
            label = try container.decode(String.self, forKey: .label)
            children = try container.decodeIfPresent(
                [RemoteTreeNode].self, forKey: .children)
        }

        init(
            id: String, label: String,
            children: [RemoteTreeMapper.RemoteTreeNode]? = nil
        ) {
            self.id = id
            self.label = label
            self.children = children
        }
    }

    static func mapToTreeNodes(
        nodes: [RemoteTreeNode], parentId: String? = nil, level: Int = 1
    ) -> [TreeNode] {
        return nodes.flatMap { remoteNode -> [TreeNode] in
            let nodeId = remoteNode.id
            let nodeLabel = remoteNode.label
            let parentNodeId = parentId
            let nodeLevel = level

            var childrenNodes: [TreeNode]?
            if let remoteChildren = remoteNode.children {
                childrenNodes = mapToTreeNodes(
                    nodes: remoteChildren, parentId: nodeId,
                    level: nodeLevel + 1)
            }

            let treeNode =
                TreeNode(
                    id: nodeId, label: nodeLabel, children: childrenNodes,
                    parentId: parentNodeId, level: nodeLevel)
            var result: [TreeNode] = [treeNode]

            if let childrenNodes = childrenNodes {
                result.append(contentsOf: childrenNodes)
            }

            return result
        }
    }

    private static var OK_200: Int { return 200 }
    public static func mapToTreeNodes(
        from data: Data, response: HTTPURLResponse
    ) throws -> [TreeNode] {
        guard response.statusCode == OK_200,
            let remoteTreeNodes = try? JSONDecoder().decode(
                [RemoteTreeNode].self, from: data)
        else {
            throw RemoteTreeNodeLoader.Error.invalidData
        }
        let result = self.mapToTreeNodes(nodes: remoteTreeNodes)
        return result
    }
}
