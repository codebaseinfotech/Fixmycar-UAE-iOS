//
//  StripeManager.swift
//  Fixmycar UAE
//
//  Created by Codebase Infotech on 08/04/26.
//

import Foundation
import UIKit
import StripePaymentSheet

class StripeManager {

    static let shared = StripeManager()

    private init() {}

    // MARK: - Configure Stripe
    func configure() {
        StripeAPI.defaultPublishableKey = STRIPE_PUBLISHABLE_KEY
    }

    // MARK: - Create Payment Sheet
    /// Creates and presents a PaymentSheet for collecting payment
    /// - Parameters:
    ///   - paymentIntentClientSecret: The client secret from your backend
    ///   - customerID: Optional Stripe customer ID
    ///   - ephemeralKeySecret: Optional ephemeral key secret for saved payment methods
    ///   - viewController: The presenting view controller
    ///   - completion: Completion handler with result
    func presentPaymentSheet(
        paymentIntentClientSecret: String,
        customerID: String? = nil,
        ephemeralKeySecret: String? = nil,
        from viewController: UIViewController,
        completion: @escaping (PaymentSheetResult) -> Void
    ) {
        var configuration = PaymentSheet.Configuration()
        configuration.merchantDisplayName = "Toretto Recovery"
        configuration.allowsDelayedPaymentMethods = false

        // Customer configuration for saved payment methods
        if let customerID = customerID, let ephemeralKeySecret = ephemeralKeySecret {
            configuration.customer = .init(id: customerID, ephemeralKeySecret: ephemeralKeySecret)
        }

        // Appearance customization
        var appearance = PaymentSheet.Appearance()
        appearance.colors.primary = UIColor(named: "AppPrimaryColor") ?? .systemBlue
        configuration.appearance = appearance

        let paymentSheet = PaymentSheet(
            paymentIntentClientSecret: paymentIntentClientSecret,
            configuration: configuration
        )

        paymentSheet.present(from: viewController) { result in
            completion(result)
        }
    }

    // MARK: - Handle Payment Result
    func handlePaymentResult(_ result: PaymentSheetResult, completion: @escaping (Bool, String?) -> Void) {
        switch result {
        case .completed:
            debugPrint("Payment completed successfully")
            completion(true, nil)

        case .canceled:
            debugPrint("Payment canceled by user")
            completion(false, "Payment was canceled")

        case .failed(let error):
            debugPrint("Payment failed: \(error.localizedDescription)")
            completion(false, error.localizedDescription)
        }
    }
}

// MARK: - PaymentSheetResult Extension
extension PaymentSheetResult {
    var isSuccess: Bool {
        if case .completed = self {
            return true
        }
        return false
    }
}
