//
//  MatchingViewModel.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2023-07-25.
//

import Foundation
import Combine
import FirebaseDatabase
import FirebaseAuth

class MatchingViewModel : ObservableObject {
    @Published var status : String = "searching" {
        didSet{
            if status == "pushing" {
                title = title0
                headline = title0
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    self.title = self.title2
                    self.headline = self.headline2
                }
            }
        }
    }
    private let currentUser = Auth.auth().currentUser
    @Published var isCanceled = false
    @Published var change = true
    @Published var isShowingSlider = false
    @Published var isTimeSet = false {
        didSet{
            if isTimeSet{
                title = title0
                headline = title0
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    self.title = self.title3
                    self.headline = self.headline3
                }
            }
        }
    }
//    var timeSelected = Date();
    var availableMinutes : CGFloat = 0;
    @Published var title = "Looking for the best available therapist"
    private let title0 = ""
    private let title1 = "Looking for the best available therapist"
    private let title2 = "We are messaging every therapist"
    private let title3 = "You will be notified once your massage is booked"
    @Published var headline = ""
    private let headline1 = ""
    private let headline2 = "Let us know what is the latest you are available to recieve your massage"
    private let headline3 = "Make sure your notification settings are turned on for our app"
    
    init(){
        listenForMatch()
    }
    
    func listenForMatch(){
        guard let uid = currentUser?.uid  else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
            Database.database().reference()
                .child("contracts")
                .child(uid)
                .child("status")
                .observe(.value){[weak self] snapshot in
                    guard let status = snapshot.value as? String else {
                        Database.database().reference()
                            .child("contracts")
                            .child(uid)
                            .observeSingleEvent(of: .value) { (snap) in
                                if !snap.exists() {
                                    self?.status = "canceled"
                                }
                            }
                        return
                    }
                    self?.status = status
                }
        }
    }
    
    func cancelReq(){
        let cancelationURL = URL(string: "https://cancelrequest-qmtthe7q5a-uc.a.run.app")!
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                print("DEBUG - MatchingVM: could not retrieve idToken with error: \(error)")
                return;
            }
            guard let token = idToken else {
                print("DEBUG - MatchingVM: idToken was empty")
                return
            }
            var request = URLRequest(url: cancelationURL)
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"
            let task = URLSession.shared.dataTask(with: request){ [weak self] (data, response, error) in
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                    print("DEBUG: NETWORK RESPONSE: \(String(describing: response))");
                    return
                }
                if let error = error {
                    print("DEBUG: ERRoR: \(error)");
                }
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data) as? [String: Bool],
                      let result = json["isCanceled"]
                else {
                    print("DEBUG: MAtchingVM: error in http request")
                    return
                }
                print("result recieved: is Canceled \(result)")
                DispatchQueue.main.async {
                    self?.isCanceled = result
                }
                
            }
            task.resume()
        }
    }
    
    func setLatestAvailability(_ timeSelected: Date){
        guard let uid = currentUser?.uid  else {
            return
        }
        let time = timeSelected.timeIntervalSince1970
        Database.database().reference()
            .child("contracts")
            .child(uid)
            .child("latestAvailability/time")
            .setValue(time)
    }
    func calculateAvailableTime(){
        let calendar = Calendar.current
        let now = Date()
        let laterToday = calendar.date(
          bySettingHour: 23,
          minute: 59,
          second: 59,
          of: now)!
        let secs = CGFloat(laterToday.timeIntervalSince(now))
        self.availableMinutes = (secs / 60)
        print("available minuts: \(availableMinutes)")
        return
    }
}
