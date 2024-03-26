//
//  IMGLYUITests.swift
//  IMGLYUITests
//
//  Created by macbook abdul on 26/03/2024.
//

import XCTest

final class IMGLYUITests: XCTestCase {


    private var app: XCUIApplication!

    fileprivate func launch(command:String = "") {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = [command]
        app.launch()
    }
    
//    override func setUpWithError() throws {
//        launch()
//       }


    func testNavigatingFromTreeToLeaf() {
                launch()
        TreeViewScreen(app: app)
            .tapOnCell(with: "imgly.A.1", text: "Entry 1")
            .verifyMessage(" fuh@wimumamok.lr")
        
        }
    

 
}
