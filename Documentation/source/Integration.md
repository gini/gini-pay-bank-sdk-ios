Integration
=============================

Gini Pay provides an information extraction system for analyzing business invoices and transfers them to the iOS banking app, where the payment process will be completed.

The Gini Pay Bank SDK for iOS provides functionality to upload the multipage documents with mobile phones, accurate line item extraction enables the user to to pay the invoice with prefferable payment provider. 

**Note** For supporting your banking app as a payment provider you need to register Gini Pay URL scheme in you  in your `Info.plist` file. Gini Pay URL schemes for specification will be provided by Gini.

<br>
<center><img src="img/definingCustomUrl.png" height="200"/></center>
</br>

#### GiniApiLib initialization

If you want to use a transparent proxy with your own authentication you can specify your own domain and add `AlternativeTokenSource` protocol implementation:

```swift
 let apiLib =  GiniApiLib.Builder(customApiDomain: "api.custom.net",
                                 alternativeTokenSource: MyAlternativeTokenSource)
                                 .build()
```
The token your provide will be added as a bearer token to all api.custom.net requests.

Optionally if you want to use _Certificate pinning_, provide metadata for the upload process, you can pass both your public key pinning configuration (see [TrustKit repo](https://github.com/datatheorem/TrustKit) for more information)
```swift
    let giniApiLib = GiniApiLib
        .Builder(client: Client(id: "your-id",
                                secret: "your-secret",
                                domain: "your-domain"),
                 api: .default,
                 pinningConfig: yourPublicPinningConfig)
        .build()
```
> ⚠️  **Important**
> - The document metadata for the upload process is intended to be used for reporting.

##  GiniPayBank initialization
Now that the `GiniApiLib` has been initialized, you can initialize `GiniPayBank`

```swift
 let bankSDK = GiniPayBank(with: giniApiLib)
```
and receive the payment requestID in `AppDelegate`. For handling incoming URL, please use the code snippet below.

```swift
func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        receivePaymentRequestId(url: url) { result in
            switch result {
            case let .success(requestId):
                self.paymentRequestId = requestId
            case .failure:
                break
            }
        }
        return true
    }
```
##  Fetching payment information

After receiving the payment request id you can get fetch the payment information:

```swift

bankSDK.receivePaymentRequest(paymentRequestId: appDelegate.paymentRequestId)

```
The method above returns the completion block with the struct `PaymentRequest`, which includes recipient, iban, amount and purpose fields.

##  Resolving payment request

```swift

bankSDK.resolvePaymentRequest(paymentRequesId: appDelegate.paymentRequestId,
                                 paymentInfo: paymentInfo)

```
The method above returns the completion block with the struct `ResolvedPaymentRequest`, which includes requesterUri for redirecting back to the payment requester's app.

##  Redirecting back to the payment requester app

If the payment request was successfully resolved you can allow the user redirect back to the payment requester app:

```swift
bankSDK.returnBackToBusinessAppHandler(resolvedPaymentRequest: resolvedPayment)
```