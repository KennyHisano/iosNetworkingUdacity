//
//  hearthstone.playground
//  iOS Networking
//
//  Created by Jarrod Parkes on 09/30/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation

/* Path for JSON files bundled with the Playground */
var pathForHearthstoneJSON = NSBundle.mainBundle().pathForResource("hearthstone", ofType: "json")

/* Raw JSON data (...simliar to the format you might receive from the network) */
var rawHearthstoneJSON = NSData(contentsOfFile: pathForHearthstoneJSON!)

/* Error object */
var parsingHearthstoneError: NSError? = nil

/* Parse the data into usable form */
var parsedHearthstoneJSON = try! NSJSONSerialization.JSONObjectWithData(rawHearthstoneJSON!, options: .AllowFragments) as! NSDictionary

func parseJSONAsDictionary(dictionary: NSDictionary) {
    /* Start playing with JSON here... */
    guard let arrayOfBasic = parsedHearthstoneJSON["Basic"] as? [[String: AnyObject]] else{
        print("cannot find key 'basic' in \(parsedHearthstoneJSON)")
        return
    }
    for cardDictionary in arrayOfBasic{
        guard let type = cardDictionary["type"] as? String else{
        print("could not find 'type'\(cardDictionary)")
            return
        }
    
        if type == "Minion" {
        //   guard let attack = cardDictionary["attack"] as? Int else{
          //   print("cannot find any 'attack' in \(cardDictionary)")
             ///  return
            //}
            
            guard let manaCost = cardDictionary["cost"] as? Int else{
                print("Cannot find key 'cost' in \(cardDictionary)")
                return
            }
            //manacost
            if manaCost == 5{
                print("found ")
            }
            //Battlecry
            if let battlecry = cardDictionary["text"] as? String where battlecry.rangeOfString("Battlecry") != nil {
                print("here is battleCry")
                
            }
            
        }
        //durability
        if type == "Weapon"{
                if let durability = cardDictionary["durability"] as? Int where durability == 2 {
                    print("found durability")
                }
                
                }
            
        
        }
        
    


}
parseJSONAsDictionary(parsedHearthstoneJSON)

