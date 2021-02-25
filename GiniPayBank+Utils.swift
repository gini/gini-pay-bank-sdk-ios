//
//  File.swift
//  GiniPayBank
//
//  Created by Nadya Karaban on 24.02.21.
//

import Foundation

    /**
     Returns an optional `UIImage` instance with the given `name` preferably from the client's bundle.
     
     - parameter name: The name of the image file without file extension.
     
     - returns: Image if found with name.
     */
    func UIImageNamedPreferred(named name: String) -> UIImage? {
        if let clientImage = UIImage(named: name) {
            return clientImage
        }
        let bundle = Bundle(for: GiniPayBank.self)
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }
