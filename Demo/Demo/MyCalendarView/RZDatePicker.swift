//
//  RZDatePicker.swift
//  RuZu
//
//  Created by Nero on 09/07/2017.
//  Copyright © 2017 Nero. All rights reserved.
//

import UIKit

class RZDatePicker: UICollectionView,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    let monthHeaderID = "monthHeaderID"
    let cellID = "cellID"
    let dateFormatter = DateFormatter()
    var startDateIndexPath: IndexPath?
    var endDateIndexPath: IndexPath?
    var isLoadingMore = false
    var initialNumberOfMonths = 24
    var subsequentMonthsLoadCount = 12
    var lastNthMonthBeforeLoadMore = 12
    var today: Date!
    var months: [Date]!
    var days: [(days: Int, prepend: Int, append: Int)]!
    var calendar: Calendar {
        return Utility.calendar
    }
    var itemWidth: CGFloat {
        return floor(self.bounds.size.width / 7)
    }
    var collectionViewWidthConstraint: NSLayoutConstraint?
    
    var selectedStartDate:Date?
    var selectedEndDate:Date?
    
    
    
    init(frame:CGRect,fromDate:Date,toDate:Date){
        super.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        today = Date()
        self.initDates()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.alwaysBounceVertical = true
        self.backgroundColor = UIColor.yellow
        self.showsVerticalScrollIndicator = false
        self.allowsMultipleSelection = true
        self.dataSource = self
        self.delegate = self
        
        self.register(RZDatePickerCell.self, forCellWithReuseIdentifier: cellID)
        self.register(RZDatePickerMonthHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: monthHeaderID)
        
//        self.topAnchor.constraint(equalTo: headerSeparator.bottomAnchor).isActive = true
//        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        self.bottomAnchor.constraint(equalTo: footerSeparator.topAnchor).isActive = true
        
//        let gap = self.bounds.size.width - (itemWidth * 7)
//        collectionViewWidthConstraint = self.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -gap)
        collectionViewWidthConstraint?.isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupLayout()
        
    }
    
    func setupLayout() {
        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 5
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = UIEdgeInsets()
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        }
    }
    
    func loadMoreMonths(completion: (() -> Void)?) {
        let lastDate = months.last!
        let month = calendar.component(.month, from: lastDate)
        let year = calendar.component(.year, from: lastDate)
        let dateComp = DateComponents(year: year, month: month + 1, day: 1)
        var curMonth = calendar.date(from: dateComp)
        for _ in 0..<subsequentMonthsLoadCount {
            months.append(curMonth!)
            let numOfDays = calendar.range(of: .day, in: .month, for: curMonth!)!.count
            let firstWeekDay = calendar.component(.weekday, from: curMonth!.startOfMonth())
            let lastWeekDay = calendar.component(.weekday, from: curMonth!.endOfMonth())
            days.append((days: numOfDays, prepend: firstWeekDay - 1, append: 7 - lastWeekDay))
            curMonth = calendar.date(byAdding: .month, value: 1, to: curMonth!)
        }
        if let handler = completion {
            handler()
        }
    }
    
    func isInBetween(indexPath: IndexPath) -> Bool {
        if let start = startDateIndexPath, let end = endDateIndexPath {
            return (indexPath.section > start.section || (indexPath.section == start.section && indexPath.item > start.item))
                && (indexPath.section < end.section || (indexPath.section == end.section && indexPath.item < end.item))
        }
        return false
    }
    
    // MARK: - Functions
    func configure(cell: RZDatePickerCell, withIndexPath indexPath: IndexPath) {
        let dateData = days[indexPath.section]
        let month = calendar.component(.month, from: months[indexPath.section])
        let year = calendar.component(.year, from: months[indexPath.section])
        
        if indexPath.item < dateData.prepend || indexPath.item >= (dateData.prepend + dateData.days) {
            cell.dateLabel.text = ""
            cell.type = [.Empty]
        } else {
            let todayYear = calendar.component(.year, from: today)
            let todayMonth = calendar.component(.month, from: today)
            let todayDay = calendar.component(.day, from: today)
            
            let curDay = indexPath.item - dateData.prepend + 1
            let isPastDate = year == todayYear && month == todayMonth && curDay < todayDay
            
            cell.dateLabel.text = String(curDay)
            cell.dateLabel.textColor = isPastDate ? UIColor.green : UIColor.white
            cell.type = isPastDate ? [.PastDate] : [.Date]
            
            if todayDay == curDay, todayMonth == month, todayYear == year  {
                cell.type.insert(.Today)
            }
        }
        
        if startDateIndexPath != nil && indexPath == startDateIndexPath {
            if endDateIndexPath == nil {
                cell.type.insert(.Selected)
            } else {
                cell.type.insert(.SelectedStartDate)
            }
        }
        
        if endDateIndexPath != nil {
            if indexPath == endDateIndexPath {
                cell.type.insert(.SelectedEndDate)
            } else if isInBetween(indexPath: indexPath) {
                cell.type.insert(.InBetweenDate)
            }
        }
        cell.configureCell()
    }
    func findIndexPath(forDate date: Date) -> IndexPath? {
        var indexPath: IndexPath? = nil
        if let section = months.index(where: {
            calendar.component(.year, from: $0) == calendar.component(.year, from: date) && calendar.component(.month, from: $0) == calendar.component(.month, from: date)}) {
            let item = days[section].prepend + calendar.component(.day, from: date) - 1
            indexPath = IndexPath(item: item, section: section)
        }
        return indexPath
    }
    
    func initDates() {
        let month = calendar.component(.month, from: today)
        let year = calendar.component(.year, from: today)
        let dateComp = DateComponents(year: year, month: month, day: 1)
        var curMonth = calendar.date(from: dateComp)
        
        months = [Date]()
        days = [(days: Int, prepend: Int, append: Int)]()
        for _ in 0..<initialNumberOfMonths {
            months.append(curMonth!)
            let numOfDays = calendar.range(of: .day, in: .month, for: curMonth!)!.count
            let firstWeekDay = calendar.component(.weekday, from: curMonth!.startOfMonth())
            let lastWeekDay = calendar.component(.weekday, from: curMonth!.endOfMonth())
            days.append((days: numOfDays, prepend: firstWeekDay - 1, append: 7 - lastWeekDay))
            curMonth = calendar.date(byAdding: .month, value: 1, to: curMonth!)
        }
    }
    //////////////////////////////////////
    func selectInBetweenCells() {
        var section = startDateIndexPath!.section
        var item = startDateIndexPath!.item
        var indexPathArr = [IndexPath]()
        while section < months.count, section <= endDateIndexPath!.section {
            let curIndexPath = IndexPath(item: item, section: section)
            if let cell = self.cellForItem(at: curIndexPath) as? RZDatePickerCell {
                if curIndexPath != startDateIndexPath && curIndexPath != endDateIndexPath {
                    cell.type.insert(.InBetweenDate)
                    cell.configureCell()
                }
                indexPathArr.append(curIndexPath)
            }
            if section == endDateIndexPath!.section && item >= endDateIndexPath!.item {
                break
            } else if item >= (self.numberOfItems(inSection: section) - 1) {
                section += 1
                item = 0
            } else {
                item += 1
            }
        }
        self.performBatchUpdates({
            (s) in
            self.reloadItems(at: indexPathArr)
        }, completion: nil)
    }
    //////////////////////////////////////
    func deselectSelectedCells() {
        if let start = startDateIndexPath {
            var section = start.section
            var item = start.item + 1
            if let cell = self.cellForItem(at: start) as? RZDatePickerCell {
                cell.type.remove([.InBetweenDate, .SelectedStartDate, .SelectedEndDate, .Selected, .Highlighted])
                cell.configureCell()
                self.deselectItem(at: start, animated: false)
            }
            if let end = endDateIndexPath {
                let indexPathArr = [IndexPath]()
                while section < months.count, section <= end.section {
                    let curIndexPath = IndexPath(item: item, section: section)
                    if let cell = self.cellForItem(at: curIndexPath) as? RZDatePickerCell {
                        cell.type.remove([.InBetweenDate, .SelectedStartDate, .SelectedEndDate, .Selected, .Highlighted])
                        cell.configureCell()
                        self.deselectItem(at: curIndexPath, animated: false)
                    }
                    
                    if section == end.section && item >= end.item {
                        // stop iterating beyond end date
                        break
                    } else if item >= (self.numberOfItems(inSection: section) - 1) {
                        // more than num of days in the month
                        section += 1
                        item = 0
                    } else {
                        item += 1
                    }
                }
                
                self.performBatchUpdates({
                    (s) in
                    self.reloadItems(at: indexPathArr)
                }, completion: nil)
            }
        }
    }
    
    
    
    
    
    
    ////////////////////////////////////
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        return months.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days[section].prepend + days[section].days + days[section].append
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // Load more months on reaching last (n)th month
        if indexPath.section == (months.count - lastNthMonthBeforeLoadMore) && !isLoadingMore {
            let originalCount = months.count
            isLoadingMore = true
            DispatchQueue.global(qos: .background).async {
                self.loadMoreMonths(completion: {
                    () in
                    DispatchQueue.main.async {
                        collectionView.performBatchUpdates({
                            () in
                            let range = originalCount..<originalCount.advanced(by: self.subsequentMonthsLoadCount)
                            let indexSet = IndexSet(integersIn: range)
                            collectionView.insertSections(indexSet)
                            
                        }, completion: {
                            (res) in
                            self.isLoadingMore = false
                        })
                    }
                })
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! RZDatePickerCell
        configure(cell: cell, withIndexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: monthHeaderID, for: indexPath) as! RZDatePickerMonthHeader
        let monthData = months[indexPath.section]
        let curYear = calendar.component(.year, from: today)
        let year = calendar.component(.year, from: monthData)
        let month = calendar.component(.month, from: monthData)
        if (curYear == year) {
            header.monthLabel.text = dateFormatter.monthSymbols[month - 1]
        } else {
            header.monthLabel.text = "\(dateFormatter.shortMonthSymbols[month - 1]) \(year)"
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.bounds.width, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! RZDatePickerCell
        cell.type.insert(.Selected)
        let selectedMonth = months[indexPath.section]
        let year = calendar.component(.year, from: selectedMonth)
        let month = calendar.component(.month, from: selectedMonth)
        let dateComp = DateComponents(year: year, month: month, day: Int(cell.dateLabel.text!))
        let selectedDate = calendar.date(from: dateComp)!
        if selectedStartDate == nil || (selectedEndDate == nil && selectedDate < selectedStartDate!) {
            if startDateIndexPath != nil, let prevStartCell = collectionView.cellForItem(at: startDateIndexPath!) as? RZDatePickerCell {
                prevStartCell.type.remove(.Selected)
                prevStartCell.configureCell()
                collectionView.deselectItem(at: startDateIndexPath!, animated: false)
            }
            selectedStartDate = selectedDate
            startDateIndexPath = indexPath
        } else if selectedEndDate == nil {
            selectedEndDate = selectedDate
            endDateIndexPath = indexPath
            // select start date to trigger cell UI change
            if let startCell = collectionView.cellForItem(at: startDateIndexPath!) as? RZDatePickerCell {
                startCell.type.insert(.SelectedStartDate)
                startCell.configureCell()
            }
            // select end date to trigger cell UI change
            if let endCell = collectionView.cellForItem(at: endDateIndexPath!) as? RZDatePickerCell {
                endCell.type.insert(.SelectedEndDate)
                endCell.configureCell()
            }
            // loop through cells in between selected dates and select them
            selectInBetweenCells()
        } else {
            // deselect previously selected cells
            deselectSelectedCells()
            selectedStartDate = selectedDate
            selectedEndDate = nil
            startDateIndexPath = indexPath
            endDateIndexPath = nil
            if let newStartCell = collectionView.cellForItem(at: startDateIndexPath!) as? RZDatePickerCell {
                newStartCell.type.insert(.Selected)
                newStartCell.configureCell()
            }
        }
        cell.configureCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let cell = collectionView.cellForItem(at: indexPath) as! RZDatePickerCell
        return cell.type.contains(.Date)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! RZDatePickerCell
        if isInBetween(indexPath: indexPath) {
            deselectSelectedCells()
            let selectedMonth = months[indexPath.section]
            let year = calendar.component(.year, from: selectedMonth)
            let month = calendar.component(.month, from: selectedMonth)
            let dateComp = DateComponents(year: year, month: month, day: Int(cell.dateLabel.text!))
            let selectedDate = calendar.date(from: dateComp)!
            selectedStartDate = selectedDate
            selectedEndDate = nil
            startDateIndexPath = indexPath
            endDateIndexPath = nil
            if let newStartCell = self.cellForItem(at: startDateIndexPath!) as? RZDatePickerCell {
                newStartCell.type.insert(.Selected)
                newStartCell.configureCell()
                self.selectItem(at: startDateIndexPath!, animated: false, scrollPosition: .left)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        if selectedEndDate == nil && startDateIndexPath == indexPath {
            return false
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! RZDatePickerCell
        cell.type.insert(.Highlighted)
        cell.configureCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        let cell = collectionView.cellForItem(at: indexPath) as! RZDatePickerCell
        return cell.type.contains(.Date)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! RZDatePickerCell
        cell.type.remove(.Highlighted)
        cell.configureCell()
    }
}
