//
//  NetworkModelTests.swift
//  DragonBallHeroesPracticaTests
//
//  Created by Sergio Reina Montes on 31/01/2024.
//

import XCTest
@testable import DragonBallHeroesPractica

final class NetworkModelTests: XCTestCase {
    private var sut: NetworkManager!
    
    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        sut = NetworkManager(session: session)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testLogin() {
        let expectedToken = "Some Token"
        let someUser = "SomeUser"
        let somePassword = "SomePassword"
        
        MockURLProtocol.requestHandler = { request in
            let loginString = String(format: "%@:%@", someUser, somePassword)
            let loginData = loginString.data(using: .utf8)!
            let base64LoginString = loginData.base64EncodedString()
            
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Basic \(base64LoginString)")
            
            let data = try XCTUnwrap(expectedToken.data(using: .utf8))
            let response = try XCTUnwrap(
                HTTPURLResponse(
                    url: URL(string: "https://dragonball.keepcoding.education")!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: ["Content-Type": "application/json"])
            )
            return (response, data)
        }
        
        let expectation = expectation(description: "Login success")
        
        sut.login(
            user: someUser,
            password: somePassword
        ) { token, error in
            if let error = error {
                XCTFail("Expected success but received \(error)")
                return
            }
            guard let token = token else {
                XCTFail("Expected a token but received nil")
                return
            }
            
            XCTAssertEqual(token, expectedToken)
            expectation.fulfill()
        }
        
        wait(for: [expectation])
    }
    
    func testHeroesList() {
        let expectedHeroesCount = 10
        let token = "SomeValidToken"
        
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer \(token)")
            
            let heroes = (1...expectedHeroesCount).map { _ in Heroe(name: "Goku", id: "1", description: "El goku del carnaval", favorite: true, photo: "https://www.mundodeportivo.com/alfabeta/hero/2022/05/goku-dragon-ball.1651847419.5233.jpg?width=1200") }
            let data = try XCTUnwrap(JSONEncoder().encode(heroes))
            let response = try XCTUnwrap(
                HTTPURLResponse(
                    url: URL(string: "https://dragonball.keepcoding.education/api/heros/all")!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: ["Content-Type": "application/json"])
            )
            return (response, data)
        }
        
        let expectation = self.expectation(description: "Heroes list fetched")
        
        sut.heroesList(token: token) { heroes, error in
            if let error = error {
                XCTFail("Expected success but received error: \(error)")
                return
            }
            
            guard let heroes = heroes else {
                XCTFail("Expected heroes but received nil")
                return
            }
            
            XCTAssertEqual(heroes.count, expectedHeroesCount)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testTransformationHeroesList() {
        let expectedTransformationsCount = 5
        let token = "SomeValidToken"
        let parentHeroId = "ParentHeroId"

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer \(token ?? "")")
            
            
            let requestBody = String(data: request.httpBody ?? Data(), encoding: .utf8)
            XCTAssertTrue(requestBody?.contains("id=\(parentHeroId)") ?? false)
            
            let transformations = (1...expectedTransformationsCount).map { _ -> TranformationHero in
                
                TranformationHero(name: "Hero Name", id: "Hero ID", description: "Hero Description", photo: "Hero Photo")
            }
            let data = try XCTUnwrap(JSONEncoder().encode(transformations))
            let response = try XCTUnwrap(
                HTTPURLResponse(
                    url: URL(string: "https://dragonball.keepcoding.education/api/heros/tranformations")!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: ["Content-Type": "application/json"])
            )
            return (response, data)
        }
        
        let expectation = self.expectation(description: "Transformation heroes list fetched")
        
        sut.transformationHeroesList(token: token, parentHeroId: parentHeroId) { heroes, error in
            if let error = error {
                XCTFail("Expected success but received error: \(error)")
                return
            }
            
            guard let heroes = heroes else {
                XCTFail("Expected heroes but received nil")
                return
            }
            
            XCTAssertEqual(heroes.count, expectedTransformationsCount)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}

//OHHTTPStubs
final class MockURLProtocol: URLProtocol {
    static var error: NetworkManager.NetworkError?
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let error = MockURLProtocol.error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        
        guard let handler = MockURLProtocol.requestHandler else {
            assertionFailure("Receive unexpected request with no handler")
            return
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        }catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {  }
}
