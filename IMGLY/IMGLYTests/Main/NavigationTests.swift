//
//  NavigationTests.swift
//  IMGLYTests
//
//  Created by macbook abdul on 26/03/2024.
//

import Foundation
@testable import IMGLY
import XCTest
final class FlowTests: XCTestCase {

    func test_append_appendsValueToNavigationPath() {
        let sut = Flow<TreeRoute>()

        XCTAssertEqual(sut.path.count, 0)

        sut.append(.leaf("2"))
        XCTAssertEqual(sut.path.count, 1)
        XCTAssertEqual(sut.path, [.leaf("2")])
    }

    func test_navigateBack_removesLastValueFromNavigationPath() {
        let sut = Flow<TreeRoute>()

        sut.append(.leaf("2"))
        XCTAssertEqual(sut.path, [.leaf("2")])

        sut.append(.leaf("3"))
        XCTAssertEqual(sut.path, [.leaf("2"), .leaf("3")])

        sut.navigateBack()
        XCTAssertEqual(sut.path, [.leaf("2")])

        sut.navigateBack()
        XCTAssertTrue(sut.path.isEmpty)
    }
}
