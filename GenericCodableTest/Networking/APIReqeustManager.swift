
import Foundation
import Alamofire
import UIKit

typealias requestCompletionHandler = (APIJSONReponse) -> Void

class APIReqeustManager: NSObject {
    
    static let sharedInstance = APIReqeustManager()
    fileprivate override init() {
        super.init()
    }
    
    fileprivate func sendRequestWithURL(_ URL: String,
                                        method: HTTPMethod,
                                        queryParameters: [String: String]?,
                                        bodyParameters: [String: AnyObject]?,
                                        headers: [String: String]?,
                                        vc : UIViewController,
                                        completionHandler:@escaping requestCompletionHandler) {
        // If there's a querystring, append it to the URL.
        
        if (Reachablity.sharedInstance.isInternetReachable == false) {
            vc.view.hideAllToasts()
            
            let userInfo: [NSObject : AnyObject] =
            [
                NSLocalizedDescriptionKey as NSObject :  CommonMessages.noInternet as AnyObject,
                NSLocalizedFailureReasonErrorKey as NSObject : CommonMessages.noInternet as AnyObject
            ]
            let error : NSError = NSError(domain: "EnomjiHttpResponseErrorDomain", code: -1, userInfo: userInfo as? [String : Any])
            let wrappedResponse = APIJSONReponse.init(error: error, dataDict: [:])
            completionHandler(wrappedResponse)
            print(error)
            return
        }
        
        let actualURL: String
        if let queryParameters = queryParameters {
            var components = URLComponents(string:URL)!
            components.queryItems = queryParameters.map { (key, value) in URLQueryItem(name: key, value: value) }
            actualURL = components.url!.absoluteString
        } else {
            actualURL = URL
        }
        
        var headerParams: HTTPHeaders?
        
        if let headers = headers {
            headerParams = headers as? HTTPHeaders
        }
        
        
        AF.request(actualURL, method:method, parameters: bodyParameters,encoding: JSONEncoding.default, headers: headerParams)
            .responseJSON { response in
                
                print("Json response: \(response)")
                switch response.result {
                case .success(let dictData):
                    //   if let result = response.result {
                    let JSON = dictData as? [String : Any]
                    
                    let wrappedResponse = APIJSONReponse.init(
                        data: response.data,
                        dict: JSON as Dictionary<String, AnyObject>?,//response.result, //as! Dictionary<String, AnyObject>,
                        response: response.response,
                        error: nil, rpcErrorData: nil)
                    DispatchQueue.main.async(execute: {
                        completionHandler(wrappedResponse)
                    })
                    //  }
                case .failure(let error):
                    let error = error
                    let wrappedResponse = APIJSONReponse.init(error: error, dataDict: [:])
                    completionHandler(wrappedResponse)
                    print(error.localizedDescription)
                }
            }
    }
    
    
    func serviceCall<T: Decodable>(param:[String:Any]?,
                                   queryParam : [String:String]? = nil,
                                   method : HTTPMethod,
                                   model: T.Type,
                                   loaderNeed : Bool,
                                   loaderPosition : ToastPosition = .center,
                                   successMessageParams: String? = nil,
                                   errorMessageParams: String? = nil,
                                   vc:UIViewController,url: String,
                                   isTokenNeeded : Bool,
                                   header : [String : String]? = nil,
                                   isErrorAlertNeeded : Bool,
                                   errorBlock:(()->())? = nil,
                                   actionErrorOrSuccess:((Bool,String) -> ())?,
                                   completionHandler:@escaping requestCompletionHandler) {
        
        let params  = ["jsonrpc" : "2.0", "params" : param ?? nil] as [String : Any?]
        print(params)
        
        sendRequestWithURL(url, method: method, queryParameters: queryParam, bodyParameters: (param != nil) ? (params as [String : AnyObject]?) : nil, headers: ["X-Requested-With" : "XMLHttpRequest"] as? [String : String], vc: vc){
            resp in
            
            print(resp.response ?? "COULDN'T PARSE: \(String(data: resp.data ?? Data(), encoding: .utf8) ?? "")")
            
            vc.view.hideAllToasts(includeActivity: true, clearQueue: true)
            if resp.error != nil{
                if vc.presentedViewController == nil{
                    vc.showSingleButtonAlertWithAction(title: CommonMessages.error, buttonTitle: CommonMessages.ok, message: resp.error?.localizedDescription ?? CommonMessages.somethingWentWrong) {
                        if let nav = vc.navigationController{
                            nav.popToRootViewController(animated: true)
                        }
                    }
                }else{
                    vc.view.makeToast(resp.error?.localizedDescription,duration : 4)
                }
                
                return
            }
            
            else if let err = ((resp.dict?["error"] as? [String : Any])?["message"] as? [String : Any] ?? (resp.dict?["error"] as? [String : Any])){
                if err["code"] as? String == "-33085" {
                    vc.showSingleButtonAlertWithAction(title: CommonMessages.error, buttonTitle: CommonMessages.continueWithLogin, message: err["meaning"] as? String ?? CommonMessages.inactiveState) {
                        vc.checkAndProcessToLogin(from: vc) {
                            //  fromLoginPageCallBack?()
                        }
                    }
                    return
                }else{
                    
                    let error : NSError = NSError(domain: "EnomjiHttpResponseErrorDomain", code: (Int(err["code"] as? String ?? "-1") ?? -1), userInfo: err)
                    let wrappedResponse = APIJSONReponse(data: resp.data, dict: resp.dict, response: resp.response, error: error, rpcErrorData: nil)
                    completionHandler(wrappedResponse)
                    errorBlock?()
                    if isErrorAlertNeeded{
                        vc.showSingleButtonAlertWithAction(title: err["message"] as? String ?? CommonMessages.error, buttonTitle: CommonMessages.ok, message: err[errorMessageParams ?? "meaning"] as? String ?? CommonMessages.somethingWentWrong) {
                            actionErrorOrSuccess?(false, err[errorMessageParams ?? "meaning"] as? String ?? CommonMessages.somethingWentWrong)
                            if err[errorMessageParams ?? "meaning"] as? String == "Authentication Token Expired" {
                                
                            }
                            
                        }
                    }
                }
                
            }
            
            else if resp.error != nil{
                
                completionHandler(resp)
                vc.view.makeToast(resp.error?.localizedDescription ?? CommonMessages.somethingWentWrong)
                
            }else{
                
                let decoder = JSONDecoder()
                if let jsonData = try? decoder.decode(model, from: resp.data ?? Data()) {
                    print("test response: \(jsonData)")
                }
                completionHandler(resp)
            }
            vc.navigationController?.navigationBar.isUserInteractionEnabled = true
            vc.navigationController?.view.isUserInteractionEnabled = true
            vc.view.isUserInteractionEnabled = true
        }
    }
    
    
}







