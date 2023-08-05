//
//  ChatViewModel.swift
//  Moissage
//
//  Created by Saman Saryazdi on 2023-08-05.
//

import Foundation
import Combine

class ChatViewModel: ObservableObject {
    let service = MessageService()
    @Published var message : String?
    @Published var converesation = [Message]()
    private var subscriptions = Set<AnyCancellable>()
    
    func sendMessage(to id: String) {
        guard let message = message,
        message != "" else {
            return
        }
        service.sendMessage(message, toUser: id)
            .sink { res in
            switch res {
            case .failure(_):
                print("DEBUG: ChatViewModel - failed to upload message")
            default: break
            }
        } receiveValue: { _ in
            print("DEBUG: ChatViewModel - message sent successfully")
        }
        .store(in: &subscriptions)
        
        DispatchQueue.main.async {
            self.message = nil
        }
    }
    
    func observeMessages(from id: String) {
        service.observeMessages(contact: id , completion:{[weak self] result in
            switch result {
            case .success(let message):
                DispatchQueue.main.async {
                    self?.converesation.append(message)
                }
            case .failure(_):
                print("DEBUG: ChatViewModel - failed to get conversation messages")
            }
//            self.converesation.append(contentsOf: messages)
        })
    }
    
    
}
