//
//  FormatterManager.swift
//  TheBoyage
//
//  Created by Madeline on 4/15/24.
//

import Foundation

class FormatterManager {
    static let shared = FormatterManager()
    
    private init() { }
    
    // MARK: "yyyy.MM.dd 요일" Date -> String
    func formatDateWithDayToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy.MM.dd EEEE"
        return dateFormatter.string(from: date)
    }
    
    func formatStringToDate(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.date(from: dateString) ?? Date()
    }
}
