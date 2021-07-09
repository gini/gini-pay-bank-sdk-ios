

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

## Example apps

The banking example app demonstrates how to integrate the Gini Pay Bank SDK. 
In order to run the app, clone the repo and run `pod install` from the Example directory first.
To inject your API credentials into the Bank example app you need to add your credentials to `Example/Bank/Credentials.pllist`.

An example business app is available in the [Gini Pay Business SDK's](https://github.com/gini/gini-pay-business-sdk-ios) repository.
You can use the same Gini Pay API client credentials in the business example app as in your app, if not otherwise specified.
The example business app initiates the payment flow.

The Gini Pay Business SDK will use a payment provider which will open your banking app via the URL scheme you will set during the integration of the Gini Pay Bank SDK.

To check the redirection from the example business app please run your banking app before running the business app.

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
