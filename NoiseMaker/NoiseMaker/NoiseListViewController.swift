//
//  NoiselistViewController.swift
//  NoiseMaker
//
//  Created by Gerry Laplante on 9/29/15.
//  Copyright © 2015 Gerry Laplante. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class NoiseListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var noiseListTableView: UITableView!
    
    var noiseAudioPlayer = AVAudioPlayer()
    
    var noiseList: [Noise] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.noiseListTableView.dataSource = self
        self.noiseListTableView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        //begin code
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let request = NSFetchRequest(entityName: "Noise")
        do {
            self.noiseList = try context.executeFetchRequest(request) as! [Noise]
        }catch {}
        self.noiseListTableView.reloadData()
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.noiseList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellNoise = self.noiseList[indexPath.row]
        let noiseCell = UITableViewCell()
        noiseCell.textLabel!.text = cellNoise.name
        return noiseCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cellNoise = self.noiseList[indexPath.row]
        
        let baseString : String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] 
        
        let pathComponents = [baseString, cellNoise.url]
        
        let audioNSURL = NSURL.fileURLWithPathComponents(pathComponents)
        
        self.noiseAudioPlayer =  try! AVAudioPlayer(contentsOfURL: audioNSURL!)
        self.noiseAudioPlayer.play()
        
        noiseListTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nextViewController = segue.destinationViewController as! NewNoiseViewController
        nextViewController.previousNoiseListViewController = self
    }
 

}

