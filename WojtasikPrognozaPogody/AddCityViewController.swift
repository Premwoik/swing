//
//  AddCityViewController.swift
//  WojtasikPrognozaPogody
//
//  Created by PW on 11/11/2018.
//  Copyright © 2018 RS KIS.EDU. All rights reserved.
//

import UIKit

class AddCityViewController: UIViewController, CityDataProt, UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityNameCell")!
        let city = cities[indexPath.row]
        cell.textLabel?.text = city.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cities[indexPath.row]
        self.parClass?.addCity(name: city.title, id: city.woeid)
        print(city.title)
        
    }
    
    var cities: CitiesData = []
    var client: CityClient?
    var parClass: MasterViewController?
    
    @IBOutlet weak var cityName: UITextField!

    @IBOutlet weak var resultTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        client = CityClient(owner: self)
        resultTableView.dataSource = self
        resultTableView.delegate = self
    }
    
    func updateCitiesData(data: CitiesData) {
        cities = data
        resultTableView.reloadData()
    }
    
    @IBAction func cancelBtnClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchBtnClick(_ sender: Any) {
        let cityN = cityName.text
        client!.searchForCity(cityName: cityN ?? "")
    }
    /*
    // MARK: - Navigation"

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
