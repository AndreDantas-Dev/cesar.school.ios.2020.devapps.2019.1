//
//  ConsoleViewController.swift
//  MyGames
//
//  Created by aluno on 16/05/20.
//  Copyright © 2020 Douglas Frari. All rights reserved.
//

import UIKit

class ConsoleViewController: UIViewController {

    @IBOutlet weak var lbConsole: UILabel!
    @IBOutlet weak var ivConsoleImage: UIImageView!
    
    var console: Console?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        lbConsole.text = console?.name
       
        if let image = console?.image as? UIImage {
            ivConsoleImage.image = image
        } else {
            ivConsoleImage.image = UIImage(named: "noCoverFull")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let vc = segue.destination as! AddEditConsoleViewController
        vc.console = console
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
