//
//  ViewController.swift
//  Minhas Viagens
//
//  Created by André Luís  Campopiano on 23/02/17.
//  Copyright © 2017 André Luís  Campopiano. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var arrayPlace:[Dictionary<String,String>] = []
    var controlNav = "add"
    @IBOutlet weak var tableView: UITableView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.controlNav = "add"
        self.reloadTravel()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func reloadTravel(){
        arrayPlace = DataStorage().listTravel()
        self.tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayPlace.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = arrayPlace[indexPath.row]["local"]
        
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.controlNav = "list"
        performSegue(withIdentifier: "showPlace", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            DataStorage().removeTravel(index: indexPath.row)
            self.reloadTravel()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showPlace"{
            let viewController = segue.destination as! MapViewController

            if self.controlNav == "list" {
                
                if let indexRecoverry = sender {
                    let index = indexRecoverry as! Int
                    viewController.viagem = arrayPlace[index]
                    viewController.indexSelected = index
                }

            }else{
                viewController.viagem = [:]
                viewController.indexSelected = -1
            }
        }
    }
}

