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
            //            calendarTableView.rowHeight = 40
        }
    }
    
    var testCalendar = Calendar(identifier: .gregorian)
    
    var subjects : [Subject] = []
    
    var eventArray : [String] = []
    
    var selectedStudent : Student = Student()
    
    var ref : DatabaseReference!
    
    let formatter = DateFormatter()
    
    var monthText = ""
    var yearText = ""
    
    var selectedDate = ""
    
    var firstTimeChecker = true
    
    var dateNumberStr = ""
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year : UILabel!
    @IBOutlet weak var month : UILabel!
    
    
    let outsideMonthColor = UIColor(colorWithHexValue: 0x5CCBEF)
    let monthColor = UIColor(colorWithHexValue: 0xEFFDFE)
    let selectedMonthColor = UIColor(colorWithHexValue: 0x5ACBEF)
    let currentDateSelectedViewColor = UIColor(colorWithHexValue: 0x9AF5F7)
    
    let todaysDate = Date()
    
    var eventsFromTheServer : [String:[String]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.scrollToDate(Date(), animateScroll: false)
        
        ref = Database.database().reference()
        
        getSubjectName()
        setUpCalendarView()
        
        reloadNewMonthEvent()
        
        //Set Background image
        let imageView = UIImageView()
        imageView.image = UIImage(named:"StudentStudying")
        imageView.contentMode = .scaleAspectFill
        
        self.tableView.backgroundView = imageView
        
        
        
    }
    
    func handleCellEvents(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCell else {return}
        
        validCell.eventDotView.isHidden = !eventsFromTheServer.contains{ $0.key == formatter.string(from: cellState.date)}
        
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCell else {return}
        
        formatter.dateFormat = "yyyy MM d"
        
        let todaysDateString = formatter.string(from: todaysDate)
        let monthDateString = formatter.string(from: cellState.date)
        
        
        if todaysDateString == monthDateString {
            validCell.dateLabel.textColor = UIColor.blue
        } else {
            validCell.dateLabel.textColor = UIColor.white
        }
        
        if validCell.isSelected {
            validCell.dateLabel.textColor = selectedMonthColor
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = monthColor
            } else {
                validCell.dateLabel.textColor = outsideMonthColor
            }
        }
        
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState, date: Date) {
        
        guard let validCell = view as? CustomCell else {return}
        
        if validCell.isSelected {
            validCell.selectedView.isHidden = false
        } else {
            validCell.selectedView.isHidden = true
        }
    }
    
    func setUpCalendarView() {
        calendarView.calendarDataSource = self
        calendarView.calendarDelegate = self
        
        //Setup calendar spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        //        calendarView.visibleDates().indates
        
        //Setup labels
        calendarView.visibleDates { (visibleDates) in
            self.setUpViewsOfCalendar(from: visibleDates)
        }
    }
    
    func setUpViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        guard let startDate = visibleDates.monthDates.first?.date else {return}
        
        let monthNumber = testCalendar.dateComponents([.month], from: startDate)
        let monthName = DateFormatter().monthSymbols[Int(monthNumber.month!) - 1]
        
        let yearNumber = testCalendar.component(.year, from: startDate)
        
        year.text = String(yearNumber)
        month.text = monthName
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
        loadDate()
        
        if tableView == self.tableView {
            count = subjects.count
        }
        
        if tableView == self.calendarTableView {
            guard let eventDate = eventsFromTheServer[dateNumberStr] else {return 0}
            return eventDate.count
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
            
            let dayStr = dateNumberStr.components(separatedBy: " ").last
            
            if dayStr == selectedDate {
                cell?.textLabel?.text = (eventsFromTheServer[dateNumberStr])?[indexPath.row]
            } else {
                return UITableViewCell()
            }
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sb = UIStoryboard(name: "Detail", bundle: Bundle.main)
        
        guard let vc = sb.instantiateViewController(withIdentifier: "ResultsViewController") as? ResultsViewController else {return}
        
        vc.selectedSubject = subjects[indexPath.row]
        vc.selectedStudent = selectedStudent
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension StudentViewController : JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyyy MM d"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        if let startDate = formatter.date(from: "2018 01 1"),
            let endDate = formatter.date(from: "2018 12 31") {
            
            let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: 6, calendar: testCalendar, generateInDates:.forAllMonths, generateOutDates: .tillEndOfGrid, firstDayOfWeek: .sunday, hasStrictBoundaries: false)
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
        
        handleCellSelected(view: cell, cellState: cellState, date: date)
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
        
        validCell.bounce()
        
        handleCellSelected(view: cell, cellState: cellState, date: date)
        handleCellTextColor(view: cell, cellState: cellState)
        handleCellEvents(view: cell, cellState: cellState)
        
        selectedDate = validCell.dateLabel.text ?? ""
        
        calendarTableView.reloadData()
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        handleCellSelected(view: cell, cellState: cellState, date: date)
        handleCellTextColor(view: cell, cellState: cellState)
        handleCellEvents(view: cell, cellState: cellState)
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setUpViewsOfCalendar(from: visibleDates)
        
        monthText = month.text ?? ""
        yearText = year.text ?? ""
        reloadNewMonthEvent()
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
    
    func loadDate() {
        
        let dict = ["January" : "01", "February" : "02", "March" : "03", "April" : "04", "May" : "05", "June" : "06", "July" : "07", "August" : "08", "September" : "09", "October" : "10", "November" : "11", "December" : "12"]
        
        guard let monthText = month.text,
            let yearText = year.text else {return}
        
        guard let monthNumber = dict[monthText] else {return}
        
        dateNumberStr = yearText + " " + monthNumber + " " + selectedDate
    }
    
    func loadDetail(completion: @escaping ([Date:[String]]) -> Void) {
        
        var eventDict : [Date:[String]] = [:]
        
        self.ref.child("Tuition").child("Event").queryOrdered(byChild: "Month").queryEqual(toValue: self.monthText).observe(.value) { (snapshot) in
            self.formatter.dateFormat = "yyyy MM d"
            
            
            if let dict = snapshot.value as? [String:[String:Any]] {
                for (_, v) in dict {
                    if let dateString = v["Date"] as? String,
                        let date = self.formatter.date(from: dateString),
                        let eventType = v["Event Type"] as? String,
                        let subject = v["Subject"] as? String {
                        
                        let subjectName = subject + " " + eventType
                        
                        if eventDict[date] != nil{
                            eventDict[date]?.append(subjectName)
                        } else {
                            eventDict[date] = [subjectName]
                        }
                    }
                    completion(eventDict)
                }
            }
        }
    }
    
    func reloadNewMonthEvent() {
        DispatchQueue.global().asyncAfter(deadline: .now()) {
            self.loadDetail(completion: { (eventDict) in
                
                for (date, event) in eventDict {
                    let stringDate = self.formatter.string(from: date)
                    self.eventsFromTheServer[stringDate] = event
                }
                
                DispatchQueue.main.async {
                    if self.firstTimeChecker == true {
                        self.calendarView.reloadData()
                        self.calendarView.selectDates([Date()])
                        self.firstTimeChecker = false
                    }
                }
            })
        }
    }
    
}

