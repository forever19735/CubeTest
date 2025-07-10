//
//  BaseResponse.swift
//  CubeTest
//
//  Created by 季紅 on 2024/10/25.
//

import Foundation

struct BaseResponse<T: Decodable>: Decodable {
    let response: T?
}
