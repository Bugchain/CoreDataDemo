//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Chainarong Chaiyaphat on 1/22/18.
//  Copyright © 2018 Chainarong Chaiyaphat. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{

    var userList = [Users]()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadData()
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? UserCollectionViewCell{
            
            cell.lblName.text = userList[indexPath.row].username
            cell.lblEmail.text = userList[indexPath.row].email
            cell.lblAge.text = "Age : \(String(describing: userList[indexPath.row].age)) years"
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.addTarget(self, action: #selector(onDeleteButtonClicked(sender:)), for: .touchUpInside)
            return cell
        }
        
        return UserCollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = self.view.bounds.width
        let cellHeight = cellWidth * 85 / 375
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    @IBAction func onAddButtonClicked(_ sender: Any) {
        
        showInputDialog()
    }
    
    @objc func onDeleteButtonClicked(sender: Any){
        if let btn = sender as? UIButton{
            
            print("On delete button clicked. \(btn.tag)")
            let context = getContext()
          
            do{
                context.delete(userList[btn.tag])
                try context.save()
                self.reloadData()
            }catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    
    }
    
    func showInputDialog(){
        let alert = UIAlertController(title: "New name", message: "Add a new name", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            guard let textField = alert.textFields?.first, let nameToSave = textField.text else{
                return
            }
            var email = nameToSave.lowercased() + "@gmail.com"
            email = email.replacingOccurrences(of: " ", with: "")
            if self.saveUser(username: nameToSave, email: email, profile: "https://github.com/\(nameToSave)", age: 20){
                self.reloadData()
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveUser(username:String, email:String, profile: String, age:Int)->Bool {
       
        var status:Bool = false
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Users", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        
        newUser.setValue(username, forKey: "username")
        newUser.setValue(email, forKey: "email")
        newUser.setValue(profile, forKey: "profile")
        newUser.setValue(age, forKey: "age")
        newUser.setValue(Date(), forKey: "date")
        
        do{
            try context.save()
            status = true
            print("Add new user completed.")
        }catch{
            print("Add new user failed.")
        }
        return status
    }
    
    func reloadData(){
       
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Users")
        let sort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        userList = try! context.fetch(fetchRequest) as! [Users]
        collectionView.reloadData()
    
    }
    
    func searchData(keyword: String){
        
        if(keyword.count <= 0){
            reloadData()
            return
        }
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Users")
        
        let sort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        // fetchRequest.predicate = NSPredicate(format: " username = %@", "Victor Frankenstein")
        fetchRequest.predicate = NSPredicate(format: "%K BEGINSWITH[cd] %@", "username" ,keyword)
        userList = try! context.fetch(fetchRequest) as! [Users]
        collectionView.reloadData()
        
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {}
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {}
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {}
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Searth with : \(searchText)")
        searchData(keyword: searchText)
    }
    
    
    func getContext()-> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
}

