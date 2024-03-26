//
//  StubbedResponses.swift
//  Core
//
//  Created by macbook abdul on 26/03/2024.
//

import Foundation

public class StubbedReponses {
    
    // Method to build the node hierarchy
    public static func buildTreeNodeHierarchy() -> [TreeNode] {
        let entry1 = TreeNode(id: "imgly.A.1", label: "Entry 1")
        let entry2 = TreeNode(id: "imgly.A.2", label: "Entry 2")
        let entry3 = TreeNode(id: "imgly.A.3", label: "Entry 3")

        let subEntry1 = TreeNode(id: "imgly.B.3.1", label: "Sub-Entry 1")
        let entry3Node = TreeNode(id: "", label: "Entry 3", children: [subEntry1])

        let workspaceA = TreeNode(id: "", label: "Workspace A", children: [entry1, entry2, entry3])
        let workspaceB = TreeNode(id: "", label: "Workspace B", children: [entry1, entry2, entry3Node])

        let imgly = TreeNode(id: "", label: "img.ly", children: [workspaceA, workspaceB])

        let entry1_9e = TreeNode(id: "9e.A.1", label: "Entry 1")
        let entry2_9e = TreeNode(id: "9e.A.2", label: "Entry 2")
        let workspaceA_9e = TreeNode(id: "", label: "Workspace A", children: [entry1_9e, entry2_9e])

        let nineElements = TreeNode(id: "", label: "9elements", children: [workspaceA_9e])

        return [imgly, nineElements]
    }
    
}
