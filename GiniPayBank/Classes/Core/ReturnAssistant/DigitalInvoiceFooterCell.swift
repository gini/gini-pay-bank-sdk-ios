//
//  DigitalInvoiceFooterCell.swift
//  GiniPayBank
//
//  Created by Maciej Trybilo on 11.12.19.
//

import UIKit
class DigitalInvoiceFooterCell: UITableViewCell {
    var returnAssistantConfiguration: ReturnAssistantConfiguration? {
        didSet {
            setup()
        }
    }
    let payButton = UIButton(type: .system)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setup() {
        let configuration = returnAssistantConfiguration ?? ReturnAssistantConfiguration.shared
        selectionStyle = .none
        backgroundColor = UIColor.from(giniColor: configuration.digitalInvoiceBackgroundColor)
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = .ginipayLocalized(resource: DigitalInvoiceStrings.footerMessage)
        messageLabel.numberOfLines = 0
        messageLabel.font = configuration.digitalInvoiceFooterMessageTextFont
        messageLabel.textColor = UIColor.from(giniColor:configuration.digitalInvoiceFooterMessageTextColor)

        contentView.addSubview(messageLabel)
        let messageLabelHeight: CGFloat = 48
        messageLabel.heightAnchor.constraint(equalToConstant: messageLabelHeight).isActive = true

        messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40).isActive = true
        messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 35).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40).isActive = true

        payButton.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(payButton)
        let payButtonHeight: CGFloat = 48
        let margin: CGFloat = 16
        payButton.heightAnchor.constraint(equalToConstant: payButtonHeight).isActive = true
        payButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor,
                                       constant: 30).isActive = true
        payButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin).isActive = true
        payButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin).isActive = true

        payButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30).isActive = true

        payButton.layer.cornerRadius = 7
        payButton.backgroundColor = configuration.payButtonBackgroundColor
        payButton.setTitleColor(configuration.payButtonTitleTextColor, for: .normal)
        payButton.titleLabel?.font = configuration.payButtonTitleFont

        payButton.layer.shadowColor = UIColor.black.cgColor
        payButton.layer.shadowRadius = 4
        payButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        payButton.layer.shadowOpacity = 0.15
    }
}
