//
//  HelpViewController.swift
//  MobileAssignmentPS
//
//  Created by Matías Gil Echavarría on 10/7/20.
//  Copyright © 2020 Matías Gil Echavarría. All rights reserved.
//

import UIKit
import WebKit

class HelpViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    let htmlString = """
    <header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>
    <h1 style="color: #5e9ca0;">Thanks for using the app!</h1>
    <h2 style="color: #2e6c80;">App Flow:</h2>
    <p>Once you start the app, previously bookmarked locations appear on the list. In the bottom of the list you can touch&nbsp;<span style="background-color: #2b2301; color: #fff; display: inline-block; padding: 3px 10px; font-weight: bold; border-radius: 5px;">Add Location</span> in order to add new location. Touching a location from the list, will show you that location detail view, showing more in deep details of the weather and the location map if it is iPad orphone in portrait mode. Phone in Landscape will not show the map.</p>
    <p>To add location once the map appears, you can navigate the map as usual, then to add a location, just touch the map where you want to set coordinates, then touch <span style="background-color: #2b2301; color: #fff; display: inline-block; padding: 3px 10px; font-weight: bold; border-radius: 5px;">Add</span> in the bottom to add it. View will dismiss and show new location on the list. Also you can cancel location addition, touching the close icon on the top left side of the map.</p>
    <p>The home list also have capability to remove all bookmarked locations, just pressing <span style="background-color: #2b2301; color: #fff; display: inline-block; padding: 3px 10px; font-weight: bold; border-radius: 5px;">Remove All</span> and <span style="background-color: #2b2301; color: #fff; display: inline-block; padding: 3px 10px; font-weight: bold; border-radius: 5px;">Help</span> opens this view.</p>
    <p>Last but not least, filtering options is available for locations list. It filters by location name.</p>
    """
    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView.loadHTMLString(htmlString, baseURL: nil)
    }


}
