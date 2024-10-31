//
//  NSMutableAttributedString+Extension.swift
//  CubeTest
//
//  Created by 季紅 on 2024/10/25.
//

import UIKit

extension NSMutableAttributedString {
    func setColorForText(_ textToFind: String, with color: UIColor) {
        let range = mutableString.range(of: textToFind, options: .caseInsensitive)
        if range.location != NSNotFound {
            addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
    }

    func setFontForText(_ textToFind: String, with font: UIFont) {
        let range = mutableString.range(of: textToFind, options: .caseInsensitive)
        if range.location != NSNotFound {
            addAttribute(NSAttributedString.Key.font, value: font, range: range)
        }
    }

    func setUnderLineForText(_ textToFind: String, with style: NSUnderlineStyle) {
        let range = mutableString.range(of: textToFind, options: .caseInsensitive)
        if range.location != NSNotFound {
            addAttribute(NSAttributedString.Key.underlineStyle, value: style.rawValue, range: range)
        }
    }
}
