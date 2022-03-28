//
//  ViewController.swift
//  ASCIISpinningDonut
//
//  Created by Nguyễn Việt Anh on 20/03/2022.
//

import UIKit

class ViewController: UIViewController {
    //MARK: Variables
    let collectionview: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        flowlayout.scrollDirection = .vertical
        return view
    }()
    
    var pixel_width = 10
    var pixel_height = 10
    
    var A: Double = 0
    var B: Double = 0
    
    var theta_spacing = 10
    var phi_spacing = 3
    
    var chars = [".",",","-","~",":",";","=","!","*","#","$","@"]
            
    var output = [String]()
    var zbuffer = [Double]()
    
    //Color
    var hue: CGFloat = 0
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ViewConfig()
        constraintsConfig()
        
    }
    
    override func viewDidLayoutSubviews() {
        collectionviewConfig()
        
        Donut()

        let timer = Timer.scheduledTimer(timeInterval: 0.0000001, target: self, selector: #selector(Donut), userInfo: nil, repeats: true)
    }
    
    //MARK: ViewConfig
    func ViewConfig() {
        self.view.backgroundColor = .black
        self.view.addSubview(collectionview)
        
    }
    
    func collectionviewConfig() {
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        
    }
    
    //MARK: Constraints
    func constraintsConfig() {
//        collectionview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
//        collectionview.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
//        collectionview.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
//        collectionview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        collectionview.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        collectionview.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        collectionview.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        collectionview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    //MARK: Donut
    @objc func Donut() {
        let screen_width: Double = Double(collectionview.frame.width / CGFloat(pixel_width))
        let screen_height: Double = Double(collectionview.frame.width / CGFloat(pixel_height))
        let screen_size = Int(screen_width * screen_height)
        
        
        var R1: Double = 10
        var R2: Double = 20
        var K2: Double = 200
        var K1: Double = screen_height * K2 * 3 / (8 * (R1 + R2))
        
        
        output = [String](repeating: " ", count: screen_size)
        zbuffer = [Double](repeating: 0, count: screen_size)
        
        
        for theta in stride(from: 0, to: 628, by: theta_spacing) {
            for phi in stride(from: 0, to: 628, by: phi_spacing) {
                
                
                let sinA = sin(A)
                let cosA = cos(A)
                let sinB = sin(B)
                let cosB = cos(B)
                
                let costheta = cos(Double(theta))
                let sintheta = sin(Double(theta))
                let cosphi = cos(Double(phi))
                let sinphi = sin(Double(phi))
                
                // x, y coordinates before revolving
                let circlex = R2 + R1 * costheta
                let circley = R1 * sintheta
                
                // 3D coordinate after rotation
                let x = circlex * (cosB * cosphi + sinA * sinB * sinphi) - circley * cosA * sinB
                let y = circlex * (sinB * cosphi - sinA * cosB * sinphi) + circley * cosA * cosB
                let z = K2 + cosA * circlex * sinphi + circley * sinA
                let ooz = 1 / z
                
                // x,y projection
                let xp = Int(screen_width / 2 + K1 * ooz * x)
                let yp = Int(screen_height / 2 - K1 * ooz * y)
                let position = Double(xp) + screen_width * Double(yp)
                                
                //Luminance
                let L = cosphi * costheta * sinB - cosA * costheta * sinphi - sinA * sintheta + cosB * (cosA * sintheta - costheta * sinA * sinphi)
                
                if ooz > zbuffer[Int(position)] {
                    zbuffer[Int(position)] = ooz
                    let luminance_index = Int(L * 8)
                    output[Int(position)] = chars[luminance_index > 0 ? luminance_index : 0]
                }
            }
        }
        
        A += 0.05
        B += 0.05
        hue += 0.005
        collectionview.reloadData()
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return Int((view.bounds.width * view.bounds.height)/10)
        
        return Int((collectionview.bounds.width / CGFloat(pixel_width)) * (collectionview.bounds.width / CGFloat(pixel_height)))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let Cell = collectionview.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        Cell.label.text = output[indexPath.item]
        Cell.label.textColor = UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 1)
        return Cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: pixel_width, height: pixel_height)
    }
    
    //Spacing between cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
