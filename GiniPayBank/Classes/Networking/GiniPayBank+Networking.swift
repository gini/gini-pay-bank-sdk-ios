//
//  GiniPayBank.swift
//  GiniPayBank
//
//  Created by Nadya Karaban on 18.02.21.
//

import Foundation
import GiniPayApiLib
import GiniCapture

extension GiniPayBank {
    /**
     Returns a view controller which will handle the analysis process.
     It's the easiest way to get started with the Gini Pay Bank SDK as it comes pre-configured and handles
     all screens and transitions out of the box, including the networking.
     
     - parameter client: `GiniClient` with the information needed to enable document analysis
     - parameter resultsDelegate: Results delegate object where you can get the results of the analysis.
     - parameter configuration: The configuration to set.
     - parameter documentMetadata: Additional HTTP headers to send when uploading documents
     - parameter api: The Gini backend API to use. Supply .custom("domain") in order to specify a custom domain.
     - parameter userApi: The Gini user backend API to use. Supply .custom("domain") in order to specify a custom domain.
     - parameter trackingDelegate: A delegate object to receive user events
     
     - note: Screen API only.

     - returns: A presentable view controller.
     */
    public class func viewController(withClient client: Client,
                                     importedDocuments: [GiniCaptureDocument]? = nil,
                                     configuration: GiniConfiguration,
                                     resultsDelegate: GiniCaptureResultsDelegate,
                                     documentMetadata: Document.Metadata? = nil,
                                     api: APIDomain = .default,
                                     userApi: UserDomain = .default,
                                     trackingDelegate: GiniCaptureTrackingDelegate? = nil) -> UIViewController {
        return GiniCapture.viewController(withClient: client, importedDocuments: importedDocuments, configuration: configuration, resultsDelegate: resultsDelegate, documentMetadata: documentMetadata, api: api, userApi: userApi, trackingDelegate: trackingDelegate)
    }
    
    public class func removeStoredCredentials(for client: Client) throws {
        let lib = GiniApiLib.Builder(client: client).build()
        
        try lib.removeStoredCredentials()
    }
    
}

extension GiniNetworkingScreenAPICoordinator: DigitalInvoiceViewControllerDelegate{
    public func didFinish(viewController: DigitalInvoiceViewController, invoice: DigitalInvoice) {
    }
    
    
    
    public func showDigitalInvoiceScreen(digitalInvoice: DigitalInvoice, analysisDelegate: AnalysisDelegate) {
    
        let digitalInvoiceViewController = DigitalInvoiceViewController()
        digitalInvoiceViewController.returnAssistantConfiguration = ReturnAssistantConfiguration.shared
        digitalInvoiceViewController.invoice = digitalInvoice
        digitalInvoiceViewController.delegate = self
        digitalInvoiceViewController.analysisDelegate = analysisDelegate
        
        screenAPINavigationController.pushViewController(digitalInvoiceViewController, animated: true)
    }
    
    fileprivate func startAnalysis(networkDelegate: GiniCaptureNetworkDelegate) {
        self.documentService.startAnalysis { result in
            
            switch result {
            case .success(let extractionResult):
                
                DispatchQueue.main.async {
                    
                    if ReturnAssistantConfiguration.shared.returnAssistantEnabled {
                        
                        do {
                            let digitalInvoice = try DigitalInvoice(extractionResult: extractionResult)
                            self.showDigitalInvoiceScreen(digitalInvoice: digitalInvoice, analysisDelegate: networkDelegate)
                        } catch {
                            self.deliver(result: extractionResult, analysisDelegate: networkDelegate)
                        }
                        
                    } else {
                        extractionResult.lineItems = nil
                        self.deliver(result: extractionResult, analysisDelegate: networkDelegate)
                    }
                }
                
            case .failure(let error):
                
                guard error != .requestCancelled else { return }
                
                networkDelegate.displayError(withMessage: .localized(resource: AnalysisStrings.analysisErrorMessage),
                                             andAction: {
                                                self.startAnalysis(networkDelegate: networkDelegate)
                })
            }
        }
    }
    
    fileprivate func upload(document: GiniCaptureDocument,
                            didComplete: @escaping (GiniCaptureDocument) -> Void,
                            didFail: @escaping (GiniCaptureDocument, Error) -> Void) {
        documentService.upload(document: document) { result in
            switch result {
            case .success:
                didComplete(document)
            case .failure(let error):
                didFail(document, error)
            }
        }
    }

    fileprivate func uploadAndStartAnalysis(document: GiniCaptureDocument,
                                            networkDelegate: GiniCaptureNetworkDelegate,
                                            uploadDidFail: @escaping () -> Void) {
        self.upload(document: document, didComplete: { _ in
            self.startAnalysis(networkDelegate: networkDelegate)
        }, didFail: { _, error in
            let error = error as? GiniCaptureError ?? AnalysisError.documentCreation

            guard let analysisError = error as? AnalysisError, case analysisError = AnalysisError.cancelled else {
                networkDelegate.displayError(withMessage: error.message, andAction: {
                    uploadDidFail()
                })
                return
            }
        })
    }
}
