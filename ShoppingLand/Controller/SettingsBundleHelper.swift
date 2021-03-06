//
//  SettingsBundleHelper.swift
//  ShoppingLand
//
//  Created by Florentin Lupascu on 27/06/2018.
//  Copyright © 2018 Florentin Lupascu. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class SettingsBundleHelper {
    struct SettingsBundleKeys {
        static let Reset = Constants.resetAppKey
        static let BuildVersionKey = Constants.buildVersionKey
        static let AppVersionKey = Constants.appVersionKey
    }
    
    // Function executed when we reset the app from Settings
    class func checkAndExecuteSettings() {
        if UserDefaults.standard.bool(forKey: SettingsBundleKeys.Reset) {
            UserDefaults.standard.set(false, forKey: SettingsBundleKeys.Reset)
            let appDomain: String? = Bundle.main.bundleIdentifier
            UserDefaults.standard.removePersistentDomain(forName: appDomain!)
        }
    }
    
    // Set version for App and Build
    class func setVersionAndBuildNumber() {
        let version: String = Bundle.main.object(forInfoDictionaryKey: Constants.cfBundleShort) as! String
        UserDefaults.standard.set(version, forKey: Constants.versionPreference)
        let build: String = Bundle.main.object(forInfoDictionaryKey: Constants.cfBundleVersion) as! String
        UserDefaults.standard.set(build, forKey: Constants.buildPreference)
    }
}
