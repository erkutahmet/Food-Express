//
//  InfoDetailsPageViewController.swift
//  Food-Express
//
//  Created by erkut on 24.10.2024.
//

import UIKit

enum InfoDetailType {
    case privacyPolicy
    case termsOfService
    case aboutUs
}

protocol InfoDetailsPageInterface {
    func appear(sender: UIViewController, detailType: InfoDetailType)
}

final class InfoDetailsPageViewController: UIViewController {

    @IBOutlet private weak var infoContentLbl: UILabel!
    @IBOutlet private weak var infoContentTitleLbl: UILabel!
    @IBOutlet private weak var scrollView: UIScrollView!

    private var infoDetailType: InfoDetailType?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUIForDetailType()
    }

    private func updateUIForDetailType() {
        guard let type = infoDetailType else { return }

        scrollView.setContentOffset(.zero, animated: true)

        switch type {
        case .privacyPolicy:
            infoContentLbl.setHTML(from: AboutUsConstants.privacyPolicy)
            infoContentTitleLbl.text = "Privacy Policy"
        case .termsOfService:
            infoContentLbl.setHTML(from: AboutUsConstants.termsOfService)
            infoContentTitleLbl.text = "Terms Of Service"
        case .aboutUs:
            infoContentLbl.setHTML(from: AboutUsConstants.aboutUs)
            infoContentTitleLbl.text = "About Us"
        }
    }
}

extension InfoDetailsPageViewController: InfoDetailsPageInterface {
    func appear(sender: UIViewController, detailType: InfoDetailType) {
        self.infoDetailType = detailType
        DispatchQueue.main.async {
            sender.navigationController?.pushViewController(self, animated: true)
        }
    }
}
