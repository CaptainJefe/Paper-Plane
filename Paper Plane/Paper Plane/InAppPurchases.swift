//
//  InAppPurchases.swift
//  Paper Plane
//
//  Created by Cade Williams on 4/14/24.
//  Copyright © 2024 Cade Williams. All rights reserved.
//


import Foundation
import StoreKit
import SystemConfiguration

@MainActor
class InAppPurchases: NSObject, ObservableObject {
    
    private let productIds = ["remove_ads"]
    
    @Published
    private(set) var products: [Product] = []
    @Published
    private(set) var purchasedProductIDs = Set<String>()
    
    private var productsLoaded = false
    private var updates: Task<Void, Never>? = nil
    
    override init() {
        super.init()
        
        updates = observeTransactionUpdate()
        
        Task.init() {
            do {
                await updatePurchasedProducts()
                try await loadProducts()
            }
        }
    }
    
    deinit {
        updates?.cancel()
    }
    
    
    func loadProducts() async throws {
        guard !self.productsLoaded else { return }
        self.products = try await Product.products(for: productIds)
        self.productsLoaded = true
    }
    
    
    func purchase (_ product: Product) async throws {
        guard isInternetAvailable() else {
            UIViewController.showAlert(title: "Network unavailable", message: "Please check your internet connection.")
            return
        }
        
        let result = try await product.purchase()
        
        switch result {
        case let .success(.verified(transaction)):
            print("Successful purchase")
            await transaction.finish()
            await self.updatePurchasedProducts()
        case let .success(.unverified(_, error)):
            print("Successful purchase but the transaction or receipt can't be verified")
            break
        case .pending:
            print("Transaction pending")
            break
        case .userCancelled:
            print("User cancelled purchase")
            break
        @unknown default:
            break
        }
    }
    
    
    func updatePurchasedProducts() async {
        var hasActiveRemoveAdsPurchase = false
        
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            
            if transaction.productID == "remove_ads" {
                hasActiveRemoveAdsPurchase = true
            }
            
            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
                if transaction.productID == "remove_ads" {
                    await removeAds()
                }
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
            }
        }
        
        // this refund block needs to be test further. Current iteration seems to work, refunds re-instate the ads, but logic needs to be double checked
        if UserDefaults.standard.bool(forKey: "remove_ads") && !hasActiveRemoveAdsPurchase {
            await restoreAds()
            UserDefaults.standard.removeObject(forKey: "remove_ads")
        }
    }
    
    
    private func observeTransactionUpdate() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            for await VerificationResult in Transaction.updates {
                await self.updatePurchasedProducts()
            }
        }
    }
    
    
    // productName could simply be "remove_ads" instead of a parameter, but this way leaves future IAPs open to be added with the current iteration
    
    func requestProduct(productName: String) {
        Task.init() {
            do {
                if let product = products.first(where: { $0.id == productName }) {
                    try await purchase(product)
                } else {
                    // if product ID doesn't match
                    UIViewController.showAlert(title: "Product Not Available", message: "We're sorry, but the item you're trying to purchase is currently unavailable. Please try again later.")
                }
            } catch {
                if let skError = error as? SKError {
                    switch skError.code {
                    case .unknown:
                        UIViewController.showAlert(title: "Product Not Available", message: "We're sorry, but the item you're trying to purchase is currently unavailable. Please try again later.")
                    default:
                        UIViewController.showAlert(title: "An unknown error occurred", message: "Please try again later.")
                        print("Failed to load products or make purchase: \(error)")
                    }
                } else {
                    // Neither product ID matches nor .unknown triggers
                    UIViewController.showAlert(title: "Purchase Failed", message: "An unexpected error occurred. Please try again later.")
                    print("Failed to load products or make purchase: \(error)")
                }
            }
        }
    }
    
    
    func restorePurchases() {
        guard isInternetAvailable() else {
            UIViewController.showAlert(title: "Network unavailable", message: "Please check your internet connection.")
            return
        }
        
        Task {
            do {
                try await AppStore.sync()
                await self.updatePurchasedProducts()
            } catch {
                print(error)
            }
        }
    }
    
    
    func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    
    func removeAds() async {
        guard adsRemoved == false else { return }
        
        print("Removing ads!")
        adsRemoved = true
        TitleScreen.shared.removeAdsButton.isHidden = true
        GameViewController.shared.bannerView.isHidden = true
        SavedSettings.shared.setAdsSettings()
        
        // Add the product ID to the record of purchases.
        UserDefaults.standard.set(true, forKey: "remove_ads")
    }
    
    
    func restoreAds() async {
        guard adsRemoved == true else { return }
        
        print("Restoring ads!")
        adsRemoved = false
        TitleScreen.shared.removeAdsButton.isHidden = false
        GameViewController.shared.bannerView.isHidden = false
        SavedSettings.shared.setAdsSettings()
    }
}
