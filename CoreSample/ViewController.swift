//
//  ViewController.swift
//  CoreSample
//
//  Created by Anil Kumar on 17/08/19.
//  Copyright © 2019 AIT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var tableview: UITableView!
  @IBOutlet weak var imageView: UIImageView!
  
  var people = [Person]()
  private lazy var imagePicker = ImagePicker()
  
  let persistancyManager : PersistenceServce
  
  init(persistancyManager: PersistenceServce = .init()) {
    self.persistancyManager = persistancyManager
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()        
    
    imagePicker.delegate = self
    let tap = UITapGestureRecognizer(target: self, action: #selector(getImage))
    imageView.isUserInteractionEnabled = true
    imageView.addGestureRecognizer(tap)
    
    
    imageView.layer.cornerRadius = imageView.frame.width/2
    imageView.layer.masksToBounds = true        
    
    tableview.tableFooterView = UIView()
    
    let people = persistancyManager.fetch(Person.self)
    self.people = people
    if people.count != 0 {
      imageView.image = UIImage(data: people[0].imagedata)
      tableview.reloadData()
    }
  }
  
  
  @objc func getImage(){
    let alertController = UIAlertController(title: "", message: "Pick or Capture image.", preferredStyle: .alert)
    
    let action1 = UIAlertAction(title: "Camera", style: .default) { (action:UIAlertAction) in
      print("You've pressed default");
      self.imagePicker.cameraAsscessRequest()
    }
    
    let action2 = UIAlertAction(title: "Dismiss", style: .cancel) { (action:UIAlertAction) in
      
    }
    
    let action3 = UIAlertAction(title: "Gallery", style: .default) { (action:UIAlertAction) in
      print("You've pressed cancel");
      self.imagePicker.photoGalleryAsscessRequest()
    }
    
    alertController.addAction(action1)
    alertController.addAction(action2)
    alertController.addAction(action3)
    self.present(alertController, animated: true, completion: nil)
  }

  @IBAction func addBtn(_ sender: Any) {
    let alert = UIAlertController(title: "Add Person", message: nil, preferredStyle: .alert)
    alert.addTextField { (textField) in
      textField.placeholder = "Name"
    }
    alert.addTextField { (textField) in
      textField.placeholder = "Age"
      textField.keyboardType = .numberPad
    }
    let action = UIAlertAction(title: "Post", style: .default) { [weak self] (_) in
      guard let `self` = self else { return }
      let name = alert.textFields!.first!.text!
      let age = alert.textFields!.last!.text!
      if name.count == 0 { return }
      
      let person = Person(context: self.persistancyManager.context)
      person.name = name
      person.age = Int16(age)!
      person.values = [23, 45, 567.8, 123, 0, 0] //just this
      
      guard let imageData = UIImage(named: "1")?.jpegData(compressionQuality: 1.0) else { return }
      person.imagedata = imageData
      
      self.persistancyManager.saveContext()
      self.people.append(person)
      self.tableview.reloadData()
    }
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
    imagePicker.present(parent: self, sourceType: sourceType)
  }
  
}

extension ViewController: UITableViewDelegate {
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return people.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
    cell.textLabel?.text = people[indexPath.row].name
    cell.detailTextLabel?.text = String(people[indexPath.row].age)
    return cell
  }
}


extension ViewController: ImagePickerDelegate {
  
  func imagePickerDelegate(didSelect image: UIImage, delegatedForm: ImagePicker) {
    imageView.image = image
    imagePicker.dismiss()
  }
  
  func imagePickerDelegate(didCancel delegatedForm: ImagePicker) { imagePicker.dismiss() }
  
  func imagePickerDelegate(canUseGallery accessIsAllowed: Bool, delegatedForm: ImagePicker) {
    if accessIsAllowed {
      presentImagePicker(sourceType: .photoLibrary)
    }
  }
  
  func imagePickerDelegate(canUseCamera accessIsAllowed: Bool, delegatedForm: ImagePicker) {
    if accessIsAllowed {
      presentImagePicker(sourceType: .camera)
    }
  }
}
