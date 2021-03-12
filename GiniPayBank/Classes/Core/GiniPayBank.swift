//
//  GiniPayBank.swift
//  GiniPayBank
//
//  Created by Nadya Karaban on 18.02.21.
//

import Foundation
import GiniCapture
import GiniPayApiLib

public protocol GiniPayBankAnalysisDelegate : AnalysisDelegate {}

@objc public final class GiniPayBank: NSObject {
    
    /**
     Returns the current version of the Gini Pay Bank SDK.
     If there is an error retrieving the version the returned value will be an empty string.
     */
    @objc public static var versionString: String {
        return GiniPayBankVersion
    }
    /**
     Indicates whether the Return Assistant feature is enabled or not. In case of `true`,
     the user will be presented with a digital representation of their invoice where they
     can see individual line items and are able to amend them or choose to not to pay for them.
     */
    
    @objc public var returnAssistantEnabled = true
    
    /**
     Singleton to make configuration internally accessible in all classes of the Gini PayBank SDK.
     */
   public static var shared = GiniPayBank()
    
   public override init() {}

}
