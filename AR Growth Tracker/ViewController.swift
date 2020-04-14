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

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var outputImage: UIButton!
    
    
    
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
        print(hitResult)
        
        let location = SCNMatrix4.init(hitResult.worldTransform)

        let x = location.m41
        let y = location.m42
        let z = location.m43
        
        let sphere = SCNSphere(radius: 0.01)
        
        let material = SCNMaterial()
        
        material.diffuse.contents = UIColor.red
        
        sphere.materials = [material]
        
        let node = SCNNode()
        
        node.position = SCNVector3Make(x, y, z)
        
        node.geometry = sphere
        
        sceneView.scene.rootNode.addChildNode(node)
        
        sceneView.autoenablesDefaultLighting = true
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
