//
//  UnixDomainSocket.swift
//  DiscordRPCBridge
//
//  Created by vapidinfinity (esi) on 2/2/2025.
//

import Foundation
import OSLog
import Darwin

/// Structure handling Unix Domain Socket operations.
public struct UnixDomainSocket {
    private static let logger = Logger(
        subsystem: (Bundle.main.bundleIdentifier?.appending(".") ?? "") + "DiscordRPCBridge",
        category: "unixDomainSocket"
    )

    /**
     Creates a Unix Domain Socket at the specified path.

     - Parameter path: The socket file path.
     - Returns: The file descriptor of the created socket, or a negative value on failure.
     */
    public static func create(atPath path: String) -> Int32 {
        let fileDescriptor = socket(AF_UNIX, SOCK_STREAM, 0)
        if fileDescriptor < 0 {
            self.logger.error("Failed to create socket at \(path)")
        } else {
            self.logger.debug("Created socket with FD \(fileDescriptor) at \(path)")
            // Prevent SIGPIPE from terminating the process
            var set: Int32 = 1
            if setsockopt(fileDescriptor, SOL_SOCKET, SO_NOSIGPIPE, &set, socklen_t(MemoryLayout<Int32>.size)) == -1 {
                self.logger.error("Failed to set SO_NOSIGPIPE on socket \(fileDescriptor)")
            } else {
                self.logger.debug("SO_NOSIGPIPE set on socket \(fileDescriptor)")
            }
        }
        return fileDescriptor
    }

    /**
     Connects to a Unix Domain Socket at the specified path.

     - Parameters:
     - fileDescriptor: The socket file descriptor.
     - path: The socket file path.
     - Returns: `true` if the connection is successful, otherwise `false`.
     */
    public static func connect(fileDescriptor: Int32, toPath path: String) -> Bool {
        var address = sockaddr_un()
        address.sun_family = sa_family_t(AF_UNIX)
        strncpy(&address.sun_path.0, path, MemoryLayout.size(ofValue: address.sun_path) - 1)
        let addressLength = socklen_t(MemoryLayout<sockaddr_un>.size)

        if Darwin.connect(fileDescriptor, withUnsafePointer(to: &address) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { $0 }
        }, addressLength) < 0 {
            self.logger.debug("Socket at \(path) is unused.")
            return false
        }

        self.logger.debug("Successfully connected to socket at \(path)")
        close(fileDescriptor)
        return true
    }

    /**
     Binds the socket to the specified path.

     - Parameters:
     - fileDescriptor: The socket file descriptor.
     - path: The socket file path.
     - Returns: `true` if binding is successful, otherwise `false`.
     */
    public static func bind(fileDescriptor: Int32, toPath path: String) -> Bool {
        var address = sockaddr_un()
        address.sun_family = sa_family_t(AF_UNIX)
        strncpy(&address.sun_path.0, path, MemoryLayout.size(ofValue: address.sun_path) - 1)
        let addressLength = socklen_t(MemoryLayout<sockaddr_un>.size)

        if Darwin.bind(fileDescriptor, withUnsafePointer(to: &address) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { $0 }
        }, addressLength) < 0 {
            self.logger.error("Failed to bind socket to \(path)")
            return false
        }
        self.logger.debug("Successfully bound socket to \(path)")
        return true
    }

    /**
     Listens for incoming connections on the socket.

     - Parameter fileDescriptor: The socket file descriptor.
     */
    public static func listen(on fileDescriptor: Int32) {
        if Darwin.listen(fileDescriptor, 128) < 0 {
            self.logger.error("Failed to listen on FD \(fileDescriptor), errno=\(errno)")
        } else {
            self.logger.debug("Listening on FD \(fileDescriptor)")
        }
    }

    /**
     Accepts a new connection on the given socket file descriptor.

     - Parameter fileDescriptor: The socket file descriptor.
     - Returns: The file descriptor of the accepted connection, or a negative value on failure.
     */
    public static func acceptConnection(on fileDescriptor: Int32) -> Int32 {
        let clientFileDescriptor = accept(fileDescriptor, nil, nil)
        if clientFileDescriptor < 0 {
            self.logger.error("Failed to accept connection on FD \(fileDescriptor), errno=\(errno)")
        } else {
            self.logger.debug("Accepted new connection with FD \(clientFileDescriptor) on socket FD \(fileDescriptor)")
        }
        return clientFileDescriptor
    }
}
