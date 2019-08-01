//
//  Date+Formatting.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 10/9/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import Foundation

private let dateAndTimeFormatter: DateFormatter = {
    var dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier:"en_US_POSIX")
    dateFormatter.dateFormat = "yyyy'-'MM'-'dd' at 'hh:mm a"
    return dateFormatter
}()

private let timeFormatter: DateFormatter = {
    var dateFormatter = DateFormatter()
    dateFormatter.timeStyle = .short
    return dateFormatter
}()

private let dateFormatter: DateFormatter = {
    var dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier:"en_US_POSIX")
    dateFormatter.dateFormat = "MMM. dd, yyyy"
    return dateFormatter
}()

private let shortDateFormatter: DateFormatter = {
    var dateFormatter = DateFormatter()
    dateFormatter.setLocalizedDateFormatFromTemplate("MMddyyyy")
    return dateFormatter
}()

private let shortestDateFormatter: DateFormatter = {
    var dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    return dateFormatter
}()

private let dayAndMonthFormatter: DateFormatter = {
    var dateFormatter = DateFormatter()
    dateFormatter.setLocalizedDateFormatFromTemplate("MMdd")
    return dateFormatter
}()

private let monthAndYearFormatter: DateFormatter = {
    var dateFormatter = DateFormatter()
    dateFormatter.setLocalizedDateFormatFromTemplate("MMyyyy")
    return dateFormatter
}()

private let longMonthAndYearFormatter: DateFormatter = {
    var dateFormatter = DateFormatter()
    dateFormatter.setLocalizedDateFormatFromTemplate("MMMMyyyy")
    return dateFormatter
}()

private let monthFormatter: DateFormatter = {
    var dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier:"en_US_POSIX")
    dateFormatter.dateFormat = "MMMM"
    return dateFormatter
}()

private let yearFormatter: DateFormatter = {
    var dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier:"en_US_POSIX")
    dateFormatter.dateFormat = "yyyy"
    return dateFormatter
}()

private let gmtDateTimeFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier:"en_US_POSIX")
    dateFormatter.timeZone = TimeZone(identifier: "GMT")
    dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss 'GMT'"
    return dateFormatter
}()

private let railsDateTimeFormatter: DateFormatter = {
    var dateFormatter = DateFormatter()
    let timeZone = TimeZone(identifier: "UTC")
    dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
    dateFormatter.locale = Locale(identifier: "en_US")
    dateFormatter.timeZone = timeZone
    return dateFormatter
}()

public let ISO8601DateTimeFormatters: [DateFormatter] = {
    var dateFormatter1 = DateFormatter()
    let timeZone = TimeZone(identifier: "UTC")
    dateFormatter1.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'S'Z'"
    dateFormatter1.locale = Locale(identifier: "en_US")
    dateFormatter1.timeZone = timeZone

    var dateFormatter2 = DateFormatter()
    dateFormatter2.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss'.'S'Z'"
    dateFormatter2.locale = Locale(identifier: "en_US")
    dateFormatter2.timeZone = timeZone

    var dateFormatter3 = DateFormatter()
    dateFormatter3.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss'.'SSSSSS'Z'"
    dateFormatter3.locale = Locale(identifier: "en_US")
    dateFormatter3.timeZone = timeZone

    var dateFormatter4 = DateFormatter()
    dateFormatter4.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSSSS'Z'"
    dateFormatter4.locale = Locale(identifier: "en_US")
    dateFormatter4.timeZone = timeZone

    var dateFormatter5 = DateFormatter()
    dateFormatter5.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss'Z'"
    dateFormatter5.locale = Locale(identifier: "en_US")
    dateFormatter5.timeZone = timeZone

    return [dateFormatter1, dateFormatter2, dateFormatter3, dateFormatter4, dateFormatter5]
}()

private let localIso8601DateTimeFormatter: DateFormatter = {
    var dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'S"
    dateFormatter.locale = Locale(identifier: "en_US")
    return dateFormatter
}()

private let railsDateFormatter: DateFormatter = {
    var dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy'-'MM'-'dd"
    return dateFormatter
}()

private let authTokenDate: DateFormatter = {
    var dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "ddMMyyyy"
    return dateFormatter
}()

private let preciseTimeFormatter: DateFormatter = {
    var dateFormatter = DateFormatter()
    let timeZone = TimeZone(identifier: "UTC")
    dateFormatter.dateFormat = "HH':'mm':'ss"
    dateFormatter.timeZone = timeZone
    return dateFormatter
}()

extension Date {
    public var dateAndTime: String {
        return dateAndTimeFormatter.string(from: self)
    }

    public var date: String {
        return dateFormatter.string(from: self)
    }

    public var time: String {
        return timeFormatter.string(from: self)
    }

    public var shortDate: String {
        return shortDateFormatter.string(from: self)
    }

    public var shortestDate: String {
        return shortestDateFormatter.string(from: self)
    }

    public var dayAndMonth: String {
        return dayAndMonthFormatter.string(from: self)
    }

    public var monthAndYear: String {
        return monthAndYearFormatter.string(from: self)
    }

    public var longMonthAndYear: String {
        return longMonthAndYearFormatter.string(from: self)
    }

    public var month: String {
        return monthFormatter.string(from: self)
    }

    public var year: String {
        return yearFormatter.string(from: self)
    }

    public var railsDateTime: String {
        return railsDateTimeFormatter.string(from: self)
    }

    public var gmtDateTime: String {
        return gmtDateTimeFormatter.string(from: self)
    }

    public var iso8601DateTime: String {
        return ISO8601DateTimeFormatters.first!.string(from: self)
    }

    public var localIso8601DateTime: String {
        return localIso8601DateTimeFormatter.string(from: self)
    }

    public var sqliteDateTime: String {
        return railsDateTimeFormatter.string(from: self)
    }

    public var railsDate: String {
        return railsDateFormatter.string(from: self)
    }

    public var sqliteDate: String {
        return railsDateFormatter.string(from: self)
    }

    public var authToken: String {
        return authTokenDate.string(from: self)
    }

    public var preciseTime: String {
        return preciseTimeFormatter.string(from: self)
    }
}

extension String {
    public var railsDateTime: Date? {
        return railsDateTimeFormatter.date(from: self)
    }

    public var railsDate: Date? {
        return railsDateFormatter.date(from: self)
    }

    public var shortDate: Date? {
        return shortDateFormatter.date(from: self)
    }

    public var gmtDate: Date? {
        return gmtDateTimeFormatter.date(from: self)
    }

    public var iso8601DateTime: Date? {
        for formatter in ISO8601DateTimeFormatters {
            if let date = formatter.date(from: self) {
                return date
            }
        }
        return nil
    }

    public func asIso8601DateTime() throws -> Date {
        guard let date = self.iso8601DateTime else {
            throw GenericSwiftlierError("parsing date", because: "the date is invalid")
        }
        return date
    }

    public var localIso8601DateTime: Date? {
        var finalString = self.replacingOccurrences(of: " ", with: "T")
        if !finalString.contains(".") {
            finalString += ".0"
        }
        return localIso8601DateTimeFormatter.date(from: finalString)
    }

    public var date: Date? {
        return dateFormatter.date(from: self)
    }
}
