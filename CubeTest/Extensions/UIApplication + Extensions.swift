//
//  UIApplication + Extensions.swift
//  CubeTest
//
//  Created by 季紅 on 2024/10/26.
//
import UIKit

extension UIApplication {
    var keyWindow: UIWindow? {
        return self.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap { $0 as? UIWindowScene }?.windows
            .first(where: \.isKeyWindow)
    }
}
