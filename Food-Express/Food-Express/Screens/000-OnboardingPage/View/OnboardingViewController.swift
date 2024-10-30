//
//  OnboardingViewController.swift
//  Food-Express
//
//  Created by erkut on 29.10.2024.
//

import UIKit

protocol OnbardingViewInterface: AnyObject {
    func setDelegateUI()
    func setUI()
}

final class OnboardingViewController: UIViewController {
    
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var onboardingCollectionView: UICollectionView!
    @IBOutlet private weak var backBtn: UIButton!
    @IBOutlet private weak var nextBtn: UIButton!
    
    @IBOutlet private weak var whiteView: UIView!
    @IBOutlet private weak var yellowView: UIView!
    
    private lazy var viewModel = OnboardingViewModel()
    
    private var currentPage = 0 {
        didSet {
            if currentPage == viewModel.numberOfItems() - 1 {
                nextBtn.setTitle("Get Started ", for: .normal)
                backBtn.isHidden = false
            } else {
                nextBtn.setTitle("", for: .normal)
                if currentPage == 0 {
                    backBtn.isHidden = true
                } else {
                    backBtn.isHidden = false
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        for cell in onboardingCollectionView.visibleCells {
            if let onboardingCell = cell as? OnboardingCollectionViewCell {
                onboardingCell.removeAllAnimations()
            }
        }
    }

    @IBAction private func nextBtnClicked(_ sender: Any) {
        if currentPage == viewModel.numberOfItems() - 1 {
            let mainVC = TabBarViewController()
            self.setRootViewController(mainVC, animated: true)
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            onboardingCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            pageControl.currentPage = currentPage
        }
    }

    @IBAction private func backBtnClicked(_ sender: Any) {
        currentPage -= 1
        let indexPath = IndexPath(item: currentPage, section: 0)
        onboardingCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage = currentPage
    }
}

extension OnboardingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
        
        let item = viewModel.setUpCell(at: indexPath)
        
        cell.setUp(item)
        cell.blinkAnimation()
        
        return cell
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        pageControl.currentPage = currentPage
    }
}

extension OnboardingViewController: UICollectionViewDelegate { }

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

extension OnboardingViewController: OnbardingViewInterface {
    func setDelegateUI() {
        onboardingCollectionView.delegate = self
        onboardingCollectionView.dataSource = self
        onboardingCollectionView.register(OnboardingCollectionViewCell.register(), forCellWithReuseIdentifier: OnboardingCollectionViewCell.identifier)
    }

    func setUI() {
        backBtn.isHidden = true
        whiteView.layer.cornerRadius = whiteView.frame.width / 2
        yellowView.layer.cornerRadius = yellowView.frame.width / 2
    }
}
