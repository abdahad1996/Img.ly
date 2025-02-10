//
//  TreeViewScreen.swift
//  IMGLYUITests
//
//  Created by macbook abdul on 26/03/2024.
//

import Foundation
import XCTest

protocol Screen {
    var app: XCUIApplication { get }
}

struct TreeViewScreen: Screen {
    let app: XCUIApplication

    @discardableResult
    func tapOnCell(with id: String, text: String) -> Self {
        if verifyCellExists(with: id) {
            app.staticTexts[verticalCellID(with: id)].firstMatch.tap()
            sleep(5)
        }

        return self

    }

    @discardableResult
    func verifyMessage(_ message: String) -> Self {
        let message = app.staticTexts[message]
        XCTAssertTrue(message.waitForExistence(timeout: 5))
        return self
    }

    @discardableResult func tapOnFilter(text: String) -> Self {
        app.buttons[text].tap()
        return self
    }

    func verifyCellExists(with id: String) -> Bool {
        return app.staticTexts[verticalCellID(with: id)].waitForExistence(
            timeout: 10)
    }
    func verticalCellID(with id: String) -> String {
        return "UICellVertical\(id)"
    }
}
