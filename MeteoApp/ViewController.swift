//
//  ViewController.swift
//  MeteoApp
//
//  Created by Julien Bremeersch on 30/04/2017.
//  Copyright © 2017 Julien Bremeersch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var villeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMeteo"{
            if let meteoCityController = segue.destinationViewController as? MeteoCityController{
//            var meteoCityController: MeteoCityController = segue!.destinationViewController as MeteoCityController
            meteoCityController.ville = villeTextField.text
            }
        }
    }


}

