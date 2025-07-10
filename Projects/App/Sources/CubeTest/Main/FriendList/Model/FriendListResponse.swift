//
//  FriendListResponse.swift
//  CubeTest
//
//  Created by 季紅 on 2024/10/25.
//

import Foundation

struct FriendListResponse: Codable, Equatable {
    let name: String
    let status: Status
    let fid, updateDate: String
    
    private let isTopString: String
    
    var isTop: Bool {
        return isTopString == "1"
    }
    
    var formattedDate: Date? {
        if let date = updateDate.toDate(format: "yyyyMMdd") {
            return date
        }
        if let date = updateDate.toDate(format: "yyyy/MM/dd") {
            return date
        }
        return nil
    }
    
    enum CodingKeys: String, CodingKey {
        case name, status, isTopString = "isTop", fid, updateDate
    }
    
    enum Status: Int, Codable {
        /// 邀請送出
        case invitationSent = 0
        /// 已完成
        case completed
        /// 邀請中
        case inviting
    }
    
       init(name: String, status: Status, isTop: Bool, fid: String, updateDate: String) {
           self.name = name
           self.status = status
           self.fid = fid
           self.updateDate = updateDate
           self.isTopString = isTop ? "1" : "0"
       }
}
