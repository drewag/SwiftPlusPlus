//
//  UserReportableError.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 4/24/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import Foundation

public enum ErrorPerpitrator: String, Codable {
    case user
    case system
    case temporaryEnvironment
}

public protocol AnyErrorReason: class {
    var because: String {get}
}

public final class ErrorReason: AnyErrorReason {
    public let because: String

    public init(_ because: String) {
        self.because = because
    }
}

open class ErrorReasonWithExtraInfo<Params>: AnyErrorReason {
    public let because: String
    public let extraInfo: Params

    init(because: String, extraInfo: Params) {
        self.because = because
        self.extraInfo = extraInfo
    }
}
public protocol ErrorGenerating {}
public protocol ReportableErrorConvertible {
    var reportableError: ReportableError {get}
}
public struct UnknownErrorGenerating: ErrorGenerating {}

open class ReportableError: Error, CustomStringConvertible, Encodable {
    enum CodingKeys: String, CodingKey {
        case message, doing, because, perpitrator
    }

    public let perpetrator: ErrorPerpitrator
    public let doing: String
    public let reason: AnyErrorReason
    public let source: ErrorGenerating.Type

    public init(from source: ErrorGenerating.Type, by: ErrorPerpitrator, doing: String, because: AnyErrorReason) {
        self.source = source
        self.perpetrator = by
        self.doing = doing
        self.reason = because
    }

    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.description, forKey: .message)
        try container.encode(self.doing, forKey: .doing)
        try container.encode(self.reason.because, forKey: .because)
        try container.encode(self.perpetrator, forKey: .perpitrator)
    }
}

public enum ReportableResult<Value> {
    case success(Value)
    case error(ReportableError)
}

extension ReportableError {
    public var alertDescription: (title: String, message: String) {
        var because = self.reason.because
        if because.first != nil {
            let first = because.removeFirst()
            because = "\(first)".capitalized + because
        }
        switch self.perpetrator {
        case .user:
            return (
                title: "Error \(self.doing.capitalized)",
                message: because
            )
        case .system:
            return (
                title: "Error \(self.doing.capitalized)",
                message: "Internal Error. Please try again. If the problem persists please contact support with the following description: Because \(self.reason.because)"
            )
        case .temporaryEnvironment:
            return (
                title: "Temporary Error \(self.doing.capitalized)",
                message: "\(because). Please try again."
            )
        }
    }

    public var description: String {
        switch self.perpetrator {
        case .user:
            return "Error \(self.doing.lowercased()) because \(self.reason.because)"
        case .system:
            return "Error \(self.doing.lowercased()) because of an internal error. Please try again. If the problem persists please contact support with the following description: Because \(self.reason.because)"
        case .temporaryEnvironment:
            return "Temporary Error \(self.doing.lowercased()) because \(self.reason.because). Please try again."
        }
    }

    public func doing(_ doing: String) -> ReportableError {
        return ReportableError(
            from: self.source,
            by: self.perpetrator,
            doing: doing,
            because: self.reason
        )
    }

    public var byUser: ReportableError {
        return ReportableError(
            from: self.source,
            by: .user,
            doing: self.doing,
            because: self.reason
        )
    }

    public func isBecause(of reasons: [AnyErrorReason]) -> Bool {
        return reasons.contains(where: {$0 === self.reason})
    }

    public func isBecause(of reasons: AnyErrorReason ...) -> Bool {
        return self.isBecause(of: reasons)
    }

    public func byUserIfBecauseOf(_ reasons: [AnyErrorReason]) -> ReportableError {
        if self.isBecause(of: reasons) {
            return self.byUser
        }
        else {
            return self
        }
    }

    public func byUserIfBecauseOf(_ reasons: AnyErrorReason ...) -> ReportableError {
        return self.byUserIfBecauseOf(reasons)
    }
}

extension ErrorGenerating {
    public static func executeWhileReattributingErrors<Returning>(
        withReasons reasons: [AnyErrorReason],
        to perpitrator: ErrorPerpitrator,
        andRephrasingAs doing: String? = nil,
        execute: () throws -> Returning
        ) throws -> Returning
    {
        do {
            return try execute()
        }
        catch let error as ReportableError {
            if reasons.contains(where: {$0 === error.reason}) {
                throw ReportableError(
                    from: error.source,
                    by: perpitrator,
                    doing: doing ?? error.doing,
                    because: error.reason
                )
            }
            throw error
        }
    }

    public static func executeWhileReattributingErrors<Returning>(
        from types: [ErrorGenerating.Type]? = nil,
        to perpitrator: ErrorPerpitrator,
        andRephrasingAs doing: String? = nil,
        execute: () throws -> Returning
        ) throws -> Returning
    {
        do {
            return try execute()
        }
        catch let error as ReportableError {
            if (types ?? [self]).contains(where: {$0 == error.source}) {
                throw ReportableError(
                    from: error.source,
                    by: perpitrator,
                    doing: doing ?? error.doing,
                    because: error.reason
                )
            }
            throw error
        }
    }

    public static func executeWhileRephrasingErrors<Returning>(as doing: String, execute: () throws -> Returning) throws -> Returning {
        do {
            return try execute()
        }
        catch let error as ReportableError {
            throw ReportableError(
                from: error.source,
                by: error.perpetrator,
                doing: doing,
                because: error.reason
            )
        }
    }

    public func executeWhileReattributingErrors<Returning>(
        withReasons reasons: [AnyErrorReason],
        to perpitrator: ErrorPerpitrator,
        execute: () throws -> Returning
        ) throws -> Returning
    {
        return try type(of: self).executeWhileReattributingErrors(withReasons: reasons, to: perpitrator, execute: execute)
    }

    public func executeWhileReattributingErrors<Returning>(
        from types: [ErrorGenerating.Type]? = nil,
        to perpitrator: ErrorPerpitrator,
        execute: () throws -> Returning
        ) throws -> Returning
    {
        return try type(of: self).executeWhileReattributingErrors(from: types, to: perpitrator, execute: execute)
    }

    public func executeWhileRephrasingErrors<Returning>(as doing: String, execute: () throws -> Returning) throws -> Returning {
        return try type(of: self).executeWhileRephrasingErrors(as: doing, execute: execute)
    }
}
