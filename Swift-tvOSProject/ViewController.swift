//
//  ViewController.swift
//  Swift-tvOSProject
//
//  Created by narendra. vadde on 12/10/20.
//  Copyright © 2020 narendra. vadde. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var categories = ["Airplanes", "Beaches","Cats", "Cities", "Dogs", "Earth", "Forests", "Galaxies", "Landmarks", "Moutains", "People", "Roads", "Sports", "Sunsets"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let controller = storyboard?.instantiateViewController(identifier: "Images") as? ImageViewController else {return}
        controller.category = categories[indexPath.row]
        present(controller, animated: true, completion: nil)
    }
}

