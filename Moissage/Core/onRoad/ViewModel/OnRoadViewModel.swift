//
//  OnRoadViewModel.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2023-07-28.
//

import Foundation

class OnRoadViweModel: ObservableObject {
    @Published var agent : Agent?
    @Published var isProfileComplete = false
//    @Published var agent : Agent = Agent(id: "1234", name: "Saman")
    private let service = RoadService()
    
    init(){
        fetchAgentProfile()
    }
    
    func fetchAgentProfile() {
        service.fetchAgentProfile {[weak self] result, handler in
            switch result {
            case .success(let agent):
                print("DEBUG: onRoadViewModel - agent's profile recieved successfully")
                DispatchQueue.main.async {
                    self?.agent = agent
                    
                }
                if let handler = handler {
                    self?.service.stopListening(handler: handler)
                }
                
            case .failure(_):
                print("DEBUG: onRoadViewModel - failed to fetch agent's profile")
            }
        }
    }
}
