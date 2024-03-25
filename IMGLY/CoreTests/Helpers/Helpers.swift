//
//  Helpers.swift
//  CoreTests
//
//  Created by macbook abdul on 25/03/2024.
//

import Foundation
import Core



 func anyValidResponse() -> (Data, HTTPURLResponse) {
    (Data(), HTTPURLResponse())
}

 func anyURL() -> URL {
    return URL(string: "https://a-url.com")!
}
