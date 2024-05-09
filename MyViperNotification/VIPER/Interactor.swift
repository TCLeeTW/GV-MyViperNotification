//
//  Interactor.swift
//  MyViperNotification
//
//  Created by TC on 2024/5/9.
//

import Foundation
/*
 
 Interactor 是一個 Object
 他有一套自己的 Protocol
 Ref to presenter
 Interactor 的主要功能是
 * go and get data
 * perform interaction
 * Deal with logics
 * handle api
 * when it is done, pass the result to presenter.
 */

protocol AnyInteractor{
    var presenter:AnyPresenter?{get set}
    func getUsers()
}

class UserInteractor:AnyInteractor{
    var presenter: (any AnyPresenter)?
    
    func getUsers() {
        print("Start fetching")
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users")else{
            self.presenter?.interactorDidFetchUsers(with: .failure(FetchError.failed))
            return
        }
        let task = URLSession.shared.dataTask(with: url) {[weak self] data, _, error in
            guard let data = data,error==nil else{
                return
            }
            do{
                let entites = try JSONDecoder().decode([User].self, from: data)
                self?.presenter?.interactorDidFetchUsers(with: .success(entites))
            }catch{
                self?.presenter?.interactorDidFetchUsers(with: .failure(error))
            }
        }
        task.resume()
        
    }
    
    
}
