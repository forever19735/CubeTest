//
//  String + Extensions.swift
//  CubeTest
//
//  Created by 季紅 on 2024/10/25.
//

import Foundation
import UIKit

extension String {
    func toDate(format: String) -> Date? {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = format
        return dateformatter.date(from: self)
    }
    
    func attributed(fontType: UIFont.FontType,
                    size: CGFloat,
                    color: UIColor,
                    lineSpacing: CGFloat = 0,
                    alignment: NSTextAlignment = .left) -> NSMutableAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        let _font = UIFont.font(fontType, fontSize: size)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment

        attributeString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributeString.length))
        attributeString.addAttribute(NSAttributedString.Key.font, value: _font, range: NSMakeRange(0, attributeString.length))
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSMakeRange(0, attributeString.length))

        return attributeString
    }
}
