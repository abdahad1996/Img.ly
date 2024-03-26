//
//  TreeViewModelTests.swift
//  IMGLYTests
//
//  Created by macbook abdul on 26/03/2024.
//

import Foundation
import IMGLY
import XCTest
import Combine
import Core

final class LeafViewModelTests: XCTestCase {
    
    func test_init_getsStateidle(){
        let (sut, _) = makeSUT()
        
        XCTAssertEqual(sut.state, .idle)
    }
    
    func test_load_CompletesWithSuccess() async {
        let (sut,loader) = makeSUT()
        let leafNode = StubbedReponses.buildLeafNode()
        
        let treeViewModelState = PublisherSpy(sut.$state.eraseToAnyPublisher())
        loader.result = .success(leafNode)
        
        await sut.load()
        
        XCTAssertEqual(treeViewModelState.results, [.idle,.isLoading ,.success(leafNode)])
        
    }
    
    func test_load_CompletesWithError() async {
        let (sut,loader) = makeSUT()
        let treeNodes = StubbedReponses.buildTreeNodeHierarchy()
        
        let treeViewModelState = PublisherSpy(sut.$state.eraseToAnyPublisher())
        loader.result = .failure(anyError)
        
        await sut.load()
        
        XCTAssertEqual(treeViewModelState.results, [.idle,.isLoading , .failure(.serverError)])
        
    }
    
   
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line,id:String = "") -> (
        sut: LeafViewModel,
        loader:LeafNodeLoaderSpy
    ) {
        let loader = LeafNodeLoaderSpy()
        let sut = LeafViewModel(loader:loader, id: id)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        return (sut, loader)
    }
    
    class LeafNodeLoaderSpy:LeafNodeLoader{
        var result: Result<LeafNode, Error>?
        private(set) var capturedValues = [String]()

        func load(id:String) async throws -> LeafNode {
            capturedValues.append(id)
            
            if let result = result {
                return try result.get()
            }
            
            throw anyError
        }
        
        
        
    }
    
    
    
}

 

