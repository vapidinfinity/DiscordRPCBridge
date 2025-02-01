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
Copyright © 2025 vapidinfinity

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
