//
//  DetailViewController.swift
//  ADR Registr
//
//  Created by Jan Osmancik on 28.10.17.
//  Copyright © 2017 Jan Osmancik. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var kemler: String?
    var name: String?
    var un: String?
    


    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var navbarTitle: UINavigationItem!
    @IBOutlet weak var lblUn: UILabel!
    @IBOutlet weak var lblKemler: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        navbarTitle.title = name
        lblName.text = name
        lblKemler.text = kemler
        lblUn.text = un
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
