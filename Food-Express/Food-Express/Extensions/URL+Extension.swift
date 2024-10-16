//
//  URL+Extension.swift
//  Food-Express
//
//  Created by erkut on 10.10.2024.
//

import Foundation

extension URL {
    static func makeImageUrl(from imageCode: String = "") -> URL? {
        return URL(string: NetworkConstant.shared.foodImageBaseUrl + imageCode)
    }
}
