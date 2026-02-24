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
import UIKit // Added for UIViewController

@MainActor
class InAppPurchases: NSObject, ObservableObject {
	
	// This matches App Store Connect. DO NOT CHANGE.
	private let productIds = ["remove_ads"]
	
	@Published private(set) var products: [Product] = []
	@Published private(set) var purchasedProductIDs = Set<String>()
	
	private var productsLoaded = false
	private var updates: Task<Void, Never>? = nil
	
	override init() {
		super.init()
		
		updates = observeTransactionUpdate()
		
		Task.init() {
			do {
				// We load products first so we have the metadata
				try await loadProducts()
				// Then check what the user owns
				await updatePurchasedProducts()
			} catch {
				print("Failed to init products: \(error)")
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
	
	
	func purchase(_ product: Product) async throws {
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
			
		case let .success(.unverified(_, _)):
			print("Successful purchase but the transaction or receipt can't be verified")
			
		case .pending:
			print("Transaction pending")
			
		case .userCancelled:
			print("User cancelled purchase")
			
		@unknown default:
			break
		}
	}
	
	
	// This is the brain of the operation. It checks with Apple to see what is valid.
	func updatePurchasedProducts() async {
		var hasActiveRemoveAdsPurchase = false
		
		// 1. Ask Apple what the user currently owns
		for await result in Transaction.currentEntitlements {
			guard case .verified(let transaction) = result else {
				continue
			}
			
			// If Apple says they own "remove_ads", mark it.
			if transaction.productID == "remove_ads" {
				hasActiveRemoveAdsPurchase = true
			}
			
			if transaction.revocationDate == nil {
				self.purchasedProductIDs.insert(transaction.productID)
			} else {
				self.purchasedProductIDs.remove(transaction.productID)
			}
		}
		
		// 2. Sync with our Local Settings
		
		if hasActiveRemoveAdsPurchase {
			// Apple says YES. Ensure local save is YES.
			if !SavedSettings.shared.areAdsRemoved {
				await removeAds()
			}
		} else {
			// Apple says NO.
			// Check if we LOCALLY think they have it. If so, it might be a refund.
			if SavedSettings.shared.areAdsRemoved {
				print("Local data says ads removed, but Apple says no entitlement. Revoking.")
				await restoreAds() // This actually re-enables ads (bad naming in original, but logic holds)
			}
		}
	}
	
	
	private func observeTransactionUpdate() -> Task<Void, Never> {
		Task(priority: .background) { [unowned self] in
			for await _ in Transaction.updates {
				await self.updatePurchasedProducts()
			}
		}
	}
	
	
	func requestProduct(productName: String) {
		Task.init() {
			do {
				if let product = products.first(where: { $0.id == productName }) {
					try await purchase(product)
				} else {
					UIViewController.showAlert(title: "Product Not Available", message: "We're sorry, but the item you're trying to purchase is currently unavailable.")
				}
			} catch {
				print("Purchase failed: \(error)")
				UIViewController.showAlert(title: "Purchase Failed", message: "An unexpected error occurred.")
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
	
	// MARK: - Local Logic & UI Updates
	
	
	/// Call this when the user successfully buys "remove_ads"
	func removeAds() async {
		// Use the Class, not the Global
		guard SavedSettings.shared.areAdsRemoved == false else { return }
		
		print("Removing ads!")
		
		// 1. Save to Disk (Single Source of Truth)
		SavedSettings.shared.areAdsRemoved = true
		
		// 2. Update UI
		// Since this class is @MainActor, these UI calls are safe
		TitleScreen.shared.removeAdsButton.isHidden = true
		GameViewController.shared.bannerView.isHidden = true
		GameViewController.shared.hideBannerAds()
		
		// Do I not add/keep: UserDefaults.standard.set(true, forKey: "remove_ads") ????
	}
	
	
	/// Call this when we need to turn ads BACK ON (e.g. Refund, or Debugging)
	func restoreAds() async {
		guard SavedSettings.shared.areAdsRemoved == true else { return }
		
		print("Re-enabling ads (Refund or Restore detected)!")
		
		// 1. Save to Disk
		SavedSettings.shared.areAdsRemoved = false
		
		// 2. Update UI
		TitleScreen.shared.removeAdsButton.isHidden = false
		GameViewController.shared.bannerView.isHidden = false
		GameViewController.shared.showBannerAds()
	}
	
	// MARK: - Helpers
	
	
	func isInternetAvailable() -> Bool {
		var zeroAddress = sockaddr_in()
		zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
		zeroAddress.sin_family = sa_family_t(AF_INET)

		let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
			$0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
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
}
