//
//  Chart.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 24/08/2566 BE.
//

import Foundation

struct ChartPost: Codable {
    let data: DataChart
}
struct DataChart: Codable {
    let user_id: Int
    let product_id: Int
    let size_id: Int
    
}
