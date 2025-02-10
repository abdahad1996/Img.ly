//
//  TreeViewCell.swift
//  SwiftHeroes
//
//  Created by macbook abdul on 24/03/2024.
//

import Core
import Foundation
import SwiftUI

public struct TreeCell: View {
    let treeCellViewModel: TreeCellViewModel
    let designLibrary: DesignLibraryProvider

    public init(
        treeCellViewModel: TreeCellViewModel,
        designLibrary: DesignLibraryProvider
    ) {
        self.treeCellViewModel = treeCellViewModel
        self.designLibrary = designLibrary
    }

    public var body: some View {
        let _ = print(
            "node label, \(treeCellViewModel.label), node level, \(treeCellViewModel.level)"
        )

        HStack {
            Image(treeCellViewModel.isLeafChild ? "child" : "parent")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)  // Set the size of the image
                .clipShape(Circle())  // Clip the image to a circle shape
                .overlay(Circle().stroke(Color.white, lineWidth: 2))  // Add a white stroke around the circle
                .shadow(radius: 3)
                .padding(.leading, CGFloat(treeCellViewModel.level) * 15)  // Add padding to the leading edge of the image

            Text(treeCellViewModel.label)
                .font(.headline)
                .font(designLibrary.font.buttonFont.standard)
                .foregroundColor(designLibrary.color.text.standard)

            Spacer()
            if treeCellViewModel.isLeafChild {
                Button(action: {}) {
                    HStack {
                        Image("duck")
                            .renderingMode(.template)
                            .foregroundColor(
                                designLibrary.color.icon.buttonPrimary)

                        Text("tap")
                            .foregroundColor(
                                designLibrary.color.text.buttonPrimary
                            )
                            .font(designLibrary.font.buttonFont.standard)
                    }
                    .frame(width: 70, height: 40)
                    .background(designLibrary.color.background.buttonPrimary)
                    .cornerRadius(
                        designLibrary.miscellaneous.cornerRadius.button)
                }
            }
        }
        .disabled(!treeCellViewModel.isLeafChild)
        .deleteDisabled(!treeCellViewModel.isLeafChild)
        .moveDisabled(!treeCellViewModel.isLeafChild)
        .contentShape(Rectangle())
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    TreeCell(
        treeCellViewModel: TreeCellViewModel(
            node: TreeNode(id: "1", label: "test", level: 2)),
        designLibrary: DesignLibrary()
    ).background(.black)

}
