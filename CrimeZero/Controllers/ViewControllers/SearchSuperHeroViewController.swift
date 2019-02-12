//
//  SearchSuperHeroViewController.swift
//  CrimeZero
//
//  Created by doxper on 26/01/19.
//  Copyright © 2019 Crime Zero INC. All rights reserved.
//

import UIKit

class SearchSuperHeroViewController: UIViewController {

    // MARK: Properties & Outlets
    @IBOutlet weak var superHeroCodeTextField: UITextField!
    @IBOutlet weak var superHeroLabel: UILabel!
    
    var superHeroNames: [String] = ["SUPERMAN", "THOR", "ROBIN", "IRONMAN", "GHOSTRIDER", "CAPTAINAMERICA", "FLASH", "WOLVERINE", "BATMAN", "HULK", "BLADE", "PHANTOM", "SPIDERMAN", "BLACKWIDOW", "HELLBOY", "PUNISHER"]
    
    var mappedCodes: [Int: [String]] = [2: ["A", "B", "C"], 3: ["D", "E", "F"], 4: ["G", "H", "I"], 5: ["J", "K", "L"], 6: ["M", "N", "O"], 7: ["P", "Q", "R", "S"], 8: ["T", "U", "V"], 9: ["W", "X", "Y", "Z"]]
    
    // MARK: View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Action Methods
    @IBAction func searchButtonClicked(_ sender: UIButton) {
        if let searchText = superHeroCodeTextField.text {
            callSuperHero(fromSearchText: searchText)
        }
        else {
            showError(message: "Please enter superhero code followed by 0")
        }
    }
    
    // MARK: Private Methods
    fileprivate func callSuperHero(fromSearchText searchText: String) {
        let validSearchTextTuple = validate(searchText: searchText)
        if validSearchTextTuple.0 == true {
            if let superHeroCode = Int64(validSearchTextTuple.1) {
                let decodedSuperHeroes = decode(superHeroCode: superHeroCode, length: validSearchTextTuple.1.count)
                if decodedSuperHeroes.count > 0 {
                    var superHeroesNameString = ""
                    decodedSuperHeroes.forEach({ (name) in
                        superHeroesNameString.append(name + ", ")
                    })
                    superHeroesNameString.removeLast(2)
                    superHeroLabel.textColor = UIColor.green
                    superHeroLabel.text = "\(superHeroesNameString) is on the way to rescue you!"
                }
                else {
                    superHeroLabel.textColor = UIColor.red
                    superHeroLabel.text = "No superheroes matched with code!\nBut don't worry I am on my way to rescue you!"
                }
            }
            else {
                showError(message: "Please enter valid superhero code followed by 0")
            }
        }
        else {
            showError(message: "Please enter valid superhero code followed by 0")
        }
    }
    
    fileprivate func validate(searchText: String) -> (Bool, String) {
        var valid: Bool = false
        var superHeroCodeString: String = ""
        let searchTextComponents = searchText.components(separatedBy: " ")
        if searchTextComponents.count >= 2 && searchTextComponents.first == "0" {
            valid = true
            superHeroCodeString = searchTextComponents[1]
        }
        return (valid, superHeroCodeString)
    }
    
    fileprivate func decode(superHeroCode: Int64, length: Int) -> [String] {
        var fullCode = superHeroCode
        var count = length - 1
        var fileterdSuperHeroesNames = superHeroNames.filter { (name) -> Bool in
            return name.count == length
        }
        if fileterdSuperHeroesNames.count > 0 {
            while (fullCode > 0) {
                let codeCharacter: Int = Int(fullCode % 10)
                let mappedCharacters = mappedCodes[codeCharacter]
                fileterdSuperHeroesNames = fileterdSuperHeroesNames.filter({ (name) -> Bool in
                    let index = name.index(name.startIndex, offsetBy: count)
                    let character = String(name[index])
                    return mappedCharacters?.contains(character) ?? false
                })
                fullCode = fullCode / 10
                count = count - 1
                if fileterdSuperHeroesNames.count == 0 {
                    break
                }
            }
        }
        return fileterdSuperHeroesNames
    }
    
    fileprivate func showError(message: String) {
        superHeroLabel.text = ""
        let alertController: UIAlertController = UIAlertController(title: "Crime Zero", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
