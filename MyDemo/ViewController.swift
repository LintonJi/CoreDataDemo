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
        insertData(name: nameTextField.text!, age: ageTextField.text!)
        nameTextField.text = nil
        ageTextField.text = nil
    }
    //删
    @IBAction func removeData(_ sender: UIButton) {
        guard let name = nameTextField.text,
            let age = ageTextField.text else { return }
        removeData(name: name, age: age)
        nameTextField.text = nil
        ageTextField.text = nil
    }
    //改
    @IBAction func updateData(_ sender: UIButton) {
        guard let name = nameTextField.text else { return }
        updateData(name: name)
    }
    //查
    @IBAction func queryData(_ sender: UIButton) {
        queryData()
    }
    

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: 增删改查
extension ViewController {
    //获取托管对象的上下文
    func getObjectContext() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        return context
    }
    
    //增
    func insertData(name: String, age: String) {
        //取得上下文
        let context = getObjectContext()
        //获取之前创建的Person实体
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: context)
        //获取托管的person对象
        let person = NSManagedObject(entity: entity!, insertInto: context)
        //给person添加姓名、年龄
        person.setValue(name, forKey: "name")
        person.setValue(age, forKey: "age")
        //执行存储
        do {
            try context.save()
            print("Success")
            //成功
        } catch {
            print(error)
            //失败
        }
    }
    //删
    func removeData(name: String, age: String) {
        let context = getObjectContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        //设置查找条件
        let condition = "name='\(name)'OR age='\(age)'"
        let predicate = NSPredicate(format: condition, "")
        fetchRequest.predicate = predicate
        do {
            let fetchResults = try context.fetch(fetchRequest)
            guard fetchResults.count > 0 else {
                print("未找到数据")
                return
            }
            for result in fetchResults as! [NSManagedObject] {
                context.delete(result)
            }
            //删除之后不要忘记save
            try context.save()
            print("删除成功")
        } catch {
            print(error)
            //失败
        }

    }
    //改:修改名字
    func updateData(name: String) {
        let context = getObjectContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        let condition = "name='\(name)'"
        let predicate = NSPredicate(format: condition, "")
        fetchRequest.predicate = predicate
        do {
            let fetchResults = try context.fetch(fetchRequest)
            guard fetchResults.count > 0 else {
                print("未找到数据")
                return
            }
            for result in fetchResults as! [NSManagedObject] {
                result.setValue("Developer", forKey: "name")
            }
            try context.save()
            print("修改成功")
        } catch {
            print(error)
        }
    }
    
    //查
    func queryData() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        //此处未设置查询条件，默认取所有数据
        do {
            let context = getObjectContext()
            let fetchResults = try context.fetch(fetchRequest)
            for result in fetchResults {
                let name = result.value(forKey: "name")!
                let age = result.value(forKey: "age")!
                print("name: \(name), age: \(age)")
            }
            //成功
        } catch {
            print(error)
            //失败
        }
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
