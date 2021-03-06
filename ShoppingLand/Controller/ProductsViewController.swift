//
//  ViewController.swift
//  ComputersLand
//
//  Created by Florentin Lupascu on 21/06/2018.
//  Copyright © 2018 Florentin Lupascu. All rights reserved.
//

import UIKit
import Foundation
import Kingfisher
import CoreData
import KRProgressHUD
import SCLAlertView
import EFInternetIndicator

class ProductsViewController: UIViewController, CellDelegate, InternetStatusIndicable {
    
    // Interface Links
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var numberOfProductsInCartLabel: UILabel!
    @IBOutlet weak var shoppingCartButton: UIButton!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var helloUserLabel: UILabel!
    
    // Properties
    var counterItem = 0
    var query: String?
    var googlePhotosArray = [Item]()
    var selectedProductsArray = [Product]()
    var priceForSelectedProductsArray = [Float]()
    var internetConnectionIndicator:InternetViewIndicator?
    
    // Life Cycle States
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        KRProgressHUD.show(withMessage: Constants.loadingMessage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateProducts()
        DispatchQueue.main.asyncAfter(deadline: .now()+1) { KRProgressHUD.dismiss() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerSettingsBundle()
        // Use Notification Pattern to detect when the background was changed
        NotificationCenter.default.addObserver(self, selector: #selector(ProductsViewController.defaultsChanged), name: UserDefaults.didChangeNotification, object: nil)
        defaultsChanged()
        updateProducts()
        self.startMonitoringInternet(backgroundColor:UIColor.red, style: .statusLine, textColor:UIColor.white, message:Constants.requireInternetMessage)
    }
    
    // Function to update the Products Table View
    func updateProducts(){
        
        getUserPhoto()
        updateNoOfProductsOnIcons()
        accessToAdminPanel()
        fetchPhotosForProductsFromGoogle()
        
        numberOfProductsInCartLabel.layer.cornerRadius = numberOfProductsInCartLabel.frame.size.height / 2
        
        do{
            productsArray = try context.fetch(Product.fetchRequest())
            
            // Remove last cell from TableView
            productsTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: productsTableView.frame.size.width, height: 1))
            
            productsTableView.rowHeight = 150
            productsTableView.estimatedRowHeight = 150
            
            productsTableView.reloadData()
        }
        catch{
            DispatchQueue.main.async { SCLAlertView().showError(Constants.error, subTitle: Constants.errorMessage) }
        }
    }
    
    // Download photos from Google for products avatar
    func fetchPhotosForProductsFromGoogle(){
        
        for eachProduct in productsArray{
            
            let productNameWithSpaces = eachProduct.name!
            query = productNameWithSpaces.replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
        }
        guard let requestURL = URL(string: URLGoogle.googleAPIUrl + "\(query ?? Constants.defaultGoogleImage)" + URLGoogle.googleSearchPhotosOnly + URLGoogle.googleSearchEngineID + URLGoogle.googleAPIKey)
            else { fatalError(Constants.urlNotFound) }
        print(requestURL)
        URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            
            guard error == nil else {
                DispatchQueue.main.async { SCLAlertView().showError(Constants.error, subTitle: Constants.errorURLSesion) }
                return
            }
            do {
                let googlePhotosList = try JSONDecoder().decode(GoogleSearchModel.self, from: data!)
                
                self.googlePhotosArray = self.googlePhotosArray + googlePhotosList.items
            } catch {
                // When the limit of 100 requests for Google Photos was reached then this Alert will pop-up every time when you click on Products Tab so leave this line commented until you subscribe at Google for more requests per day.
                //DispatchQueue.main.async { SCLAlertView().showError(Constants.error, subTitle: Constants.errorJSONDecode) }
            }
            DispatchQueue.main.async {
                
                self.productsTableView.reloadData()
            }
            }.resume()
    }
    
    // Function used to load the selected User Photo
    func getUserPhoto(){
        
        // Decode the selected user photo
        guard let data = UserDefaults.standard.object(forKey: Constants.nameOfSavedUserPhoto) as? NSData else{
            userAvatarImageView.image = UIImage(named: Constants.defaultPhotoUser)
            return
        }
        userAvatarImageView.image = UIImage(data: data as Data)
        userAvatarImageView.contentMode = .scaleToFill
    }
    
    // Function to send details about a product from this VC to another VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let selectedIndexPath = productsTableView.indexPathForSelectedRow{
            let detailsVC = segue.destination as! ProductDetailsViewController
            
            detailsVC.selectedProduct = productsArray[selectedIndexPath.row]
            detailsVC.getGooglePhotosArray = self.googlePhotosArray
        }
    }
    
    // Func to update the number of products on the carts
    func updateNoOfProductsOnIcons(){
        
        counterItem = ((self.tabBarController?.viewControllers![1] as! UINavigationController).topViewController as! CartViewController).productsInCartArray.count
        
        UIApplication.shared.applicationIconBadgeNumber = counterItem
        numberOfProductsInCartLabel.text = String(counterItem)
    }
    
    // Navigate to Cart when you click the basket icon
    @IBAction func shoppingCartButton(_ sender: UIButton) {
        tabBarController?.selectedIndex = 1
    }
    
    // Func which is using GestureRecognition to access the Admin Panel when we press on User Avatar
    func accessToAdminPanel(){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProductsViewController.adminImageTapped(gesture:)))
        
        userAvatarImageView.addGestureRecognizer(tapGesture)
    }
    
    // Function to open the AdminPanelViewController
    @objc func adminImageTapped(gesture: UIGestureRecognizer) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: Constants.adminSB, bundle:nil)
        let adminPanelVC = storyBoard.instantiateViewController(withIdentifier: Constants.adminPanelStoryboard) as! AdminPanelViewController
        self.navigationController?.pushViewController(adminPanelVC, animated: true)
    }
    
    // Func to register the Settings Bundle when the app start
    func registerSettingsBundle(){
        let appDefaults = [String:AnyObject]()
        UserDefaults.standard.register(defaults: appDefaults)
    }
    
    // Func which is called when we modify the default settings in the bundle
    @objc func defaultsChanged(){
        if UserDefaults.standard.bool(forKey: Constants.silverThemeKey) {
            
            let silverBackground = UIImageView(image: UIImage(named: Constants.silverBackgroundImage))
            silverBackground.frame = self.productsTableView.frame
            self.productsTableView.backgroundView = silverBackground
            self.view.backgroundColor = UIColor.lightGray
        }
        else {
            self.productsTableView.backgroundView = UIImageView()
            self.view.backgroundColor = UIColor.white
        }
    }
    
    // Function to get the CGPoint position of Add To Cart buton.
    func addProductToCartButton(_ sender: UIButton) {
        
        let buttonPosition : CGPoint = sender.convert(sender.bounds.origin, to: self.productsTableView)
        let indexPath = self.productsTableView.indexPathForRow(at: buttonPosition)!
        addProduct(at: indexPath)
    }
    
    // Function to animate the product from respective position to the Cart icon position.
    func addProduct(at indexPath: IndexPath) {
        let cell = productsTableView.cellForRow(at: indexPath) as! ProductTableViewCell
        
        let imageViewPosition : CGPoint = cell.productImageView.convert(cell.productImageView.bounds.origin, to: self.view)
        
        let imgViewTemp = UIImageView(frame: CGRect(x: imageViewPosition.x, y: imageViewPosition.y, width: cell.productImageView.frame.size.width, height: cell.productImageView.frame.size.height))
        
        imgViewTemp.image = cell.productImageView.image
        
        animationProduct(tempView: imgViewTemp)
    }
    
    // Function to animate the product into the Cart
    func animationProduct(tempView : UIView)  {
        self.view.addSubview(tempView)
        UIView.animate(withDuration: 1.0,
                       animations: {
                        tempView.animationZoom(scaleX: 1.5, y: 1.5)
        }, completion: { _ in
            
            UIView.animate(withDuration: 0.5, animations: {
                
                tempView.animationZoom(scaleX: 0.2, y: 0.2)
                tempView.animationRoted(angle: CGFloat(Double.pi))
                
                tempView.frame.origin.x = self.shoppingCartButton.frame.origin.x
                tempView.frame.origin.y = self.shoppingCartButton.frame.origin.y
                
            }, completion: { _ in
                
                tempView.removeFromSuperview()
                
                UIView.animate(withDuration: 1.0, animations: {
                    
                    self.counterItem += 1
                    self.numberOfProductsInCartLabel.text = String(self.counterItem)
                    self.tabBarController?.tabBar.items?[1].badgeValue = String(self.counterItem)
                    self.shoppingCartButton.animationZoom(scaleX: 1.3, y: 1.3)
                    
                }, completion: {_ in
                    self.shoppingCartButton.animationZoom(scaleX: 1.0, y: 1.0)
                })
            })
        })
    }
    
    // Func which will add the product into an array of products when the user press Add To Cart
    func didTapAddToCart(_ cell: ProductTableViewCell) {
        let indexPath = self.productsTableView.indexPath(for: cell)
        
        addProduct(at: indexPath!)
        selectedProductsArray.append(productsArray[(indexPath?.row)!]) // Append products for cart
        priceForSelectedProductsArray.append(productsArray[(indexPath?.row)!].price) // Append prices for selected products
    }
}

// ProductsTableView Protocols
extension ProductsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return productsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = productsTableView.dequeueReusableCell(withIdentifier: Constants.identifierProductCell, for: indexPath) as! ProductTableViewCell
        cell.delegate = self
        
        cell.productTitleLabel.text = productsArray[indexPath.row].name!
        cell.productDescriptionLabel.text = productsArray[indexPath.row].prodDescription!
        cell.productPriceLabel.text = String(format: Constants.floatTwoDecimals, productsArray[indexPath.row].price) + Constants.currencyPound
        
        DispatchQueue.main.async {
            let productPhotoURL = self.googlePhotosArray.first?.link ?? Constants.defaultProductPhotoURL
            let resourcePhoto = ImageResource(downloadURL: URL(string: productPhotoURL)!, cacheKey: productPhotoURL)
            
            cell.productImageView.kf.setImage(with: resourcePhoto)
        }
        
        // Customize AddToCart btn
        cell.addToCartBtn.layer.cornerRadius = 8
        cell.addToCartBtn.layer.borderWidth = 2
        cell.addToCartBtn.layer.borderColor = UIColor.white.cgColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: Constants.segueForDetailsPage, sender: indexPath)
    }
    
    // Remove all products from the cart when one ore more products are deleted from the CoreData.
    func removeAllProductsFromCart(){
        
        selectedProductsArray = [Product]()
        priceForSelectedProductsArray = [Float]()
        counterItem = 0
        numberOfProductsInCartLabel.text = String(0)
        self.tabBarController?.tabBar.items?[1].badgeValue = String(0)
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    // Function to delete a Product from the table view and also from CoreData
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let productEntity = Constants.productEntity
        let product = productsArray[indexPath.row]
        
        if editingStyle == .delete {
            context.delete(product)
            do {
                try context.save()
                removeAllProductsFromCart()
            } catch _ as NSError {
                DispatchQueue.main.async { SCLAlertView().showError(Constants.error, subTitle: Constants.errorDeletingProduct) }
            }
        }
        
        // fetch new data from DB and reload products table view
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: productEntity)
        do {
            productsArray = try context.fetch(fetchRequest) as! [Product]
        } catch _ as NSError {
            DispatchQueue.main.async { SCLAlertView().showError(Constants.error, subTitle: Constants.errorFetchingData) }
        }
        productsTableView.reloadData()
    }
}

// Extension for zoom animation when the user add a product in the Cart
extension UIView{
    func animationZoom(scaleX: CGFloat, y: CGFloat) {
        self.transform = CGAffineTransform(scaleX: scaleX, y: y)
    }
    
    func animationRoted(angle : CGFloat) {
        self.transform = self.transform.rotated(by: angle)
    }
}

// Set URL Google
extension URLGoogle{
    static let googleAPIUrl = Constants.googleAPIUrl
    static let googleSearchPhotosOnly = Constants.googleSearchPhotosOnly
    static let googleSearchEngineID = Constants.googleSearchEngineID
    static let googleAPIKey = Constants.googleAPIKey
}


