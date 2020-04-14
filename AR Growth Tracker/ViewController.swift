//
//  ViewController.swift
//  AR Growth Tracker
//
//  Created by FGT MAC on 4/13/20.
//  Copyright © 2020 FGT MAC. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    
    //MARK: - Properties
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var outputImage: UIButton!
    
    var dotNodes = [SCNNode]()
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        debuggingOptions()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
    //MARK: - Actions
    
    @IBAction func takeScreenshotAction(_ sender: UIButton) {
        print("Tokk screenshot")
    }
    
    
    
    //MARK: - Custom Methods
    
    func debuggingOptions() {
        
        //Use to show dots when a plane has been detected
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
    }
    
    //Create a dot to be place at the location where the user touches on the screen
    func addDot(at hitResult: ARHitTestResult) {
        
        //Create Dot
        let dot = SCNSphere(radius: 0.005)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        dot.materials = [material]
        
        //Get Location coodinates
        let x = hitResult.worldTransform.columns.3.x
        let y = hitResult.worldTransform.columns.3.y
        let z = hitResult.worldTransform.columns.3.z
        
        //Postion on the scene
        let node = SCNNode()
        node.position = SCNVector3Make(x, y, z)
        node.geometry = dot
        
        //Place it on the scene
        sceneView.scene.rootNode.addChildNode(node)
        
        //Add shadows
        sceneView.autoenablesDefaultLighting = true
        
        //Add dots to array
        dotNodes.append(node)
        
        if dotNodes.count >= 2 {
            caculateDistance()
        }        
    }
    
    func caculateDistance() {
        let start = dotNodes[0]
        let end = dotNodes[1]
        
        let a = end.position.x - start.position.x
        let b = end.position.y - start.position.y
        let c = end.position.z - start.position.z
        
        let distance = sqrt(pow(a,2) + pow(b,2) + pow(c,2) )
        
        distanceLabel(text: "\(abs(distance))")
        
    }
    
    func distanceLabel(text: String)  {
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        
        
    }

    // MARK: - ARSCNViewDelegate
    
    //Grab the location of the touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touchLocation = touches.first?.location(in: sceneView){
            
            let hitTestResults = sceneView.hitTest(touchLocation, types: .featurePoint)
            
            if let hitResult = hitTestResults.first {
                addDot(at: hitResult)
            }
        }
    }
    
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    

}
