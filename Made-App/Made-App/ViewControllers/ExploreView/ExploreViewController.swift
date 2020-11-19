//
//  ExploreViewController.swift
//  Made-App
//
//  Created by Marissa Jenkins on 11/6/20.
//

import UIKit
import Foundation

class ExploreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var categories = ["Food", "Lifestyle", "Art", "Clothing", "Accessories", "Kids", "Science", "Pets", "Plants"]
    let tableCellIdentifier = "ExploreTableCell"
    @IBOutlet weak var searchBar: UISearchBar!
    let searchController = UISearchController(searchResultsController: nil)
    var currCategory = ""
    var filterCategories: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchBar.delegate = self
        tableView.dataSource = self
        filterCategories = categories
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath as IndexPath) as! ExploreTableViewCell
        let row = indexPath.row
        let category = filterCategories[row]
        cell.categoryLabel?.text = category
        cell.categoryImage.image = UIImage(named: category)
        return cell
    }
    
    func getCategory() -> Int {
        let indexPath = tableView.indexPathForSelectedRow
        return indexPath!.row
    }
    
    // This method updates filteredData based on the text in the Search Box
    // https://guides.codepath.com/ios/Search-Bar-Guide
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        filterCategories = searchText.isEmpty ? categories : categories.filter { (item: String) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        tableView.reloadData()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let row = getCategory()
        currCategory = filterCategories[row]
        print(currCategory)
        print("in the prepare of EXPLORE VIEW")
        if segue.identifier == "exploreFeedSegue",
        let nextVC = segue.destination as? ExploreFeedViewController {
            nextVC.currCategory = currCategory
        }
    }
    

}
