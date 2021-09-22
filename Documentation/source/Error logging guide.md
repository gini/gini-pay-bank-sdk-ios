Error Logging
=============================

The Gini Pay Bank SDK logs errors to the Gini Pay API when the default networking implementation is used (see the UI with Networking (Recommended) section in Integration guide). We log only non-sensitive information like response status codes, headers and error messsages.

You can disable the default error logging by passing false to `GiniPayBankConfiguration().giniErrorLoggerIsOn`.

If you would like to get informed of error logging events you need to set `GiniPayBankConfiguration().customGiniErrorLoggerDelegate` which confirms to `GiniCaptureErrorLoggerDelegate`:

```swift
class CustomErrorLogger: GiniCaptureErrorLoggerDelegate {
    func handleErrorLog(error: ErrorLog) {
        //TODO
    }
}

let configuration = GiniPayBankConfiguration()
configuration.customGiniErrorLoggerDelegate = CustomErrorLogger()
```
