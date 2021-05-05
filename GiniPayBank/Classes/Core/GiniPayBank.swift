//
//  GiniPayBank.swift
//  GiniPayBank
//
//  Created by Nadya Karaban on 18.02.21.
//

import Foundation
import GiniPayApiLib

/**
 Core class for GiniPayBank SDK.
 */
@objc public final class GiniPayBank: NSObject {
    /// reponsible for interaction with Gini Pay backend .
    public var giniApiLib: GiniApiLib
    /// reponsible for the payment processing.
    public var paymentService: PaymentService

    /**
     Returns a GiniPayBank instance

     - parameter giniApiLib: GiniApiLib initialized with client's credentials
     */
    public init(with giniApiLib: GiniApiLib) {
        self.giniApiLib = giniApiLib
        paymentService = giniApiLib.paymentService()
    }

    /**
     Fetches the payment request via payment request id.

     - parameter paymentRequestId: Id of payment request.
     - parameter completion: An action for processing asynchronous data received from the service with Result type as a paramater. Result is a value that represents either a success or a failure, including an associated value in each case.
     Completion block called on main thread.
     In success returns the payment request structure.
     In case of failure error from the server side.

     */
    public func receivePaymentRequest(paymentRequestId: String, completion: @escaping (Result<PaymentRequest, GiniPayBankError>) -> Void) {
        paymentService.paymentRequest(id: paymentRequestId) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(paymentRequest):
                    completion(.success(paymentRequest))
                case let .failure(error):
                    completion(.failure(.apiError(error)))
                }
            }
        }
    }

    /**
     Resolves the payment via payment request id.

     - parameter paymentRequesId: Id of payment request.
     - parameter completion: An action for processing asynchronous data received from the service with Result type as a paramater. Result is a value that represents either a success or a failure, including an associated value in each case.
     Completion block called on main thread.
     In success returns the payment structure.
     In case of failure error from the server side.

     */
    public func resolvePaymentRequest(paymentRequesId: String, paymentInfo: PaymentInfo, completion: @escaping (Result<String, GiniPayBankError>) -> Void) {

        paymentService.resolvePaymentRequest(id: paymentRequesId, recipient: paymentInfo.recipient, iban: paymentInfo.iban, amount: paymentInfo.amount, purpose: paymentInfo.purpose, completion: { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(payment):
                    completion(.success(payment))
                case let .failure(error):
                    completion(.failure(.apiError(error)))
                }
            }
        }
        )
    }

    /**
     Returns back to the business app.
     Return button should be active for the user after resolving the payment request.

     */
    public func returnBackToBusinessAppHandler(paymentRequesterScheme: String) {
        if let resultUrl = URL(string: paymentRequesterScheme) {
            DispatchQueue.main.async {
                UIApplication.shared.open(resultUrl, options: [:], completionHandler: nil)
            }
        }
    }
}
