//
//  DigitalInvoiceTotalPriceCell.swift
//  GiniPayBank
//
//  Created by Maciej Trybilo on 11.12.19.
//

import Foundation
class DigitalInvoiceTotalPriceCell: UITableViewCell {
    
    var returnAssistantConfiguration: ReturnAssistantConfiguration? {
        didSet {
            setup()
            updateTotalPriceLabel()
        }
    }
    
    private var totalPriceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    var totalPrice: Price? {
        didSet {
            updateTotalPriceLabel()
        }
    }
    
    private func setup() {
        
        selectionStyle = .none
        
        totalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(totalPriceLabel)
        
        totalPriceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        totalPriceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        totalPriceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        backgroundColor = UIColor.from(giniColor: returnAssistantConfiguration?.digitalInvoiceBackgroundColor ?? ReturnAssistantConfiguration.shared.digitalInvoiceBackgroundColor)
    }
    
    private func updateTotalPriceLabel() {
        guard let totalPrice = totalPrice else { return }
        
        guard let totalPriceString = totalPrice.string else { return }
        
        let attributedString =
            NSMutableAttributedString(string: totalPriceString,
                                      attributes: [NSAttributedString.Key.foregroundColor: returnAssistantConfiguration?.digitalInvoiceTotalPriceColor ?? ReturnAssistantConfiguration.shared.digitalInvoiceTotalPriceColor,
                                                   NSAttributedString.Key.font: returnAssistantConfiguration?.digitalInvoiceTotalPriceMainUnitFont ?? ReturnAssistantConfiguration.shared.digitalInvoiceTotalPriceMainUnitFont])
        
        attributedString.setAttributes([NSAttributedString.Key.foregroundColor: returnAssistantConfiguration?.digitalInvoiceTotalPriceColor ?? ReturnAssistantConfiguration.shared.digitalInvoiceTotalPriceColor,
                                        NSAttributedString.Key.baselineOffset: 9,
                                        NSAttributedString.Key.font: returnAssistantConfiguration?.digitalInvoiceTotalPriceFractionalUnitFont ?? ReturnAssistantConfiguration.shared.digitalInvoiceTotalPriceFractionalUnitFont],
                                       range: NSRange(location: totalPriceString.count - 3, length: 3))
        
        totalPriceLabel.attributedText = attributedString
        
        let format = DigitalInvoiceStrings.totalAccessibilityLabel.localizedGiniPayFormat
        totalPriceLabel.accessibilityLabel = String.localizedStringWithFormat(format,
                                                                              totalPriceString)
    }
}
