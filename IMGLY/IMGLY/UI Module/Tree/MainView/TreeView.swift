//
//  TreeView.swift
//  SwiftHeroes
//
//  Created by macbook abdul on 24/03/2024.
//

import Foundation
import SwiftUI
import Core

public struct TreeView<TreeViewCell: View>: View {
    let treeViewCell: (TreeNode) -> TreeViewCell
    let goToDetail: (String) -> Void
    let designLibrary: DesignLibraryProvider
    @StateObject var treeViewModel: TreeViewModel
    @State private var isEditing = false

    init(treeViewModel: TreeViewModel,
         treeViewCell: @escaping (TreeNode) -> TreeViewCell,
         goToDetail: @escaping (String) -> Void,
         designLibrary: DesignLibraryProvider
    ) {
        self._treeViewModel = StateObject(wrappedValue: treeViewModel)
        self.treeViewCell = treeViewCell
        self.goToDetail = goToDetail
        self.designLibrary = designLibrary
    }

    public var body: some View {
        VStack {
            switch treeViewModel.state {
            case .idle:
                RetryButton(text: "tap on the button to get data", designLibrary: designLibrary) {
                    Task {
                        await treeViewModel.load()
                    }
                }

            case .isLoading:
                ProgressView()

            case .failure(let error):
                RetryButton(text: error.rawValue, designLibrary: designLibrary) {
                    Task {
                        await treeViewModel.load()
                    }
                }
            case .success(let nodes):
                List {
                    ForEach(nodes, id: \.id) { node in

                        treeViewCell(node)

                            .onTapGesture {
                                print(node)
                                print(node.children?.isEmpty ?? false)
                                if node.children == nil {
                                    goToDetail(node.id)
                                }
                               
                            }
                    
                    }
                    .onDelete(perform: treeViewModel.deleteNode)
                    .onMove(perform: treeViewModel.move)
                    .listRowSeparatorTint(designLibrary.color.text.standard)
                    .listRowBackground(Color.clear)
                    
                }

        
                .listRowInsets(.none)
                .listStyle(PlainListStyle())
                .environment(\.editMode, isEditing ? .constant(.active) : .constant(.inactive))

                .scrollContentBackground(.hidden)
                .background(designLibrary.color.background.cell.edgesIgnoringSafeArea(.all))
                .frame(maxWidth: .infinity)
                .navigationBar(backgroundColor: designLibrary.color.background.cardDetails, titleColor: designLibrary.color.text.standard)
                .navigationBarItems(trailing: editButton)
            }
        }

        .refreshable {
            await treeViewModel.load()
        }
        .task {
            if treeViewModel.state == .idle {
                await treeViewModel.load()
            }
        }
    }

    @ViewBuilder var editButton: some View {
        Button(action: {
            withAnimation {
                isEditing.toggle()
            }
        }) { HStack {
            Image("duck")
                .renderingMode(.template)
                .foregroundColor(designLibrary.color.icon.buttonPrimary)

            Text(isEditing ? "Done" : "Edit")
                .foregroundColor(designLibrary.color.text.buttonPrimary)
                .font(designLibrary.font.buttonFont.standard)
        }
        .frame(width: 80, height: 40)
        .background(designLibrary.color.background.buttonPrimary)
        .cornerRadius(designLibrary.miscellaneous.cornerRadius.button)
        }
    }

}



#Preview {
    TreeView(treeViewModel: TreeViewModel(loader: StubLoader()), treeViewCell: { node in
        TreeCell(treeCellViewModel: TreeCellViewModel(node: node), designLibrary: DesignLibrary())
    }, goToDetail: {_ in}, designLibrary: DesignLibrary())
}

struct StubLoader:TreeNodeLoader{
    func load() async throws -> [TreeNode] {
        return StubbedReponses.buildTreeNodeHierarchy()
    }
    
    
}
