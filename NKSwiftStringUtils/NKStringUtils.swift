/*
 * Copyright (c) 2016 Naresh Kumar
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation
import UIKit

extension String {
    
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
    var isPhoneNumber: Bool {
        
        let charcter  = NSCharacterSet(charactersIn: "+0123456789").inverted
        var filtered:NSString!
        let inputString = self.components(separatedBy: charcter)
        filtered = inputString.joined(separator: "") as NSString!
        return  self == filtered as String
        
    }
    
    func validatePhone(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    func isNumber() -> Bool {
        let numberCharacters = NSCharacterSet.decimalDigits.inverted
        return !self.isEmpty && self.rangeOfCharacter(from: numberCharacters) == nil
    }
    
    func isBackSpaceDetected() -> Bool{
        let  char = self.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        if (isBackSpace == -92) {
            return true
        }
        return false
    }
    
    func isValidIP(s: String) -> Bool {
        let parts = s.components(separatedBy: ".")
        let nums = parts.flatMap { Int($0) }
        return parts.count == 4 && nums.count == 4 && nums.filter { $0 >= 0 && $0 < 256}.count == 4
    }
    
    func isValidURLStringFormat() -> Bool {
        guard let url = NSURL(string: String(self)) else {return false}
        if !UIApplication.shared.canOpenURL(url as URL) {return false}
        
        //
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: String(self))
    }
    
    func maskingPassword(count:Int) -> String {
        var ret:String = ""
        for _ in 0..<count {
            ret.append("*" as Character)
        }
        return ret
    }
    
    func maskingCardNumber() -> String {
        if self.characters.count < 4 {
            return "NA"
        }
        let index = self.index(self.endIndex, offsetBy: -4)
        return "**** **** **** "+self.substring(from:index)
    }

    func maskingCardNumberWithoutSpace() -> String {
        if self.characters.count < 4 {
            return "NA"
        }
        let index = self.index(self.endIndex, offsetBy: -4)
        return "************"+self.substring(from:index)
    }
    
    func removeSpecialCharsFromString() -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890".characters)
        return String(self.characters.filter {okayChars.contains($0) })
    }
    
    func replaceSpecialCharsWithString(string:String) -> String {
        let set = NSCharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890").inverted
        let formatedString = self.components(separatedBy:set).joined(separator: string)
        return formatedString
    }
    
    func removeNonDigitsFromString() -> String {
        let set = NSCharacterSet.decimalDigits.inverted
        let numbers = self.components(separatedBy:set)
        return numbers.joined(separator: "")
    }
    
    func replaceNonDigitsWithString(string:String) -> String {
        let set = NSCharacterSet.decimalDigits.inverted
        let numbers = self.components(separatedBy:set)
        return numbers.joined(separator: string)
    }
    
    func chopPrefix(count: Int = 1) -> String {
        let index = self.index(self.startIndex, offsetBy: count)
        return self.substring(from: index)
    }
    
    func chopSuffix(count: Int = 1) -> String {
        let index = self.index(self.endIndex, offsetBy: -count)
        return self.substring(to: index)
    }
    
    func containsSpecialChars() -> Bool {
        let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: NSRegularExpression.Options())
        if regex.firstMatch(in: String(self), options: NSRegularExpression.MatchingOptions(), range:NSMakeRange(0, String(self).characters.count)) != nil {
            return true
        }
        return false
    }
    
    func containsDigits() -> Bool {
        let regex = try! NSRegularExpression(pattern: ".*[^0-9].*", options: NSRegularExpression.Options())
        if regex.firstMatch(in: String(self), options: NSRegularExpression.MatchingOptions(), range:NSMakeRange(0, String(self).characters.count)) != nil {
            return true
        }
        return false
    }
    
    func containsSpecialCharsWithHyphenAndUnderscore() -> Bool {
        let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z0-9._-].*", options: NSRegularExpression.Options())
        if regex.firstMatch(in: String(self), options: NSRegularExpression.MatchingOptions(), range:NSMakeRange(0, String(self).characters.count)) != nil {
            return true
        }
        return false
    }
    
    func containsStarPound() -> Bool {
        let regex = try! NSRegularExpression(pattern: ".*[*#]+.*", options: NSRegularExpression.Options())
        if regex.firstMatch(in: String(self), options: NSRegularExpression.MatchingOptions(), range:NSMakeRange(0, String(self).characters.count)) != nil {
            return true
        }
        return false
    }
    
    func containsExpression(expression: String) -> Bool {
        return self.lowercased().range(of:expression.lowercased(), options: .regularExpression) != nil
    }
    
    func extractExpression(expression: String) -> String? {
        let regex = try! NSRegularExpression(pattern: expression, options: [])
        let matches = regex.matches(in: self, options: [], range: NSMakeRange(0, self.characters.count))
        return matches.first.map { (self as NSString).substring(with: $0.range) }
    }
    
    func gmtDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone!
        
        return formatter
    }
    
    func toDate() -> NSDate? {
        let dateTimeFormatExpression = "(\\d{4})-(\\d{2})-(\\d{2})T(\\d{2})\\:(\\d{2})\\:(\\d{2})(z|Z)?"
        let dateFormatExpression = "(\\d{4})-(\\d{2})-(\\d{2})"
        
        var (dateString, dateFormat): (String?, String?)
        if (self.characters.last == "z" || self.characters.last == "Z")
            && self.characters.count <= 20
            && self.containsExpression(expression: dateTimeFormatExpression) {
            // String contains a date and time
            dateString = self.extractExpression(expression: dateTimeFormatExpression)
            dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        } else if self.containsExpression(expression: dateFormatExpression) {
            // String contains a date only
            dateString = self.extractExpression(expression: dateFormatExpression)
            dateFormat = "yyyy-MM-dd"
        }
        
        let result: NSDate?
        if let dateString = dateString,
            let dateFormat = dateFormat {
            let formatter = self.gmtDateFormatter()
            formatter.dateFormat = dateFormat
            result = formatter.date(from: dateString) as NSDate?
        } else {
            result = nil
        }
        
        return result
    }
    
}
