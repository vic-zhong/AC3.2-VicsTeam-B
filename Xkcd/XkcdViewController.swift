//
//  XkcdViewController.swift
//  Xkcd
//
//  Created by Eric Chang on 12/1/16.
//  Copyright © 2016 Eric Chang. All rights reserved.
//

import UIKit

class XkcdViewController: UIViewController {
    @IBOutlet weak var testLabel: UILabel!

    let apiClient = APIManager()
    
    var comic: Comic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        somefunc()
    }

    func somefunc() {
        apiClient.getData(completionHandler: { results in
            DispatchQueue.main.async {
                if let results = results {
                    self.comic = results
                    self.testLabel.text = self.comic?.image
                }
                
            }
        })

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
