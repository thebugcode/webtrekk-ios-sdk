//The MIT License (MIT)
//
//Copyright (c) 2016 Webtrekk GmbH
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the
//"Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish,
//distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject
//to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
//CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
//SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//  Created by arsen.vartbaronov on 07/09/16.
//

import UIKit

class DeepLink: NSObject{
    
    private let sharedDefaults = UserDefaults.standardDefaults.child(namespace: "webtrekk")
    static let savedDeepLinkMediaCode = "mediaCodeForDeepLink"
    
    // add wt_application to delegation class in runtime and switch implementation with application func
    @nonobjc
    func deepLinkInit(){
        let replacedSel = #selector(wt_application(_:continueUserActivity:restorationHandler:))
        
        var methodCount: UInt32 = 0
        
        // get class of delegate instance
        guard let delgate = UIApplication.shared.delegate,
              let delegateClass = object_getClass(delgate) else {
            return
        }
        
        let methodCheck = class_getInstanceMethod(delegateClass, replacedSel)
        
        // check if there is no such method. Otherwise exit as no repeat operation can be done
        guard  methodCheck == nil else {
            return
        }
        
        //get all methods of delegeta class
        var methods = class_copyMethodList(delegateClass, &methodCount)
        
        if methods != nil {
            let count = Int(methodCount)
            
            defer {
                methods!.deinitialize()
                methods!.deallocate(capacity: count)
            }
            // go throught all methods
            for i in 0..<count {
                let method : Method = methods![i]!
                let methodSel = method_getName(method)
                let methodName = String(cString: sel_getName(methodSel))
                
                //if appplication with continueUserActivity found replace this method
                if methodName == "application:continueUserActivity:restorationHandler:" {
                    // firstly add method to delegate class
                    if addMethodFromAnotherClass(toClass: delegateClass,
                      methodSelector:replacedSel, fromClass: DeepLink.self) {
                    
                        // next change implementation of two methods
                        if swizzleMethod(ofType: delegateClass, fromSelector: methodSel!, toSelector: replacedSel) {
                            WebtrekkTracking.defaultLogger.logDebug("swizzle Deep Link successfully")
                        } else {
                            WebtrekkTracking.defaultLogger.logError("Cann't swizzle Deep Link")
                        }
                    } else {
                        WebtrekkTracking.defaultLogger.logError("Can't add new method to delegate class.")
                    }
                    
                    break;
                }
            }
        }
        
        
    }
    
    // method that replaces application in delegate
    @objc(wt_application:continueUserActivity:restorationHandler:)
    dynamic func wt_application(_ application: UIApplication,
                     continueUserActivity userActivity: NSUserActivity,
                                          restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        
        // test if this is deep link
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
                let url = userActivity.webpageURL,
                let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
                let queryItems = components.queryItems{
            
            WebtrekkTracking.defaultLogger.logDebug("Deep link is received")
            
            // as this implementation is added to another class with swizzle we can't use local parameters
            let track = WebtrekkTracking.instance()
            
            //loop for all parameters
            for queryItem in queryItems {
                //if parameter is everID set it
                if queryItem.name == "wt_everID" {
                    
                    if let value = queryItem.value  {
                        // check if ever id has correct format 19 digits.
                        if let isMatched = value.isMatchForRegularExpression("\\d{19}") , isMatched {
                            track.everId = value
                            WebtrekkTracking.defaultLogger.logDebug("Ever id from Deep link is set")
                        } else {
                            WebtrekkTracking.defaultLogger.logError("Incorrect everid: \(queryItem.value)")
                        }
                    } else {
                      WebtrekkTracking.defaultLogger.logError("Everid is empty in request")
                    }
                }
                //if parameter is media code set it
                if queryItem.name == "wt_mediaCode", let value = queryItem.value {
                    track.mediaCode = value
                    WebtrekkTracking.defaultLogger.logDebug("Media code from Deep link is set")
                }
            }
        }
        
        return self.wt_application(application, continueUserActivity: userActivity, restorationHandler: restorationHandler)
    }
    
    // returns media code and delete it from settings
    func getAndDeletSavedDeepLinkMediaCode() -> String?{
        let mediaCode = self.sharedDefaults.stringForKey(DeepLink.savedDeepLinkMediaCode)
        
        if let _ = mediaCode {
            self.sharedDefaults.remove(key: DeepLink.savedDeepLinkMediaCode)
        }
        
        return mediaCode
    }
    
    //save media code to settings
    func setMediaCode(_ mediaCode: String)
    {
        self.sharedDefaults.set(key: DeepLink.savedDeepLinkMediaCode, to: mediaCode)
    }

}
