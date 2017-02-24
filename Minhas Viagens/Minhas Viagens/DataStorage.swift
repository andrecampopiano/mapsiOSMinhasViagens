//
//  DataStorage.swift
//  Minhas Viagens
//
//  Created by André Campopiano on 23/02/17.
//  Copyright © 2017 André Luís  Campopiano. All rights reserved.
//

import UIKit

class DataStorage {

    
    let storageKey = "travelPlace"
    var viagens: [Dictionary<String, String>] = []
    
    func getDefaults() -> UserDefaults{
        return UserDefaults.standard
    }
    
    
    
    func saveTravel(viagem:Dictionary<String, String>){
        
        viagens = listTravel()
        
        viagens.append(viagem)
        getDefaults().set(viagens, forKey: storageKey)
        getDefaults().synchronize()
    }
    
    func listTravel() ->[ Dictionary<String, String> ]{
       var data = getDefaults().object(forKey: storageKey)
        
        if data == nil {
            data = []
        }
        
        return data as! Array
        
    }
    
    func removeTravel(index: Int){
       
        viagens = listTravel()
        viagens.remove(at: index)
        
        getDefaults().set(viagens, forKey: storageKey)
        getDefaults().synchronize()
    }
}
