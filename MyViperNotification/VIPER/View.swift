//
//  View.swift
//  MyViperNotification
//
//  Created by TC on 2024/5/9.
//

import Foundation
import UIKit
/*
 View 是一個 Viewcontroller，去控制各個view
 他有一套自己的 Protocol
 Referecen to presenter
 Ref 的意思是會需要通知誰。在這裏ref to presenter就是意指資訊的傳遞方向
 */

protocol AnyView{
    var presenter:AnyPresenter?{get set}
    func update(with user:[User])
    func update(with error:String)
}



class UserViewController:UIViewController,AnyView{
    var presenter: (any AnyPresenter)?
    
    private let tableview:UITableView={
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.isHidden = true
        return table
    }()
    private let label:UILabel={
        let label = UILabel()
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    var users:[User]=[]
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        view.addSubview(tableview)
        view.addSubview(label)
        tableview.delegate = self
        tableview.dataSource = self
        label.isHidden = true
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableview.frame = view.bounds
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        label.center = view.center
    }
    func update(with user: [User]) {
        print("Successfully get user")
        DispatchQueue.main.async {
            self.users = user
            self.tableview.reloadData()
            self.tableview.isHidden = false
            self.label.isHidden = true
            
        }
        //
    }
    
    func update(with error: String) {
        
        DispatchQueue.main.async{
            self.label.text = error
            self.label.isHidden = false
            self.users = []
            self.tableview.isHidden = true
        }
            
        //
        print(error)
    }
    
    
}

extension UserViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].name
        return cell
    }
    
    
}
