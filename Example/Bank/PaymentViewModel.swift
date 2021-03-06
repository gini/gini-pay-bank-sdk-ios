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

    private var paymentRequest: ResolvedPaymentRequest?

    public init(with giniApiLib: GiniApiLib) {
        apiLib = giniApiLib
        bankSDK = GiniPayBank(with: apiLib)
    }
    

    func resolvePaymentRequest(paymentInfo: PaymentInfo) {
        isLoading = true
        bankSDK.resolvePaymentRequest(paymentRequesId: appDelegate.paymentRequestId, paymentInfo: paymentInfo) { [weak self] result in
            switch result {
            case .success(let resolvedPaymentRequest):
                self?.paymentRequest = resolvedPaymentRequest
                self?.isLoading = false
                self?.onResolvePaymentRequest()
            case .failure:
                self?.isLoading = false
                self?.onResolvePaymentRequestErrorHandling()
            }
        }
    }

    func openPaymentRequesterApp() {
        if let resolvedPayment = paymentRequest {
            bankSDK.returnBackToBusinessAppHandler(resolvedPaymentRequest: resolvedPayment)
        }
    }

    func fetchPaymentRequest() {
        if appDelegate.paymentRequestId != "" {
            isLoading = true
            bankSDK.receivePaymentRequest(paymentRequestId: appDelegate.paymentRequestId) { [weak self] result in
                switch result {
                case let .success(paymentRequest):
                    self?.isLoading = false
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
