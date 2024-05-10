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
    func checkVersion()
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
    
    func checkVersion(){
        //TODO: 完成version api call
        guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
              let url = URL(string: "https://us-central1-tc-testing-server.cloudfunctions.net/api/checkVersion")
        else{
            print("Invalid URL in check version")
            return
        }
        let queryItem = URLQueryItem(name: "version", value: currentVersion)
        let finalURL = url.appending(queryItems: [queryItem])
        print("final URL: ",finalURL)
        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) {[weak self] data, _, error in
            guard let data = data,error==nil else{
                print("Get version error: ",error!)
                return
            }
            let result = String(data: data, encoding: .utf8)
            guard let updateStatus = Updateable(rawValue: result!) else {
                   print("Invalid update status received: ",result)
                   return
               }
            self?.presenter?.interactorDidCheckAppVersion(with:.success(updateStatus))
         
        }
        task.resume()
        
        print("Version: ",currentVersion )
        
    }
    
    
}
