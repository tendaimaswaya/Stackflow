//
//  QuestionCell.swift
//  Stackflow
//
//  Created by Tendai Maswaya on 9/18/21.
//

import Foundation
import UIKit

class QuestionCell: UITableViewCell {
    static let reuseId = "QuestionsCell"
    var question: Question?{
        didSet{
            questionLabel.text = question?.title
            votesLabel.text = "\(question?.score ?? 0)"
            answersLabel.text = String(describing:question?.answer_count ?? 0)
            ownerLabel.text = "by \(String(describing: question?.owner.display_name ?? ""))"
            setTags(tags: question?.tags ?? [])
            
            let date = Date(timeIntervalSince1970: TimeInterval(question?.creation_date ?? 0))
            timestampLabel.text = date.timeAgoSinceDate()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: QuestionCell.reuseId)
        setupCell()
    }
    
    func setTags(tags:[String]){
        let buttonPadding:CGFloat = 5
        var xOffset:CGFloat = 10
        for i in 0 ... tags.count - 1  {
         let label = UILabel()
         label.text = String(describing: tags[i])
         let button = UIButton()
         button.tag = i
         button.backgroundColor = .hexStringToUIColor(hex: "#e9edf1")
         button.setTitleColor(.hexStringToUIColor(hex: Colors.blue), for: .normal)
         button.titleLabel?.font =  UIFont(name:Fonts.robotoSlab,size:CGFloat(12))
         button.layer.cornerRadius = 2
         button.setTitle("\(tags[i])", for: .normal)
         button.frame = CGRect(x: xOffset, y: CGFloat(buttonPadding), width: 100, height: 22)

        xOffset = xOffset + CGFloat(buttonPadding) + button.frame.size.width
        scrollView.addSubview(button)
        scrollView.contentSize = CGSize(width: xOffset, height: scrollView.frame.height)
        }

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: contentView.bounds.width, height: 30))
        contentView.addSubview(scrollView)
        scrollView.backgroundColor = UIColor.clear
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
      
        return scrollView
    }()
    
    lazy var actionsContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.cornerRadius = 5
        container.backgroundColor = .hexStringToUIColor(hex: Colors.gray350)
        return container
    }()
    
    lazy var questionContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .clear
        return container
    }()
    
    lazy var questionLabel: UILabel = {
        var titleFontSize = 15
        let label = UILabel()
        label.textColor = .hexStringToUIColor(hex: Colors.blue)
        label.font = UIFont(name:Fonts.robotoSlab,size:CGFloat(titleFontSize))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    lazy var timestampLabel: UILabel = {
        var titleFontSize = 9
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont(name:Fonts.robotoSlab,size:CGFloat(titleFontSize))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    lazy var ownerLabel: UILabel = {
        var titleFontSize = 11
        let label = UILabel()
        label.textColor = .hexStringToUIColor(hex: Colors.blue)
        label.font = UIFont(name:Fonts.robotoSlab,size:CGFloat(titleFontSize))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    lazy var votesLabel: UILabel = {
        var titleFontSize = 17
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name:Fonts.robotoSlab,size:CGFloat(titleFontSize))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    lazy var voteActionIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "arrow.up")?.withRenderingMode(.alwaysTemplate)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        imageView.tintColor = UIColor.white
        return imageView
    }()
    
    lazy var answersLabel: UILabel = {
        var titleFontSize = 17
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name:Fonts.robotoSlab,size:CGFloat(titleFontSize))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    lazy var answersIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "ic_answers")?.withRenderingMode(.alwaysTemplate)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        imageView.tintColor = UIColor.white
        return imageView
    }()
    
    func setupCell(){
        actionsContainer.addSubview(votesLabel)
        actionsContainer.addSubview(voteActionIcon)
        actionsContainer.addSubview(answersLabel)
        actionsContainer.addSubview(answersIcon)
        
        questionContainer.addSubview(questionLabel)
        questionContainer.addSubview(timestampLabel)
        questionContainer.addSubview(ownerLabel)
        questionContainer.addSubview(scrollView)
        
        contentView.addSubview(actionsContainer)
        contentView.addSubview(questionContainer)
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 90),

            actionsContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            actionsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            actionsContainer.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.12),
            actionsContainer.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.95),
            
            questionContainer.leadingAnchor.constraint(equalTo: actionsContainer.trailingAnchor, constant: 3),
            questionContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            questionContainer.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.88),
            questionContainer.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            
            votesLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            votesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            voteActionIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            voteActionIcon.leadingAnchor.constraint(equalTo: votesLabel.trailingAnchor, constant: 2),
            voteActionIcon.widthAnchor.constraint(equalToConstant: 17),
            voteActionIcon.heightAnchor.constraint(equalToConstant: 17),
            
            answersLabel.topAnchor.constraint(equalTo: votesLabel.bottomAnchor, constant: 10),
            answersLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            answersIcon.topAnchor.constraint(equalTo: voteActionIcon.bottomAnchor, constant: 16.5),
            answersIcon.leadingAnchor.constraint(equalTo: answersLabel.trailingAnchor, constant: 4),
            answersIcon.widthAnchor.constraint(equalToConstant: 18),
            answersIcon.heightAnchor.constraint(equalToConstant: 18),
            
            questionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            questionLabel.leadingAnchor.constraint(equalTo: questionContainer.leadingAnchor, constant: 10),
            questionLabel.trailingAnchor.constraint(equalTo:questionContainer.trailingAnchor),
            
            scrollView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 0),
            scrollView.heightAnchor.constraint(equalToConstant: 30),
            scrollView.leadingAnchor.constraint(equalTo: questionContainer.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo:questionContainer.trailingAnchor),
            
            timestampLabel.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 3),
            timestampLabel.leadingAnchor.constraint(equalTo: questionContainer.leadingAnchor, constant: 10),
            
            ownerLabel.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 1),
            ownerLabel.leadingAnchor.constraint(equalTo: timestampLabel.trailingAnchor, constant: 5),
        ])
    }

}
