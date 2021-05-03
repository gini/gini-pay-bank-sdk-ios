//
//  ViewController.swift
//  Bank
//
//  Created by Nadya Karaban on 30.04.21.
//

import UIKit
import GiniPayApiLib
import GiniPayBank

class PaymentViewController: UIViewController {
    @IBOutlet weak var receipient: UITextField!
    @IBOutlet weak var iban: UITextField!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var purpose: UITextField!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var backToBusinessButton: UIButton!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var paymentRequestID: String = {
        return appDelegate.paymentRequestId
    }()
    
    lazy var bankSdk: GiniPayBank = {
        let client = Client(id: "gini-mobile-test", secret: "wT4o4kXPAYtDknnOYwWf4w5s", domain: "gini.net")
        let lib = GiniApiLib.Builder(client: client).build()
        return GiniPayBank(with: lib)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchPaymentData()
    }
    
    func setupUI(){
        payButton.isEnabled = false
        payButton.addTarget(self, action: #selector(resolvePayment), for: .touchUpInside)
        backToBusinessButton.isHidden = true
        backToBusinessButton.addTarget(self, action: #selector(handleBackToBusiness), for: .touchUpInside)
    }
    
    @objc func resolvePayment(){
        let paymentInfo = PaymentInfo.init(recipient: receipient.text ?? "", iban: iban.text ?? "", bic: "", amount: amount.text ?? "", purpose: purpose.text ?? "")
        
        bankSdk.resolvePayment(paymentRequesId: paymentRequestID, paymentInfo: paymentInfo){ result in
            switch result {
            case .success(_):
                self.backToBusinessButton.isHidden = false
            case .failure(_):
                break
            }
            
        }
    }
    
    @objc func handleBackToBusiness(){
        bankSdk.returnBackToBusinessAppHandler()
    }
    
    func fillOutTheData(paymentRequest: PaymentRequest){
        receipient.text = paymentRequest.recipient
        iban.text = paymentRequest.iban
        amount.text = paymentRequest.amount
        purpose.text = paymentRequest.purpose
        payButton.isEnabled = true
    }
    
    func fetchPaymentData(){
        bankSdk.receivePaymentRequest(paymentRequestId: paymentRequestID) { result in
            switch result {
            case .success( let paymentRequest):
                self.fillOutTheData(paymentRequest: paymentRequest)
            case .failure(_): break
                
            }
        }
    }

}

