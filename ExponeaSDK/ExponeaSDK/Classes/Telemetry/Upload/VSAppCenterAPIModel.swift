//
//  VSAppCenterAPIModel.swift
//  ExponeaSDK
//
//  Created by Panaxeo on 18/11/2019.
//  Copyright © 2019 Exponea. All rights reserved.
//

/**
 * This file contains models for Visual Studio App Center Logs API
 * It's only partial model, all required properties and only useful optional ones
 * https://docs.microsoft.com/en-us/appcenter/diagnostics/upload-custom-crashes#upload-a-crash-report
 * https://in.appcenter.ms/preview/swagger.json
 */
struct VSAppCenterAPIRequestData: Encodable {
    let logs: [VSAppCenterAPILog]
}

enum VSAppCenterAPILog {
    case fatalError(VSAppCenterAPIAppleErrorReport)
    case nonFatalError(VSAppCenterAPIHandledErrorReport)
}

extension VSAppCenterAPILog: Encodable {
    func encode(to encoder: Encoder) throws {
        switch self {
        case .fatalError(let fatalError):
            try fatalError.encode(to: encoder)
        case .nonFatalError(let nonFatalError):
            try nonFatalError.encode(to: encoder)
        }
    }
}

struct VSAppCenterAPIHandledErrorReport: Encodable {
    let id: String
    let type: String = "handledError"
    let fatal: Bool = false
    let userId: String?
    let device: VSAppCenterAPIDevice
    let exception: VSAppCenterAPIException
    let timestamp: String
    let appLaunchTimestamp: String

    // Below are fields that are required by App Center, but we don't need them(for now)
    let processId: Int = 0
    let processName: String = "placeholder"
}

struct VSAppCenterAPIAppleErrorReport: Encodable {
    let id: String
    let type: String = "appleError"
    let fatal: Bool = true
    let userId: String?
    let device: VSAppCenterAPIDevice
    let exception: VSAppCenterAPIException
    let timestamp: String
    let appLaunchTimestamp: String

    // Below are fields that are required by App Center, but we don't need them(for now)
    let processId: Int = 0
    let processName: String = "placeholder"
    let applicationPath: String = "iOS/Exponea"
    /**
    * CPU primary architecture.
    * Expected values are as follows:
    * public static primary_i386 = 0x00000007;
    * public static primary_x86_64 = 0x01000007;
    * public static primary_arm = 0x0000000C;
    * public static primary_arm64 = 0x0100000C;
    */
    let primaryArchitectureId: Int = 0x00000007
    let osExceptionType: String
    let osExceptionCode: String = "0"
    let osExceptionAddress: String = "0x00"
    let threads: [VSAppCenterAPIThread] = []
    let binaries: [VSAppCenterAPIBinary] = []
}

struct VSAppCenterAPIThread: Codable {
    let id: Int
    let frames: [VSAppCenterAPIStackFrame]
    let exception: VSAppCenterAPIException
}

struct VSAppCenterAPIStackFrame: Codable {
    let address: String
    let code: String
}

struct VSAppCenterAPIBinary: Codable {
    let id: String = UUID().uuidString
    let startAddress: String = "placeholder_startAddress"
    let endAddress: String = "placeholder_endAddress"
    let name: String = "placeholder_name"
    let path: String = "placeholder_path"
}

struct VSAppCenterAPIDevice: Codable {
    let appNamespace: String
    let appVersion: String
    let appBuild: String
    let sdkName: String
    let sdkVersion: String
    let osName: String
    let osVersion: String
    let model: String?
    let locale: String
}

struct VSAppCenterAPIException: Codable {
    let type: String
    let message: String
    let frames: [VSAppCenterAPIStackFrame]
}
