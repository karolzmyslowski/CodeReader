//
//  ViewController.swift
//  CodeReader
//
//  Created by Karol Zmyslowski on 13.03.2018.
//  Copyright © 2018 Karol Zmyslowski. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var video = AVCaptureVideoPreviewLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let session = AVCaptureSession()
        
        let captureDevide = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevide!)
            session.addInput(input)
        } catch {
            print("error")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.ean13]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.frame
        view.layer.addSublayer(video)
        
        session.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count != 0 {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject{
                if object.type == AVMetadataObject.ObjectType.ean13{
                    let alert = UIAlertController(title: "QRCode", message: object.stringValue, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { (nil) in
                        UIPasteboard.general.string = object.stringValue
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

