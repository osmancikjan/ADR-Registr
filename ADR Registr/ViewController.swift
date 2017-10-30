//
//  ViewController.swift
//  ADR Registr
//
//  Created by osmancikjan on 10/23/17.
//  Copyright © 2017 Jan Osmancik. All rights reserved.
//

import UIKit


class MyPrototypeCel: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var un: UILabel!
    @IBOutlet weak var kemler: UILabel!
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var txtKemler: UITextField!
    @IBOutlet weak var txtUn: UITextField!
    
    var parsedData = [Latka]()
    var filteredData = [Latka]()
    
    var isNazevSearching = false
    var isUnSearching = false
    var isKemlerSearching = false
    
    var un: String = ""
    var kemler: String = ""
    var name: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ParseMinimalData()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        txtUn.delegate = self
        txtUn.addTarget(self, action: #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:)), for: UIControlEvents.editingChanged)
        txtKemler.delegate = self
        txtKemler.addTarget(self, action: #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:)), for: UIControlEvents.editingChanged)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isNazevSearching || isUnSearching || isKemlerSearching {
            return filteredData.count
        }
        return parsedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MyPrototypeCel
        
        if isNazevSearching || isUnSearching || isKemlerSearching {
            cell.name.text = filteredData[indexPath.row].nazev
            cell.un.text = filteredData[indexPath.row].un
            cell.kemler.text = filteredData[indexPath.row].kemler
        }
        else {
            cell.name.text = parsedData[indexPath.row].nazev
            cell.un.text = parsedData[indexPath.row].un
            cell.kemler.text = parsedData[indexPath.row].kemler
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row at index: ", indexPath.row)
   
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! MyPrototypeCel
        
        un = currentCell.un.text!
        kemler = currentCell.kemler.text!
        name = currentCell.name.text!
   
        self.performSegue(withIdentifier: "ShowDetail", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let backItem = UIBarButtonItem()
            backItem.title = "Zpet"
            navigationItem.backBarButtonItem = backItem
            if let destination = segue.destination as? DetailViewController {
                destination.un = un
                print(un)
                destination.kemler = kemler
                print(kemler)
                destination.name = name
                print(name)
            }
        }
    }
  
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if searchBar.text == nil || searchBar.text == "" {
            isNazevSearching = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            isNazevSearching = true
            filteredData = parsedData.filter{
                $0.nazevBezDiakritiky.lowercased().contains(searchBar.text!.lowercased()) || $0.nazevBezDiakritiky.lowercased().contains(searchBar.text!.lowercased())
            }
            tableView.reloadData()
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.isEqual(txtUn) {
            txtKemler.text = nil
            if (txtUn.text?.characters.count)! > 4 {
                txtUn.deleteBackward()
            }
            if (textField.text?.isEmpty)! {
                isUnSearching = false
                view.endEditing(true)
                tableView.reloadData()
            } else {
                isUnSearching = true
                print(textField.text!)
                filteredData = parsedData.filter{
                    $0.un.contains(textField.text!)
                }
                tableView.reloadData()
            }
        }
        if textField.isEqual(txtKemler) {
            txtUn.text = nil
            if (txtKemler.text?.characters.count)! > 4 {
                txtKemler.deleteBackward()
            }
            if (textField.text?.isEmpty)! {
                isKemlerSearching = false
                view.endEditing(true)
                tableView.reloadData()
            } else {
                isKemlerSearching = true
                print(textField.text!)
                filteredData = parsedData.filter{
                    $0.kemler.contains(textField.text!.uppercased())
                }
                tableView.reloadData()
            }
        }
        return true
    }
    
    func ParseMinimalData (){
        guard let path = Bundle.main.path(forResource: "registr", ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            guard let array = json as? [Any] else { return }
            
            for item in array {
                guard let dict = item as? [String : Any] else { return }
                guard let kemler = dict["KEMLER"] as? String else { return }
                guard let nazev = dict["LATKA"] as? String else { return }
                guard let nazevBezDiakritiky = dict["LATKABEZDIAKRITIKY"] as? String else { return }
                guard let un = dict["UN"] as? String else { return }
                parsedData.append(Latka(un : un, nazev : nazev, nazevBezDiakritiky : nazevBezDiakritiky, kemler : kemler))
            }
        }
        catch {
            print(error)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

class Latka {
    var un : String!
    var nazev : String!
    var nazevBezDiakritiky : String!
    var kemler : String!
    
    init(un : String, nazev : String, nazevBezDiakritiky: String, kemler : String) {
        self.un = un
        self.nazev = nazev
        self.nazevBezDiakritiky = nazevBezDiakritiky
        self.kemler = kemler
    }
}

