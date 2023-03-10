//
//  Distance.swift
//  BanTaxi
//
//  Created by 엄태양 on 2023/03/10.
//

import Foundation

struct Distance {
    static func calcDistance(_ p1: (lat: Double?, lon: Double?), _ p2: (lat:Double?, lon:Double?)) -> Double? {
        
        if let lat1 = p1.lat, let lon1 = p1.lon, let lat2 = p2.lat, let lon2 = p2.lon {
            if ((lat1 == lat2) && (lon1 == lon2)) {
                return 0;
            } else {
                let theta = abs(lon1 - lon2)
                var dist = sinl(deg2rad(lat1)) * sinl(deg2rad(lat2)) + cosl(deg2rad(lat1)) * cosl(deg2rad(lat2)) * cosl(deg2rad(theta));
                dist = acosl(dist)
                dist = rad2deg(dist)
                dist = dist * 60 * 1.1515
                
                dist *= 1.609344
                
                return dist
            }
        } else {
            return 0.0
        }
        
        
    }
    
    private static func deg2rad(_ deg: Double) -> Double {
        return (deg * Double.pi / 180)
    }

    private static func rad2deg(_ rad: Double) -> Double {
        return (rad * 180 / Double.pi)
    }
}
