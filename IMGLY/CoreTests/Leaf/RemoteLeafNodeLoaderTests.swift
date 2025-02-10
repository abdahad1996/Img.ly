//
//  Api.swift
//  CoreTests
//
//  Created by macbook abdul on 25/03/2024.
//

import Core
import Foundation
import XCTest

class RemoteLeafNodeLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requests.isEmpty)
    }

    func test_load_checksUrlConstruction() async {
        let url = URL(string: "https://ubique.img.ly/frontend-tha")!
        let (sut, client) = makeSUT(url: url)

        _ = try? await sut.load(id: "imgly.B.1")

        XCTAssertEqual(
            client.requestedURLs[0].absoluteString,
            "https://ubique.img.ly/frontend-tha/entries/imgly.B.1.json")
    }

    func test_loadTwice_requestsDataFromURLTwice() async {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        _ = try? await sut.load(id: "")
        _ = try? await sut.load(id: "")

        XCTAssertEqual(client.requestedURLs.count, 2)
    }
    //
    func test_load_deliversConnectivityErrorOnClientError() async throws {
        let (sut, _) = makeSUT(error: .connectivity)
        do {
            let result = try await sut.load(id: "")
            XCTFail(
                "Expected result \(RemoteLeafNodeLoader.Error.connectivity) got \(result) instead"
            )
        } catch let error as RemoteLeafNodeLoader.Error {
            XCTAssertEqual(error, .connectivity)
        }
    }
    //
    func test_load_deliversInvalidDataErrorOnNon200HTTPResponse() async throws {
        let samples = [199, 201, 300, 400, 500]

        for code in samples {
            let json = emptyJsonData
            let httpURLResponse = HTTPURLResponse(
                url: anyURL(), statusCode: code, httpVersion: nil,
                headerFields: nil)!

            let (sut, _) = makeSUT(result: (json, httpURLResponse))

            do {
                let result = try await sut.load(id: "")
                XCTFail(
                    "Expected result \(RemoteLeafNodeLoader.Error.invalidData) got \(result) instead"
                )
            } catch let error as RemoteLeafNodeLoader.Error {
                XCTAssertEqual(error, .invalidData)
            }
        }
    }

    func test_load_deliversInvalidDataErrorOn200HTTPResponse() async throws {

        let emptyListJSON = emptyJsonData
        let httpURLResponse = HTTPURLResponse(
            url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!

        let (sut, _) = makeSUT(result: (emptyListJSON, httpURLResponse))

        do {
            let result = try await sut.load(id: "")
            XCTFail(
                "Expected result \(RemoteLeafNodeLoader.Error.invalidData) got \(result) instead"
            )
        } catch let error as RemoteLeafNodeLoader.Error {
            XCTAssertEqual(error, .invalidData)
        }
    }

    func test_load_deliversSuccessWithLeafNodeOn200HTTPResponseWithJSONItems()
        async throws
    {

        let json = jsonData
        let httpURLResponse = HTTPURLResponse(
            url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!

        let (sut, _) = makeSUT(result: (json, httpURLResponse))

        do {
            let result = try await sut.load(id: "")
            XCTAssertEqual(result.id, "25359599-ba54-5132-8309-97c8513e08e9")
            XCTAssertEqual(result.createdAt, "2082-09-12T06:43:47.099Z")
            XCTAssertEqual(result.createdBy, "du@ijdu.cm")
            XCTAssertEqual(result.lastModifiedAt, "2023-08-31T07:07:40.646Z")
            XCTAssertEqual(result.lastModifiedBy, "pit@gon.bw")
            XCTAssertEqual(
                result.description,
                "Duw orevoza jiprudis faz alnaimu sazafapa cuwpe zifehe kowo wasmag otu tuwulfoj bifo se botirgo. Kiojka roftan otecu ohukdu zuaruuze ow ko jogapob naw jadkawwa nem vo fasoz tofih vu oz hizjorguc maj. Kedfov kikodu lan afavo ehonaki be nem du sudomaew mohe vohicemu vultuob muhbacni suzfef ihidozep azitude tilre hubju. Ovdunir ozu melnutvu ti fudolwe ohtet bicun tirat honwajak ujnu ak pelbod cuw coez cu aha. Icuru faabupuf la tu vegelu cinak wuoh hulico nen ri mub cedal sir hakeje guaja supbad togju jolug. Res ipemte bovzahle ih tus hi mopeczaj fahahal ejaha cibvi kene ti gele romi ufpiki lihkefju jol. Perum vudfen micbibo tueku seab nobjeolu keden elgeiv he efoas woz kusfop lirfidu."
            )

        } catch let error as RemoteTreeNodeLoader.Error {
            XCTFail("Expected result got \(error) instead")
        }
    }

    // MARK: - Helpers

    private func makeSUT(
        url: URL = URL(string: "https://a-url.com")!,
        result: (Data, HTTPURLResponse)? = nil,
        error: RemoteLeafNodeLoader.Error? = nil,
        file: StaticString = #filePath, line: UInt = #line
    ) -> (sut: RemoteLeafNodeLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy(result: result, error: error)
        let sut = RemoteLeafNodeLoader(url: url, client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }

    class HTTPClientSpy: HTTPClient {
        private(set) var requests = [URL]()
        private let result: (Data, HTTPURLResponse)?
        private let error: RemoteLeafNodeLoader.Error?

        var requestedURLs: [URL] {
            return requests
        }

        init(
            result: (Data, HTTPURLResponse)?, error: RemoteLeafNodeLoader.Error?
        ) {
            self.result = result
            self.error = error
        }

        func get(from url: URL) async throws -> (Data, HTTPURLResponse) {
            self.requests.append(url)
            guard let result = result else {
                throw error ?? .connectivity
            }

            return result
        }
    }

    // MARK: - JSON HELPERS
    let emptyJsonData = """
        """.data(using: .utf8)!

    let jsonData = """
        {
                "id": "25359599-ba54-5132-8309-97c8513e08e9",
                "createdAt": "2082-09-12T06:43:47.099Z",
                "createdBy": "du@ijdu.cm",
                "lastModifiedAt": "2023-08-31T07:07:40.646Z",
                "lastModifiedBy": "pit@gon.bw",
                "description": "Duw orevoza jiprudis faz alnaimu sazafapa cuwpe zifehe kowo wasmag otu tuwulfoj bifo se botirgo. Kiojka roftan otecu ohukdu zuaruuze ow ko jogapob naw jadkawwa nem vo fasoz tofih vu oz hizjorguc maj. Kedfov kikodu lan afavo ehonaki be nem du sudomaew mohe vohicemu vultuob muhbacni suzfef ihidozep azitude tilre hubju. Ovdunir ozu melnutvu ti fudolwe ohtet bicun tirat honwajak ujnu ak pelbod cuw coez cu aha. Icuru faabupuf la tu vegelu cinak wuoh hulico nen ri mub cedal sir hakeje guaja supbad togju jolug. Res ipemte bovzahle ih tus hi mopeczaj fahahal ejaha cibvi kene ti gele romi ufpiki lihkefju jol. Perum vudfen micbibo tueku seab nobjeolu keden elgeiv he efoas woz kusfop lirfidu."
            }
        """.data(using: .utf8)!

}
