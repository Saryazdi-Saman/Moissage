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
    @ObservedObject var locationVM : LocationSearchViewModel
    let mapView = MKMapView()
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.isRotateEnabled = false
//        mapView.userTrackingMode = .follow
        mapView.mapType = .mutedStandard
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
//        let nearbyWorkers = locationVM.workCandidates
        if let userAddress = locationVM.invoice.address {
            context.coordinator.addAnnotations(forLocation: userAddress)
            context.coordinator.updateMapCenter(forLocation: userAddress)
        } 
        
        if let selectedWorker = locationVM.onCallWorker {
            withAnimation {
                context.coordinator.agentAnno(forLocation: selectedWorker)
                context.coordinator.configurePolyline(from: selectedWorker)
            }
            
        }
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
            
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,
                                                                           longitude: userLocation.coordinate.longitude),
                                            span: MKCoordinateSpan(latitudeDelta: 0.008,
                                                                   longitudeDelta: 0.008))
            parent.mapView.setRegion(region, animated: true)
            parent.mapView.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 400, right: 5)
            parent.mapView.showsUserLocation = false
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let polyLine = MKPolylineRenderer(overlay: overlay)
            polyLine.strokeColor = .systemBlue
            polyLine.lineWidth = 3
            return polyLine
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard !(annotation is MKUserLocation) else {return nil}
            
            let maleIcon = UIImage(named: "male")
            let femaleIcon = UIImage(named: "female")
            let homeIcon = UIImage(named: "home")
            let resizedHomeSize = CGSize(width: 40, height: 40)
            let resizedMaleSize = CGSize(width: 45.5, height: 45.5)
            let resizedFemaleSize = CGSize(width: 30.5, height: 36.54)
            
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
        
//        func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
//            if parent.locationVM.onCallWorker != nil {
//                mapView.showsUserLocation = false
//                mapView.removeAnnotation(mapView.userLocation)
//            }
//        }
        
        
        // MARK: - Helpers
        func addAnnotations(forLocation address: Address?){
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            if let location = address {
                let anno = MKPointAnnotation()
                anno.title = "address"
                anno.coordinate = location.location.coordinate
                parent.mapView.addAnnotation(anno)
            }
            
            parent.mapView.showAnnotations(parent.mapView.annotations, animated: false)
        }
        func agentAnno(forLocation address: AddressPoint){
//            parent.mapView.removeAnnotations(parent.mapView.annotations)
            let anno = MKPointAnnotation()
            anno.title = "male"
            anno.coordinate = address.location.coordinate
            parent.mapView.addAnnotation(anno)
            
            parent.mapView.showAnnotations(parent.mapView.annotations, animated: false)
        }
//        func addAnnotations(forWorkers workerDB: [Therapist], serviceLocation address: Address?){
//            parent.mapView.removeAnnotations(parent.mapView.annotations)
//            if let location = address {
//                let anno = MKPointAnnotation()
//                anno.title = "address"
//                anno.coordinate = location.location.coordinate
//                parent.mapView.addAnnotation(anno)
//            }
//            let numberOfAnnos = min(3, workerDB.count)
//            for worker in workerDB[..<numberOfAnnos]{
//                let anno = MKPointAnnotation()
//                if worker.gender == "male"{
//                    anno.title = "male"
//                } else {
//                    anno.title = "female"
//                }
//                anno.coordinate = worker.location.coordinate
//                self.parent.mapView.addAnnotation(anno)
//            }
//            parent.mapView.showAnnotations(parent.mapView.annotations, animated: true)
//        }
        
        func updateMapCenter(forLocation location: Address?){
            guard let location = location else {return}
            let mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.lat, longitude: location.lon), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
            parent.mapView.setRegion(mapRegion, animated: false)
        }
        
        
        func configurePolyline(from worker: AddressPoint) {
            guard let userAddress = parent.locationVM.invoice.address else {return}
            let workerLocation = CLLocationCoordinate2D(latitude: worker.location.coordinate.latitude,
                                                        longitude: worker.location.coordinate.longitude)
            let userLocation = CLLocationCoordinate2D(latitude: userAddress.location.coordinate.latitude,
                                                      longitude: userAddress.location.coordinate.longitude)
            
            getDestinationRoute(from: workerLocation, to: userLocation) { route in
                self.parent.mapView.removeOverlays(self.parent.mapView.overlays)
                self.parent.mapView.addOverlay(route.polyline)
                self.updateMapRegion(forPolyline: route.polyline)
            }
        }
        
        
        func updateMapRegion(forPolyline polyLine: MKPolyline){
            var regionRect = polyLine.boundingMapRect
            
            let wPadding = regionRect.size.width * 0.25
            let hPadding = regionRect.size.height * 0.25
            
            //Add padding to the region
            regionRect.size.width += wPadding
            regionRect.size.height += hPadding
            
            //Center the region on the line
            regionRect.origin.x -= wPadding / 2
            regionRect.origin.y -= hPadding / 2
            
            parent.mapView.setRegion(MKCoordinateRegion(regionRect), animated: true)
        }
        
        
        func getDestinationRoute(from workerLocation: CLLocationCoordinate2D,
                                 to userLocation: CLLocationCoordinate2D, completion:
                                 @escaping(MKRoute)-> Void){
            let workerPlacemark = MKPlacemark(coordinate: workerLocation)
            let userPlaceMark = MKPlacemark(coordinate: userLocation)
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: workerPlacemark)
            request.destination = MKMapItem(placemark: userPlaceMark)
            let directions = MKDirections(request: request)
            
            directions.calculate { response, error in
                if let error = error {
                    print("DEBUG: failed to get directions with error \(error.localizedDescription)")
                    return
                }
                guard let route = response?.routes.first else { return }
                completion(route)
            }
            
        }
    }
}
