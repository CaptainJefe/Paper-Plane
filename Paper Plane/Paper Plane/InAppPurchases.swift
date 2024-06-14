//
//  InAppPurchases.swift
//  Paper Plane
//
//  Created by Cade Williams on 4/14/24.
//  Copyright © 2024 Cade Williams. All rights reserved.
//

import Foundation
import StoreKit

class InAppPurchaseManager: NSObject, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    
    static let shared = InAppPurchaseManager()
    
    var productRequest: SKProductsRequest?
    var products: [SKProduct]!
        
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    
    func unlockContent() {
        
        adsRemoved = true
        TitleScreen.shared.removeAdsButton.isHidden = true
        
        GameViewController.shared.bannerView.isHidden = true
        SavedSettings.shared.setAdsSettings()
        
        // hide interstitial here
        
    }
    
    
    func fetchProducts() {
            let productIdentifiers = Set(["remove_ads"])
            productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
            productRequest?.delegate = self
            productRequest?.start()
    }
    
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        if let product = products.first {
            print("Fetched product: \(product.productIdentifier)")
        } else {
            print("Failed to fetch product")
        }
    }
    
    
    // These two methods below are to request a purchase/restore which are called from TitleScreen buttons "removeAdButton" and "restorePurchases"
    
    func requestPurchase() {
        if let product = InAppPurchaseManager.shared.products.first(where: { $0.productIdentifier == "remove_ads" }) {
            Task {
                do {
                    try await InAppPurchaseManager.shared.purchase(product)
                } catch {
                    print("Failed to initiate purchase: \(error)")
                }
            }
        }
    }
    
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
    func purchase(_ product: SKProduct) async throws {
        print("request called")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                
                print("Transaction Successful: \(transaction.payment.productIdentifier)")
                
                unlockContent()
                SKPaymentQueue.default().finishTransaction(transaction)
                
            case .failed:

                print("Transaction Failed: \(transaction.error?.localizedDescription ?? "Unknown error")")

                SKPaymentQueue.default().finishTransaction(transaction)
                
            case .restored:
                
                print("Transaction Restored: \(transaction.payment.productIdentifier)")
                
                unlockContent()
                SKPaymentQueue.default().finishTransaction(transaction)
                
            default:
                break
            }
        }
    }
}
