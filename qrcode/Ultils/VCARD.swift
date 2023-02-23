//
//  VCARD.swift
//  qrcode
//
//  Created by Quang Tran on 2/8/21.
//

import Foundation

struct VCARD {
    
    var firstName: String = ""
    var lastName: String = ""
    var street: String = ""
    var city: String = ""
    var postCode: String = ""
    var country: String = ""
    var province: String = ""
    var mobileNumber: String = ""
    var phoneNumber: String = ""
    var fax: String = ""
    var email: String = ""
    var website: String = ""
    var birthDay: String = ""
    var company: String = ""
    var title: String = ""
    
    var encoded: String {
        
        return """
        BEGIN:VCARD
        VERSION:3.0
        N:\(lastName);\(firstName)
        FN:\(firstName) \(lastName)
        ORG:\(company)
        TITLE:\(title)
        ADR:;;\(street);\(city);\(province);\(postCode);\(country)
        TEL;WORK;VOICE:\(phoneNumber)
        TEL;CELL:\(mobileNumber)
        TEL;FAX:\(fax)
        EMAIL;WORK;INTERNET:\(email)
        URL:\(website)
        BDAY:\(birthDay)
        END:VCARD
        """
    }
    
    var fields: [QRInputField] {
        return [
            .init(label: .firstName_text, value: firstName),
            .init(label: .lastName_text, value: lastName),
            .init(label: .street_text, value: street),
            .init(label: .city_text, value: city),
            .init(label: .postCode_text, value: postCode),
            .init(label: .country_text, value: country),
            .init(label: .province_text, value: province),
            .init(label: .mobileNumber_text, value: mobileNumber),
            .init(label: .phoneNumber_text, value: phoneNumber),
            .init(label: .fax_text, value: fax),
            .init(label: .email_text, value: email),
            .init(label: .website_text, value: website),
            .init(label: .birthDay_text, value: birthDay),
            .init(label: .company_text, value: company),
            .init(label: .title_text, value: title),
        ]
    }
    
    static func decoded(from code: String) -> VCARD? {
        guard code.matched(regexString: "(?s)BEGIN:VCARD.*END:VCARD")
        
        else { return nil }
        
        var card = VCARD()
        
        if let name = code.firstMatch(for: "N:.*;.*") {
            if let firstName = name.firstMatch(for: "N:.*;") {
                card.firstName = String(firstName.dropFirst(2).dropLast(1))
            }
            
            if let lastName = name.firstMatch(for: ";.*") {
                card.lastName = String(lastName.dropFirst(1))
            }
        }
        
        if let company = code.firstMatch(for: "ORG:.*") {
            card.company = String(company.dropFirst(4))
        }
        
        if let title = code.firstMatch(for: "TITLE:.*") {
            card.title = String(title.dropFirst(6))
        }
        
        if let adr = code.firstMatch(for: "ADR:.*") {
            let components = String(adr.dropFirst(4))
                .components(separatedBy: ";")
            
            if components.indices.contains(2) {
                
                card.street = components[2]
            }
            
            if components.indices.contains(3) {
                
                card.city = components[3]
            }
            
            if components.indices.contains(4) {
                
                card.province = components[4]
            }
            
            if components.indices.contains(5) {
                
                card.postCode = components[5]
            }
            
            if components.indices.contains(6) {
                
                card.country = components[6]
            }
        }
        
        if let phone = code.firstMatch(for: "TEL;WORK;VOICE:.*") {
            card.phoneNumber = String(phone.dropFirst(15))
        }
        
        if let mobile = code.firstMatch(for: "TEL;CELL:.*") {
            card.mobileNumber = String(mobile.dropFirst(9))
        }
        
        if let fax = code.firstMatch(for: "TEL;FAX:.*") {
            card.fax = String(fax.dropFirst(8))
        }
        
        if let email = code.firstMatch(for: "EMAIL;WORK;INTERNET:.*") {
            card.email = String(email.dropFirst(20))
        }
        
        if let text = code.firstMatch(for: "URL:.*") {
            card.website = String(text.dropFirst(4))
        }
        
        return card
    }
}
