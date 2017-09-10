//
//  WeatherTableViewController.swift
//  Weather or Not
//
//  Created by Daniel Huang on 9/9/17.
//  Copyright © 2017 Daniel Huang. All rights reserved.
//

import UIKit
import CoreLocation //used for geocoding

class WeatherTableViewController: UITableViewController,UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var forecastData = [Weather]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        updateWeatherForLocation(location: "San Diego") //to display San Diego as default city
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let locationString = searchBar.text, !locationString.isEmpty{
            //make sure the search text is not empty
            //then call the update function
            updateWeatherForLocation(location: locationString)
        }
        
    }
    
    //the function that call the forecast func in Weather struct
    func updateWeatherForLocation(location: String){
        CLGeocoder().geocodeAddressString(location) { (placemarks:[CLPlacemark]?, error:Error?) in
            if error == nil {
                
                if let location = placemarks?.first?.location {
                    
                    //call our favorite static function
                    Weather.forecast(withLocation: location.coordinate, completion: { (results:[Weather]?) in
                        //the results is what we need that are sent back by the API
                        if let weatherData = results{
                            self.forecastData = weatherData
                            
                            
                            //this is to perform data transfer (asynchronously) to the main thread in order to update UI
                            DispatchQueue.main.sync {
                                self.tableView.reloadData() //this reload func triggers the below numberOfSections and 2 tableView fuctions
                            }
                        }
                    })
                }
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    
    //NOTICE the following two funcs have been modified to present all sections (each has 1 single row)
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return forecastData.count
        //return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        //return forecastData.count
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let weatherObj = forecastData[indexPath.section]
        
        cell.textLabel?.text = weatherObj.summary
        cell.detailTextLabel?.text = "\(Int(weatherObj.temperature)) °F"
        cell.imageView?.image = UIImage(named: weatherObj.icon)
        return cell
    }
    
    //the function provides the date info for the header of each section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //Date() initializer is set to current time by default
        let date = Calendar.current.date(byAdding: .day, value: section, to: Date())
        
        let dateFormatter = DateFormatter()  //This is to formate the raw "date" data
        
        dateFormatter.dateFormat = "MMMM dd, YYYY"
        
        return dateFormatter.string(from: date!)
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
