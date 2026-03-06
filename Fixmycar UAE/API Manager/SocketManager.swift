//
//  SocketManager.swift
//  Fixmycar UAE
//
//  Created on 06/03/26.
//

import Foundation
import SocketIO

class FMSocketManager {

    static let shared = FMSocketManager()

    private var manager: SocketManager?
    private var socket: SocketIOClient?

    // MARK: - Connection Status
    var isConnected: Bool {
        return socket?.status == .connected
    }

    // MARK: - Callbacks
    var onConnect: (() -> Void)?
    var onDisconnect: ((String) -> Void)?
    var onError: ((String) -> Void)?
    var onMessageReceived: ((MessageDetails) -> Void)?
    var onRoomJoined: ((String) -> Void)?

    private init() {}

    // MARK: - Debug Log
    private func log(_ message: String) {
        print("[SOCKET] \(message)")
    }

    // MARK: - Setup & Connect
    func connect() {
        log("========================================")
        log("CONNECTING TO SOCKET...")
        log("URL: \(SOCKET_URL)")

        guard let url = URL(string: SOCKET_URL) else {
            log("ERROR: Invalid socket URL")
            onError?("Invalid socket URL")
            return
        }

        // Get auth token
        let token = UserDefaults.standard.string(forKey: "access_token") ?? ""
        log("Auth Token: \(token)...")

        let config: SocketIOClientConfiguration = [
            .log(true),
            .compress,
            .forceWebsockets(true),
            .connectParams([
                "token": token
            ]),
            .reconnects(true),
            .reconnectAttempts(-1),
            .reconnectWait(3)
        ]

        manager = SocketManager(socketURL: url, config: config)
        socket = manager?.defaultSocket

        setupEventListeners()
        socket?.connect()

        setupEventListeners()
        socket?.connect()
        log("Connection initiated...")
    }

    // MARK: - Disconnect
    func disconnect() {
        log("DISCONNECTING...")
        socket?.disconnect()
        socket = nil
        manager = nil
        log("Disconnected and cleaned up")
    }

    // MARK: - Event Listeners
    private func setupEventListeners() {
        log("Setting up event listeners...")

        // Connection events
        socket?.on(clientEvent: .connect) { [weak self] data, ack in
            self?.log("========================================")
            self?.log("CONNECTED SUCCESSFULLY!")
            self?.log("Socket ID: \(self?.socket?.sid ?? "unknown")")
            self?.log("========================================")
            self?.onConnect?()
        }

        socket?.on(clientEvent: .disconnect) { [weak self] data, ack in
            let reason = data.first as? String ?? "Unknown"
            self?.log("DISCONNECTED: \(reason)")
            self?.onDisconnect?(reason)
        }

        socket?.on(clientEvent: .error) { [weak self] data, ack in
            let error = data.first as? String ?? "Unknown error"
            self?.log("ERROR: \(error)")
            self?.log("Full error data: \(data)")
            self?.onError?(error)
        }

        socket?.on(clientEvent: .reconnect) { [weak self] data, ack in
            self?.log("RECONNECTING... Attempt: \(data)")
        }

        socket?.on(clientEvent: .reconnectAttempt) { [weak self] data, ack in
            self?.log("RECONNECT ATTEMPT: \(data)")
        }

        socket?.on(clientEvent: .statusChange) { [weak self] data, ack in
            self?.log("STATUS CHANGED: \(data)")
        }

        // Custom events
        socket?.on("receive_message") { [weak self] data, ack in
            self?.log("MESSAGE RECEIVED: \(data)")
            self?.handleReceiveMessage(data)
        }

        socket?.on("room_joined") { [weak self] data, ack in
            self?.log("ROOM JOINED: \(data)")
            if let roomId = data.first as? String {
                self?.onRoomJoined?(roomId)
            }
        }

        socket?.on("error") { [weak self] data, ack in
            self?.log("SERVER ERROR: \(data)")
        }

        // Listen to all events for debugging
        socket?.onAny { [weak self] event in
            self?.log("EVENT: \(event.event) | DATA: \(event.items ?? [])")
        }
    }

    // MARK: - Join Room
    func joinRoom(jobId: Int) {
        log("JOIN ROOM - Job ID: \(jobId)")
        log("Is Connected: \(isConnected)")

        guard isConnected else {
            log("ERROR: Cannot join room - Socket not connected")
            onError?("Socket not connected")
            return
        }

        let roomData: [String: Any] = [
            "booking_id": jobId
        ]

        socket?.emit("join_room", roomData)
        log("Emitted join_room event with data: \(roomData)")
    }

    // MARK: - Leave Room
    func leaveRoom(jobId: Int) {
        log("LEAVE ROOM - Job ID: \(jobId)")

        guard isConnected else {
            log("Cannot leave room - Socket not connected")
            return
        }

        let roomData: [String: Any] = [
            "booking_id": jobId
        ]

        socket?.emit("leave_room", roomData)
        log("Emitted leave_room event")
    }

    // MARK: - Send Message
    func sendMessage(jobId: Int, message: String, messageType: String = "text") {
        log("SEND MESSAGE")
        log("Job ID: \(jobId)")
        log("Message: \(message)")
        
        log("Socket Status: \(socket?.status.description ?? "nil")")

        guard isConnected else {
            log("ERROR: Cannot send - Socket not connected")
            onError?("Socket not connected")
            return
        }

        let messageData: [String: Any] = [
            "booking_id": jobId,
            "message": message,
            "message_type": messageType
        ]

        log("Emitting send_message with data: \(messageData)")

        // Try emit with acknowledgment to see if server responds
        socket?.emitWithAck("send_message", messageData).timingOut(after: 5) { [weak self] data in
            self?.log("EMIT ACK RESPONSE: \(data)")
        }

        log("Emit called successfully")
    }

    // MARK: - Handle Received Message
    private func handleReceiveMessage(_ data: [Any]) {
        log("PROCESSING RECEIVED MESSAGE...")
        log("Raw data: \(data)")

        guard let messageDict = data.first as? [String: Any] else {
            log("ERROR: Invalid message format - not a dictionary")
            log("Data type: \(type(of: data.first))")
            return
        }

        log("Message dict: \(messageDict)")

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: messageDict)
            let message = try JSONDecoder().decode(MessageDetails.self, from: jsonData)
            log("Successfully decoded message: \(message.message ?? "")")
            onMessageReceived?(message)
        } catch {
            log("ERROR: Failed to decode message: \(error)")
        }
    }

    // MARK: - Reconnect
    func reconnect() {
        log("MANUAL RECONNECT...")
        disconnect()
        connect()
    }

    // MARK: - Status Check
    func printStatus() {
        log("========================================")
        log("SOCKET STATUS CHECK")
        log("Is Connected: \(isConnected)")
        log("Socket Status: \(socket?.status.description ?? "nil")")
        log("Socket ID: \(socket?.sid ?? "nil")")
        log("Manager: \(manager != nil ? "exists" : "nil")")
        log("Socket: \(socket != nil ? "exists" : "nil")")
        log("========================================")
    }
}
