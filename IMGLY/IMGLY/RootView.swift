//
//  RootView.swift
//  IMGLY
//
//  Created by macbook abdul on 26/03/2024.
//

import Core
import Foundation
import SwiftUI

public struct RootView: View {
  private let baseURL = URL(string: "https://ubique.img.ly/frontend-tha")!

  @StateObject var treeflow = Flow<TreeRoute>()
  @State private var isToggled = false
  @State private var isActive = false

  public init() {

  }
  public var body: some View {
    if isActive {
      makeTreeFlowView(
        designLibrary: isToggled ? DesignLibraryAlternative() : DesignLibrary(),
        loader: TreeNodeFactory.treeLoader(baseURL: baseURL))
    } else {
      SplashScreen(isActive: $isActive)
    }

  }

  @ViewBuilder public func makeTreeFlowView(
    designLibrary: DesignLibraryProvider,
    loader: TreeNodeLoader

  )
    -> some View
  {
    NavigationStack(path: $treeflow.path) {
      TreeFlowView(designLibrary: designLibrary).makeTreeView(
        flow: treeflow,
        treeLoader: loader
      )
      .navigationBarItems(
        leading:
          Toggle(isOn: $isToggled) {
            Text("Change Theme")
          }.foregroundColor(designLibrary.color.text.standard)
          .toggleStyle(SwitchToggleStyle(tint: designLibrary.color.background.buttonPrimary))
      )
      .navigationDestination(for: TreeRoute.self) { route in
        switch route {
        case .leaf(let id):
          makeLeafView(id: id, designLibrary: designLibrary)
        }
      }
    }
  }

  @ViewBuilder public func makeLeafView(id: String, designLibrary: DesignLibraryProvider)
    -> some View
  {
    //remote loader
    let remoteLeafNodeLoader = LeafFactory.remoteLeafNodeLoader(baseURL: baseURL, id: id)

    //local loader and local cache
    let localLeafNodeLoader = LeafFactory.localLeafNodeLoader()

    let leafNodeLoaderCacheDecorator = LeafNodeLoaderCacheDecorator(
      remoteLeafNodeLoader: remoteLeafNodeLoader, leafNodeCache: localLeafNodeLoader)

    let leafNodeLoaderWithFallbackComposite = LeafNodeLoaderWithFallbackComposite(
      primaryLoader: leafNodeLoaderCacheDecorator, secondaryLoader: localLeafNodeLoader)

    let loader: LeafNodeLoader = leafNodeLoaderWithFallbackComposite

    LeafView(
      leafViewModel:
        LeafViewModel(loader: loader, id: id),
      designLibrary: designLibrary)
  }

}

#Preview {
  RootView()
}
