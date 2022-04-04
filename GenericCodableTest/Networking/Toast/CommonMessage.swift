//
//  CommonMessage.swift
//  Sama Contact Lens
//
//  Created by Convergent Infoware on 09/10/20.
//  Copyright © 2020 Convergent Infoware. All rights reserved.
//

import Foundation

enum ValidatorType : String{
    
    case email = "Please enter a valid email address"
    case password = "Password should be minimum of 8 character, at least one capital letter, one number, one special character from these (@ # $ % & ? ! * )"
    case confirmPassword = "Password and confirm password must be same"
    case language = "Please select language"
    case fname = "Please enter your first name."
    case lname = "Please enter your last name."
    case country = "Please select country from list"
    case mobileNo = "Please enter a valid mobile no."
    case address = "Please type your full address."
    case state = "Please enter your state name."
    case city = "Please enter your city name."
    case zip = "Please enter your zip code."
    case otp = "Please enter a valid one time password."
    case message = "Please enter some message."
    case location = "Please enter location."
    case subject = "Please enter some subject."
    case title = "Please enter title."
    case category = "Please select category."
    case subcategory = "Please select sub category."
    case service = "Please enter service."
    case numofperson = "Please select number of persons."
    case currency = "Please select currency."

    case fromdate = "Please enter from date."
    case todate = "Please enter to date."
    case description = "Please enter description."
    case minbudget = "Please enter minbudget."
    case maxbudget = "Please enter maxbudget."
    case bankname = "Please enter bank name."
    case accNum = "Please enter your acc number."
    case accHoldName = "Please enter Name of the Acc Holder."
    case bankCode = "Please enter Bank code."
    case amount = "Please enter Amount."
    case postcode = "Please enter postcode."

}

class CommonMessages{
    static let tokenExpire = "Your session has expired. Try to relogging your account.".localizedWithLanguage
    static let success = "Successful".localizedWithLanguage
    static let error = "Error".localizedWithLanguage
    static let registerSuccess = "You have been registered successfully".localizedWithLanguage
    static let loginSuccess = "You have been logged in successfully".localizedWithLanguage
    static let ok = "Okay".localizedWithLanguage
    static let alert = "Alert".localizedWithLanguage
    static let authFailed = "Authentication Failed".localizedWithLanguage
    static let continueWithLogin = "Continue with login".localizedWithLanguage
    static let inactiveState = "Your current session is expire.".localizedWithLanguage
    static let logout = "You are logged out from the app. Please re-login".localizedWithLanguage
    static let taskSuccessful = "Your current task successful.".localizedWithLanguage
    static let accountInactiveState = "Your account is currently in inactive or unverified state.".localizedWithLanguage
    static let noInternet = "No Internet Connection is there.".localizedWithLanguage
    static let somethingWentWrong = "Something Went Wrong \n Please Try After Some Time".localizedWithLanguage
    static let messageArchived = "Chat archived successfully".localizedWithLanguage
    static let messageUnArchived = "Chat un-archived successfully".localizedWithLanguage
    static let not_shipable = "We can not ship to this country.".localizedWithLanguage
    static func validationError(of type : ValidatorType) -> String{
        return type.rawValue.localizedWithLanguage
//    static let dispute_created = "We can not ship to this country.".localizedWithLanguage
    }
    
}
