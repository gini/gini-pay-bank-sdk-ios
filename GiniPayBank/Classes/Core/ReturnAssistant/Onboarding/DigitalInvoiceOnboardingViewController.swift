//
//  OnboardingDigitalInvoiceViewController.swift
//  GiniPayBank
//
//  Created by Nadya Karaban on 21.10.20.
//

import Foundation
import GiniCapture
    final class DigitalInvoiceOnboardingViewController: UIViewController {
    var returnAssistantConfiguration = ReturnAssistantConfiguration()

    @IBOutlet var topImageView: UIImageView!
    @IBOutlet var badgeImageView: UIImageView!
    @IBOutlet var firstLabel: UILabel!
    @IBOutlet var helpItemImageView: UIImageView!
    @IBOutlet var secondLabel: UILabel!
    @IBOutlet var doneButton: UIButton!

    fileprivate var topImage: UIImage {
        return prefferedImage(named: "digital_invoice_onboarding_icon") ?? UIImage()
    }

    fileprivate var badgeImage: UIImage {
        return prefferedImage(named: "digital_invoice_onboarding_new_badge") ?? UIImage()
    }

    fileprivate var helpItemImage: UIImage {
        return prefferedImage(named: "digital_invoice_onboarding_item_help") ?? UIImage()
    }

    fileprivate var firstLabelText: String {
        return
            NSLocalizedStringPreferredGiniPayFormat("ginipaybank.digitalinvoice.onboarding.text1", comment: "title for the first label on the digital invoice onboarding screen")
    }

    fileprivate var secondLabelText: String {
        return NSLocalizedStringPreferredGiniPayFormat("ginipaybank.digitalinvoice.onboarding.text2", comment: "title for the second label on the digital invoice onboarding screen")
    }

    fileprivate var doneButtonTitle: String {
        return NSLocalizedStringPreferredGiniPayFormat("ginipaybank.digitalinvoice.onboarding.donebutton", comment: "title for the done button on the digital invoice onboarding screen")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    fileprivate func configureUI() {
        title = .ginipayLocalized(resource: DigitalInvoiceStrings.screenTitle)
        view.backgroundColor = UIColor.from(giniColor: returnAssistantConfiguration.digitalInvoiceOnboardingBackgroundColor)

        topImageView.image = topImage

        badgeImageView.image = badgeImage

        firstLabel.text = firstLabelText
        firstLabel.font = returnAssistantConfiguration.digitalInvoiceOnboardingTextFont
        firstLabel.textColor = UIColor.from(giniColor: returnAssistantConfiguration.digitalInvoiceOnboardingTextColor)

        helpItemImageView.image = helpItemImage

        secondLabel.text = secondLabelText
        secondLabel.font = returnAssistantConfiguration.digitalInvoiceOnboardingTextFont
        secondLabel.textColor = UIColor.from(giniColor: returnAssistantConfiguration.digitalInvoiceOnboardingTextColor)

        doneButton.layer.cornerRadius = 7.0
        doneButton.backgroundColor = UIColor.from(giniColor: returnAssistantConfiguration.digitalInvoiceOnboardingDoneButtonBackgroundColor)
        doneButton.tintColor = UIColor.from(giniColor: returnAssistantConfiguration.digitalInvoiceOnboardingDoneButtonTextColor)
        doneButton.setTitle(doneButtonTitle, for: .normal)
        doneButton.titleLabel?.font = returnAssistantConfiguration.digitalInvoiceOnboardingDoneButtonTextFont
        doneButton.addTarget(self, action: #selector(doneAction(_:)), for: .touchUpInside)
    }
 
    @objc func doneAction(_ sender: UIButton!) {
        dismiss(animated: true) {
            UserDefaults.standard.set(true, forKey: "ginipaybank.defaults.digitalInvoiceOnboardingShowed")
        }
    }
}
