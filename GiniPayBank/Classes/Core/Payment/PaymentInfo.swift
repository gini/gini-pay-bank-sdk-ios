//
//  PaymentInfo.swift
//  GiniPayBank
//
//  Created by Nadya Karaban on 29.04.21.
//

import Foundation
/**
 Model object for payment information
  */

public struct PaymentInfo {
    public var recipient,iban: String
    public var bic: String
    public var amount, purpose: String
}
