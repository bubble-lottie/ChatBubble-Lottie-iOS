//
//  ViewController.swift
//  changeBubbleJson
//
//  Created by iOSzhang Inc on 20/10/14.
//  Copyright © 2020 iOSzhang Inc. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTextViewDelegate {

    @IBOutlet weak var orignJsonUploadButton: NSButton!
    
    @IBOutlet weak var selectedImageLoactionButton: NSPopUpButton!
    
    @IBOutlet weak var uploadImageButton: NSButton!
    
    @IBOutlet weak var exportButton: NSButton!
    
    @IBOutlet var showJsonTextView: NSTextView!
    
    var orignPath : URL? = nil
    
    var asserts:[NSMutableDictionary] = []
    
    var finalJson : [String:AnyObject] = [:]
    
    var alert : NSAlert = NSAlert()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showJsonTextView.delegate = self
//        showJsonTextView.maximumNumberOfLines = 50
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func tapAddButton(_ sender: NSButton) {
        guard let path = openFilePanel(title: "选择气泡json文件") else {
            return
        }
        sender.title = path
        print("原气泡json地址:\(path)")
        uploadJsonFile(jsonPath: path)
    }
    
    /// 文件流览器，打开文件
    /// - parameter title 显示的标题
    func openFilePanel(title: String)->String?{
        let dialog = NSOpenPanel()
        dialog.title                   = title
        dialog.showsResizeIndicator    = true
        dialog.canChooseDirectories    = true
        dialog.canCreateDirectories    = true
        dialog.allowsMultipleSelection = false
        //        dialog.allowedFileTypes        = ["iw"]
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            if (result != nil) {
                return result!.path
            }
        }
        return nil
    }
    
    @IBAction func pictureButton(_ sender: NSButton) {
        if asserts.isEmpty {
            alert = NSAlert()
            alert.messageText = "未上传气泡json或该json中不含图片信息"
            
            alert.addButton(withTitle: "知道了")
            
            alert.runModal()
            return
        }
        if (sender.image != nil) && !sender.image!.isEqual(to: NSImage.init(named: "NSAddTemplate")) {
            alert = NSAlert()
            alert.messageText = "当前位置已有图片是否替换"
            
            alert.addButton(withTitle: "替换")
            alert.addButton(withTitle: "取消")
            
            let reCode = alert.runModal()
            
            if reCode.rawValue == 1000 {
                changeImageButtonClick()
            }
            
        } else {
            changeImageButtonClick()
        }
    }

    @IBAction func exportButton(_ sender: NSButton) {
//        let orignAsserts = finalJson["assets"] as! [NSDictionary]
        
        for oneAssert in asserts {
            if !(oneAssert["p"] as! String).hasPrefix("data:") {
                
                let alert:NSAlert = NSAlert()
                alert.messageText = "未上传\(String(describing: oneAssert["nm"]))"
                alert.addButton(withTitle: "OK")
                
                alert.runModal()
                return
            }
        }
        
        let paths = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true)
        let deskPath = paths.first
        let fileName = orignPath?.deletingPathExtension().lastPathComponent
        let fileExtension = orignPath?.pathExtension
        
        let exportUrl = URL.init(fileURLWithPath: "\(deskPath!)/\(fileName!)1.\(fileExtension!)")
            
        do {
            let finalJsonData = try JSONSerialization.data(withJSONObject: finalJson, options: [])
            
            let finalString = NSMutableString(data: finalJsonData, encoding: String.Encoding.utf8.rawValue)
//                String(data: finalJsonData, encoding: .utf8)
            
            //修改排序并存储
            self.sortToFront(txt: finalString ?? "", key: "ty")
            self.sortToFront(txt: finalString ?? "", key: "d")
            
            let finalFinalString = String(finalString ?? "")
            
            let finalData = finalString?.data(using: String.Encoding.utf8.rawValue)
//            JSONSerialization.data(withJSONObject: finalFinalString, options: [])
            
            try finalData!.write(to: exportUrl)
            
            let alert:NSAlert = NSAlert()
            alert.messageText = "保存至桌面\(exportUrl.lastPathComponent)"
            alert.addButton(withTitle: "OK")
            
            alert.runModal()
            
            orignJsonUploadButton.title = ""
            uploadImageButton.image = nil
            showJsonTextView.string = ""
            selectedImageLoactionButton.removeAllItems()
            finalJson = [:]
            asserts = []
        } catch let error as NSError{
            print("保存出错: \(error.localizedDescription)")

        }
    }
    
    func uploadJsonFile(jsonPath: String!) -> Void {
        orignPath = URL.init(fileURLWithPath: jsonPath)
        //解析地址内容后展示到textview上
        //3 解析json内容
        do{
            let jsonData = try Data.init(contentsOf: orignPath!, options: .dataReadingMapped)
            
            let json = try JSONSerialization.jsonObject(with: jsonData, options:.allowFragments) as! [String:AnyObject]

            // a 解析最外层的 "name"

            let orignAsserts = json["assets"] as! [NSDictionary]
            
            asserts.removeAll()
            for oneAssert in orignAsserts {
                let newDict = NSMutableDictionary.init(dictionary: oneAssert)
                asserts.append(newDict)
            }
            
            let orignlayers = json["layers"] as! [NSDictionary]
            for oneLayer in orignlayers {
                if let refId = oneLayer["refId"] {
                    for oneAsset in asserts {
                        let id = oneAsset["id"] as! String
                        if id==refId as! String  {
                            oneAsset["nm"] = oneLayer["nm"]
                        }
                    }
                }
            }
            
            //重置选项卡
            if selectedImageLoactionButton.itemArray.count != 0 {
                selectedImageLoactionButton.removeAllItems()
                uploadImageButton.image = nil;
            }
            
            var assertTitles:[String] = []
            
            for oneAsset in asserts {
                let nm = oneAsset["nm"] as! String
                assertTitles.append(nm)
            }
            
            selectedImageLoactionButton.addItems(withTitles: assertTitles)
            
            finalJson = json
            showJsonTextView.string = json.debugDescription

        } catch let error as NSError{
            print("解析出错: \(error.localizedDescription)")
        }
    }
    
    func changeImageButtonClick() -> Void {
        guard let path = openFilePanel(title: "选择\(String(describing: selectedImageLoactionButton.selectedItem?.title))文件") else {
            return
        }
        //        sender.title = path
        print("源图片地址:\(path)")
        
        let filePath = URL.init(fileURLWithPath: path)
        uploadImageButton.image = NSImage.init(contentsOf: filePath)
        let picData = NSData.init(contentsOf: filePath)
        let base64String = picData?.base64EncodedString(options: .endLineWithLineFeed)
        
        print("\(String(describing: base64String))")
        
        //查找位置并替换文本
        for oneAssert in asserts {
            if let assertNM = oneAssert["nm"] {
                if assertNM as! String == selectedImageLoactionButton.selectedItem?.title {
                    //查找原始数据中的位置并替换
                    
                    let orignAsserts = finalJson["assets"] as! [NSDictionary]
                    
                    var newAsserts : [NSDictionary] = []
                    
                    for oneOriAssert in orignAsserts {
                        if oneOriAssert["id"] as! String == oneAssert["id"] as! String {
                            let newDict = NSMutableDictionary.init(dictionary: oneOriAssert)
                            newDict.setValue("data:image/png;base64,\(base64String!)", forKey: "p")
                            oneAssert["p"] = "data:image/png;base64,\(base64String!)"
                            newAsserts.append(newDict)
                        } else {
                            newAsserts.append(oneOriAssert)
                        }
                    }
                    
                    finalJson["assets"] = newAsserts as AnyObject
                    showJsonTextView.string = finalJson.debugDescription
                }
            }
        }
    }
    
    //MARK: - NSTextViewDelegate
    func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
        if FileManager.default.fileExists(atPath: replacementString ?? "") {
            uploadJsonFile(jsonPath: replacementString)
            return false
        }
        return true
    }
    
    func sortToFront(txt: NSMutableString, key: NSString) -> Void {
        let word = "\"\(key)\":"
        var keyIndex = 0
        while true {
            keyIndex = txt.range(of: word, options: [], range: NSRange(location: keyIndex+1, length: txt.length-keyIndex-1)).location
        
            if keyIndex <= -1 || keyIndex >= txt.length {
                break
            }
            
            var start = keyIndex
            var sum = 0b1000
            while true {
                switch txt.substring(with: NSRange(location: start, length: 1)) {
                case "{":
                    sum+=1
                    break
                case "}":
                    sum-=1
                    break
                default:
                    break
                }
                if sum == 0b1001 {
                    break
                }
                if (start >> 31) == 1 {
                    start-=1
                    return
                } else {
                    start-=1
                }
            }
            start+=1
            
            let index2 = txt.range(of: ",", options: [], range: NSRange(location: keyIndex, length: txt.length-keyIndex)).location
            let index3 = txt.range(of: "}", options: [], range: NSRange(location: keyIndex, length: txt.length-keyIndex)).location
            if index2 < index3 {
                let all = txt.substring(with: NSRange(location: keyIndex, length: index2+1-keyIndex))
                txt.replaceCharacters(in: NSRange(location: keyIndex, length: index2+1-keyIndex), with: "")
                txt.insert(all, at: start)
            } else if txt.substring(with: NSRange(location: keyIndex-1, length: 1)) == "," {
                let all = txt.substring(with: NSRange(location: keyIndex, length: index3-keyIndex))
                txt.replaceCharacters(in: NSRange(location: keyIndex, length: index3-keyIndex), with: "")
                txt.insert(",", at: start)
                txt.insert(all, at: start)
            }
        }
    }
}

