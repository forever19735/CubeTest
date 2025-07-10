//
//  FriendViewModelTests.swift
//  CubeTestTests
//
//  Created by 季紅 on 2024/10/27.
//

import Combine
@testable import CubeTest
import XCTest

final class FriendViewModelTests: XCTestCase {
    var viewModel: FriendViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        viewModel = FriendViewModel(dataLoader: APIManager.shared, rootType: .onlyFriendList)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }

    func testProcessCombinedFriendList() {
        // Arrange: Create mock data for the test
        let friend1 = FriendListResponse(name: "黃靖僑", status: .completed, isTop: false, fid: "001", updateDate: "20190801")
        let friend2 = FriendListResponse(name: "翁勳儀", status: .invitationSent, isTop: true, fid: "002", updateDate: "20190802")
        let friend3 = FriendListResponse(name: "黃靖僑", status: .completed, isTop: false, fid: "001", updateDate: "2019/08/02")

        // Act: Run the method under test
        viewModel.processCombinedFriendList(firstList: [friend1, friend2], secondList: [friend3])

        // Assert: Check if friendListResponse is sorted as expected
        XCTAssertEqual(viewModel.friendListResponse.count, 2)
        XCTAssertEqual(viewModel.friendListResponse[0].name, "翁勳儀")
        XCTAssertEqual(viewModel.friendListResponse[0].updateDate, "20190802")
        XCTAssertEqual(viewModel.friendListResponse[1].name, "黃靖僑")
        XCTAssertEqual(viewModel.friendListResponse[1].updateDate, "2019/08/02")
    }

    // Test performSearch method
    func testPerformSearch() {
        // Arrange: Set up friendListResponse for search testing
        viewModel.friendListResponse = [
            FriendListResponse(name: "黃靖僑", status: .completed, isTop: false, fid: "001", updateDate: "20190801"),
            FriendListResponse(name: "翁勳儀", status: .invitationSent, isTop: true, fid: "002", updateDate: "20190802"),
            FriendListResponse(name: "林宜真", status: .completed, isTop: false, fid: "012", updateDate: "2019/08/01"),
        ]

        // Act: Perform search
        let expectation = XCTestExpectation(description: "Search completes")
        viewModel.performSearch(text: "翁")

        viewModel.$searchResults
            .dropFirst()
            .sink { results in
                // Assert: Verify the search result
                XCTAssertEqual(results.count, 1)
                XCTAssertEqual(results[0].name, "翁勳儀")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
}
