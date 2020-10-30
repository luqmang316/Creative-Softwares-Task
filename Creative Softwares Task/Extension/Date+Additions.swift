//
//  String+Additions.swift
//  Creative Softwares Task
//
//  Created by Muhammad Luqman on 10/30/20.
//

import Foundation

extension Date {
    
    func dateString(formate: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = formate
        return dateFormatter.string(from: self)
    }
    
}
