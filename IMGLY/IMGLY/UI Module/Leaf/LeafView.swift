//
//  TreeViewCell.swift
//  SwiftHeroes
//
//  Created by macbook abdul on 24/03/2024.
//

import Core
import Foundation
import SwiftUI

extension String {
    func formattedDate() -> String {
        let inputFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let outputFormat = "MMM dd, yyyy hh:mm:ss a"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat

        guard let date = dateFormatter.date(from: self) else {
            // Return an empty string or any default value if parsing fails
            return self
        }

        dateFormatter.dateFormat = outputFormat
        return dateFormatter.string(from: date)
    }
}

struct LeafView: View {
    @StateObject var leafViewModel: LeafViewModel
    let designLibrary: DesignLibraryProvider
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            switch leafViewModel.state {
            case .idle:
                EmptyView()
            case .isLoading:
                ProgressView()
            case .failure(let error):
                RetryButton(text: error.rawValue, designLibrary: designLibrary)
                {
                    Task {
                        await leafViewModel.load()
                    }
                }
            case .success(let node):

                detailText("Created At:", node.createdAt)
                detailText("Created By:", node.createdBy)
                detailText("lastModified At:", node.lastModifiedAt)
                detailText("lastModified By:", node.lastModifiedBy)

                CardView(designLibrary: designLibrary, leaf: node)
            }

        }.task {
            await leafViewModel.load()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBar(
            backgroundColor: .clear,
            titleColor: designLibrary.color.text.standard
        )
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .background(
            designLibrary.color.background.cell.edgesIgnoringSafeArea(.all)
        )
        .ignoresSafeArea()

    }

    @ViewBuilder fileprivate func detailText(
        _ title: String, _ nodeText: String
    ) -> some View {
        HStack {
            Text("\(title)").font(designLibrary.font.cardFont.body)
            Text(" \(nodeText.formattedDate())").font(
                designLibrary.font.cardFont.body)

        }.foregroundColor(designLibrary.color.text.standard)
    }

    @ViewBuilder var backButton: some View {
        Button(action: {
            withAnimation {
                dismiss()
            }
        }) {
            HStack {
                Image("duck")
                    .renderingMode(.template)
                    .foregroundColor(designLibrary.color.icon.buttonPrimary)

                Text("Back")
                    .foregroundColor(designLibrary.color.text.buttonPrimary)
                    .font(designLibrary.font.buttonFont.standard)
            }
            .frame(width: 80, height: 40)
            .background(designLibrary.color.background.buttonPrimary)
            .cornerRadius(designLibrary.miscellaneous.cornerRadius.button)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    LeafView(
        leafViewModel: LeafViewModel(loader: stubbedLeafLoader(), id: "2"),
        designLibrary: DesignLibrary())
}

private struct stubbedLeafLoader: LeafNodeLoader {
    func load(id: String) async throws -> Core.LeafNode {
        return StubbedReponses.buildLeafNode()
    }

}
