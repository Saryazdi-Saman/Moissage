//
//  MapViewRepresentable.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-11.
//

import SwiftUI
import UIKit
import MapKit

struct MapViewRepresentable : UIViewRepresentable {
    @EnvironmentObject var locationVM : LocationSearchViewModel
    
    let mapView = MKMapView()
    let locationManager = LocationManager.shared
    
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        let nearbyWorkers = locationVM.workCandidates
        let address = locationVM.selectedLocation
        context.coordinator.addAnnotations(forWorkers: nearbyWorkers, serviceLocation: address)
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
        
    }
}

extension MapViewRepresentable {
    class MapCoordinator : NSObject, MKMapViewDelegate{
        let parent : MapViewRepresentable
        // MARK: - Lifecycle
        init(parent: MapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        // MARK: - MKMapViewDelegate
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,
//                                                                           longitude: userLocation.coordinate.longitude),
//                                            span: MKCoordinateSpan(latitudeDelta: 0.05,
//                                                                   longitudeDelta: 0.05))
//
//            parent.mapView.setRegion(region, animated: true)
            parent.mapView.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 500, right: 5)
        }
//
        
        
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard !(annotation is MKUserLocation) else {return nil}
            
            let maleIcon = UIImage(named: "male")
            let femaleIcon = UIImage(named: "female")
            let homeIcon = UIImage(named: "home")
            let resizedHomeSize = CGSize(width: 40, height: 40)
            let resizedMaleSize = CGSize(width: 65, height: 65)
            let resizedFemaleSize = CGSize(width: 43.5, height: 52.2)
            
            UIGraphicsBeginImageContext(resizedMaleSize)
            maleIcon?.draw(in: CGRect(origin: .zero, size: resizedMaleSize))
            let resizedMaleIcon = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            UIGraphicsBeginImageContext(resizedFemaleSize)
            femaleIcon?.draw(in: CGRect(origin: .zero, size: resizedFemaleSize))
            let resizedFemaleIcon = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            UIGraphicsBeginImageContext(resizedHomeSize)
            homeIcon?.draw(in: CGRect(origin: .zero, size: resizedHomeSize))
            let resizedhomeIcon = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
                annotationView?.canShowCallout = false
            }else {
                annotationView?.annotation = annotation
            }
            switch annotation.title {
            case "male" :
                annotationView?.image = resizedMaleIcon
            case "female" :
                annotationView?.image = resizedFemaleIcon
            case "address" :
                annotationView?.image = resizedhomeIcon
            default : break
            }
            
            return annotationView
        }
        
        
        // MARK: - Helpers
        func addAnnotations(forWorkers workerDB: [Therapist], serviceLocation address: Address?){
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            if let location = address {
                let anno = MKPointAnnotation()
                anno.title = "address"
                anno.coordinate = location.location.coordinate
                parent.mapView.addAnnotation(anno)
            }
            let numberOfAnnos = min(4, workerDB.count)
            for worker in workerDB[..<numberOfAnnos]{
                let anno = MKPointAnnotation()
                if worker.gender == "male"{
                    anno.title = "male"
                } else {
                    anno.title = "female"
                }
                anno.coordinate = worker.location.coordinate
                self.parent.mapView.addAnnotation(anno)
            }
            parent.mapView.showAnnotations(parent.mapView.annotations, animated: true)
        }
    }
}
