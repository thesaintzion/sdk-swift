# Dojah iOS KYC SDK


## Installation

Using SPM add `https://github.com/dojah-inc/sdk-swift.git` as a dependency and set the `Dependency Rule` to the `main` branch.

Add the following keys to your Info.plist file:

- `NSCameraUsageDescription` - describe why your app needs access to the camera. This is called Privacy - Camera Usage Description in the visual editor.

- `NSMicrophoneUsageDescription` - describe why your app needs access to the microphone, if you intend to record videos. This is called Privacy - Microphone Usage Description in the visual editor.


- `NSLocationWhenInUseUsageDescription` - describe why your app needs access to the location, if you intend to verify address/location. This is called Privacy - Location Usage Description in the visual editor.

## Usage

```swift
DojahWidgetSDK.initialize(
    widgetID: {Required: Your_WidgetID},
    referenceID: {Optional: Reference_ID},
    emailAddress: {Optional: Email_Address},
    navController: {Required: UINavigationController Instance}
)
```

### SDK Parameters
- `WidgetID` - a `REQUIRED` parameter. You get this ID when you sign up on the Dojoh platform
- `Reference ID` - an `OPTIONAL` parameter that allows you to initialize the SDK for an ongoing verification.
- `Email Address` - an `OPTIONAL` parameter that allows you to initialize the SDK for an ongoing verification.
- `navController` - a `REQUIRED` parameter. An instance of `UINavigationController` from which the SDK is presented.


## Additional information

Contact Dojah for more options for the config object.
