//
//  NetworkLayer.swift
//  SigTuple
//
//  Created by Coffeebeans on 25/09/18.
//  Copyright © 2018 Coffeebeans. All rights reserved.
//

import Foundation

class NetworkLayer {
    
    static let sharedInstance = NetworkLayer()
    let cache = NSCache<AnyObject, AnyObject>()
    
    func getOpenOrClosedIssues(orgName:String,repoName:String,completion:@escaping(([GitHubModel]?,[GitHubModel]?)->())) {
        if let url = URL(string: urlForOpenIssues + String(orgName) + "/" + String(repoName) + "/" + "issues?state=open")
        {
            if let object = cache.object(forKey: "\(orgName)-\(repoName)" as AnyObject) as? [String:Any] {
                if let storedDate = object["timeStamp"] as? TimeInterval {
                    let currentDate = Date().timeIntervalSinceReferenceDate
                    let diffInSeconds =  currentDate - storedDate
                    if(diffInSeconds / 60 < 30.0) {
                       completion(object["githubOpenIssues"] as? [GitHubModel],object["githubClosedIssues"] as? [GitHubModel])
                    }else{
                        getDataFromApi(url,orgName,repoName,completion)
                    }
                }
            } else {
                getDataFromApi(url,orgName,repoName,completion)
            }   
        }
    }
    
    func getDataFromApi(_ url:URL,_ orgName:String,_ repoName:String,_ completion:@escaping(([GitHubModel]?,[GitHubModel]?)->())) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if(error == nil && data != nil) {
                let decoder = JSONDecoder()
                do{
                    let githubOpenIssues = try decoder.decode([GitHubModel].self, from: data!)
                    if let url = URL(string: urlForOpenIssues + String(orgName) + "/" + String(repoName) + "/" + "issues?state=closed") {
                        let newtask = URLSession.shared.dataTask(with: url) { (data, response, error) in
                            if(error == nil && data != nil) {
                                do{
                                    let decoder = JSONDecoder()
                                    let githubClosedIssues = try decoder.decode([GitHubModel].self, from: data!)
                                    completion(githubOpenIssues,githubClosedIssues)
                                    self.cache.setObject(["githubOpenIssues":githubOpenIssues as [GitHubModel],"githubClosedIssues":githubClosedIssues as [GitHubModel],"timeStamp":Date().timeIntervalSinceReferenceDate as TimeInterval] as AnyObject, forKey: "\(orgName)-\(repoName)" as AnyObject)
                                }catch{
                                   completion(nil,nil)
                                }
                            }else{
                                completion(nil,nil)
                            }
                        }
                        newtask.resume()
                    }
                }catch {
                    print("error")
                    completion(nil,nil)
                }
            }else{
                completion(nil,nil)
            }
        }
        task.resume()
    }
}
