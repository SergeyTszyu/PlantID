import ApphudSDK
import SwiftUI
import StoreKit

final class PremiumManager {
    
    static let shared = PremiumManager()
    
    @Published var weeklyPrice = "$6.99"
    @Published var annuallyPrice = "$49.99"
    
    static var weeklyProduct: ApphudProduct?
    static var annuallyProduct: ApphudProduct?
    
    @MainActor func setup() {
        Apphud.start(apiKey: "app_tut6SonAy645ZDQWCXLeTCXsf8UqWd")
    }
    
    @MainActor func collectProducts() {
        Task {
            let products = try await Apphud.fetchProducts()
            products.forEach { product in
                let p = Apphud.apphudProductFor(product)
                switch product.id {
                case "annual.s":
                    PremiumManager.annuallyProduct = p
                    PremiumManager.shared.annuallyPrice = product.displayPrice
                case "weekly.s":
                    PremiumManager.weeklyProduct = p
                    PremiumManager.shared.weeklyPrice = product.displayPrice
                default:
                    break
                }
            }
        }
    }
}


extension SKProduct {
    func localizedPrice() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: self.price) ?? ""
    }
}

