//
//  CreditCard.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import Foundation

struct Card {
    let name: String
    let numberCard: Int32
    let expMonth: Int
    let exYear: Int
    let cvc: Int
}

typealias CreditCard = [Card]
