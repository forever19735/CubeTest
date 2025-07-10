//
//  UIView + Extensions.swift
//  CubeTest
//
//  Created by 季紅 on 2024/10/25.
//

import UIKit
import SnapKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        for view in views {
            addSubview(view)
        }
    }
    
    var safeArea: ConstraintBasicAttributesDSL {
            return self.safeAreaLayoutGuide.snp
      
    }
}
