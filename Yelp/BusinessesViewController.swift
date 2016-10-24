//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate {
    
  //  @IBOutlet var dismissKeyboardView: UIView!
    @IBOutlet weak var yelpTableView: UITableView!
    var businesses: [Business]!
    var searchBar: UISearchBar!
    var originalResults: [Business]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yelpTableView.delegate = self
        yelpTableView.dataSource = self
        yelpTableView.rowHeight = UITableViewAutomaticDimension
        yelpTableView.estimatedRowHeight = 100
        
        searchBar = UISearchBar()
        searchBar.placeholder = "Restaurants"
        searchBar.sizeToFit()
        searchBar.delegate = self
        
        navigationItem.titleView = searchBar
        navigationController?.navigationBar.barTintColor = UIColor(red: 179/255, green: 16/255, blue: 0, alpha: 1)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "keyboardShouldReturn")
        //tap.cancelsTouchesInView = false
        yelpTableView.addGestureRecognizer(tap)

        Business.searchWithTerm(term: "Restaurants", completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.originalResults = businesses
            self.yelpTableView.reloadData()
            }
        )
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var filteredBusinesses = [Business]()
        
        for business in businesses {
            let name = business.name!.lowercased()
            if name.contains(searchText.lowercased()) == true {
                filteredBusinesses.append(business)
            }
        }
//Code below checked for restaurant name from businesses dict
      /*  if searchText == "" {
            businesses = originalResults
        } else {
            businesses = filteredBusinesses
        }
        yelpTableView.reloadData()
 */
//Code below changes the "term" value for searching and does the api get call
        Business.searchWithTerm(term: searchText, completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.originalResults = businesses
            self.yelpTableView.reloadData()
            }
        )

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        cell.business = businesses[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses!.count
        }
        return 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navController = segue.destination as! UINavigationController
        let filtersVC = navController.topViewController as! FiltersViewController
        filtersVC.delegate = self
        
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        var milesToMeters = [0.0, 482.803, 1609.34, 8046.72, 32186.9]
        var searchText = "Restaurants"
        let categories = filters["categories"] as? [String]
        let deals = filters["deal"] as? Bool
        let distanceIndex = filters["distance"] as? Int
        let sortType = filters["sort"] as? Int
        let sortMode = YelpSortMode(rawValue: sortType!)
        var radius:Double?
        if distanceIndex! > 0 {
            radius = milesToMeters[distanceIndex!]
        }
        if searchBar.text != "" {
            searchText = searchBar.text!
        }
        Business.searchWithTerm(term: searchText, sort: sortMode, categories: categories, deals: deals, radius: radius) { (businesses, error) in
            self.businesses = businesses
            self.originalResults = businesses
            self.yelpTableView.reloadData()
        }
    }
    
    func keyboardShouldReturn() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        searchBar.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
