//
//  GameViewController.swift
//  KusoGomoku
//
//  Created by ZONG-YING Tsai on 2017/8/21.
//  Copyright © 2017年 com.kusogomoku. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene(size: view.bounds.size)
        let skview = view as! SKView
        skview.showsFPS = true
        skview.showsNodeCount = true
        //scene.scaleMode = .aspectFill
        skview.presentScene(scene)
        
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
