//
//  ViewController.swift
//  SwiftDemo
//
//  Created by WEI YANG on 2021/5/10.
//

import UIKit

let sampleUrl = URL(string: "https://postman-echo.com/get?foo1=bar1&foo2=bar2")!

class ViewController: UIViewController {

    let postButton = UIButton(frame: CGRect(origin: CGPoint(x: 50,y: 50), size: CGSize(width: 200,height: 50)))
    let resultLabel = UILabel(frame: CGRect(origin: CGPoint(x: 10,y: 70), size: CGSize(width: 300,height: 450)))
    let openGumpayButton = UIButton(frame: CGRect(origin: CGPoint(x: 50,y: 500), size: CGSize(width: 200,height: 50)))

    private var rawResult = "No result"
    private var jsonParsedResult = "No result"

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }


    private func initUI(){
        
        postButton.setTitle("Post URL", for: .normal)
        postButton.setTitleColor(.blue, for: .normal)
        postButton.addTarget(self, action: #selector(postURLClicked), for: .touchUpInside)
        // Do any additional setup after loading the view.
        self.view.addSubview(postButton)

        resultLabel.text = ""
        resultLabel.textColor = .black
        resultLabel.font = .systemFont(ofSize: 15)
        resultLabel.isHidden = true
        resultLabel.numberOfLines = 0
        self.view.addSubview(resultLabel)
        
        openGumpayButton.setTitle("Open Gumpay", for: .normal)
        openGumpayButton.setTitleColor(.blue, for: .normal)
        openGumpayButton.addTarget(self, action: #selector(openGumpayClicked), for: .touchUpInside)
        // Do any additional setup after loading the view.
        self.view.addSubview(openGumpayButton)

    }
    
    @objc private func postURLClicked(sender: UIButton){
        // create post request
        let url = sampleUrl
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        //Just in case you need to add params in POST
//                // prepare json data
//                let json: [String: Any] = ["sample_para": "12345"]
//
//                let jsonData = try? JSONSerialization.data(withJSONObject: json)
//                // insert json data to the request
//                request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            guard let data = data, error == nil else {
                
                print(error?.localizedDescription ?? "No data")
                rawResult = error?.localizedDescription ?? "No data"
                return
            }
            
            rawResult = data.description
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
                jsonParsedResult = responseJSON.description
            }else{
                jsonParsedResult = "Failed to parse json"
            }
            
            DispatchQueue.main.async {
                resultLabel.text = rawResult+"\n"+jsonParsedResult
                resultLabel.isHidden = false
            }
        }

        task.resume()
    }
    
    @objc private func openGumpayClicked(sender: UIButton){
        guard let gumpayScheme = URL(string: "gumpay://") else {
          return //be safe
        }
        UIApplication.shared.open(gumpayScheme, options: [:], completionHandler: nil)
    }
    
}

