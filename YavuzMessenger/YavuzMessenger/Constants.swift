//
//  Constants.swift
//  YavuzMessenger
//
//  Created by iOS PSI on 24.10.2022.
//

struct K {
    static let appName = "Yavuz Messenger 💬"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    static let cellNibName = "MessageCell"
    static let cellIdentifier = "ReusableCell"
    
    struct BrandColors{
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lightBlue = "BrandLightBlue"
     }
    
    struct FStore{
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}


