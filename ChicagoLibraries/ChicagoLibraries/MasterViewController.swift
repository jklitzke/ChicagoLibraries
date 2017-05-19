//
//  MasterViewController.swift
//  ChicagoLibraries
//
//  Created by James Klitzke on 1/28/17.
//  Copyright © 2017 James Klitzke. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    let libraryDetailSegue = "showLibraryDetail"
    let tableViewCellIdentifier = "Cell"
    
    lazy var cityOfChicagoServices : CityOfChicagoServicesProtcol = CityOfChicagoServices.sharedInstnace

    var libraries = [Library]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityOfChicagoServices.getListOfLibraries(success: {
            [unowned self] libraries in
                self.libraries = libraries
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
        }, failure: {
            [unowned self] error, response in
                self.showServiceError()
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func showServiceError() {
        let alert = UIAlertController(title: "We're Sorry", message: "We couldn't get the list of libraires right now.  Please try again later.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == libraryDetailSegue {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! DetailViewController
                controller.library = libraries[indexPath.row]
                
            }
        }
    }

    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return libraries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath)

        cell.textLabel!.text = libraries[indexPath.row].name_
        return cell
    }
}

