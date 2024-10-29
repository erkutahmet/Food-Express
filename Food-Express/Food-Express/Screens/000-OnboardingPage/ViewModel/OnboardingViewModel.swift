//
//  OnboardingViewModel.swift
//  Food-Express
//
//  Created by erkut on 29.10.2024.
//

import Foundation

protocol OnboardingViewModelInterface {
    var view: OnbardingViewInterface? { get set }
    
    func viewDidLoad()
    func setUpCell(at indexPath: IndexPath) -> OnboardingModel
    func numberOfItems() -> Int
}

final class OnboardingViewModel {
    weak var view: OnbardingViewInterface?
    private var slides = [
        OnboardingModel(title: "Delicious Dishes", description: "Experience a variety of amazing dishes from different cultures around the world.", image: "pasta"),
        OnboardingModel(title: "World-Class Chefs", description: "Our dishes are prepared by only the best.", image: "pizza"),
        OnboardingModel(title: "Instant World-Wide Delivery", description: "Your orders will be delivered instantly irrespective of your location around the world.", image: "salad")
    ]
}

extension OnboardingViewModel: OnboardingViewModelInterface {
    func viewDidLoad() {
        view?.setDelegateUI()
        view?.setUI()
    }

    func numberOfItems() -> Int {
        return slides.count
    }

    func setUpCell(at indexPath: IndexPath) -> OnboardingModel {
        return slides[indexPath.item]
    }
}
