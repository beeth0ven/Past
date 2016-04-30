//
//  EditeSingleTextTVC.swift
//  Past
//
//  Created by luojie on 16/4/30.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EditeSingleTextTVC: UITableViewController {
    
    var keyDisplayName: String?
    var value: String!
    var placeholder: String?
    
    var didEdite: ((String) -> Void)!
    
    @IBOutlet private weak var textField: UITextField! {
        didSet {
            textField.text = value
            textField
                .rx_text
                .subscribeNext { [unowned self] in self.value = $0 }
                .addDisposableTo(disposeBag)
            
            textField
                .rx_controlEvent(.EditingDidEndOnExit)
                .subscribeNext { [unowned self] in self.done() }
                .addDisposableTo(disposeBag)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    private func updateUI() {
        title = keyDisplayName
        textField.placeholder = placeholder
    }
    
    @IBAction private func done(sender: UIBarButtonItem) {
        done()
    }
    
    private func done() {
        navigationController?.popViewControllerAnimated(true)
        didEdite?(value.trimedString)
    }
    
    deinit {
        print(String(self.dynamicType), #function)
    }
}


