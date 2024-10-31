//
//  UIViewController + Extensions.swift
//  CubeTest
//
//  Created by 季紅 on 2024/10/27.
//
import UIKit

extension UIViewController {
    func setupNavigationBar(title: String?, textColor: UIColor = UIColor(hex: "#1B212B"), backgroundColor: UIColor = .whiteTwo) {
        navigationItem.title = title
        navigationController?.navigationBar.prefersLargeTitles = false
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.font(.pingFangBold, fontSize: 14),
                                                         .foregroundColor: textColor]
        
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = backgroundColor
        barAppearance.titleTextAttributes = attributes
        barAppearance.shadowColor = nil
        navigationController?.navigationBar.standardAppearance = barAppearance
        navigationController?.navigationBar.compactAppearance = barAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = barAppearance
    }
}
