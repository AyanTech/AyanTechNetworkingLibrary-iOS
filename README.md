# iOS SDK for work with AyanTech web services

Use this SDK to communicate with AyanTech web services.

## Requirements

- iOS 13.0+
- Swift 6.0+
- Xcode 16+

## Changes

### response header type

`ATResponse.headers` changed from `[AnyHashable: Any]` to `[String: String]` so that `ATResponse` can safely conform to `Sendable`. HTTP header names and values are now represented as strings.


## Installation

### CocoaPods

In your project `Podfile` add:

```
pod 'AyanTechNetworkingLibrary'
```

Then run `pod install`.

### Swift Package Manager

In Xcode, use **File → Add Package Dependencies** and enter:

```
https://github.com/AyanTech/AyanTechNetworkingLibrary-iOS.git
```

## Configuration

Configure the library once at app launch (for example in `AppDelegate`):

```swift
ATRequest.Configuration.noProxy = true
ATRequest.Configuration.timeout = 30
ATRequest.Configuration.defaultHeaders = [:]
ATRequest.Configuration.setLoggerLevel(.default)
```

### Logger

Control network request/response logging globally:

```swift
ATRequest.Configuration.setLoggerLevel(.default) // logs requests and responses (default)
ATRequest.Configuration.setLoggerLevel(.none)    // disables network logging
```

For a custom logger:

```swift
ATRequest.Configuration.setLogger(myCustomLogger)
```

Recommended setup:

```swift
#if DEBUG
ATRequest.Configuration.setLoggerLevel(.default)
#else
ATRequest.Configuration.setLoggerLevel(.none)
#endif
```

## Usage

### Combine

Use `valuePublisher()` when network and API errors should be emitted as `ATError`:

```swift
import AyanTechNetworkingLibrary
import Combine

var cancellables = Set<AnyCancellable>()

ATRequest.request(
    url: "https://ayantech.ir/some/endpoint/url",
    method: .post
)
.setJsonBody(body: [
    "Parameters": [
        "ParamA": "ValueA",
        "ParamB": "ValueB"
    ]
])
.valuePublisher()
.sink(
    receiveCompletion: { completion in
        if case let .failure(error) = completion {
            print(error.persianDescription ?? "Unknown error")
        }
    },
    receiveValue: { response in
        print(response.parametersJsonObject ?? [:])
    }
)
.store(in: &cancellables)
```

Use `responsePublisher()` when you always want an `ATResponse` and prefer to inspect `response.error` yourself. Its failure type is `Never`.

### Async/await

```swift
let request = ATRequest.request(url: "https://ayantech.ir/some/endpoint/url", method: .get)

let task = Task {
    let response = await request.send()
    if response.error?.type == .cancelled { return }
    print(response.responseString ?? "null")
}

// To cancel:
task.cancel()
```

### Callback (deprecated)

```swift
// Method can be omitted; the default is POST.
let request = ATRequest.request(url: "https://ayantech.ir/some/endpoint/url", method: .post)
request.setJsonBody(body: [
    "Parameters": [
        "ParamA": "ValueA",
        "ParamB": "ValueB"
    ]
])
request.send { response in
    print("response code is: \(response.responseCode)")
    print("response raw string is: \(response.responseString)")
    print("response raw json is: \(response.responseJsonObject)")
    print("parameters json object is: \(response.parametersJsonObject)")
}
```

### Cancellation

| API | Cancel method |
|-----|---------------|
| `valuePublisher()` / `responsePublisher()` | Cancel the `AnyCancellable` subscription |
| `send { }` (deprecated) | `request.cancel()` |
| `await send()` (modern) | Cancel the `Task` — **`request.cancel()` does not work** |

Cancelling an `AnyCancellable` stops publisher events from reaching the subscriber. The underlying async request may continue after the subscription is cancelled.

The modern async API uses `URLSession.data(for:)`, which does not expose a `URLSessionTask`. To cancel an in-flight async request, keep a reference to the `Task` and call `task.cancel()`.

In SwiftUI, `.task { await request.send() }` cancels automatically when the view disappears.

## Mocking response:
Good news 😍! you can mock your response using a response file.

Response file is a json file containing response body and headers. Currently only success responses can be mocked. here is the mock json file format and usage:
#### Mock file format:
```javascript
{
  "headers": {},
  "body": {},
  "meta": {
    "statusCode": 200,
    "delay": 2.0
  }
}
```

- `header` should be **Object** containing all header fields. *(optional)*
- `meta` should be **Object** contains the status code and response delay in second. meta object is optional, default value for `statusCode` is 200 and for `delay` is 0
- `body` can be **any** type i.e. Object, Array, String, Int, ... *(required)*

example of mock json file:
```javascript
{
  "headers": {
    "Access-Control-Allow-Headers": "X-Requested-With,Content-Type, Accept",
    "Access-Control-Allow-Origin": "*",
    "Cache-Control": "private",
    "Content-Length": "805",
    "Content-Type": "application/json; charset=utf-8",
    "Date": "Wed, 12 Sep 2018 06:05:07 GMT",
    "Server": "Microsoft-IIS/8.5",
    "X-AspNet-Version": "4.0.30319",
    "X-Powered-By": "ASP.NET"
  },
  "body": {
    "Parameters": [
      {
        "Detail": "درخواست انتقال وجه",
        "ID": 100,
        "Name": "100",
        "ShowName": "100"
      }
    ],
    "Status": {
      "Code": "G00000",
      "Description": "درخواست با موفقیت انجام شد."
    }
  },
  "meta": {
    "statusCode": 200,
    "delay": 2.0
  }
}
```

#### Using mock file to mock response:
Just use `mockResponse` method of `ATRequest` and pass the file path.\
It looks like this:
```swift
ATRequest.request(url: "http://api.ayantech.ir/sampleApi", method: .get)
    .mockResponse(using:  Bundle.main.path(forResource: "mockFile", ofType: nil)!)
    .send { response in
        print(response.responseString ?? "null")
    }
```

## Cheatsheet:

### ATRequest:
| Property |        Type       | Description                                                                                          |
|:--------:|:-----------------:|------------------------------------------------------------------------------------------------------|
| url      | String            | Request url string                                                                                   |
| method   | HTTPMethod        | Request http method (get, post, put, ...)                                                            |
| headers  | [String: String]  | Request headers                                                                                      |
| body     | [String: Any]     | Request parameters (can be body or query params depend on encoding)                                  |
| encoding | ParameterEncoding | Encoding method for body. this variable decides whether body should be query parameters os http body |


----

### ATResponse:
|       Property       |      Type      | Description                                                          |
|:--------------------:|:--------------:|----------------------------------------------------------------------|
| headers              | [String: String] | Response headers map with string names and values                  |
| responseString       | String?        | Response raw body in String                                          |
| status               | Status?        | Response Status object (if exist)                                    |
| error                | ATError?       | Response error (if status code is something other than 20x)          |
| responseCode         | Int            | Response status code (20x for success)                               |
| responseJsonObject   | [String: Any]? | Response body in JSON object format (if body is a valid json string) |
| parametersJsonObject | [String Any]?  | Parameters object of response json object (if exist)                 |


----

### ATError
|      Property      |     Type     | Description                          |
|:------------------:|:------------:|--------------------------------------|
| persianDescription | String?      | Error human-readable string in Farsi |
| code               | Int?         | Error code                           |
| type               | ATErrorType? | Error type                           |
| name               | String?      | Error code name                      |


----

### ATErrorType
|     Case    | Description                                                          |
|:-----------:|----------------------------------------------------------------------|
| noInternet  | When the user has no internet connection (neither wifi nor cellular) |
| timeout     | When the request has timed out                                       |
| serverError | When server returns 50x error code                                   |
| cancelled   | When request was cancelled by user                                   |
| general     | None of the above                                                    |
