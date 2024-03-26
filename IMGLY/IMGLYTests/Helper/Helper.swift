//
//  Helper.swift
//  IMGLYTests
//
//  Created by macbook abdul on 26/03/2024.
//

import Foundation

import XCTest
import SwiftUI
import SnapshotTesting

func assertLightAndDarkSnapshot<SomeView: View>(
    matching value: SomeView,
    as snapshotting: Snapshotting<UIViewController, UIImage> = .image,
    record recording: Bool = false,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
) {
    assertLightSnapshot(matching: value, as: snapshotting, record: recording, file: file, testName: testName, line: line)
    assertDarkSnapshot(matching: value, as: snapshotting, record: recording, file: file, testName: testName, line: line)
}

func assertLightSnapshot<SomeView: View>(
    matching value: SomeView,
    as snapshotting: Snapshotting<UIViewController, UIImage>,
    record recording: Bool = false,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line) {
    let trait = UITraitCollection(userInterfaceStyle: .light)
    let view = UIHostingController(rootView: value)

    assertSnapshot(matching: view,
                   as: .image(on: .init(),traits: trait),
                   named: "light",
                   record: recording,
                   file: file,
                   testName: testName,
                   line: line)
}

func assertDarkSnapshot<SomeView: View>(
    matching value: SomeView,
    as snapshotting: Snapshotting<UIViewController, UIImage>,
    record recording: Bool = false,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line) {
    let trait = UITraitCollection(userInterfaceStyle: .dark)
    let view = UIHostingController(rootView: value)

    assertSnapshot(matching: view,
                   as: .image(on: .init(),traits: trait),
                   named: "dark",
                   record: recording,
                   file: file,
                   testName: testName,
                   line: line)
}
