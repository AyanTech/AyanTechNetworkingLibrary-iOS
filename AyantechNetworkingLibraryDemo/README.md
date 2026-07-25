# AyanTech Networking Library Demo

This UIKit demo shows how to use `AyanTechNetworkingLibrary` with Combine in a small layered architecture. It makes a real request for donation referrer types, converts the response into domain and UI models, sorts the result, and renders it in a view controller.

## Requirements

- iOS 13.0+
- Swift 6.0+
- Xcode 16+

## Running the demo

1. Open `AyantechNetworkingLibraryDemo.xcodeproj`.
2. Select the `AyantechNetworkingLibraryDemo` scheme.
3. Choose an iOS simulator or device and run the app.

The project uses the networking package from the parent repository as a local Swift Package dependency. The sample request intentionally uses an empty token because this endpoint does not require authentication.

## Architecture

The demo follows the conventions of mobile team architecture documentation.

The ViewController sends user actions to the ViewModel, which calls the use case. The use case depends on the repository interface, while the data layer provides its implementation. The repository implementation reads remote data through the data source, and the data source performs requests through `AppNetwork`.

- **UI** observes the ViewModel state and only renders prepared UI models.
- **Domain** contains the repository interface, use case, domain model, and sorting rule.
- **Data** performs the request, decodes DTOs, maps them to domain models, and implements the repository.

`AppDependencies` is the composition root. It creates one shared `AppNetwork` and wires the feature dependencies together. Protocols at the use-case, repository, and remote-data-source boundaries also make each layer replaceable in tests.

## Networking flow

`DonationReferrerTypesRemoteDataSource` reads its endpoint from `DonationReferrerTypesAPI` and sends an empty request DTO through `AppNetwork`.

`AppNetwork` wraps every input in the common Ayan request structure:

```json
{
  "Identity": {
    "Token": ""
  },
  "Parameters": {}
}
```

It then uses `valuePublisher(as:decoder:)` to decode the `Parameters` object into the requested DTO. The library handles the top-level `Status`; the feature DTO only represents the contents of `Parameters`.

The publisher exposes `ATError` through the layers to the ViewModel. The ViewModel converts successful domain models into `ReferrerTypeUIModel` values and converts failures into an error UI state, so the ViewController does not depend on networking errors.
