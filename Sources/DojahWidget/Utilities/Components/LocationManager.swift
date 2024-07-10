//
//  LocationManager.swift
//
//
//  Created by Isaac Iniongun on 08/02/2024.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    var lastLocation: CLLocation?
    var hasLocationPermission: Bool {
        [.authorizedWhenInUse, .authorizedAlways].contains(CLLocationManager.authorizationStatus())
    }
    var didChangeAuthorization: ((CLAuthorizationStatus) -> Void)? = nil
    var didUpdateLocation: ((CLLocation) -> Void)? = nil
    
    override private init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters //Other options: [kCLLocationAccuracyBest, kCLLocationAccuracyBestForNavigation, kCLLocationAccuracyNearestTenMeters, kCLLocationAccuracyKilometer, kCLLocationAccuracyThreeKilometers]
    }
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        didChangeAuthorization?(status)
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            kprint("Location services authorization granted.")
        case .denied, .restricted:
            kprint("Location services authorization denied or restricted.")
        case .notDetermined:
            kprint("Location services authorization status not determined.")
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        lastLocation = newLocation
        kprint("New Location: \(newLocation)")
        didUpdateLocation?(newLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        kprint("Location manager error: \(error.localizedDescription)")
    }
}
