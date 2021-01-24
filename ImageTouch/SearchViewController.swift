//
//  SearchViewController.swift
//  ImageTouch
//
//  Created by Madji on 24.01.21.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBarTextView: UITextField!
    @IBOutlet weak var searchButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        
        guard let text = searchBarTextView.text else {
            return
        }
        
        print(text)        
        searchBarTextView.text = ""
    }
    


}
