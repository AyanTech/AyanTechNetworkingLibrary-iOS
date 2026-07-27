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
NetworkClientV2.setLoggerLevel(.default)
```

Pass per-request settings through `ConfigurationV2`:

```swift
let configuration = ConfigurationV2(
    timeout: 30,
    defaultHeaders: [:],
    token: "your-auth-token"
)
```

### Logger

Control network request/response logging globally:

```swift
NetworkClientV2.setLoggerLevel(.default) // logs requests and responses (default)
NetworkClientV2.setLoggerLevel(.none)    // disables network logging
```

For a custom logger:

```swift
NetworkClientV2.setLogger(myCustomLogger)
```

Recommended setup:

```swift
#if DEBUG
NetworkClientV2.setLoggerLevel(.default)
#else
NetworkClientV2.setLoggerLevel(.none)
#endif
```

### V1 configuration (deprecated)

```swift
ATRequest.Configuration.noProxy = true
ATRequest.Configuration.timeout = 30
ATRequest.Configuration.defaultHeaders = [:]
ATRequest.Configuration.setLoggerLevel(.default)
```

## Usage

### V2 (Combine)

Create a typed `ATRequestV2`. The SDK wraps `parameters` and `token` in the `Identity` / `Parameters` envelope and sends a POST request.

Combine publishers are available on V2 only:

- `valuePublisher(as:)` — decoded `Parameters` value
- `responsePublisher(as:)` — full `ATResponseV2` with `status`, `headers`, and raw `body`

See `AyantechNetworkingLibraryDemo` for a full example.

```swift
let request = ATRequestV2(
    url: "https://ayantech.ir/some/endpoint/url",
    parameters: MyParameters(paramA: "ValueA", paramB: "ValueB"),
    configuration: .init(token: "your-auth-token")
)

request.valuePublisher(as: MyResponse.self).sink(...).store(in: &cancellables)
```

Use `responsePublisher(as:)` when you want the full `ATResponseV2` and prefer to inspect `status` or `headers` yourself:

```swift
request.responsePublisher(as: MyResponse.self).sink(...).store(in: &cancellables)
```

### V1 (deprecated)

V1 uses the callback-based `send` API. Migrate new code to `ATRequestV2` for typed requests and Combine support.

```swift
// Method can be omitted; the default is GET.
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
| V2 `valuePublisher()` / `responsePublisher()` | Cancel the `AnyCancellable` subscription |
| V1 `send { }` (deprecated) | `request.cancel()` |

Cancelling an `AnyCancellable` cancels the underlying `URLSessionDataTask`. As with standard Combine publishers, cancellation does not emit an additional value or completion.

## Mocking response (V1 only):
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

### ATRequestV2:
| Property | Type | Description |
|:--------:|:----:|-------------|
| url | String | Request url string |
| parameters | Encodable? | Request parameters (encoded into the `Parameters` field) |
| headers | [String: String] | Request headers |
| configuration | ConfigurationV2 | Timeout, default headers, and auth token |

----

### ATResponseV2:
| Property | Type | Description |
|:--------:|:----:|-------------|
| value | Decodable | Decoded `Parameters` object |
| body | Data | Raw response body |
| httpStatusCode | Int | HTTP status code |
| headers | [String: String] | Response headers |
| status | ATStatusV2 | API status object |
| responseString | String? | Raw response body as string |

----

### ATErrorV2:
| Property | Type | Description |
|:--------:|:----:|-------------|
| message | String | Error human-readable string in Farsi |
| errorType | ATErrorTypeV2 | Error type |
| status | ATStatusV2? | API status object (if available) |
| httpStatusCode | Int? | HTTP status code (if available) |
| isTokenExpired | Bool | `true` when the API status code is `G00002` |

----

### ATRequest (deprecated):
| Property |        Type       | Description                                                                                          |
|:--------:|:-----------------:|------------------------------------------------------------------------------------------------------|
| url      | String            | Request url string                                                                                   |
| method   | HTTPMethod        | Request http method (get, post, put, ...)                                                            |
| headers  | [String: String]  | Request headers                                                                                      |
| body     | [String: Any]     | Request parameters (can be body or query params depend on encoding)                                  |
| encoding | ParameterEncoding | Encoding method for body. this variable decides whether body should be query parameters os http body |


----

### ATResponse (deprecated):
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

### ATError (deprecated)
|      Property      |     Type     | Description                          |
|:------------------:|:------------:|--------------------------------------|
| persianDescription | String?      | Error human-readable string in Farsi |
| code               | Int?         | Error code                           |
| type               | ATErrorType? | Error type                           |
| name               | String?      | Error code name                      |


----

### ATErrorType (deprecated)
|     Case    | Description                                                          |
|:-----------:|----------------------------------------------------------------------|
| noInternet  | When the user has no internet connection (neither wifi nor cellular) |
| timeout     | When the request has timed out                                       |
| serverError | When server returns 50x error code                                   |
| cancelled   | When request was cancelled by user                                   |
| general     | None of the above                                                    |
