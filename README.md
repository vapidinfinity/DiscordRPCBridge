# DiscordRPCBridge
**by @vapidinfinity**

A Swift framework that sets up a Unix Domain Socket server to listen for Discord IPC connections and bridges activities into a `WKWebView`. It handles handshake, frame processing, and activity injection while maintaining robust client management and detailed logging.

## Features
* Unix Domain Socket server for Discord IPC connections
* Activity injection into a WKWebView via JavaScript
* Handshake and command processing (SET_ACTIVITY, INVITE_BROWSER, etc.)
* Detailed logging with OSLog
* Clean client management and socket handling

## Installation
* Clone the repository.
* Open the project in Xcode.
* Build the project using Xcode’s Product > Build menu.
* Run or debug the application as needed.

## Usage
### Starting the Bridge
```swift
let webView = WKWebView(frame: .zero)
Task {
    await discordRPCBridge.startBridge(for: webView)
}
```

### Stopping the Bridge
```swift
discordRPCBridge.stopBridge()
```

## Project Structure
DiscordRPCBridge.swift
This file contains the core functionality including:
* Unix Domain Socket operations (create, bind, listen, accept connections)
* IPC message parsing and handling (handshake, frame, ping, pong, close)
* Client management via the ClientManager actor
* Activity injection into the Discord web client using JavaScript

## Logging
The framework uses OSLog to output debug, info, and error messages. Check the Xcode console for detailed log output.

## Support
If you like what you see here, you should definitely check out [Mythic](https://github.com/MythicApp/Mythic) -- A game launcher that lets you play Windows on Mac.


## License
idk yet lol
