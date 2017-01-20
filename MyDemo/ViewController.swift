//
//  ViewController.swift
//  MyDemo
//
//  Created by Linton on 2017/1/19.
//  Copyright © 2017年 linton. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        ageTextField.delegate = self
    }
    
    //增
    @IBAction func insertData(_ sender: UIButton) {
        DataStore.insertData(name: nameTextField.text!, age: ageTextField.text!)
        nameTextField.text = nil
        ageTextField.text = nil
    }
    //删
    @IBAction func removeData(_ sender: UIButton) {
        guard let name = nameTextField.text,
            let age = ageTextField.text else { return }
        DataStore.removeData(name: name, age: age)
        nameTextField.text = nil
        ageTextField.text = nil
    }
    //改
    @IBAction func updateData(_ sender: UIButton) {
        guard let name = nameTextField.text else { return }
        DataStore.updateData(name: name)
    }
    //查
    @IBAction func queryData(_ sender: UIButton) {
        DataStore.queryData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: 收键盘
extension ViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
