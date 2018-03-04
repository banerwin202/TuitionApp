//
//  StudentViewController.swift
//  TuitionApp
//
//  Created by Ban Er Win on 02/03/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import UIKit
import FirebaseDatabase
import JTAppleCalendar

class StudentViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        }
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl! {
        didSet {
            segmentedControl.addTarget(self, action: #selector(indexChanged), for: .valueChanged)
        }
    }
    
    @IBOutlet weak var calendarTableView: UITableView! {
        didSet {
            calendarTableView.dataSource = self
            calendarTableView.register(UITableViewCell.self, forCellReuseIdentifier: "calendarCell")
            calendarTableView.rowHeight = 40
        }
    }
    
    
    var subjects : [Subject] = []
    
    var eventArray : [String] = []
    
    var ref : DatabaseReference!
    
    let formatter = DateFormatter()
    
//    var eventChecker : Bool = false
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year : UILabel!
    @IBOutlet weak var month : UILabel!
    
    
    let outsideMonthColor = UIColor(colorWithHexValue: 0x5CCBEF)
    let monthColor = UIColor(colorWithHexValue: 0xEFFDFE)
    let selectedMonthColor = UIColor(colorWithHexValue: 0x5ACBEF)
    let currentDateSelectedViewColor = UIColor(colorWithHexValue: 0x9AF5F7)
    
    let todaysDate = Date()
    
    var eventsFromTheServer : [String:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let serverObjects = self.getServerEvents()
            
            for (date, event) in serverObjects {
                let stringDate = self.formatter.string(from: date)
                self.eventsFromTheServer[stringDate] = event
            }
            
            DispatchQueue.main.async {
                self.calendarView.reloadData()
            }
            
        }
        
        ref = Database.database().reference()
        
        getSubjectName()
        setUpCalendarView()
        
        calendarView.scrollToDate(Date(), animateScroll: false)
        calendarView.selectDates([Date()])
        
    }
    
    func handleCellEvents(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCell else {return}
        
        validCell.eventDotView.isHidden = !eventsFromTheServer.contains{ $0.key == formatter.string(from: cellState.date)}
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCell else {return}
        
        formatter.dateFormat = "yyyy MM dd"
        
        let todaysDateString = formatter.string(from: todaysDate)
        let monthDateString = formatter.string(from: cellState.date)
        
        
        if todaysDateString == monthDateString {
            validCell.dateLabel.textColor = UIColor.blue
        } else {
            validCell.dateLabel.textColor = UIColor.white
        }
        
        if cellState.isSelected {
            validCell.dateLabel.textColor = selectedMonthColor
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = monthColor
            } else {
                validCell.dateLabel.textColor = outsideMonthColor
            }
        }
        
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCell else {return}
        
        if validCell.isSelected {
            validCell.selectedView.isHidden = false
        } else {
            validCell.selectedView.isHidden = true
        }
    }
    
    func setUpCalendarView() {
        //Setup calendar spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        //Setup labels
        calendarView.visibleDates { (visibleDates) in
            self.setUpViewsOfCalendar(from: visibleDates)
        }
    }
    
    func setUpViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        guard let date = visibleDates.monthDates.first?.date else {return}
        
        formatter.dateFormat = "yyyy"
        year.text = formatter.string(from: date)
        
        formatter.dateFormat = "MMMM"
        month.text = formatter.string(from: date)
    }
    
    
    //SUBJECT NAMES
    func getSubjectName() {
        ref.child("Tuition").child("Student").child("StudentID").child("Subjects").observe(.value) { (snapshot) in
            
            self.subjects.removeAll()
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                
                let subjectName = Subject(name: key)
                
                self.subjects.append(subjectName)
            }
            self.tableView.reloadData()
        }
    }
    
    @objc func indexChanged() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            tableView.isHidden = false
            calendarView.isHidden = true
        case 1:
            tableView.isHidden = true
            calendarView.isHidden = false
        default:
            break
        }
    }
    
}

extension StudentViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count : Int?
        
        if tableView == self.tableView {
            count = subjects.count
        }
        
        if tableView == self.calendarTableView {
            count = eventsFromTheServer.count
        }
        
        return count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell?
        
        if tableView == self.tableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            cell?.textLabel?.text = subjects[indexPath.row].name
        }
        
        if tableView == self.calendarTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "calendarCell", for: indexPath)
            
            for event in eventsFromTheServer.values {
                eventArray.append(event)
            }
            
//            if eventChecker == true {
                cell?.textLabel?.text = eventArray[indexPath.row]
//            } else {
//                cell?.textLabel?.text = ""
//            }
            
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sb = UIStoryboard(name: "Detail", bundle: Bundle.main)
        
        guard let vc = sb.instantiateViewController(withIdentifier: "ResultsViewController") as? ResultsViewController else {return}
        
        vc.selectedSubject = subjects[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension StudentViewController : JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        if let startDate = formatter.date(from: "2018 01 01"),
            let endDate = formatter.date(from: "2018 12 31") {
            
            let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
            return parameters
        }
        return ConfigurationParameters(startDate: Date(), endDate: Date())
    }
    
}

extension StudentViewController : JTAppleCalendarViewDelegate {
    
    //display cell
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        guard let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as? CustomCell else {return JTAppleCell()}
        
        cell.dateLabel.text = cellState.text
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        handleCellEvents(view: cell, cellState: cellState)
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        guard let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as? CustomCell else {return}
        
        cell.dateLabel.text = cellState.text
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        guard let validCell = cell as? CustomCell else {return}
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        handleCellEvents(view: cell, cellState: cellState)
        
//        eventsFromTheServer.contains(where: { $0.key == formatter.string(from: cellState.date)})
        
        if !validCell.eventDotView.isHidden {
//            self.eventChecker = true
            calendarTableView.rowHeight = 40
            calendarTableView.reloadData()
        } else {
            calendarTableView.rowHeight = 0
            calendarTableView.reloadData()
        }
        
        calendarTableView.reloadData()
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        handleCellEvents(view: cell, cellState: cellState)
        
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setUpViewsOfCalendar(from: visibleDates)
    }
    
}

extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0xFF0000) >> 8) / 255.0,
            blue: CGFloat(value & 0xFF0000) / 255.0,
            alpha: alpha
        )
    }
}

extension StudentViewController {
    func getServerEvents() -> [Date:String] {
        formatter.dateFormat = "yyyy MM dd"
        
        return [
            formatter.date(from: "2018 03 01")! : "Happy Birthday",
            formatter.date(from: "2018 03 02")! : "Test Event"
        ]
        
        
        
    }
    
    
}

