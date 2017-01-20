//
//  DataStore.swift
//  MyDemo
//
//  Created by Linton on 2017/1/20.
//  Copyright © 2017年 linton. All rights reserved.
//

import UIKit
import CoreData

struct DataStore {
    //获取托管对象的上下文
    static func getObjectContext() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        return context
    }
    
    //增
    static func insertData(name: String, age: String) {
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
    static func removeData(name: String, age: String) {
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
    static func updateData(name: String) {
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
    static func queryData() {
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
