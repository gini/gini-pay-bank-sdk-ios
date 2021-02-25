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

//public protocol GiniPayBankNetworkingScreenAPICoordinator: GiniNetworkingScreenAPICoordinator{}
/**
 Convenience class to interact with the Gini Pay Bank SDK.
 
 Gini Pay Bank SDK provides views for capturing, reviewing and analysing documents.
 
 By integrating this library in your application you can allow your users to easily take a picture of
 a document, review it and - by implementing the necessary callbacks - upload the document for analysis to the Gini API.
 
 The Gini Pay Bank SDK can be integrated in two ways, either by using the **Screen API** or
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
     Returns the current version of the Gini Pay Bank SDK.
     If there is an error retrieving the version the returned value will be an empty string.
     */
    @objc public static var versionString: String {
        return GiniPayBankVersion
    }
}
