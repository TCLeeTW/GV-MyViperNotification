//
//  Router.swift
//  MyViperNotification
//
//  Created by TC on 2024/5/9.
//

import Foundation
import UIKit

/*
    Router 是一個object
    是整個Module 的進入點
 
 */

typealias EntryPoint = AnyView & UIViewController
// 首先先定義所有的router都應該要有的基本架構
// protocol的定義在每個object的最上方，可以幫助快速檢視有哪一些基本的函式，可以說是一個函式清單
protocol AnyRouter{
    var entry : EntryPoint?{get}
    // 所有的router 一定要有一個static func 去啟動
    static func start()->AnyRouter
}

class UserRouter:AnyRouter{
    
    var entry:EntryPoint?
    
    static func start() -> any AnyRouter {
        let router = UserRouter()
        // 啟動後第一件事情就是把VIP準備好
        var view:AnyView = UserViewController()
        var presenter:AnyPresenter = UserPresenter()
        var interactor:AnyInteractor = UserInteractor()
        
        view.presenter = presenter
        interactor.presenter = presenter
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        
        router.entry = view as? EntryPoint
        
        return router
    }
    
    
}
