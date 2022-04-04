//
//  EMBaseModel.swift
//  AlmoFire API Calling Example
//
//  Created by Hasya.Panchasara on 03/11/17.
//  Copyright © 2017 Hasya Panchasara. All rights reserved.
//


import Foundation

struct APIResponseStatusKeys {
    static let success = "success"
    static let message = "message"
    static let status = "status"
    static let data = "data"
    static let tokenData = "tokendata"
}

class APIBaseModel {
    
    var status: String?
    var success: String?
    var message : String?
    
    init(jsonDict: Dictionary<String, AnyObject>) {
        
        self.status = jsonDict[APIResponseStatusKeys.status] as? String
        self.message = jsonDict[APIResponseStatusKeys.message] as? String
    }
}

class APIResponseModel {
    
    var status: String?
    var success: String?
    var message : String?
    var data : Dictionary<String,AnyObject>?
    var tokenData : Dictionary<String,AnyObject>?
    
    init(jsonDict: Dictionary<String, AnyObject>) {
        
        self.status = jsonDict[APIResponseStatusKeys.status] as? String
        self.message = jsonDict[APIResponseStatusKeys.message] as? String
        
        if(self.status == APIResponseStatusKeys.success){
            data = jsonDict[APIResponseStatusKeys.data] as? Dictionary<String,AnyObject>
        }
        
        if jsonDict[APIResponseStatusKeys.tokenData] != nil {
            tokenData = jsonDict[APIResponseStatusKeys.tokenData] as? Dictionary<String,AnyObject>
        }
        
    }
}

public class ErrorModel {
    public var code : String?
    public var message : String?
    public var meaning : String?
    public var en : ErrorModel?
    public var status : ErrorModel?
    
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [ErrorModel]
    {
        var models:[ErrorModel] = []
        for item in array
        {
            models.append(ErrorModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary) {
        code = (dictionary["code"] as? String) ?? (dictionary["code"] as? NSNumber)?.description
        message = dictionary["message"] as? String
        meaning = dictionary["meaning"] as? String
        if (dictionary["status"] != nil) { status = ErrorModel(dictionary: dictionary["status"] as? NSDictionary ?? NSDictionary())}
        if (dictionary["en"] != nil) { en = ErrorModel(dictionary: dictionary["en"] as? NSDictionary ?? NSDictionary())}
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.code, forKey: "code")
        dictionary.setValue(self.message, forKey: "message")
        dictionary.setValue(self.meaning, forKey: "meaning")
        dictionary.setValue(self.en?.dictionaryRepresentation(), forKey: "en")
        dictionary.setValue(self.status?.dictionaryRepresentation(), forKey: "status")
        
        return dictionary
    }
}

public class ErrorDataModel {
    public var jsonrpc : String?
    public var error : ErrorModel?
    public var result : ErrorModel?
    public var email : String?
    
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [ErrorDataModel]
    {
        var models:[ErrorDataModel] = []
        for item in array
        {
            models.append(ErrorDataModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary) {
        
        jsonrpc = dictionary["jsonrpc"] as? String
        email = dictionary["email"] as? String
        if (dictionary["error"] != nil) { error = ErrorModel(dictionary: dictionary["error"] as? NSDictionary ?? NSDictionary())}
        if (dictionary["result"] != nil) { result = ErrorModel(dictionary: dictionary["result"] as? NSDictionary ?? NSDictionary())}
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.jsonrpc, forKey: "jsonrpc")
        dictionary.setValue(self.email, forKey: "email")
        dictionary.setValue(self.error?.dictionaryRepresentation(), forKey: "error")
        dictionary.setValue(self.result?.dictionaryRepresentation(), forKey: "result")
        
        return dictionary
    }
    
}

