//
//  DispatchManager.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2022-10-18.
//
//
//import Foundation
//import FirebaseDatabase
//import CoreLocation
//import Combine
//
//class DispatchManager: ObservableObject{
//    @Published var contactingNow: Therapist?
//    @Published var retry = [Therapist]()
//    @Published var selectedAgent: Therapist?
//    @Published var isEmpty = false
//    private var subscriptions = Set<AnyCancellable>()
//    private var firebaseHandle: DatabaseHandle?
//    private var agents = [Therapist]()
//    private var listWithPriority = [Therapist]()
//    private var shouldStop = false
//    
//    init(){
//        locateAgents()
//    }
//    
//    func showAgents(closeTo location:CLLocation)->[Therapist]? {
//        return agents.sorted(
//            by: { $0.distance(to: location)
//                < $1.distance(to: location)})
//    }
//    
//    func start(_ location: CLLocation,_ gender: Gender){
//        updateList(location, gender)
//        
////
////        while !shouldStop {
////            if !agents.isEmpty {
////                list += agents
////                agents.removeAll()
////                list = list.sorted(
////                    by: { $0.distance(to: location)
////                    < $1.distance(to: location)})
////            }
////            if list.isEmpty {
////                shouldStop = true
////                continue
////            }
////
////        }
//    }
//    
//    private func updateList(_ location: CLLocation,_ gender: Gender){
//        guard !agents.isEmpty else { return }
//        switch gender {
//        case .male, .female:
//            listWithPriority += agents.filter {$0.gender == gender.rawValue}
//        default:
//            listWithPriority += agents
//        }
//        listWithPriority = agents.sorted(
//            by: { $0.distance(to: location)
//                < $1.distance(to: location)})
//        agents.removeAll()
//    }
//}
//
//private extension DispatchManager{
//    
//    private func locateAgents(){
//        firebaseHandle = Database.database().reference()
//            .child("dispatch/agent/")
//            .observe(.childAdded, with: { [weak self] dataSnap in
//                guard let data = dataSnap.value as? [String:Any] else {
//                    print("DEBUG: DispatchManager - agent could not be transformed to [String:Any]")
//                    return
//                }
//                guard let id = data["id"] as? String,
//                      let lat = data["lat"] as? Double,
//                      let lon = data["lon"] as? Double,
//                      let gender = data["gender"] as? String else {
//                    return
//                }
//                
//                self?.agents.append(Therapist(id: id,
//                                              name: dataSnap.key,
//                                              gender: gender,
//                                              lat: lat,
//                                              lon: lon))
//            })
//    }
//    
//    struct searchEngine{
//        func start() async throws -> Therapist {
//            
//            return Therapist(id: "", name: "", gender: "", lat: 00, lon: 2)
//        }
//    }
////    let service = searchEngine()
//    
//    
//    private func sendOffer(to candids:[Therapist]){
////        for agent in candids {
////
////        }
//    }
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//

//class DispatchManager2 : ObservableObject {
//    private var callTherapistWorkItem : DispatchWorkItem?
//    private var removeOfferWorkItem : DispatchWorkItem?
//
//    private let uid = UserDefaults.standard.string(forKey: "id") ?? ""
//    private let candidates : [Therapist]
//    private let cart : Cart
//    private let serviceAddress : Address
//    private var jobListing: [String:Any]
//    private let database = Database.database(url:"http://localhost:9000?ns=moissage-a078d").reference()
//    private var orderOfPriority : Array<Int>
//    private var toPost: Int?
//    private var toRemove: String?
//
//
//    init(candidates: [Therapist], cart: Cart, serviceAddress: Address) {
//        self.candidates = candidates
//        self.cart = cart
//        self.serviceAddress = serviceAddress
//        jobListing = ["id" : self.uid,
//                      "lat" : serviceAddress.lat,
//                      "lon" : serviceAddress.lon,
//                      "duration" : cart.duration.rawValue,
//                      "type" : cart.mainService.title,
//                      "amount" : cart.total,
//                      "status": false]
//        if cart.extraHeadMassage != .none {
//            jobListing["extra_head_massage"] = cart.extraHeadMassage.rawValue
//        }
//        if cart.extraFootMassage != .none {
//            jobListing["extra_foot_massage"] = cart.extraFootMassage.rawValue
//        }
//
//        self.orderOfPriority = Array(0..<candidates.count)
//    }
//
//    func submitOrder(completion: @escaping (Result<Therapist, Error>) -> Void){
//
//        var jobAccepted = false{
//            didSet{
//                if jobAccepted{
//                    print("Job was accepted - updating through didSet")
//
//                    callTherapistWorkItem?.cancel()
//                    removeOfferWorkItem?.cancel()
//                }
//            }
//        }
//
//        let postingWork = DispatchWorkItem{
//
//            DispatchQueue.global(qos: .userInitiated).async {
//                self.firstAvailableWorker()
//                guard let queNumber = self.toPost else {
//                    return
//                }
//                let candidate = self.candidates[queNumber]
//                self.database.child("aactive")
//                    .child(candidate.id)
//                    .child("offer").updateChildValues(self.jobListing)
//
//                self.database.child("aactive")
//                    .child(candidate.id)
//                    .child("offer").observe(.value) { snapshot in
//                        guard let value = snapshot.value as? [String: Any] else
//                        {return}
//                        if let status = value["status"] as? Bool{
//                            jobAccepted = status
//                            if jobAccepted {
//                                completion(.success(candidate))
//                            }
//                        }
//                    }
//                self.toRemove = candidate.id
//                self.toPost = nil
//            }
//        }
//
//        let removeWorkItem = DispatchWorkItem{
//            guard let id = self.toRemove else { return }
//            self.database.child("aactive")
//                .child(id)
//                .child("offer").setValue(nil)
//
//            self.database.child("aactive")
//                .child(id)
//                .child("offer").removeAllObservers()
//            self.toRemove = nil
//
//            if self.orderOfPriority.isEmpty{
//                completion(.failure(DatabaseError.failedToFindWorker))
//                print("caught it")
//                return
//            }
//
//
//        }
//
//
//        removeOfferWorkItem = removeWorkItem
//        callTherapistWorkItem = postingWork
//
//
//        var delay = 0
//        for _ in candidates{
//            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay), execute: postingWork)
//            delay += 10
//            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay), execute: removeWorkItem)
//        }
//    }
//
//    private func hasAnotherOffer(workID: String, completion: @escaping ((Bool) -> Void)) {
//        let directory = database
//            .child("aactive")
//            .child(workID).child("offer")
//
//        directory.observeSingleEvent(of: .value, with: { snapshot in
//            guard snapshot.value as? [String: Any] != nil else {
//                completion(false)
//                return
//            }
//            completion(true)
//        })
//
//    }
//
//    private func firstAvailableWorker(){
//
//        let group = DispatchGroup()
//        var foundWorker = false
//        for i in orderOfPriority.indices{
//
//            group.enter()
//            let candidNumber = orderOfPriority[i]
//            self.hasAnotherOffer(workID: candidates[candidNumber].id) { hasAnotherOffer in
//
//                defer {
//                    group.leave()
//                }
//                if !hasAnotherOffer {
//                    self.orderOfPriority.remove(at: i)
//                    self.toPost = candidNumber
//                    foundWorker = true
//                }
//            }
//            group.wait()
//            guard !foundWorker else { break }
//        }
//    }
//
//    func cancelRequest(){
//        callTherapistWorkItem?.cancel()
//        removeOfferWorkItem?.cancel()
//        guard let id = toRemove else { return }
//        self.database.child("aactive")
//            .child(id)
//            .child("offer").setValue(nil)
//
//        self.database.child("aactive")
//            .child(id)
//            .child("offer").removeAllObservers()
//        self.toRemove = nil
//    }
//
//}

