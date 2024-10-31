//
//  UserAPITargetType.swift
//  CubeTest
//
//  Created by 季紅 on 2024/10/25.
//
import Foundation
import Moya

protocol UserAPITargetType: DecodableResponseTargetType {}

extension UserAPITargetType {
    var baseURL: URL { URL(string: "https://dimanyen.github.io")! }

    var method: Moya.Method { .get }

    var headers: [String: String]? {
        return nil
    }

    var sampleData: Data { return "".data(using: String.Encoding.utf8)! }
}

enum UserAPI {

    struct UserInfo: UserAPITargetType {
        typealias Response = [UserInfoResponse]

        var path: String { "/man.json" }

        var task: Task { .requestPlain }
    }
    
    struct FriendList: UserAPITargetType {
        typealias Response = [FriendListResponse]
        
        var path: String { "/friend1.json" }
        
        var task: Task { .requestPlain }
    }
    
    struct FriendList2: UserAPITargetType {
        typealias Response = [FriendListResponse]
        
        var path: String { "/friend2.json" }
        
        var task: Task { .requestPlain }
    }
    
    struct FriendList3: UserAPITargetType {
        typealias Response = [FriendListResponse]
        
        var path: String { "/friend3.json" }
        
        var task: Task { .requestPlain }
    }

    struct FriendList4: UserAPITargetType {
        typealias Response = [FriendListResponse]
        
        var path: String { "/friend4.json" }
        
        var task: Task { .requestPlain }
    }
}
