//
//  ViewController.swift
//  Demo
//
//  Created by Nero on 09/07/2017.
//  Copyright © 2017 Nero. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.yellow
        self.view.addSubview(self.button)
        self.button.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.size.equalTo(CGSize.init(width: 200, height: 50))
        }
        
        self.startLabel.text = "开始时间"
        self.view.addSubview(self.startLabel)
        self.startLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(30)
            make.top.equalTo(self.view).offset(130)
        }
        self.endLabel.text = "结束时间"
        self.view.addSubview(self.endLabel)
        self.endLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-30)
            make.top.equalTo(self.view).offset(130)
        }
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func showView(){
        let clendarView = CalendarSelectedUIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        clendarView.showCalendarView()
    }
    
    
    lazy var button:UIButton = {
        let button = UIButton.init(type: .custom)
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(showView), for: .touchUpInside)
        return button
    }()
    
    lazy var startLabel:UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.black
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 15)
        label.backgroundColor = UIColor.clear
        return label
    }()
    
    lazy var endLabel:UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.black
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 15)
        label.backgroundColor = UIColor.clear
        return label
    }()

    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

