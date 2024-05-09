//
//  Presenter.swift
//  MyViperNotification
//
//  Created by TC on 2024/5/9.
//

import Foundation
/*
 
 Presenter是把東西集中在一起的地方
 Presenter 是一個 object
 他有一套自己的 Protocol
 ref to interactor, router, view
 當從view 收到使用者的動作後，presenter會轉通知interactor去處理這些資訊
 Interactor會把指令丟回來透過presenter告訴view 做出變化，或是告訴router去跳轉到其他畫面
 
 */
enum FetchError:Error{
    case failed
}
protocol AnyPresenter{
    var router:AnyRouter?{get set}
    var interactor:AnyInteractor?{get set}
    var view: AnyView?{get set}
    func interactorDidFetchUsers(with result:Result<[User],Error>)
}

// 針對UserPresenter我們希望這個object 一定要有的fucntion（這樣其他人可以直接call）的，列在這裏
// 在iOS Academy 的示範專案裡是直接放在AnyPresenter裡面，像是上面這個，但這樣就不是AnyPresenter了
// 在GV的專案裡是全部都放在dedicate的protocol裡面，像是下面這個，但這樣重複的router, interactor, view就要在每一個都被定義。雖然說並沒有多幾行，但就容易漏掉


class UserPresenter: AnyPresenter {
    
    var router: AnyRouter?
    var interactor: AnyInteractor?{didSet{
        
        interactor?.getUsers()
    }}
    var view:  AnyView?
    
    
    
    func interactorDidFetchUsers(with result: Result<[User], any Error>) {
        switch result{
        case .success(let users):
            view?.update(with: users)
        case .failure:
            view?.update(with: "Fail to update user")
        }
        //
    }
    
}
