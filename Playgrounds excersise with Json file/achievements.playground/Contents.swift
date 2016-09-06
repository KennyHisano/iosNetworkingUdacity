//
//  achievements.playground
//  iOS Networking
//
//  Created by Jarrod Parkes on 09/30/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation

/* Path for JSON files bundled with the Playground */
var pathForAchievementsJSON = NSBundle.mainBundle().pathForResource("achievements", ofType: "json")

/* Raw JSON data (...simliar to the format you might receive from the network) */
var rawAchievementsJSON = NSData(contentsOfFile: pathForAchievementsJSON!)

/* Error object */
var parsingAchivementsError: NSError? = nil

/* Parse the data into usable form */
var parsedAchievementsJSON = try! NSJSONSerialization.JSONObjectWithData(rawAchievementsJSON!, options: .AllowFragments) as! NSDictionary



func parseJSONAsDictionary(dictionary: NSDictionary) {
    var numPoints = 0
    var totalPoints = 0
    
    guard let arrayOfAchivements = parsedAchievementsJSON["achievements"] as? [[String: AnyObject]] else{
        print("Cannot finr any achievements in \(parsedAchievementsJSON)")
        return
    }
    
    for achievementsDictionary in arrayOfAchivements{
        guard let points = achievementsDictionary["points"] as? Int else{
            print("cannot find any points")
            return
        }
        guard let description = achievementsDictionary["description"] as? String else{
            print("cannot find description")
            return
        }

        numPoints += 1
        totalPoints += points
        if points > 10{
            print("I got one")
        }
        
        guard let title = achievementsDictionary["title"] as? String else{
            print("Cannot find any title")
            return
        }
        
        if title == "Cool Running"
        {
          
            print(description)
            
        }
        
        
        
    }
    print(Double(totalPoints)/Double(numPoints))
    
}

parseJSONAsDictionary(parsedAchievementsJSON)
