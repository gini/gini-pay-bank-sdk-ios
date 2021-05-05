//
//  PaymentViewModel.swift
//  Bank
//
//  Created by Nadya Karaban on 03.05.21.
//

import Foundation
import GiniPayApiLib
import GiniPayBank
/**
 View model class for review screen
  */
public class PaymentViewModel: NSObject {
    private var apiLib: GiniApiLib
    private var bankSDK: GiniPayBank

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var onPaymentInfoFetched: (_ info: PaymentInfo) -> Void = { _ in }

    var updateLoadingStatus: () -> Void = {}

    var onErrorHandling: (_ error: GiniPayBankError) -> Void = { _ in }

    var onResolvePaymentRequest: () -> Void = {}

    var onResolvePaymentRequestErrorHandling: () -> Void = {}

    var isLoading: Bool = false {
        didSet {
            updateLoadingStatus()
        }
    }

    var requesterAppScheme = ""

    public init(with giniApiLib: GiniApiLib) {
        apiLib = giniApiLib
        bankSDK = GiniPayBank(with: apiLib)
    }
    

    func resolvePaymentRequest(paymentInfo: PaymentInfo) {
        isLoading = true
        bankSDK.resolvePayment(paymentRequesId: appDelegate.paymentRequestId, paymentInfo: paymentInfo) { [weak self] result in
            switch result {
            case .success:
                self?.isLoading = false
                self?.onResolvePaymentRequest()
            case .failure:
                self?.isLoading = false
                self?.onResolvePaymentRequestErrorHandling()
            }
        }
    }

    func openPaymentRequesterApp() {
        bankSDK.returnBackToBusinessAppHandler(paymentRequesterScheme: requesterAppScheme)
    }

    func fetchPaymentRequest() {
        if appDelegate.paymentRequestId != "" {
            isLoading = true
            bankSDK.receivePaymentRequest(paymentRequestId: appDelegate.paymentRequestId) { [weak self] result in
                switch result {
                case let .success(paymentRequest):
                    self?.isLoading = false
                    self?.requesterAppScheme = paymentRequest.requesterURI
                    let paymentInfo = PaymentInfo(recipient: paymentRequest.recipient, iban: paymentRequest.iban, bic: paymentRequest.bic, amount: paymentRequest.amount, purpose: paymentRequest.purpose)
                    self?.onPaymentInfoFetched(paymentInfo)
                case let .failure(error):
                    self?.isLoading = false
                    self?.onErrorHandling(error)
                }
            }
      }
    }
}
