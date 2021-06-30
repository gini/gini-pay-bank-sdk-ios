Migrate from Gini Vision Library to Gini Pay Bank SDK
=======================================================

The Gini Capture SDK provides components for capturing, reviewing and analyzing photos of invoices and remittance slips. 
The Gini Capture SDK (`GiniCapture`) will be used in place of the Gini Vision Library (`GiniVision`). 
The Gini Capture SDK used by the Gini Pay Bank SDK and therefore will be mentioned in the migration guide in a couple of places.

The [Gini Pay Api Library](https://github.com/gini/gini-pay-api-lib-ios) (`GiniApiLib`) provides ways to interact with the Gini Pay API and therefore, adds the possiblity to scan documents and extract information from them and support the payment functionality.
The Gini Pay Api Library will be used instead of the Gini iOS SDK.

## Configuration

For customization the Gini Pay Bank SDK uses `GiniPayBankConfiguration` class - extended version of `GiniConfiguration`. All settings from the `GiniConfiguration` are availible in `GiniPayBankConfiguration`.

## Screen API

#### UI with Networking (Recommended)

In place of using `GiniVision`:
```swift
let viewController = GiniVision.viewController(withClient: client,
                                               configuration: giniConfiguration,
                                               resultsDelegate: resultsDelegate)

present(viewController, animated: true, completion:nil)
```
Please use the snippet with `GiniPayBank` method below:

```swift
let viewController = GiniPayBank.viewController(withClient: client,
                                               configuration: giniPayBankConfiguration,
                                               resultsDelegate: giniCaptureResultsDelegate)

present(viewController, animated: true, completion: nil)
```
If you want to use _Certificate pinning_, provide metadata for the upload process, please use `GiniPayBank` method below:

```swift
let viewController = GiniPayBank.viewController(withClient: client,
                                               configuration: giniPayBankConfiguration,
                                               resultsDelegate: giniCaptureResultsDelegate,
                                               publicKeyPinningConfig: yourPublicPinningConfig,
                                               documentMetadata: documentMetadata,
                                               api: .default)

present(viewController, animated: true, completion:nil)
```

#### Only UI

For using only the UI and to handle all the analysis process (either use the [Gini Pay Api Library](https://github.com/gini/gini-pay-api-lib-ios) (previously used Gini API SDK for that purpose) or with your own implementation of the [Gini Pay API](https://pay-api.gini.net/documentation/#gini-pay-api-documentation-v1-0)) (the previous end point was [Gini API](https://developer.gini.net/gini-api/html/index.html)), just get the `UIViewController` as follows:

```swift
let viewController = GiniPayBank.viewController(withDelegate: self,
                                               withConfiguration: giniPayBankConfiguration)

present(viewController, animated: true, completion: nil)
```

## Component API

Alternately of using `GiniConfiguration` in the Gini Pay Bank SDK was introduced `GiniPayBankConfiguration`.
The configuration for `GiniCapture` should be set explicitly as it's shown below:

```swift
let giniPayBankConfiguration = GiniPayBankConfiguration()
.
.
.
GiniCapture.setConfiguration(giniPayBankConfiguration.captureConfiguration())
```