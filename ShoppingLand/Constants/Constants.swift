//
//  Constants.swift
//  ShoppingLand
//
//  Created by Florentin Lupascu on 29/06/2018.
//  Copyright © 2018 Florentin Lupascu. All rights reserved.
//

import Foundation
import UIKit

enum Constants {
    
    static let defaultPhotoUser = "DefaultImageUser"
    static let defaultPhotoProduct = "DefaultImageProduct"
    static let nameOfSavedUserPhoto = "saveUserImage"
    static let adminPanelTitle = "Admin Panel"
    static let silverThemeKey = "SilverThemeKey"
    static let silverBackgroundImage = "silverBackground.jpg"
    static let googleAPIUrl = "https://www.googleapis.com/customsearch/v1?q="
    static let googleSearchPhotosOnly = "&imgType=photo&imgSize=medium&searchType=image"
    static let googleSearchEngineID = "&cx=004797504301667307438:v974oybby28"
    static let googleAPIKey = "&key=AIzaSyA_QlOnYMZLbFCV_oh49Z97_tx7zA-Qeig"
    static let websiteAppExperts = "https://theappexperts.co.uk"
    static let productDetailsTitle = "Product Details"
    static let currentUser = "Current user:"
    static let nameRequired = "Name required"
    static let messageNameRequired = "Product name is required !"
    static let categoryRequired = "Category required"
    static let messageCategoryRequired = "Product Category required !"
    static let descriptionRequired = "Description required"
    static let messageDescriptionRequired = "Product Description required !"
    static let priceRequired = "Price required"
    static let messagePriceRequired = "Product Price required !"
    static let done = "Done"
    static let error = "Error"
    static let success = "Success"
    static let messageProductAdded = "Product was added with success !"
    static let messagePhotoSaved = "Photo was saved."
    static let defaultGoogleImage = "ChihuahuaExtreme"
    static let errorURLSesion = "Error URL Session."
    static let urlNotFound = "URL can't be found."
    static let adminPanelStoryboard = "AdminPanelStoryboard"
    static let segueForDetailsPage = "goToDetails"
    static let identifierProductCell = "ProductCell"
    static let errorMessage = "Error. Something is wrong !"
    static let adminSB = "AdminPanel"
    static let productNameLabel = "Name: "
    static let productCategoryLabel = "Category: "
    static let productDescriptionLabel = "Description: "
    static let floatTwoDecimals = "%.2f"
    static let productPriceLabel = "Price: "
    static let amazonURL = "https://www.amazon.co.uk/s/field-keywords="
    static let amazonDefaultSearch = "Learn+Swift+4"
    static let inProgress = "In progress"
    static let messageInProgress = "This feature is under construction..."
    static let identifierCartProductDetailsCell = "cartProductDetailsCell"
    static let identifierCartTotalPriceCell = "cartTotalPriceCell"
    static let currencyPound = " £"
    static let quantityLabel = "Quantity: "
    static let resetAppKey = "RESET_APP_KEY"
    static let buildVersionKey = "BuildVersionKey"
    static let appVersionKey = "AppVersionKey"
    static let productEntity = "Product"
    static let errorDeletingProduct = "Error While Deleting Product: "
    static let errorFetchingData = "Error While Fetching Data From DB: "
    static let loadingMessage = "ShoppingLoad..."
    static let payPalURL = "https://www.paypal.com/uk/home"
    static let allowedCharacters = "0123456789."
    static let accessDeniedCalendar = "Access to use calendar was denied."
    static let reminderTitleBuyProduct = "Reminder to buy: "
    static let reminderMessageBuyProduct = "Don't forget to buy from ShoppingLand your favorite product: "
    static let errorSavingEvent = "Error: Failed while saving event."
    static let eventSavedSuccessfull = "The event was saved successfull. \nCheck you calendar for more details."
    static let requireInternetMessage = "ShoppingLand require Internet Connection"
    static let errorJSONDecode = "Error on JSON Decoding."
    static let defaultProductPhotoURL = "https://s3.amazonaws.com/MarketingFromScratch/images/are-you-missing-something-from-sales.jpg"
    static let pathCoreDB = "\nPath for temporary CoreData DB:\n"
    static let cfBundleShort = "CFBundleShortVersionString"
    static let versionPreference = "version_preference"
    static let cfBundleVersion = "CFBundleVersion"
    static let buildPreference = "build_preference"
    static let lightThemeNotificationKey = "themeSelected.light"
    static let darkThemeNotificationKey = "themeSelected.dark"
    static let accountBalance = "Account Balance: £"
    static let identifierThemeSelection = "ThemeSelection"
}
