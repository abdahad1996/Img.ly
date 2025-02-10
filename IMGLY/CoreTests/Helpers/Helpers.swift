//
//  Helpers.swift
//  CoreTests
//
//  Created by macbook abdul on 25/03/2024.
//

import Core
import Foundation

func anyValidResponse() -> (Data, HTTPURLResponse) {
    (Data(), HTTPURLResponse())
}

func anyURL() -> URL {
    return URL(string: "https://a-url.com")!
}

var anyError: NSError {
    NSError(domain: "any error", code: 1)
}
