//
//  FoodCellColors.swift
//  Food-Express
//
//  Created by erkut on 10.10.2024.
//

import Foundation
import UIKit

struct FoodCellColors {
    let color: UIColor

    static let backgroundColors: [FoodCellColors] = [
        FoodCellColors(color: UIColor(hex: "E77CE3")),
        FoodCellColors(color: UIColor(hex: "7CA7E7")),
        FoodCellColors(color: UIColor(hex: "B6E77C")),
        FoodCellColors(color: UIColor(hex: "E7C97C")),
        FoodCellColors(color: UIColor(hex: "E77C89")),
        FoodCellColors(color: UIColor(hex: "7CE0E7"))
    ]

    static let tintColors: [FoodCellColors] = [
        FoodCellColors(color: UIColor(hex: "963298")),
        FoodCellColors(color: UIColor(hex: "325598")),
        FoodCellColors(color: UIColor(hex: "539832")),
        FoodCellColors(color: UIColor(hex: "985732")),
        FoodCellColors(color: UIColor(hex: "98325D")),
        FoodCellColors(color: UIColor(hex: "237168"))
    ]

    static let shadowColors: [FoodCellColors] = [
        FoodCellColors(color: UIColor(hex: "6E2371")),
        FoodCellColors(color: UIColor(hex: "254177")),
        FoodCellColors(color: UIColor(hex: "407527")),
        FoodCellColors(color: UIColor(hex: "693C22")),
        FoodCellColors(color: UIColor(hex: "67223F")),
        FoodCellColors(color: UIColor(hex: "19524B"))
    ]
}
