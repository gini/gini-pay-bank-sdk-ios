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
    
    private var totalCaptionExplanationLabel = UILabel()


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
        
        totalCaptionExplanationLabel.text = .ginipayLocalized(resource: DigitalInvoiceStrings.totalExplanationLabel)
        totalCaptionExplanationLabel.font = configuration.digitalInvoiceTotalExplanationLabelFont
        totalCaptionExplanationLabel.textColor = UIColor.from(giniColor: configuration.digitalInvoiceTotalExplanationLabelTextColor)

        totalCaptionExplanationLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(totalCaptionExplanationLabel)
        
        totalCaptionExplanationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2).isActive = true
        totalCaptionExplanationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true        
        
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = .ginipayLocalized(resource: DigitalInvoiceStrings.footerMessage)
        messageLabel.numberOfLines = 0
        messageLabel.font = configuration.digitalInvoiceFooterMessageTextFont
        messageLabel.textColor = UIColor.from(giniColor:configuration.digitalInvoiceFooterMessageTextColor)
        messageLabel.textAlignment = .center

        contentView.addSubview(messageLabel)
        let messageLabelHeight: CGFloat = 48
        messageLabel.heightAnchor.constraint(equalToConstant: messageLabelHeight).isActive = true

        messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40).isActive = true
        messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 35).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40).isActive = true

    }
}
