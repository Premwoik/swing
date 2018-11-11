//
//  MasterViewController.swift
//  WojtasikPrognozaPogody
//
//  Created by PW on 11/11/2018.
//  Copyright © 2018 RS KIS.EDU. All rights reserved.
//

import UIKit

protocol CitySelectionDelegate: class {
    func citySelected(_ newCity: City)
}
class MasterViewController: UITableViewController {
    weak var delegate: CitySelectionDelegate?
    
    var cities: [City] = [City(id: 44418, name: "London"), City(id: 523920, name: "Warsaw"), City(id: 638242, name: "Berlin")]
 
    @objc func addBtnClick(_ sender: UIButton){
        performSegue(withIdentifier: "AddCity", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AddCityViewController{
            let c = segue.destination as? AddCityViewController
            c?.parClass = self
        }
    }
    
    func addCity(name: String, id: Int){
        let c = City(id: id, name: name)
        c.load()
        cities.append(c)
        self.tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add" , style: .plain, target: self, action: #selector(addBtnClick(_:)))
        super.viewDidLoad()
        for c in cities {
            c.load()
        }
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cities.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CityCell
        let city = cities[indexPath.row]
        cell.temp.text = String(format: "%.1f", city.temp ?? 0)     // Configure the cell...
        cell.title.text = city.name
        cell.img.image = city.img
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cities[indexPath.row]
        delegate?.citySelected(city)
        if let detailViewController = delegate as? ViewController {
            splitViewController?.showDetailViewController(detailViewController, sender: nil)
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
