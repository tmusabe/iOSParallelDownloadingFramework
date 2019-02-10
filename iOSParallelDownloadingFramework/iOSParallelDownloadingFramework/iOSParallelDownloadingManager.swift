//
//  iOSParallelDownloadingManager.swift
//  iOSParallelDownloadingFramework
//
//  Created by Taif Al Musabe on 2/6/19.
//  Copyright © 2019 taifalmusabe. All rights reserved.
//

import Foundation

public typealias DownloadCompletionBlock = (_ data: Data?, _ error: Error?) -> Void
public typealias ParallelDownloadingCompletion = (_ data: [Data]?,_ error: [Error]?) -> Void

public class ParallelDownloadingManger: NSObject, URLSessionDelegate, URLSessionDataDelegate{
    public static let sharedInstance = ParallelDownloadingManger()
    
    public var progress: Progress?
    
    var delegate: ParallelDownloadingMangerDelegate?
    
    private static let rawPointer : [UInt8] = [0x04, 0x00, 0x00, 0x00,
                                               0x08, 0x00, 0x00, 0x00,
                                               0x0C, 0x00, 0x00, 0x00]
    private static let progressObserverContext:UnsafeMutableRawPointer = UnsafeMutableRawPointer(mutating:rawPointer)
    
    private var downloadSession: URLSession!
    private var fractionCompleted: Double! = 0.0
    public override init() {
        super.init()
        downloadSession = URLSession(configuration: URLSessionConfiguration.ephemeral, delegate: self, delegateQueue: nil)
        
    }
    
    public func parallelDownloadingForURLs(_ urls:[String], completion: ParallelDownloadingCompletion?){
        var datas: [Data] = [Data]()
        var errors: [Error] = [Error]()
        let downloadGroup = DispatchGroup()
        let _ = DispatchQueue.global(qos: .userInitiated)
        DispatchQueue.concurrentPerform(iterations: urls.count) { (index) in
            let address = urls[index]
            let url = URL(string: address)
            downloadGroup.enter()
            download(url: url!, completion: { (data, error) in
                if error == nil {
                    datas.append(data!)
                } else {
                    errors.append(error!)
                }
                downloadGroup.leave()
            })
        }
        downloadGroup.notify(queue: DispatchQueue.main) {
            completion?(datas,errors)
        }
    }
    
    
    private func download(url: URL, completion: DownloadCompletionBlock?) {
        let task = downloadSession.dataTask(with: url) { (data, response, error) in
            completion?(data,error)
        }
        self.progress = task.progress
        self.progress!.addObserver(self, forKeyPath: "fractionCompleted", options: .new, context: ParallelDownloadingManger.progressObserverContext)
        task.resume()
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == ParallelDownloadingManger.progressObserverContext {
            DispatchQueue.main.async(execute: {
                var progress: Progress!
                if let progressCount = object {
                    progress = progressCount as? Progress
                }
                else {
                    progress = Progress(totalUnitCount:0)
                }
                self.progress = progress
                
                if self.fractionCompleted < progress.fractionCompleted {
                    self.fractionCompleted = progress.fractionCompleted
                }
                
                self.delegate?.getDataTaskCompletedFraction(fractionComplete: self.fractionCompleted)
            })
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
        
    }
}

protocol ParallelDownloadingMangerDelegate {
    func getDataTaskCompletedFraction(fractionComplete: Double)
}

