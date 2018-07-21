# iOS SDK for work with AyanTech web services

use this SDK for communicate with AyanTech web services.

## Installation:
In your project `PodFile` add this line:
```
pod 'AyanTechNetworkingLibrary`
```
And then run `pod install` command from terminal

## Usage:
```swift
//method can be omitted (default is POST)
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