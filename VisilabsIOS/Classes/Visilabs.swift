//
//  Visilabs.swift
//  VisilabsIOS
//
//  Created by Egemen on 14.07.2020.
//

//TODO: cocoapods bundle identifier işini çöz

public class Visilabs {
    public class func callAPI() -> VisilabsInstance {
        if let instance = VisilabsManager.sharedInstance.getInstance() {
            return instance
        } else {
            assert(false, "You have to call createAPI before calling the callAPI.")
            return Visilabs.createAPI(organizationId: "", profileId: "", dataSource: "")
        }
    }

    @discardableResult
    public class func createAPI(organizationId: String, profileId: String, dataSource: String, inAppNotificationsEnabled: Bool = false, channel: String = "IOS", requestTimeoutInSeconds: Int = 60, geofenceEnabled: Bool = false, maxGeofenceCount: Int = 20) -> VisilabsInstance {
        VisilabsManager.sharedInstance.initialize(organizationId: organizationId, profileId: profileId, dataSource: dataSource, inAppNotificationsEnabled: inAppNotificationsEnabled, channel: channel, requestTimeoutInSeconds: requestTimeoutInSeconds, geofenceEnabled: geofenceEnabled, maxGeofenceCount: maxGeofenceCount)
    }
}
