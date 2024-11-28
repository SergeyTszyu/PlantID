//
//  OnboardingDelegate.swift

import Foundation

protocol OnboardingRouterDelegate: AnyObject {
    func routeToTrialView()
    func routeToPreparing()
    func routeToMainView()
}
