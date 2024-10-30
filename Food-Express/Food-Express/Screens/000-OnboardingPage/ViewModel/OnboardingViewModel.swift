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
        OnboardingModel(
            title: "Easy Ordering",
            description: "Order your favorite meals in just a few taps. Quick and convenient! Choose from a variety of options.",
            image: "onboarding_image_1"
        ),
        OnboardingModel(
            title: "Exclusive Deals",
            description: "Enjoy special discounts on your favorite dishes. Save more with us! Discover new offers every day.",
            image: "onboarding_image_2"
        ),
        OnboardingModel(
            title: "Quick Delivery",
            description: "Ensure your meals arrive fresh at your door. Don't stay hungry! Our delivery team is always on time.",
            image: "onboarding_image_3"
        )
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
