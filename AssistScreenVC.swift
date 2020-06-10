//
//  AssistScreenVC.swift
//  vaal sos
//
//  Created by Rp on 21/11/18.
//  Copyright © 2018 Rp. All rights reserved.
//

import UIKit

class AssistScreenVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tblview : UITableView!
    
    var arrExpandObjects = NSMutableArray()
    
    var array = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblview.tableFooterView = UIView()
        SVProgressHUD.show()
        
        // Do any additional setup after loading the view.
        
        tblview.separatorStyle = .none
        
        self.getmenu()
    }
    
    func getmenu(){
        
        let str = "http://sosapp.co.za/system/se_vdbp/get_assist.php"
        
        let url = URL.init(string: str)
        
        let request = NSMutableURLRequest.init(url: url as! URL)
        request.httpMethod = "POST"
        
        let strParameter = String.init(format: "data=%@","Rescom")
        
        request.httpBody = strParameter.data(using: String.Encoding.utf8)
        
        let configuration = URLSessionConfiguration.default
        
        let session = URLSession.init(configuration: configuration)
        
        let task =  session.dataTask(with: request as URLRequest, completionHandler: {(data,response, error) -> Void in
            SVProgressHUD.dismiss()
            do{
                let dic = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! NSDictionary
                print(dic)
                DispatchQueue.main.async {
                    
                    self.array = dic.object(forKey: "data") as! NSArray
                    self.tblview.reloadData()
                   // print(self.array)
                }
                
            }catch{
                
            }
            
        })
        task.resume()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let number = NSNumber.init(value: section)
        
        if arrExpandObjects.contains(number)
        {
            let dic = self.array.object(at: section) as! NSDictionary
            let arrObject = dic.value(forKey: "array") as! NSArray
            
            return arrObject.count
        }
        
        return 0

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let dic = self.array.object(at: indexPath.section) as! NSDictionary
        let arrObject = dic.value(forKey: "array") as! NSArray
        
        let  object = arrObject.object(at: indexPath.row) as! NSDictionary
        let strName = object.value(forKey: "name") as? String
        
        let lbl = cell.contentView.viewWithTag(1001) as! UILabel
        lbl.text = strName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerview = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
        headerview.backgroundColor = UIColor.white
        let lbl = UILabel()
        lbl.frame = CGRect.init(x: 10, y: 10, width: UIScreen.main.bounds.size.width, height: 30)
        let dic = self.array.object(at: section) as! NSDictionary
        lbl.text = dic.value(forKey: "header") as? String
        
        let view = UIView()
        view.tag = section
        view.frame = CGRect.init(x: 10, y: 5, width: UIScreen.main.bounds.size.width-20, height: 50)
        view.backgroundColor = UIColor.red
        view.addSubview(lbl)
        
        headerview.addSubview(view)
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapOnview(gesture:)))
        view.addGestureRecognizer(tapGesture)
        
        return headerview
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    @objc func tapOnview(gesture:UITapGestureRecognizer){
       
        let view = gesture.view as! UIView
        let index = view.tag
        
        let number = NSNumber.init(value: index)
        
        if arrExpandObjects.contains(number)
        {
           arrExpandObjects.remove(number)
            self.tblview.beginUpdates()
            
            self.deleteRows(section: index)
            self.tblview.endUpdates()
        }
        else{
            arrExpandObjects.add(number)
            self.tblview.beginUpdates()
            self.insertRows(section: index)
            self.tblview.endUpdates()
        }
    }
    
    func insertRows(section:NSInteger)
    {
        let dic = self.array.object(at: section) as! NSDictionary
        let arrObject = dic.value(forKey: "array") as! NSArray
        
        for i in 0..<arrObject.count{
            
            let indexPath = NSIndexPath.init(row: i, section: section)
            
            tblview.insertRows(at: [indexPath as IndexPath], with: .automatic)
        }
    }

    func deleteRows(section:NSInteger)
    {
        let rows = tblview.numberOfRows(inSection: section)
        
        for i in 0..<rows
        {
            let indexPath = NSIndexPath.init(row: i, section: section)

            tblview.deleteRows(at: [indexPath as IndexPath], with: .automatic)
        }
    }
    
    @IBAction func clicknBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
