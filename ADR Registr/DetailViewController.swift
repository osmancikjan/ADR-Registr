//
//  DetailViewController.swift
//  ADR Registr
//
//  Created by Jan Osmancik on 28.10.17.
//  Copyright © 2017 Jan Osmancik. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var kemler: String = ""
    var name: String = ""
    var un: String = ""
    
    @IBOutlet weak var txtKemler: UILabel!
    @IBOutlet weak var txtUn: UILabel!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        txtKemler.text = kemler
        txtUn.text = un
    }
}
