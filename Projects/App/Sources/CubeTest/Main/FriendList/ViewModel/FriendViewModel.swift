//
//  FriendViewModel.swift
//  CubeTest
//
//  Created by 季紅 on 2024/10/25.
//
import Combine
import UIKit

class FriendViewModel {
    @Published private(set) var userInfoResponse: [UserInfoResponse] = []
    @Published var friendListResponse: [FriendListResponse] = []
    @Published private(set) var invitedFriendsResponse: [FriendListResponse] = []
    @Published private(set) var searchResults: [FriendListResponse] = []

    private(set) var errorMessage = PassthroughSubject<APIError, Never>()

    private var cancellables = Set<AnyCancellable>()
    
    private var dataLoader: APIManager
    let rootType: RootType

    init(dataLoader: APIManager, rootType: RootType) {
        self.dataLoader = dataLoader
        self.rootType = rootType
    }
}

extension FriendViewModel {
    func getUserInfo() {
        let targetType = UserAPI.UserInfo()
        dataLoader.request(targetType, useSampleData: false) { result in
            switch result {
            case let .success(response):
                self.userInfoResponse = response ?? []
            case let .failure(failure):
                self.errorMessage.send(failure)
            }
        }
    }
    
    func fetchFriendListBasedOnRootType() {
        switch rootType {
        case .noFriend:
            getFriendList4()
        case .onlyFriendList:
            fetchCombinedFriendList()
        case .friendListAndInvitation:
           getFriendList3()
        }
    }

    func fetchCombinedFriendList() {
        let firstList = Future<[FriendListResponse]?, APIError> { promise in
            self.dataLoader.request(UserAPI.FriendList(), useSampleData: false) { result in
                switch result {
                case let .success(response):
                    promise(.success(response))
                case let .failure(error):
                    promise(.failure(error))
                }
            }
        }

        let secondList = Future<[FriendListResponse]?, APIError> { promise in
            self.dataLoader.request(UserAPI.FriendList2(), useSampleData: false) { result in
                switch result {
                case let .success(response):
                    promise(.success(response))
                case let .failure(error):
                    promise(.failure(error))
                }
            }
        }

        Publishers.CombineLatest(firstList, secondList)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    self?.errorMessage.send(error)
                }
            } receiveValue: { [weak self] firstResponse, secondResponse in
                self?.processCombinedFriendList(firstList: firstResponse, secondList: secondResponse)
            }
            .store(in: &cancellables)
    }

    func processCombinedFriendList(firstList: [FriendListResponse]?, secondList: [FriendListResponse]?) {
        let combinedList = (firstList ?? []) + (secondList ?? [])
        let groupedDict = Dictionary(grouping: combinedList) { $0.fid }
            .mapValues { friends in
                friends.sorted { $0.formattedDate ?? Date() > $1.formattedDate ?? Date() }.first!
            }

        let sortedList = Array(groupedDict.values).sorted {
            $0.isTop == $1.isTop ? $0.updateDate > $1.updateDate : $0.isTop
        }

        friendListResponse = sortedList
    }

    func getFriendList3() {
        let targetType = UserAPI.FriendList3()
        dataLoader.request(targetType, useSampleData: false) { result in
            switch result {
            case let .success(response):
                self.invitedFriendsResponse = response?.filter { $0.status == .invitationSent } ?? []
                self.friendListResponse = response?.filter { $0.status != .invitationSent } ?? []
            case let .failure(failure):
                self.errorMessage.send(failure)
            }
        }
    }

    func getFriendList4() {
        let targetType = UserAPI.FriendList4()
        dataLoader.request(targetType, useSampleData: false) { result in
            switch result {
            case let .success(response):
                self.friendListResponse = response ?? []
            case let .failure(failure):
                self.errorMessage.send(failure)
            }
        }
    }

    func performSearch(text: String) {
        let searchText = text.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        DispatchQueue.global(qos: .userInitiated).async {
            let results = searchText.isEmpty ? self.friendListResponse : self.friendListResponse.filter {
                $0.name.lowercased().contains(searchText)
            }
            DispatchQueue.main.async {
                self.searchResults = results
            }
        }
    }
}
