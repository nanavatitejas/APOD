//
//  APODViewModelTests.swift
//  APODTests
//
//  Created by Tejas Nanavati on 18/01/23.
//

import XCTest

import CoreData
@testable import APOD


class APODViewModelTests: XCTestCase {
    var viewModel: APODViewModel!
    
    override func setUp() {
        viewModel = APODViewModel()
    }
    
    
    
    func testFetchAPODWithDate() {
        let expect = expectation(description: "APOD with date")
        let date = Calendar.current.date(byAdding: .day, value: -7, to: Date())
       

        viewModel.fetchAPOD(on: date ?? Date()) { (result) in
            switch result {
            case .success(let apod):
                XCTAssertNotNil(apod)
                XCTAssertEqual(apod.date, Helper.shared.dateFormatter.string(from: date ?? Date()))
                expect.fulfill()
            case .failure(let error):
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    
    func testSaveAsFavorite() {
        let apod = APOD(copyright: "", date: "2021-01-01", explanation: "Test Explanation", hdurl: URL(string: ""), mediaType: "", serviceVersion: "", title: "", url: URL(fileURLWithPath: ""))
        viewModel.apod = apod
        
        viewModel.saveAsFavorite()
//        viewModel.saveAsFavorite { (success) in
//            XCTAssertTrue(success)
//            saveExpectation.fulfill()
//        }
//        waitForExpectations(timeout: 5, handler: nil)
        
        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", apod.date)
        let result = try! CoreDataStack.shared.context.fetch(fetchRequest)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.date, apod.date)
        XCTAssertEqual(result.first?.title, apod.title)
        XCTAssertEqual(result.first?.explanation, apod.explanation)
        XCTAssertEqual(result.first?.url, apod.url.absoluteString)
    }

    
}
   


//class APODViewModelTests: XCTestCase {
//
//    var viewModel: APODViewModel!
//    var mockAPIClient: MockAPIClient!
//    var mockCache: MockCache!
//    var mockDelegate: MockDelegate!
//
//    override func setUp() {
//        mockAPIClient = MockAPIClient()
//        mockCache = MockCache()
//        mockDelegate = MockDelegate()
//        viewModel = APODViewModel
//    }
//
//    func testFetchAPOD() {
//        XCTAssert(mockAPIClient.fetchAPODCalled)
//        XCTAssert(mockDelegate.didStartFetchingCalled)
//    }
//
//    func testFetchAPODWithError() {
//        let error = NSError(domain: "test", code: 0, userInfo: nil)
//        mockAPIClient.error = error
//        XCTAssert(mockDelegate.didFailWithErrorCalled)
//    }
//
//    func testFetchAPODWithSuccess() {
//        let apod = APOD(title: "test", explanation: "test", url: "test", date: "test")
//        mockAPIClient.apod = apod
//        XCTAssert(mockDelegate.didFinishFetchingCalled)
//        XCTAssertEqual(viewModel.title, apod.title)
//        XCTAssertEqual(viewModel.explanation, apod.explanation)
//        XCTAssertEqual(viewModel.url, apod.url)
//        XCTAssertEqual(viewModel.date, apod.date)
//    }
//
//    func testSaveAsFavorite(){
//        let apod = APOD(title: "test", explanation: "test", url: "test", date: "test")
//        viewModel.saveAsFavorite(apod)
//        XCTAssert(mockCache.saveCalled)
//    }
//    func testRemoveFromFavorite(){
//        let apod = APOD(title: "test", explanation: "test", url: "test", date: "test")
//        viewModel.removeFromFavorite(apod)
//        XCTAssert(mockCache.removeCalled)
//    }
//}


class MockAPIClient {
    var fetchAPODCalled = false
    var error: Error?
    var apod: APOD?
    func fetchAPOD(date: String?, completion: @escaping (Result<APOD, Error>) -> Void) {
        fetchAPODCalled = true
        if let error = error {
            completion(.failure(error))
        } else {
            completion(.success(apod!))
        }
    }
}

class MockCache {
    var saveCalled = false
    var removeCalled = false
    func save(_ apod: APOD) {
        saveCalled = true
    }
    func remove(_ apod: APOD) {
        removeCalled = true
    }
}

class MockDelegate{
    var didStartFetchingCalled = false
    var didFinishFetchingCalled = false
    var didFailWithErrorCalled = false
    var error: Error?
    func didStartFetching() {
        didStartFetchingCalled = true
    }
    func didFinishFetching() {
        didFinishFetchingCalled = true
    }
    func didFailWithError(_ error: Error) {
        didFailWithErrorCalled = true
        self.error = error
    }
}
