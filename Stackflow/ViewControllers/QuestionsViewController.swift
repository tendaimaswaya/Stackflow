//
//  QuestionsViewController.swift
//  Stackflow
//
//  Created by Tendai Maswaya on 9/18/21.
//

import Foundation
import UIKit
import Combine

class QuestionsViewController : BaseViewController, UIGestureRecognizerDelegate {
    var activityIndicator = UIActivityIndicatorView()
    
    private var apiService = ApiService()
    private var cancellableSet: Set<AnyCancellable> = []
    
    var questions : Questions = Questions.init(items: [], has_more: false){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var page : Int!{
        didSet{
            getQuestions(for: "questions", page: page)
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        constrainContents()
        setupOnClickListeners()
        page = 1
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        /*for item in cancellableSet {
            item.cancel()
        }*/
    }
    
    lazy var tableView: UITableView = {
        tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.register(QuestionCell.self, forCellReuseIdentifier: QuestionCell.reuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.backgroundView = activityIndicator
        activityIndicator.startAnimating()
        return tableView
    }()
    
    lazy var viewMoreBtn: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .hexStringToUIColor(hex: Colors.gray350)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name:Fonts.dmSans,size:13)
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowOpacity = 0.50
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowRadius = 2
        button.layer.masksToBounds = false
        button.isHidden = true
        button.setTitle("View more questions", for: .normal)
        return button
    }()
    
    func setupOnClickListeners(){
        let viewMoreTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(QuestionsViewController.viewMoreTapped(gestureRecognizer:)))
        viewMoreTapRecognizer.delegate = self
       self.viewMoreBtn.addGestureRecognizer(viewMoreTapRecognizer)
    }
    
    func constrainContents(){
        view.addSubview(tableView)
        view.addSubview(viewMoreBtn)
        
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            viewMoreBtn.widthAnchor.constraint(equalToConstant: 220),
            viewMoreBtn.heightAnchor.constraint(equalToConstant: 40),
            viewMoreBtn.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            viewMoreBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        ])
    }
    
    @objc func viewMoreTapped(gestureRecognizer: UIGestureRecognizer){
        page = page + 1
    }
    
    func getQuestions(for section: String, page: Int)  {
         apiService.getPaginatedPublisher(for: section, page: page)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { status in
                print(status)
            }) { page in
                self.questions = page
        }.store(in: &self.cancellableSet)
    }
    
    
}

extension QuestionsViewController:UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: QuestionCell.reuseId, for: indexPath) as? QuestionCell{
            cell.question = questions.items[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let question = questions.items[indexPath.row]

        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == tableView.numberOfSections - 1 &&
            indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            viewMoreBtn.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 60))
        
                let label = UILabel()
                label.text = "Questions"
                label.textColor = .hexStringToUIColor(hex: Colors.black)
                label.font = UIFont(name:Fonts.dmSans,size:36)
                label.translatesAutoresizingMaskIntoConstraints = false
                label.numberOfLines = 1
        
                label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
          
                headerView.backgroundColor = .white
                headerView.addSubview(label)
                return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
                return 60
    }
}




