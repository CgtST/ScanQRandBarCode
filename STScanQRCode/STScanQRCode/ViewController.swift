//
//  ViewController.swift
//  STScanQRCode
//
//  Created by Mac on 15/5/15.
//  Copyright © 2015年 st. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class ViewController: UIViewController ,AVCaptureMetadataOutputObjectsDelegate{
    
    let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    let session = AVCaptureSession()
    var layer : AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //设置灰色背景
        self.view.backgroundColor = UIColor.grayColor()
        let labIntroudction = UILabel(frame: CGRectMake(15,30,290,70))
        labIntroudction.numberOfLines = 3
        labIntroudction.textColor = UIColor.whiteColor()
        labIntroudction.text = "将二维码，条形码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别。"
        self.view.addSubview(labIntroudction)
        
        //添加边框
        let imageView = UIImageView(frame: CGRectMake(10, 100, 300, 300))
        imageView.image = UIImage(named: "pick_bg")
        self.view.addSubview(imageView)
        
        //添加下面工具条
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        let item0 = UIBarButtonItem(image: (UIImage(named: "ocrBack.png")), style: (UIBarButtonItemStyle.Bordered), target: self, action: (Selector("backClick")) )
        let item1 = UIBarButtonItem(image:(UIImage(named:"ocr_flash-off.png")), style:(UIBarButtonItemStyle.Bordered), target:self, action:(Selector("turnTorchOn")))
        let item2 = UIBarButtonItem(image:(UIImage(named:"ocr_albums.png")), style:(UIBarButtonItemStyle.Bordered), target:self, action:(Selector("pickPicture")))
        let flexibleSpaceItem = UIBarButtonItem(barButtonSystemItem : (UIBarButtonSystemItem.FlexibleSpace), target: self, action: nil)      //边距
        toolBar.items = [item0,flexibleSpaceItem,item2,flexibleSpaceItem,item1]
        toolBar.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height-44, UIScreen.mainScreen().bounds.size.width, 44)
        self.view.addSubview(toolBar)
    }
    func backClick(){
        
    }
    func turnTorchOn(){
        
    }
    func pickPicture(){
        session.startRunning()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setupCamera()
        self.session.startRunning()
    }
    
    func setupCamera(){
        //高质量采集率
        self.session.sessionPreset = AVCaptureSessionPresetHigh
        var error : NSError?
        //输入流
        let input : AVCaptureDeviceInput!
        do{
            input = try AVCaptureDeviceInput(device: device)
        }
            //异常处理
        catch let error1 as NSError {
            error  = error1
            input = nil
        }
        if(error != nil){
            print(error?.description)
            return
        }
        if session.canAddInput(input){
            session.addInput(input)
        }
        //显示图像
        layer =  AVCaptureVideoPreviewLayer(session: session)
        layer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        layer!.frame = CGRectMake(20, 110, 280, 280)
        self.view.layer.insertSublayer(self.layer!, atIndex: 0)
        
        let output = AVCaptureMetadataOutput()
        //设置代理在主线程里刷新
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        if session.canAddOutput(output) {
            session.addOutput(output)
            //设置扫码支持的编码格式（如下设置各种条形码和二维码兼容）
            output.metadataObjectTypes = [ AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypePDF417Code,
                AVMetadataObjectTypeAztecCode,
                AVMetadataObjectTypeCode93Code,
                AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeCode39Mod43Code];
            //            output.rectOfInterest = CGRectMake(0, 0, 1, 0)
        }
        session.startRunning()
    }

    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        var stringValue:String?
        if metadataObjects.count > 0 {
            let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            stringValue = metadataObject.stringValue
        }
        self.session.stopRunning()
        print("code is \(stringValue)")
        let alertView = UIAlertView()
        alertView.delegate=self
        alertView.title = "二维码或条形码"
        alertView.message = "扫到的内容为:\(stringValue)"
        alertView.addButtonWithTitle("确认")
        alertView.show()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

