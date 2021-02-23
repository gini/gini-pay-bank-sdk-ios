//
//  GiniPayBank.swift
//  GiniPayBank
//
//  Created by Nadya Karaban on 18.02.21.
//

import Foundation
import GiniCapture

//public typealias GiniPayBankCaptureNetworkDelegate = GiniCaptureNetworkDelegate
//
///**
// Delegate to inform the reveiver about the current status of the Gini Capture SDK.
// Makes use of callbacks for handling incoming data and to control view controller presentation.
//
// - note: Screen API only.
// */
public protocol GiniPayBankAnalysisDelegate : AnalysisDelegate {}

@objc public protocol GiniPayBankCaptureNetworkDelegate: GiniCaptureNetworkDelegate {}
public protocol GiniPayBankAnalysisScreenTrackingDelegate: AnalysisScreenTrackingDelegate {}

public struct GiniPayBankEvent <T: RawRepresentable> where T.RawValue == String {
    
    /// Type of the event.
    public let type: T
    
    /// Additional information carried by the event.
    public let info: [String : String]?
    
    init(type: T, info: [String : String]? = nil) {
        self.type = type
        self.info = info
    }
    
}

//
//    /**
//     Called when the user has taken a picture or imported a file (image or PDF) from camera roll or document explorer
//
//     - parameter document: `GiniCaptureDocument`
//     - parameter networkDelegate: `GiniCaptureNetworkDelegate` used to tell the Gini Capture
//                                   Library to upload the pages upload state
//
//     */
//
//    func didCapture(document: GiniCaptureDocument, networkDelegate: GiniPayBankCaptureNetworkDelegate)
//
//
//    /**
//     Called when the user has reviewed one or several documents.
//     It is used to add any optional parameters, like rotationDelta, when creating the composite document.
//
//     - parameter documents: An array containing on or several reviewed `GiniCaptureDocument`
//     - parameter networkDelegate: `GiniCaptureNetworkDelegate` used to tell the Gini Capture SDK that the documents
//                                   were reviewed and can be analyzed or uploaded.
//
//     */
//    func didReview(documents: [GiniCaptureDocument], networkDelegate: GiniPayBankCaptureNetworkDelegate)
//
//    /**
//     Called when the user cancels capturing on the camera screen.
//     Should be used to dismiss the presented view controller.
//     */
//    func didCancelCapturing()
//
//    /**
//     Called when the user navigates back from the review screen to the camera potentially to
//     retake an image. Should be used to cancel any ongoing analysis task on the image.
//     */
//    func didCancelReview(for document: GiniCaptureDocument)
//
//    /**
//     Called when the user navigates back from the analysis screen to the review screen.
//     It is used to cancel any ongoing analysis task on the image.
//     */
//    func didCancelAnalysis()

/**
 Convenience class to interact with the Gini Capture SDK.
 
 The Gini Capture SDK provides views for capturing, reviewing and analysing documents.
 
 By integrating this library in your application you can allow your users to easily take a picture of
 a document, review it and - by implementing the necessary callbacks - upload the document for analysis to the Gini API.
 
 The Gini Capture SDK can be integrated in two ways, either by using the **Screen API** or
 the **Component API**. The Screen API provides a fully pre-configured navigation controller for
 easy integration, while the Component API provides single view controllers for advanced
 integration with more freedom for customization.
 
 - important: When using the Component API we advise you to use a similar flow as suggested in the
 Screen API. Use the `CameraViewController` as an entry point with the `OnboardingViewController` presented on
 top of it. After capturing let the user review the document with the `ReviewViewController` and finally present
 the `AnalysisViewController` while the user waits for the analysis results.
 */
@objc public final class GiniPayBank: NSObject {
    
    /**
     Sets a configuration which is used to customize the look and feel of the Gini Capture SDK,
     for example to change texts and colors displayed to the user.
     
     - parameter configuration: The configuration to set.
     */
    @objc public class func setConfiguration(_ configuration: GiniConfiguration) {
        GiniCapture.setConfiguration(configuration)
    }
    
    /**
     Returns a view controller which will handle the analysis process.
     
     - note: Screen API only.
     
     - parameter delegate: An instance conforming to the `GiniPayBankCaptureNetworkDelegate` protocol.
     - parameter importedDocuments: Documents that come from a source different than `CameraViewController`.
     There should be either images or one PDF, and they should be validated before calling this method.
     
     - returns: A presentable view controller.
     */
    @objc public class func viewController(withDelegate delegate: GiniPayBankCaptureNetworkDelegate,
                                           importedDocuments: [GiniCaptureDocument]? = nil) -> UIViewController {
        
        GiniCapture.viewController(withDelegate: delegate as! GiniCaptureDelegate, importedDocuments: importedDocuments)
    }
    
    /**
     Returns a view controller which will handle the analysis process.
     
     - note: Screen API only.
     
     - parameter delegate: An instance conforming to the `GiniPayBankCaptureNetworkDelegate` protocol.
     - parameter importedDocuments: Documents that come from a source different than `CameraViewController`.
     There should be either images or one PDF, and they should be validated before calling this method.
     - parameter trackingDelegate: A delegate object to receive user events
     
     - returns: A presentable view controller.
     */
    public class func viewController(withDelegate delegate: GiniPayBankCaptureNetworkDelegate,
                                           importedDocuments: [GiniCaptureDocument]? = nil,
                                           trackingDelegate: GiniCaptureTrackingDelegate? = nil) -> UIViewController {
        GiniCapture.viewController(withDelegate: delegate as! GiniCaptureDelegate,
        importedDocuments: importedDocuments,
        trackingDelegate: trackingDelegate)
    }
    
    /**
     Returns a view controller which will handle the analysis process.

     - note: Screen API only.
     
     - parameter delegate: An instance conforming to the `GiniPayBankCaptureNetworkDelegate` protocol.
     - parameter importedDocument: Documents that come from a source different than CameraViewController.
     There should be either images or one PDF, and they should be validated before calling this method.

     - returns: A presentable view controller.
     */
    @objc public class func viewController(withDelegate delegate: GiniPayBankCaptureNetworkDelegate,
                                           importedDocument: GiniCaptureDocument? = nil) -> UIViewController {
        
        
        var documents: [GiniCaptureDocument]?
        if let importedDocument = importedDocument {
            documents = [importedDocument]
        }
        
        return GiniCapture.viewController(withDelegate: delegate as! GiniCaptureDelegate, importedDocuments: documents)
    }
    
    /**
     Returns a view controller which will handle the analysis process.

     - note: Screen API only.
     
     - parameter delegate: An instance conforming to the `GiniPayBankCaptureNetworkDelegate` protocol.
     - parameter importedDocument: Documents that come from a source different than CameraViewController.
     There should be either images or one PDF, and they should be validated before calling this method.
     - parameter trackingDelegate: A delegate object to receive user events

     - returns: A presentable view controller.
     */
    public class func viewController(withDelegate delegate: GiniPayBankCaptureNetworkDelegate,
                                           importedDocument: GiniCaptureDocument? = nil,
                                           trackingDelegate: GiniCaptureTrackingDelegate? = nil) -> UIViewController {
        var documents: [GiniCaptureDocument]?
        if let importedDocument = importedDocument {
            documents = [importedDocument]
        }
        
        return GiniCapture.viewController(withDelegate: delegate as! GiniCaptureDelegate, importedDocuments: documents, trackingDelegate: trackingDelegate)
    }
    
    /**
     Returns a view controller which will handle the analysis process.
     Allows to set a custom configuration to change the look and feel of the Gini Capture SDK.
     
     - note: Screen API only.
     
     - parameter delegate:      An instance conforming to the `GiniPayBankCaptureNetworkDelegate` protocol.
     - parameter configuration: The configuration to set.
     - parameter importedDocument: Documents that come from a source different than CameraViewController.
     There should be either images or one PDF, and they should be validated before calling this method.

     - returns: A presentable view controller.
     */
    @objc public class func viewController(withDelegate delegate: GiniPayBankCaptureNetworkDelegate,
                                           withConfiguration configuration: GiniConfiguration,
                                           importedDocument: GiniCaptureDocument? = nil) -> UIViewController {
        setConfiguration(configuration)
        return viewController(withDelegate: delegate, importedDocument: importedDocument)
    }
    
    /**
     Returns a view controller which will handle the analysis process.
     Allows to set a custom configuration to change the look and feel of the Gini Capture SDK.
     
     - note: Screen API only.
     
     - parameter delegate:      An instance conforming to the `GiniPayBankCaptureNetworkDelegate` protocol.
     - parameter configuration: The configuration to set.
     - parameter importedDocument: Documents that come from a source different than CameraViewController.
     There should be either images or one PDF, and they should be validated before calling this method.
     - parameter trackingDelegate: A delegate object to receive user events

     - returns: A presentable view controller.
     */
    public class func viewController(withDelegate delegate: GiniPayBankCaptureNetworkDelegate,
                                           withConfiguration configuration: GiniConfiguration,
                                           importedDocument: GiniCaptureDocument? = nil,
                                           trackingDelegate: GiniCaptureTrackingDelegate? = nil) -> UIViewController {
        setConfiguration(configuration)
        return viewController(withDelegate: delegate, importedDocument: importedDocument, trackingDelegate: trackingDelegate)
    }
    
    /**
     Returns the current version of the Gini Pay Bank SDK.
     If there is an error retrieving the version the returned value will be an empty string.
     */
    @objc public static var versionString: String {
        return GiniPayBankVersion
    }
    
    /**
     Validates a `GiniCaptureDocument` with a given `GiniConfiguration`.
     
     - Throws: `DocumentValidationError` if there was an error during the validation.
     
     */
    @objc public class func validate(_ document: GiniCaptureDocument,
                                     withConfig giniConfiguration: GiniConfiguration) throws {
        try GiniCaptureDocumentValidator.validate(document, withConfig: giniConfiguration)
    }
}
