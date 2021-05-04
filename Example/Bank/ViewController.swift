//
//  ViewController.swift
//  Bank
//
//  Created by Nadya Karaban on 30.04.21.
//

import GiniPayApiLib
import GiniPayBank
import UIKit

class PaymentViewController: UIViewController {
    @IBOutlet var receipient: UITextField!
    @IBOutlet var iban: UITextField!
    @IBOutlet var amount: UITextField!
    @IBOutlet var purpose: UITextField!
    @IBOutlet var payButton: UIButton!
    @IBOutlet var backToBusinessButton: UIButton!

    var viewModel: PaymentViewModel?
    public static func instantiate(with apiLib: GiniApiLib) -> PaymentViewController {
        let vc = (UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "paymentViewController") as? PaymentViewController)!
        vc.viewModel = PaymentViewModel(with: apiLib)
        return vc
    }
    
    fileprivate func subscribeForNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeForNotifications()
    }

    @objc func appBecomeActive() {
        setupUI()
        setupViewModel()
   }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setupUI()
        setupViewModel()
    }

    func setupViewModel() {
        
        viewModel?.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async { [weak self] in
                let isLoading = self?.viewModel?.isLoading ?? false
                if isLoading {
                    self?.view.showLoading(style:.large, color:GiniPayBankConfiguration.shared.analysisLoadingIndicatorColor, scale: 1.0)
                } else {
                    self?.view.stopLoading()
                }
            }
        }
        
        viewModel?.onPaymentInfoFetched = {[weak self] paymentInfo in
            DispatchQueue.main.async {
                self?.fillOutTheData(paymentInfo: paymentInfo)
            }
        }
        
        viewModel?.onResolvePaymentRequest = {
            DispatchQueue.main.async {
                self.backToBusinessButton.isHidden = false
                self.showAlert(message: "Payment was successfully resolved")
            }
        }
        viewModel?.onResolvePaymentRequestErrorHandling = {
            DispatchQueue.main.async {
                self.backToBusinessButton.isHidden = false
                self.showAlert(message: "Payment was not resolved")
            }
        }
        viewModel?.fetchPaymentRequest()
    }

    func setupUI() {
        payButton.isEnabled = false
        backToBusinessButton.isHidden = true
    }
    
    
    @IBAction func resolvePayment(_ sender: Any) {
        let paymentInfo = PaymentInfo(recipient: receipient.text ?? "", iban: iban.text ?? "", bic: "", amount: amount.text ?? "", purpose: purpose.text ?? "")
        viewModel?.resolvePaymentRequest(paymentInfo: paymentInfo)
    }
    
    @IBAction func backToBusiness(_ sender: Any) {
        viewModel?.openPaymentRequesterApp()
    }
    
    func fillOutTheData(paymentInfo: PaymentInfo) {
        receipient.text = paymentInfo.recipient
        iban.text = paymentInfo.iban
        amount.text = paymentInfo.amount
        purpose.text = paymentInfo.purpose
        payButton.isEnabled = true

        self.showAlert("", message: "Payment data was successfully fetched")

    }

}

extension PaymentViewController {
    func showAlert(_ title: String? = nil, message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion: nil)
    }
}
