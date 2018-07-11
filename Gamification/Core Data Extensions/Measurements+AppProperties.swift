//
//  Measurements+AppProperties.swift
//  CoreDirection
//
//  Created by Ahmar on 9/21/17.
//  Copyright © 2017 Rebel Technology. All rights reserved.
//

import Foundation
import CoreData

extension Measurements   {
    
    class func fetchLatestMeasurement() -> Measurements? {
        var testArray = [Measurements]()
        testArray = self.fetchAllMeasurements()
        
        let sortedMeasurementsList = testArray.sorted(by: { ($0).lastUpdated > ($1).lastUpdated })
        return sortedMeasurementsList.first
    }

    class func fetchAllMeasurements() -> [Measurements] {
        var measurementsArray = [Measurements]()
        measurementsArray = CoreDataManager.fetchList(entityName: Entity.measurement, predicate: nil) as! [Measurements]
        return measurementsArray
    }
    
    var isMeasured: Bool    {
        return self.users?.contains(SessionManager.user!) ?? false
    }

    func addToMeasured() {
        self.addToUsers(SessionManager.user!)
    }

    func removeFromMeasured() {
        self.removeFromUsers(SessionManager.user!)
    }
    
    class func sync(data: [String: Any], type: String = K.history)    {
        
        if let takeSelfie = data[K.takeSelfie] as? Bool {
            SessionManager.user?.takeSelfie = takeSelfie
        }

        
        var measurementsList = data[K.list] as! [[String: Any]]
        print("=============================================")
        print("sync stared")
        let entityName = Entity.measurement
        
        let oldMeasurementsList = Measurements.fetchAllMeasurements()
        for measurementObj in oldMeasurementsList {
            measurementObj.removeFromMeasured()
        }
        CoreDataManager.deleteAll(entityName: entityName)
        
        // Since, out DeleteAll is not save immidiately so therefore, save  now
        CoreDataStack.save()

        
        
        for i in 0..<measurementsList.count {
            
            var measurementDictionary = measurementsList[i] 
            measurementDictionary =  parseMeasurementFor(dict: measurementDictionary)
 
            let id = measurementDictionary[K.id] as! Int64
            let lastUpdateValue = measurementDictionary[K.lastUpdated] as! Double
            
            var measurement: Measurements!
            let updatePredicate = NSPredicate(format: "id == \(id) && lastUpdated != \(lastUpdateValue)")
            
            if CoreDataManager.ifExist(entityName: entityName, predicate: updatePredicate) {
                measurementDictionary["image"] = NSNull()//nil
                measurement = CoreDataManager.update(object: measurementDictionary, entityName: entityName, id: id) as! Measurements
                measurement.users = nil
                print("item updated: \(id) - \(String(describing: measurementDictionary[K.title]))")
                
            }
            else if !CoreDataManager.ifExist(entityName: entityName, id: id)    {
                measurement = CoreDataManager.insert(object: measurementDictionary, entityName: entityName) as! Measurements

                print("item inserted: \(id) - \(String(describing: measurementDictionary[K.title]))")
            }
            else    {
                measurement = CoreDataManager.fetchObject(entityName: entityName, id: id) as! Measurements
            }
            
            let dict = measurementsList[i]
            let measurementParamList = (dict["measurements"] as? [[String: Any]] ?? [])!
        
            measurement.params = nil
            
            for measurementParam in measurementParamList {
                self.syncWith(measurement: measurement, data: measurementParam)
            }
            
            measurement.addToMeasured()
        }
        
        print("=============================================")
        print("sync end")
        
        CoreDataStack.save()
    }
    
    // Parsing for Measurement
    
    class func parseMeasurementFor(dict: [String: Any]?) -> [String: Any] {
        
        var measurementDict = [String:Any]()
        
            measurementDict["id"] = Int64((dict?["id"] as? Int  ?? 0)!)
            measurementDict["date"] = (dict?["date"] as? String ?? "")!
            measurementDict["lastUpdated"] = Double((dict?["lastUpdated"] as? Double ?? 0)!)
            measurementDict["imageUrl"] = (dict?["selfieUrl"] as? String ?? "")!
        
        return measurementDict
    }
    
    // Parsing for MeasurementsParam
    
    class func parseMeasurementsParamFor(dict: [String: Any]?) -> [String: Any] {
        
        var measurementDict = [String:Any]()
        
        measurementDict["value"] = Double((dict?["value"] as? Double  ?? 0)!)
        if let value = dict?["value"] as? String {
            measurementDict["value"] = Double(value)
        }
        measurementDict["title"] = (dict?["title"] as? String ?? "")!
        measurementDict["unit"] = (dict?["unit"] as? String ?? "")!
        measurementDict["maxValue"] = Double((dict?["max_value"] as? Double ?? 0)!)
        measurementDict["minValue"] = Double((dict?["min_value"] as? Double ?? 0)!)
        
        return measurementDict
    }
    
    class func syncWith(measurement: Measurements, data: [String: Any])   {
        var measurementParamDictionary = data
        measurementParamDictionary =  parseMeasurementsParamFor(dict: data)
        let measurementsParam = CoreDataManager.insert(object: measurementParamDictionary, entityName: Entity.measurementsParam) as! MeasurementsParam
        measurementsParam.measurement = measurement
        CoreDataStack.save()
    }

}


private struct K    {
    static let id = "id"
    static let title = "title"
    static let imageUrl = "imageUrl"
    static let isFavorite = "isFavorite"
    static let lastUpdated = "lastUpdated"
    static let list = "list"
    static let searchResults = "searchResults"
    static let history = "history"
    static let current = "current"
    static let takeSelfie = "takeSelfie"
}
