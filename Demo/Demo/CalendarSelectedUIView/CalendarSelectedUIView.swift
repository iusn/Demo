//
//  CalendarSelectedUIView.swift
//  RuZu
//
//  Created by Nero on 07/06/2017.
//  Copyright © 2017 Nero. All rights reserved.
//

import UIKit

class CalendarSelectedUIView: UIView {
    let topExitView:UIButton
    let calendarBgView = UIView.init()
    let topDateView:CalendarSelectedTopView
//    let calendarView:MyCalenderView
    let calendarView:RZDatePicker
    override init(frame: CGRect) {
        topExitView = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 64))
        calendarBgView.frame = CGRect.init(x: 0, y: SCREEN_HEIGHT - 10, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64)
        topDateView = CalendarSelectedTopView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_HEIGHT, height: 90))
        let calendarFrame =  CGRect.init(x: 0, y: topDateView.frame.maxY, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64 - 90)
        calendarView = RZDatePicker.init(frame: calendarFrame, fromDate: Date.init(), toDate: Date.init())
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        calendarBgView.backgroundColor = UIColor.white
        topExitView.backgroundColor = UIColor.clear
        topDateView.backgroundColor = UIColor.init(rgb: 0xeeeeee)
        calendarView.backgroundColor = UIColor.white
        topExitView.addTarget(self, action: #selector(removeFunction), for: .touchUpInside)
        self.addSubview(topExitView)
        self.addSubview(calendarBgView)
        calendarBgView.addSubview(topDateView)
        calendarBgView.addSubview(calendarView)
    }
    
    func showCalendarView () {
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.3, animations: {
            var frame = self.calendarBgView.frame
            frame.origin.y = 64
            self.calendarBgView.frame = frame
        })
    }
    func removeFunction() {
        UIView.animate(withDuration: 0.3, animations: {
            var frame = self.calendarBgView.frame
            frame.origin.y = SCREEN_HEIGHT - 10
            self.calendarBgView.frame = frame
            }, completion: { (finished) in
                if finished {
                    self.removeFromSuperview()
                }
                })
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
