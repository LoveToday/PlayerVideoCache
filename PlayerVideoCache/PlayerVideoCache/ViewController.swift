//
//  ViewController.swift
//  PlayerVideoCache
//
//  Created by ChenJiangLin on 2020/4/14.
//  Copyright © 2020 LoveToday. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let queue = OperationQueue()
        
        let task1 = BlockOperation {
            print("test1")
        }
        
        
        
        let task3 = BlockOperation{
            print("task3")
            
            
            
            
        }
        
        let task2 = BlockOperation{
            print("task2")
            DispatchQueue.main.async {
                print("task2 finished")
                queue.addOperations([task3], waitUntilFinished: true)
            }
        }
        
        
        
        queue.addOperations([task1], waitUntilFinished: true)
        queue.addOperations([task2], waitUntilFinished: true)
        
        
        print("查看结果")
        
        
        
        
    }
    
    
    


}

