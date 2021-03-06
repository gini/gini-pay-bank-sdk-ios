////
////  GiniPayBankUtils.swift
////  GiniPayBank
////
////  Created by Nadya Karaban on 24.02.21.
////
//
//import Foundation
//import UIKit
//
///**
// Returns an optional `UIImage` instance with the given `name` preferably from the client's bundle.
// 
// - parameter name: The name of the image file without file extension.
// 
// - returns: Image if found with name.
// */
//public func PreferredImage(named name: String) -> UIImage? {
//    if let clientImage = UIImage(named: name) {
//        return clientImage
//    }
//    let bundle = Bundle(for: GiniPayBank.self)
//    return UIImage(named: name, in: bundle, compatibleWith: nil)
//}

/**
 Returns a localized string resource preferably from the client's bundle. Used in Return Assistant Screens.
 
 - parameter key:     The key to search for in the strings file.
 - parameter comment: The corresponding comment.
 
 - returns: String resource for the given key.
 */
func NSLocalizedStringPreferredGiniPayFormat(_ key: String,
                                      fallbackKey: String = "",
                                      comment: String,
                                      isCustomizable: Bool = true) -> String {
    let clientString = NSLocalizedString(key, comment: comment)
    let fallbackClientString = NSLocalizedString(fallbackKey, comment: comment)
    let format: String
    
    if (clientString.lowercased() != key.lowercased() || fallbackClientString.lowercased() != fallbackKey.lowercased())
        && isCustomizable {
        format = clientString
    } else {
        let bundle = giniPayBankBundle()
        var defaultFormat = NSLocalizedString(key, bundle: bundle, comment: comment)
        
        if defaultFormat.lowercased() == key.lowercased() {
            defaultFormat = NSLocalizedString(fallbackKey, bundle: bundle, comment: comment)
        }
        
        format = defaultFormat
    }
    
    return format
}

func giniPayBankBundle() -> Bundle {
    Bundle(for: GiniPayBank.self)
}

