

<p align="center">
<img src="img/repo-logo.png" width="250">
</p>
# Gini Pay Bank SDK for iOS
[![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)]()
[![Devices](https://img.shields.io/badge/devices-iPhone%20%7C%20iPad-blue.svg)]()
[![Swift version](https://img.shields.io/badge/swift-5.0-orange.svg)]()


The Gini Pay Bank SDK provides components for uploading, reviewing and analyzing photos of invoices and remittance slips.

By integrating this SDK into your application you can allow your users to easily upload a picture of a document, review it and get analysis results from the Gini backend, create a payment and send it to the prefferable payment provider.

## Documentation

Further documentation with installation, integration or customization guides can be found in our [website](http://developer.gini.net/gini-pay-bank-sdk-ios/docs/).

## Example

We are providing example app for integrating payment functionality for Swift. This app demonstrates how to integrate the Gini Pay Bank SDK. To run the example project, clone the repo and run `pod install` from the Example directory first.
To inject your API credentials into the Example app, just add to the Example/Bank directory the `Credentials.plist` file with the following format:

<br>
<center><img src="img/credentials_plist_format.png"/></center>
</br>

## Requirements

- iOS 10.2+
- Xcode 10.2+

**Note:**
In order to have better analysis results it is highly recommended to enable only devices with 8MP camera and flash. These devices would be:

* iPhones with iOS 10.2 or higher.
* iPad Pro devices (iPad Air 2 and iPad Mini 4 have 8MP camera but no flash).

## Author

Gini GmbH, hello@gini.net

## License

The Gini Pay Bank SDK for iOS is licensed under a Private License. See [the license](http://developer.gini.net/gini-pay-bank-sdk-ios/docs/license.html) for more info.

**Important:** Always make sure to ship all license notices and permissions with your application.
