//
//  ViewController.swift
//  SleepingInTheLibrary
//
//  Created by Jarrod Parkes on 11/3/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit

// MARK: - ViewController: UIViewController

class ViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoTitleLabel: UILabel!
    @IBOutlet weak var grabImageButton: UIButton!
    
    // MARK: Actions
    
    @IBAction func grabNewImage(sender: AnyObject) {
        setUIEnabled(false)
        getImageFromFlickr()
    }
    
    // MARK: Configure UI
    
    private func setUIEnabled(enabled: Bool) {
        photoTitleLabel.enabled = enabled
        grabImageButton.enabled = enabled
        
        if enabled {
            grabImageButton.alpha = 1.0
        } else {
            grabImageButton.alpha = 0.5
        }
    }
    
    // MARK: Make Network Request
    
    private func getImageFromFlickr() {
        
        // TODO: Write the network code here!
//        let url = NSURL(string: "https://api.flickr.com/services/rest/?method=flickr.galleries.getPhotos&api_key=dc430ba898fb358a9e1df2cee786d165&gallery_id=5704-72157622566655097&extras=url_m&format=json&nojsoncallback=1&api_sig=b843493b33a28cd3555357ddd1211d38")!
//        
//        print(url)
// press command + / for comment out
        let methodParametes = [
            Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.GalleryPhotosMethod,
            Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
            Constants.FlickrParameterKeys.GalleryID: Constants.FlickrParameterValues.GalleryID,
            Constants.FlickrParameterKeys.Extras: Constants.FlickrParameterValues.MediumURL,
            Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat,
            Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback
            ]
        let urlString = Constants.Flickr.APIBaseURL + escapedParameters(methodParametes)
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error)
         in
            
            func displayError(error: String) {
                print(error)
                print("URL at time of error: \(url)")
                performUIUpdatesOnMain {
                    self.setUIEnabled(true)
                }
            }

            if error == nil{
                
              
                    let parsedResult: AnyObject!
                    do {
                     parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                    } catch {
                        displayError("Could not parse the data as JSON: '\(data)'")
                        return
                    }
                    
                    if let photosDictionary = parsedResult[Constants.FlickrResponseKeys.Photos] as? [String: AnyObject],
                        photoArray = photosDictionary[Constants.FlickrResponseKeys.Photo] as? [[String:AnyObject]]{
                        let randomPhotoIndex = Int(arc4random_uniform(UInt32(photoArray.count)))
                        let photoDictionary = photoArray[randomPhotoIndex] as [String: AnyObject]
                        
                        if let imageUrlString = photoDictionary[Constants.FlickrResponseKeys.MediumURL] as? String,
                            let photoTitle = photoDictionary[Constants.FlickrResponseKeys.Title] as? String {
                            
                            let imageURL = NSURL(string: imageUrlString)
                            if let imageData = NSData(contentsOfURL: imageURL!){
                                performUIUpdatesOnMain(){
                                self.photoImageView.image = UIImage(data: imageData)
                                self.photoTitleLabel.text = photoTitle
                                self.setUIEnabled(true)
                                }
                                
                            
                            
                            }
                        }
                        
                }
                    }

            
        }
        task.resume()
        
    }
    
    
    private func escapedParameters(parameters: [String:AnyObject]) -> String{
    
        if parameters.isEmpty{
            return ""
        }else{
            var keyValuePairs = [String]()
            
            for(key, value) in parameters {
                //make sure that it is a string value
                let stringValue = "\(value)"
                // combert to ascii value and escape it
                let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
                   // stringbyaddingpercentencodingwithallowedcharacters has been replaced with above in ios9
                
                keyValuePairs.append(key + "=" + "\(escapedValue!)")
            }
            return "?\(keyValuePairs.joinWithSeparator("&"))"
        
        }
    }
    
    
    
}