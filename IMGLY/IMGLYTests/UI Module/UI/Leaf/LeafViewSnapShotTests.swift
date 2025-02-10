//
//  LeafViewSnapShotTests.swift
//  IMGLYTests
//
//  Created by macbook abdul on 26/03/2024.
//

import Core
import Foundation
import SnapshotTesting
import SwiftUI
import XCTest

@testable import IMGLY

final class LeafViewSnapshotTests: XCTestCase {

    func test_leafViewIdleState() {
        let sut = makeSUT(getLeafViewState: .idle)

        assertLightAndDarkSnapshot(matching: sut)
    }

    func test_leafViewIsLoadingState() {
        let sut = makeSUT(getLeafViewState: .isLoading)

        assertLightAndDarkSnapshot(matching: sut)
    }

    func test_leafViewFailureState() {
        let sut = makeSUT(getLeafViewState: .failure(.serverError))

        assertLightAndDarkSnapshot(matching: sut)
    }

    func test_leafViewSuccessState() {
        let sut = makeSUT(
            getLeafViewState: .success(StubbedReponses.buildLeafNode()))

        assertLightAndDarkSnapshot(matching: sut)
    }

    func test_leafViewSuccessState_DifferentTheme() {
        let sut = makeSUT(
            getLeafViewState: .success(StubbedReponses.buildLeafNode()),
            designLibrary: DesignLibraryAlternative())

        assertLightAndDarkSnapshot(matching: sut)
    }

    // MARK: - Helpers

    private func makeSUT(
        getLeafViewState: LeafViewModel.State,
        designLibrary: DesignLibraryProvider = DesignLibrary()
    ) -> some View {
        let leafViewModel = LeafViewModel(
            loader: EmptyStubLeafNodeLoader(), id: "")
        leafViewModel.state = getLeafViewState

        return LeafView(
            leafViewModel: leafViewModel, designLibrary: designLibrary)

    }

    private class EmptyStubLeafNodeLoader: LeafNodeLoader {
        func load(id: String) async throws -> LeafNode {
            return StubbedReponses.buildLeafNode()
        }

    }

}
