
//
//  ViewController.swift
//  HapplyNews
//
//  Created by koneti santhosh kumar on 02/07/19.
//  Copyright © 2019 sp. All rights reserved.
//

//almafire
//https://stackoverflow.com/questions/41364794/alamofire-4-swift-3-get-request-with-parameters

//uisafari_UIviewController
//https://stackoverflow.com/questions/38203960/how-to-open-safari-view-controller-from-a-webview-swift

//key_old: 2a66e460c1af4f298c8248cc85b48d01

//key: 452aad4896e34de98e566f53f812a39a

//https://newsapi.org/



import UIKit
import Alamofire
import RealmSwift
import SafariServices



class ViewController: UIViewController , SFSafariViewControllerDelegate {
    
    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet weak var tableViewList: UITableView!
    var articlesArray: [NewsListArticlesStruct]?
    var articlesList : Results<NewsListRealmDB>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTxt.text = "bitcoin"
        self.registerCell()
        self.fetchDataFromRealm()
    }
    
    
    //MARK:-IBActions
    @IBAction func SearchBtnAction(_ sender: UIButton) {
        self.deleteDataFrom()
        self.newAPiList()
    }
    
    
    //MARK:- Func
    func registerCell(){
        tableViewList.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell")
    }
    
    //MARK:- Api_Call
    
    //https://newsapi.org/v2/everything?q=bitcoin&from=2019-06-02&sortBy=publishedAt&apiKey=452aad4896e34de98e566f53f812a39a
    
    //http://newsapi.org/v2/everything?q=bitcoin&from=2020-09-07&sortBy=publishedAt&apiKey=452aad4896e34de98e566f53f812a39a
    
    func newAPiList(){
        let search = self.searchTxt.text
        let newsApi = "https://newsapi.org/v2/everything?q=\(search ?? "")&from=2020-09-07&sortBy=publishedAt&apiKey=452aad4896e34de98e566f53f812a39a"
        
        Alamofire.request(newsApi, method: .get, encoding: JSONEncoding.default)
            .responseData { response in
                debugPrint(response)
                if let responseData = response.data {
                    let res =  try? JSONDecoder().decode(NewsListStruct.self, from: responseData)
                    print(res as Any)
                    DispatchQueue.main.async {
                        self.articlesArray = res?.articles
                        self.insertingDataIntoRealm()
                    }
                }
        }
        
        //        Alamofire.request(newsApi, method: .get, encoding: JSONEncoding.default)
        //            .responseJSON { response in
        //                debugPrint(response)
        //
        //                if let data = response.result.value{
        //                    // Response type-1
        //                    if  (data as? [[String : AnyObject]]) != nil{
        //                        print("data_1: \(data)")
        //                    }
        //                    // Response type-2
        //                    if  (data as? [String : AnyObject]) != nil{
        //                        print("data_2: \(data)")
        //                    }
        //                    if (data as? Data) != nil {
        //                        print(data)
        //                    }
        //                }
        //        }
        
    }
}

//MARK:- delegateMethods_Tableview
extension ViewController : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell") as! NewsTableViewCell
        cell.titleLbl.text = articlesList?[indexPath.row].title
        cell.autherLbl.text = articlesList?[indexPath.row].author
        cell.newsImageView.load(articlesList?[indexPath.row].urlToImage ?? "")
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let url = articlesList?[indexPath.row].url {
            self.openSafariVC(url)
        }
    }
    
    func openSafariVC(_ urlStr:String) {
        let safariVC = SFSafariViewController(url: NSURL(string: urlStr)! as URL)
        self.present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

//MARK:- Realm_Methods
extension ViewController {
    func insertingDataIntoRealm(){
        var newsValues = [NewsListRealmDB]()
        if let arr = self.articlesArray {
            for (_,ele) in arr.enumerated() {
                let newsValue = NewsListRealmDB()
                newsValue.author = ele.author ?? ""
                newsValue.title = ele.title ?? ""
                newsValue.urlToImage =  ele.urlToImage ?? ""
                newsValue.url = ele.url ?? ""
                newsValues.append(newsValue)
            }
        }
        
        do {
            let realm = try Realm()
            try! realm.write {
                realm.add(newsValues)
            }
            self.fetchDataFromRealm()
        } catch {
            print("Error parse item json \(error)")
        }
    }
    
    func fetchDataFromRealm(){
        do {
            let realm = try Realm()
            let list = realm.objects(NewsListRealmDB.self)
            self.articlesList = list
            DispatchQueue.main.async {
                self.tableViewList.reloadData()
            }
        } catch let error {
            print("Error: \(error)")
        }
        
    }
    
    func deleteDataFrom(){
        do {
            let realm = try Realm()
            try! realm.write {
                realm.deleteAll()
            }
            
        }
        catch let error {
            print("Error: \(error)")
        }
    }
}


