//
//  Particle.swift
//  ColorLines3D
//
//  Created by Алексей Химунин on 06.02.2023.
//

import Foundation
import SceneKit

extension SceneView{
    func loadParticleSystems(atPath path: String) -> [SCNParticleSystem] {
        let url = URL(fileURLWithPath: path)
        let directory = url.deletingLastPathComponent()

        let fileName = url.lastPathComponent
        let ext: String = url.pathExtension

        if ext == "scnp" {
            return [SCNParticleSystem(named: fileName, inDirectory: directory.relativePath)!]
        } else {
            var particles = [SCNParticleSystem]()
            let scene = SCNScene(named: fileName, inDirectory: directory.relativePath, options: nil)
            scene!.rootNode.enumerateHierarchy({(_ node: SCNNode, _ _: UnsafeMutablePointer<ObjCBool>) -> Void in
                if node.particleSystems != nil {
                    particles += node.particleSystems!
                }
            })
            return particles
        }
    }
    
    func setupParticleSystem() {
        particleSystems[ParticleKind.stars.rawValue] = loadParticleSystems(atPath: "SKScene.scnassets/particles/p_a1.scnp")
    }
    
    func particleSystems(with kind: ParticleKind) -> [SCNParticleSystem] {
        return particleSystems[kind.rawValue]
    }

    func addParticles(with kind: ParticleKind, withTransform transform: SCNMatrix4, color: NSColor) {
        let particles = particleSystems(with: kind)
        for ps: SCNParticleSystem in particles {
            ps.particleColor = color
            scene!.addParticleSystem(ps, transform: transform)
        }
    }
}
