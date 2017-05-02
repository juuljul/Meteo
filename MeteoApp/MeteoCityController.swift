//
//  MeteoCityController.swift
//  MeteoApp
//
//  Created by Julien Bremeersch on 30/04/2017.
//  Copyright © 2017 Julien Bremeersch. All rights reserved.
//

import UIKit

class MeteoCityController: UIViewController {
    
    private let meteoDebutURL = "http://api.openweathermap.org/data/2.5/weather"
    private let apiKey = "8cae1724449fdda131a00f91c5dae4b5"
    
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cielLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var heureLabel: UILabel!
    @IBOutlet weak var villeLabel: UILabel!
    
    
    @IBOutlet weak var cielImageView: UIImageView!
    
    var temperature: Double!
    var ciel: String!
    var descript: String!
    var heure: Double!
    
    var ville: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        villeLabel.text = ville
        getMeteo(ville)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func celciusFromKelvin(celcius: Double)-> Double{
        return celcius - 273.15
    }
    
    func dateStringFromUnixTimestamp(timestamp: Double)-> String{
        
        let date = NSDate(timeIntervalSince1970: timestamp)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let strDate = dateFormatter.stringFromDate(date)
        
        return strDate
    }
    
    
    func imageCiel(ciel: String){
        switch ciel {
        case "Clear":
            self.cielImageView.image = UIImage(named: "soleil")
        case "Clouds":
            self.cielImageView.image = UIImage(named: "nuage")
        case "Rain":
            self.cielImageView.image = UIImage(named: "pluie")
        default:
            self.cielImageView.image = UIImage(named: "orage")
        }
    }
    
    
    func getMeteo(ville: String) {
        
        let session = NSURLSession.sharedSession()
//        let meteoRequestURL = NSURL(string: "\(meteoDebutURL)?APPID=\(apiKey)&q=\(ville)")!
        
        let stringUrl = "\(meteoDebutURL)?APPID=\(apiKey)&q=\(ville)"
        let meteoRequestURL = NSURL(string: stringUrl.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        
        let dataTask = session.dataTaskWithURL(meteoRequestURL) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) in
            if let error = error {
                print("Error:\n\(error)")
            }
            else {
                do {
                    let meteo = try NSJSONSerialization.JSONObjectWithData(
                        data!,
                        options: .MutableContainers) as! [String: AnyObject]
                    
                    
                    if let dt = meteo["dt"] as? Double{
                        self.heure = dt
                    }
                    
                    
                    if let weather = meteo["weather"] as? [[String: AnyObject]]{

                                if let main = weather[0]["main"] as? String{
                                self.ciel = main
                            }
                                if let detailCiel = weather[0]["description"] as? String{
                                self.descript = detailCiel
                            }
                    }
                    
                    if let mesures = meteo["main"] as? [String: AnyObject]{
                        if let temp = mesures["temp"] as? Double{
                            self.temperature = temp
                        }
                    }
                    
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        self.temperatureLabel.text = "\(self.celciusFromKelvin(self.temperature)) °"
                        self.cielLabel.text = self.ciel
                        self.imageCiel(self.ciel)
                        self.descriptionLabel.text = self.descript
                        self.heureLabel.text = "\(self.dateStringFromUnixTimestamp(self.heure))"
                        
//                    DispatchQueue.main.async {
//                        if self.exists{
//                            self.jsonLabel.text = self.base
//                        }
//                        else{
//                            self.jsonLabel.text = "No matching city found"
//                        }
                        
                    }
//                    jsonLabel.text = weather["base"] as! String
                    
                    
                }
                catch let jsonError as NSError {
                    print("JSON error description: \(jsonError.description)")
                }
            }
        }
        dataTask.resume()
    }

    



}
