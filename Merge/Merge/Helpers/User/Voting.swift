//
//  Voting.swift
//  Merge
//
//  Created by Codelynks on 10/02/21.
//  Copyright © 2021 SC. All rights reserved.
//

import UIKit
import CoreData

class Voting: NSManagedObject {
    static func saveVotedData(votingModel:VotingRequestModel){
        var vote:Voting?
        if let _vote = Voting.getVotedSong(votingModel: votingModel) {
            vote = _vote
        } else {
            vote = CoreDataHandler.sharedInstance.newEntityForName(entityName: "Voting") as? Voting
        }
        vote?.songName = votingModel.songName
        CoreDataHandler.sharedInstance.saveContext()
    }
    
    class func getVotedSong(votingModel: VotingRequestModel) -> Voting? {
        let votePredicate = NSPredicate(format: "songName==%@",votingModel.songName)
        let detailsArrayPost = CoreDataHandler.sharedInstance.getAllDatasWithPredicate(entity: "Voting", predicate: votePredicate, sortDescriptor: nil) as NSArray
        if (detailsArrayPost.count != 0) {
            return detailsArrayPost.object(at: 0) as? Voting
        }
        return nil
    }
    
    class func getVotedSongWithSongName(songName: String) -> Voting? {
        let votePredicate = NSPredicate(format: "songName==%@",songName)
        let detailsArrayPost = CoreDataHandler.sharedInstance.getAllDatasWithPredicate(entity: "Voting", predicate: votePredicate, sortDescriptor: nil) as NSArray
        if (detailsArrayPost.count != 0) {
            return detailsArrayPost.object(at: 0) as? Voting
        }
        return nil
    }
    
}
