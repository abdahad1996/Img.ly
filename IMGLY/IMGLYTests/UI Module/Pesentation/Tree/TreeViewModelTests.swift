//
//  TreeViewModelTests.swift
//  IMGLYTests
//
//  Created by macbook abdul on 26/03/2024.
//

import Combine
import Core
import Foundation
import IMGLY
import XCTest

final class TreeViewModelTests: XCTestCase {

    func test_init_getsStateidle() {
        let (sut, _) = makeSUT()

        XCTAssertEqual(sut.state, .idle)
    }

    func test_load_CompletesWithSuccess() async {
        let (sut, loader) = makeSUT()
        let treeNodes = StubbedReponses.buildTreeNodeHierarchy()

        let treeViewModelState = PublisherSpy(sut.$state.eraseToAnyPublisher())
        loader.result = .success(treeNodes)

        await sut.load()

        XCTAssertEqual(
            treeViewModelState.results,
            [.idle, .isLoading, .success(treeNodes)])

    }

    func test_load_CompletesWithError() async {
        let (sut, loader) = makeSUT()
        let treeNodes = StubbedReponses.buildTreeNodeHierarchy()

        let treeViewModelState = PublisherSpy(sut.$state.eraseToAnyPublisher())
        loader.result = .failure(anyError)

        await sut.load()

        XCTAssertEqual(
            treeViewModelState.results,
            [.idle, .isLoading, .failure(.serverError)])

    }

    func test_deleteNode_removesNodeFromArray() async {
        let sut = TreeViewModel(loader: MockTreeNodeLoader())
        await sut.load()

        XCTAssertEqual(
            sut.state,
            .success([
                TreeNode(id: "1", label: "Node 1"),
                TreeNode(id: "2", label: "Node 2"),
                TreeNode(id: "3", label: "Node 3"),
            ]))

        sut.deleteNode(at: IndexSet(integer: 1))

        XCTAssertEqual(
            sut.state,
            .success([
                TreeNode(id: "1", label: "Node 1"),
                TreeNode(id: "3", label: "Node 3"),

            ]))

    }

    func test_MoveNode_movesNodeFromArray() async {
        let sut = TreeViewModel(loader: MockTreeNodeLoader())
        await sut.load()

        XCTAssertEqual(
            sut.state,
            .success([
                TreeNode(id: "1", label: "Node 1"),
                TreeNode(id: "2", label: "Node 2"),
                TreeNode(id: "3", label: "Node 3"),
            ]))

        sut.move(fromOffsets: IndexSet(integer: 0), toOffset: 2)

        XCTAssertEqual(
            sut.state,
            .success([
                TreeNode(id: "2", label: "Node 2"),
                TreeNode(id: "1", label: "Node 1"),
                TreeNode(id: "3", label: "Node 3"),

            ]))
    }

    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (
        sut: TreeViewModel,
        loader: TreeNodeLoaderSpy
    ) {
        let loader = TreeNodeLoaderSpy()
        let sut = TreeViewModel(loader: loader)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        return (sut, loader)
    }

    class TreeNodeLoaderSpy: TreeNodeLoader {
        var result: Result<[TreeNode], Error>?

        func load() async throws -> [TreeNode] {

            if let result = result {
                return try result.get()
            }

            return []

        }

    }

}

final class PublisherSpy<Success> where Success: Equatable {
    private var cancellable: Cancellable?
    private(set) var results = [Success]()

    init(_ publisher: AnyPublisher<Success, Never>) {
        cancellable = publisher.sink(receiveValue: { value in
            self.results.append(value)
        })
    }

    func cancel() {
        cancellable?.cancel()
    }
}
