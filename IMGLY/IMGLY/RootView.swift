//
//  RootView.swift
//  IMGLY
//
//  Created by macbook abdul on 26/03/2024.
//

import Foundation
import SwiftUI

struct RootView: View {
    private let baseURL = URL(string: "https://ubique.img.ly/frontend-tha")!

    @StateObject var treeflow = Flow<TreeRoute>()
    @State private var isToggled = false

    var body: some View {
        
        makeTreeFlowView(designLibrary: isToggled ? DesignLibraryAlternative() : DesignLibrary())

    }

    @ViewBuilder private func makeTreeFlowView(designLibrary: DesignLibraryProvider)
        -> some View {
        NavigationStack(path: $treeflow.path) {
            TreeFlowView(designLibrary: designLibrary).makeTreeView(
                flow: treeflow,
                treeLoader: TreeNodeFactory.treeLoader(baseURL: baseURL)
            )
            .navigationBarItems(leading:
                Toggle(isOn: $isToggled) {
                    Text("Change Theme")
                }.foregroundColor(designLibrary.color.text.standard)
                    .toggleStyle(SwitchToggleStyle(tint: designLibrary.color.background.buttonPrimary))
            )
            .navigationDestination(for: TreeRoute.self) { route in
                switch route {
                case .leaf(let id):
                    let _ = print(id)
                }
            }
        }
    }

    
}

#Preview {
    RootView()
}
