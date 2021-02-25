//
//  DigitalInvoiceAddonCell.swift
//  GiniPayBank
//
//  Created by Alpár Szotyori on 02.09.20.
//

import Foundation
import GiniCapture
class DigitalInvoiceAddonCell: UITableViewCell {
    
    let returnAssistantConfiguration = ReturnAssistantConfiguration.shared
    
    private var addonNameLabel = UILabel()
    
    private var addonPriceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    var addonName: String = "" {
        didSet {
            let attributedString =
                NSMutableAttributedString(string: "\(addonName):",
                                          attributes: [NSAttributedString.Key.font: returnAssistantConfiguration.digitalInvoiceAddonLabelFont])
            
            addonNameLabel.attributedText = attributedString
        }
    }
    
    var addonPrice: Price? {
        didSet {
            
            guard let addonPrice = addonPrice else { return }
            
            guard let addonPriceString = addonPrice.string else { return }
            
            let attributedString =
                NSMutableAttributedString(string: addonPriceString,
                                          attributes: [NSAttributedString.Key.foregroundColor: returnAssistantConfiguration.digitalInvoiceAddonPriceColor,
                                                       NSAttributedString.Key.font: returnAssistantConfiguration.digitalInvoiceAddonPriceMainUnitFont])
            
            attributedString.setAttributes([NSAttributedString.Key.foregroundColor: returnAssistantConfiguration.digitalInvoiceAddonPriceColor,
                                            NSAttributedString.Key.baselineOffset: 5,
                                            NSAttributedString.Key.font: returnAssistantConfiguration.digitalInvoiceAddonPriceFractionalUnitFont],
                                           range: NSRange(location: addonPriceString.count - 3, length: 3))
            
            addonPriceLabel.attributedText = attributedString
        }
    }
    
    private func setup() {
        
        selectionStyle = .none
        
        addonPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(addonPriceLabel)
        
        Constraints.active(item: addonPriceLabel, attr: .top, relatedBy: .equal, to: contentView, attr: .top, constant: 10)
        Constraints.active(item: addonPriceLabel, attr: .trailing, relatedBy: .equal, to: contentView, attr: .trailing, constant: -16)
        Constraints.active(item: addonPriceLabel, attr: .bottom, relatedBy: .equal, to: contentView, attr: .bottom)
        
        addonNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(addonNameLabel)
        
        Constraints.active(item: addonNameLabel, attr: .trailing, relatedBy: .equal, to: contentView, attr: .trailing, constant: -100)
        Constraints.active(item: addonNameLabel, attr: .firstBaseline, relatedBy: .equal, to: addonPriceLabel, attr: .firstBaseline)
    }
}
