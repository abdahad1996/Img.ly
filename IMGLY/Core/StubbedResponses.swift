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
    let entry3Node = TreeNode(
      id: "", label: "Entry 3", children: [subEntry1])

    let workspaceA = TreeNode(
      id: "", label: "Workspace A", children: [entry1, entry2, entry3])
    let workspaceB = TreeNode(
      id: "", label: "Workspace B",
      children: [entry1, entry2, entry3Node])

    let imgly = TreeNode(
      id: "", label: "img.ly", children: [workspaceA, workspaceB])

    let entry1_9e = TreeNode(id: "9e.A.1", label: "Entry 1")
    let entry2_9e = TreeNode(id: "9e.A.2", label: "Entry 2")
    let workspaceA_9e = TreeNode(
      id: "", label: "Workspace A", children: [entry1_9e, entry2_9e])

    let nineElements = TreeNode(
      id: "", label: "9elements", children: [workspaceA_9e])

    return [imgly, nineElements]
  }

  public static func buildLeafNode() -> LeafNode {
    return LeafNode(
      id: "25359599-ba54-5132-8309-97c8513e08e9",
      createdAt: "2082-09-12T06:43:47.099Z",
      createdBy: "du@ijdu.cm",
      lastModifiedAt: "2023-08-31T07:07:40.646Z",
      lastModifiedBy: "pit@gon.bw",
      description:
        "Duw orevoza jiprudis faz alnaimu sazafapa cuwpe zifehe kowo wasmag otu tuwulfoj bifo se botirgo. Kiojka roftan otecu ohukdu zuaruuze ow ko jogapob naw jadkawwa nem vo fasoz tofih vu oz hizjorguc maj. Kedfov kikodu lan afavo ehonaki be nem du sudomaew mohe vohicemu vultuob muhbacni suzfef ihidozep azitude tilre hubju. Ovdunir ozu melnutvu ti fudolwe ohtet bicun tirat honwajak ujnu ak pelbod cuw coez cu aha. Icuru faabupuf la tu vegelu cinak wuoh hulico nen ri mub cedal sir hakeje guaja supbad togju jolug. Res ipemte bovzahle ih tus hi mopeczaj fahahal ejaha cibvi kene ti gele romi ufpiki lihkefju jol. Perum vudfen micbibo tueku seab nobjeolu keden elgeiv he efoas woz kusfop lirfidu."
    )

  }

}
