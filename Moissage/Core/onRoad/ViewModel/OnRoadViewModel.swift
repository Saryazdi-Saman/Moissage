//
//  OnRoadViewModel.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2023-07-28.
//

import Foundation
import UIKit

class OnRoadViweModel: ObservableObject {
    @Published var agent : Agent?{
        didSet{
            if let agent = agent {
                fetchImage(for: agent)
            }
        }
    }
    @Published var isSessionCanceled = false
    @Published var cancelRequested = false
    @Published var isProfileComplete = false
    @Published var isPhotoReady = false
    @Published var profilePhoto : UIImage?
//    @Published var agent : Agent = Agent(id: "1234", name: "Saman")
    private let service = RoadService()
    
    init(){
        print("DEBUG: onRoadView init Started")
        fetchAgentProfile()
    }
    
    func fetchAgentProfile() {
        service.fetchAgentProfile {[weak self] result in
            switch result {
            case .success(let agent):
                DispatchQueue.main.async {
                    self?.agent = agent
                    self?.isProfileComplete.toggle()
                }
                
            case .failure(_):
                print("DEBUG: onRoadViewModel - failed to fetch agent's profile")
            }
        }
    }
    
    func fetchImage(for agent: Agent){
        if let path = agent.imageUrl {
            service.getPhoto(at: path) {[weak self] result in
                switch result{
                case .success(let data):
                    print("DEBUG: onRoadViewModel - agent's photo downloaded successfully")
                    DispatchQueue.main.async {
                        if let data = data {
                            self?.profilePhoto = UIImage(data: data)
                        }
                        self?.isPhotoReady.toggle()
                    }
                case .failure(_):
                    print("DEBUG: onRoadViewModel - failed to download photo")
                }
            }
        }
    }
    
    func cancelSession() {
        service.cancelSession {[weak self] result in
            switch result {
            case .failure(_):
                return
            case .success(let isCanceled):
                DispatchQueue.main.async {
                    self?.isSessionCanceled = isCanceled
                }
            }
        }
    }
}
