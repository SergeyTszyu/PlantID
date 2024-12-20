//
//  SettingsViewModel.swift

import UIKit
import MessageUI
import StoreKit
import SafariServices
import AlertKit

private let SUPPORT_EMAIL = "cakirsinan78@outlook.com"

class SettingsViewModel: NSObject, MFMailComposeViewControllerDelegate {
    weak var viewController: UIViewController?
    
    func sendEmailToSupport() {
        if MFMailComposeViewController.canSendMail() {
            guard let viewController = viewController else { return }
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([SUPPORT_EMAIL])
            mail.setSubject("Support message")
            viewController.present(mail, animated: true)
        } else {
            AlertKitAPI.present(
                title: "Can’t send email right now",
                icon: .error,
                style: .iOS17AppleMusic,
                haptic: .error
            )
        }
    }

    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        controller.dismiss(animated: true, completion: nil)
    }

    func shareApp() {
        guard let viewController = viewController else { return }

        let appStoreLink = "https://apps.apple.com/app/id"

        let activityViewController = UIActivityViewController(
            activityItems: [appStoreLink],
            applicationActivities: nil
        )

        activityViewController
            .popoverPresentationController?
            .sourceView = viewController.view

        viewController.present(
            activityViewController,
            animated: true,
            completion: nil
        )
    }
    
    func rateApp() {
        
    }

    func suggestIdeaAction() {
        if MFMailComposeViewController.canSendMail() {
            guard let viewController = viewController else { return }
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([SUPPORT_EMAIL])
            mail.setSubject("Idea Suggestion")
            mail.setMessageBody("Hi! I have an idea …", isHTML: true)
            viewController.present(mail, animated: true)
        } else {
            AlertKitAPI.present(
                title: "Can’t send email now",
                icon: .error,
                style: .iOS17AppleMusic,
                haptic: .error
            )
        }
    }

    func openExternalLink(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(
                url,
                options: [:],
                completionHandler: nil
            )
        }
    }
}
