//
//  Cluster.swift
//  new app 3
//
//  Created by William Hinson on 7/3/20.
//  Copyright © 2020 Mixed WIth Music. All rights reserved.
//

import UIKit

class Cluster {
    var points = [Point]()
    var center : Point
    init(center : Point) {
        self.center = center
    }
    
    func calculateCurrentCenter() -> Point {
        if points.isEmpty {
            return Point.zero
        }
        return points.reduce(Point.zero, +) / CGFloat(points.count)
    }
    
    func updateCenter() {
        if points.isEmpty {
            return
        }
        let currentCenter = calculateCurrentCenter()
        center = points.min(by: {$0.distanceSquared(to: currentCenter) < $1.distanceSquared(to: currentCenter)})!
    }
    
    private func findClosest(for p : Point, from clusters: [Cluster]) -> Cluster {
        return clusters.min(by: {$0.center.distanceSquared(to: p) < $1.center.distanceSquared(to: p)})!
    }
    
    func cluster(points : [Point], into k : Int) -> [Cluster] {
    }
}
