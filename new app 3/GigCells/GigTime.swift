//
//  GigTime.swift
//  new app 3
//
//  Created by William Hinson on 3/4/21.
//  Copyright © 2021 Mixed WIth Music. All rights reserved.
//

import UIKit

protocol TimeDelegate: class {
    func handleTap(_ cell: GigTime)
}

class GigTime: UITableViewCell {
    
    weak var delegate: TimeDelegate?
    
    var selectedTime : String = ""
    
    let eventTime: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "When will it be taking place?"
        label.textColor = .black
        return label
    }()
    
    let selectTime: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.placeholder = "Ex: March 5th, 7:30 p.m"
        tf.textColor = .lightGray
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tf.addGestureRecognizer(tap)
        tf.isUserInteractionEnabled = true
        return tf
    }()
    
    let datePicker = UIDatePicker()
    
    
 override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
   super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        
    addSubview(eventTime)
    eventTime.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
    
    contentView.addSubview(selectTime)
    selectTime.anchor(top: eventTime.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 16)
    let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    selectTime.addGestureRecognizer(tap)
    selectTime.isUserInteractionEnabled = true

    
    contentView.addSubview(datePicker)
    datePicker.anchor(top: eventTime.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 16)
    
    datePicker.addTarget(self, action: #selector(handleTap), for: .allEvents)
    
    let toolbar:UIToolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 0))
    
    selectTime.inputView = datePicker
    selectTime.inputAccessoryView = toolbar
    selectTime.isHidden = true
    
    
    
    
    let divider = UIView()
    divider.backgroundColor = .systemGroupedBackground
    addSubview(divider)
    divider.anchor(top: datePicker.bottomAnchor, left: leftAnchor,
                   right: rightAnchor, paddingTop: 2, paddingLeft: 16, paddingRight: 16, height: 1)
//        addSubview(titleTextField)
//        titleTextField.anchor(top: genrelabel.bottomAnchor, left: self.leftAnchor, paddingTop: 8, paddingLeft: 16)

}
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    @objc func handleTap() {
        delegate?.handleTap(self)
    }

}
