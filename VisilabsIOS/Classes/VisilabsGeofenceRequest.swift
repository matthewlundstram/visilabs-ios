//
//  VisilabsGeofenceRequest.swift
//  VisilabsIOS
//
//  Created by Egemen on 1.04.2020.
//

import Foundation

class VisilabsGeofenceRequest: VisilabsAction {
    var action: String
    var actionID: String
    var lastKnownLatitude: Double
    var lastKnownLongitude: Double
    var geofenceID: String
    var isDwell: Bool
    var isEnter: Bool
    
    internal init(action: String, actionID: String, lastKnownLatitude: Double = 0.0, lastKnownLongitude: Double = 0.0, geofenceID: String, isDwell: Bool = false, isEnter: Bool = false) {
        self.action = action
        self.actionID = actionID
        self.lastKnownLatitude = lastKnownLatitude
        self.lastKnownLongitude = lastKnownLongitude
        self.geofenceID = geofenceID
        self.isDwell = isDwell
        self.isEnter = isEnter
        super.init(requestMethod: "GET")
    }
    
    override func buildURL() -> URL? {
        
        if Visilabs.callAPI() == nil || Visilabs.callAPI()!.organizationID.count == 0 || Visilabs.callAPI()!.siteID.count == 0 {
            return nil
        }
        
        var geofenceURL = Visilabs.callAPI()!.geofenceURL
        let queryParameters = getParametersAsQueryString()
        geofenceURL = geofenceURL! + queryParameters!
        return URL(string: geofenceURL!)
    }
    
    private func getParametersAsQueryString() -> String? {
        
        var queryParameters = "?\(VisilabsConfig.ORGANIZATIONID_KEY)=\(Visilabs.callAPI()!.organizationID)&\(VisilabsConfig.SITEID_KEY)=\(Visilabs.callAPI()!.siteID)"

        if Visilabs.callAPI()!.cookieID != nil && Visilabs.callAPI()!.cookieID!.count > 0 {
            let encodedCookieIDValue = Visilabs.callAPI()!.urlEncode(Visilabs.callAPI()!.cookieID!)
            let cookieParameter = "&\(VisilabsConfig.COOKIEID_KEY)=\(encodedCookieIDValue)"
            queryParameters = queryParameters + cookieParameter
        }
        
        if Visilabs.callAPI()!.exVisitorID != nil && Visilabs.callAPI()!.exVisitorID!.count > 0 {
            let encodedExVisitorIDValue = Visilabs.callAPI()!.urlEncode(Visilabs.callAPI()!.exVisitorID!)
            let exVisitorIDParameter = "&\(VisilabsConfig.EXVISITORID_KEY)=\(encodedExVisitorIDValue)"
            queryParameters = queryParameters + exVisitorIDParameter
        }

        if action.count > 0 {
            let encodedActionValue = Visilabs.callAPI()!.urlEncode(action)
            let actionParameter = "&\(VisilabsConfig.ACT_KEY)=\(encodedActionValue)"
            queryParameters = queryParameters + actionParameter
        }
        
        if actionID.count > 0 {
            let encodedActionIDValue = Visilabs.callAPI()!.urlEncode(actionID)
            let actionIDParameter = "&\(VisilabsConfig.ACT_ID_KEY)=\(encodedActionIDValue)"
            queryParameters = queryParameters + actionIDParameter
        }
        
        if Visilabs.callAPI()!.tokenID != nil && Visilabs.callAPI()!.tokenID!.count > 0 {
            let encodedTokenValue = Visilabs.callAPI()!.urlEncode(Visilabs.callAPI()!.tokenID!)
            let tokenParameter = "&\(VisilabsConfig.TOKENID_KEY)=\(encodedTokenValue)"
            queryParameters = queryParameters + tokenParameter
        }
        
        if Visilabs.callAPI()!.appID != nil && Visilabs.callAPI()!.appID!.count > 0 {
            let encodedAppValue = Visilabs.callAPI()!.urlEncode(Visilabs.callAPI()!.appID!)
            let appParameter = "&\(VisilabsConfig.APPID_KEY)=\(encodedAppValue)"
            queryParameters = queryParameters + appParameter
        }
        
        //TODO: Burada büyüktür 0 kontrolü doğru mu sedat'a sor
        if lastKnownLatitude > 0 {
            let encodedLatitudeValue = String(format: "%.013f", lastKnownLatitude)
            let latitudeParameter = "&\(VisilabsConfig.LATITUDE_KEY)=\(encodedLatitudeValue)"
            queryParameters = queryParameters + latitudeParameter
        }

        if lastKnownLongitude > 0 {
            let encodedLongitudeValue = String(format: "%.013f", lastKnownLongitude)
            let longitudeParameter = "&\(VisilabsConfig.LONGITUDE_KEY)=\(encodedLongitudeValue)"
            queryParameters = queryParameters + longitudeParameter
        }
        
        if geofenceID.count > 0 {
            let encodedGeofenceID = Visilabs.callAPI()!.urlEncode(geofenceID)
            let geofenceIDParameter = "&\(VisilabsConfig.GEO_ID_KEY)=\(encodedGeofenceID)"
            queryParameters = queryParameters + geofenceIDParameter
        }
        
        //TODO: OnEnter ve OnExit i VisilabsConfig e koy
        if isDwell {
            if isEnter {
                let triggerEventParameter = "&\(VisilabsConfig.TRIGGER_EVENT_KEY)=\("OnEnter")"
                queryParameters = queryParameters + triggerEventParameter
            } else {
                let triggerEventParameter = "&\(VisilabsConfig.TRIGGER_EVENT_KEY)=\("OnExit")"
                queryParameters = queryParameters + triggerEventParameter
            }
        }
        
        for (key, value) in VisilabsPersistentTargetManager.getParameters() {
            if !key.isEmptyOrWhitespace && !value.isNilOrWhiteSpace {
                queryParameters = "\(queryParameters)&\(key)=\(Visilabs.callAPI()!.urlEncode(value!))"
            }
        }

        return queryParameters
    }
}
