//
//  extenstions.swift
//  openlly
//
//  Created by Mobin on 27/12/24.
//
import Foundation

func timeAgo(from date: String) -> String {
     let formatter = ISO8601DateFormatter()
     formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

     if let createdDate = formatter.date(from: date) {
         let now = Date()
         let interval = now.timeIntervalSince(createdDate)
         let seconds = Int(interval)
         if seconds < 60 {
             return "Just now"
         }
         let minutes = Int(interval / 60)
         if minutes < 60 {
             return "\(minutes) min ago"
         }
         let hours = minutes / 60
         if hours < 24 {
             return "\(hours) hr ago"
         }
         let days = hours / 24
         return "\(days) days ago"
     }
     return "Unknown"
 }
