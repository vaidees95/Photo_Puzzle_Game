//
//  ScoreboardCRUD.swift
//  PhotoPuzzle
//
//  Created by Dinesh Yeligandla on 11/21/19.
//  Copyright © 2019 Ramon Rodriguez. All rights reserved.
import UIKit
import CoreData

class ScoreboardCRUD: NSObject {
    static func create(newName:String, newMove:String, newTime:String, newScore:String) {
        
        //Get the managed context context from AppDelegate
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            //Create a new empty record.
            let guessWordEntity = NSEntityDescription.entity(forEntityName: "Scoreboard", in: managedContext)!
            //Fill the new record with values
            let guessword = NSManagedObject(entity: guessWordEntity, insertInto: managedContext)
            guessword.setValue(newName, forKeyPath: "name")
            guessword.setValue(newMove, forKey: "moves")
            guessword.setValue(newTime, forKey: "time")
            guessword.setValue(newScore, forKey: "score")
            do {
                //Save the managed object context
                try managedContext.save()
            } catch let error as NSError {
                print("Could not create the new record! \(error), \(error.userInfo)")
            }
        }
    }
    
    static func read() -> [[String]]? {
        var stringArray:[[String]] = [[]]
        var stringOneArray:[String] = []
        //Get the managed context context from AppDelegate
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            
            //Prepare the request of type NSFetchRequest  for the entity (SELECT * FROM)
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Scoreboard")
            //Add a contition to the fetch request (WHERE)
         //   fetchRequest.predicate = NSPredicate(format: "category = %@", category)
            //Add a sorting preference (ORDER BY)
            fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "score", ascending: false)]
            do {
                //Execute the fetch request
                let result = try managedContext.fetch(fetchRequest)
                if result.count > 0 {
                      stringArray.removeAll()
                    for x in 0..<result.count
                    {
                      

                   // let randNum = Int.random(in: 0 ..< result.count)
                        if( x < 5)
                       {
                    let record = result[x] as! NSManagedObject
                    let word = record.value(forKey: "name") as! String
                    let word1 = record.value(forKey: "time") as! String
                     let word2 = record.value(forKey: "score") as! String
                    stringOneArray.append(word)
                     stringOneArray.append(word1)
                     stringOneArray.append(word2)
                        
                        stringArray.append(stringOneArray)
                        stringOneArray.removeAll()
                        }
                  /*  stringArray[i].append(word)
                    stringArray[i].append(word1)
                    stringArray[i].append(word2)*/
                        
                  //  i += 1
                    }
                    
                }
                return stringArray
            } catch let error as NSError {
                print("Could not fetch the record! \(error), \(error.userInfo)")
            }
        }
        return nil
    }
    
    static func delete(oldWord:String) {
        //Get the managed context context from AppDelegate
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            
            //Prepare a fetch request for the record to delete
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Guessword")
            fetchRequest.predicate = NSPredicate(format: "word = %@", oldWord)
            
            do {
                //Fetch the record to delete
                let test = try managedContext.fetch(fetchRequest)
                
                //Delete the record
                let objectToDelete = test[0] as! NSManagedObject
                managedContext.delete(objectToDelete)
                
                do {
                    //Save the managed object context
                    try managedContext.save()
                }
                catch let error as NSError {
                    print("Could not delete the record! \(error), \(error.userInfo)")
                }
            }
            catch let error as NSError {
                print("Could not find the record to delete! \(error), \(error.userInfo)")
            }
            
        }
    }

    
    
    
    
    
    static func delete() {
          //Get the managed context context from AppDelegate
          if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
              let managedContext = appDelegate.persistentContainer.viewContext
              
              //Prepare a fetch request for the record to delete
              let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Scoreboard")
              
              do {
                  //Fetch the record to delete
                  let test = try managedContext.fetch(fetchRequest)
                if(test.count>0)
                {
                  //Delete the record
                  let objectToDelete = test[0] as! NSManagedObject
                  managedContext.delete(objectToDelete)
                  
                  do {
                      //Save the managed object context
                      try managedContext.save()
                  }
                  catch let error as NSError {
                      print("Could not delete the record! \(error), \(error.userInfo)")
                  }
                }
              }
              catch let error as NSError {
                  print("Could not find the record to delete! \(error), \(error.userInfo)")
              }
              
          }
      }

    
    
    static func update(oldWord:String, newWord:String) {
        //Get the managed context context from AppDelegate
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            
            //Prepare a fetch request for the record to update
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Guessword")
            fetchRequest.predicate = NSPredicate(format: "word = %@", oldWord)
            
            do{
                //Fetch the record to update
                let test = try managedContext.fetch(fetchRequest)
                
                //Update the record
                let objectToUpdate = test[0] as! NSManagedObject
                objectToUpdate.setValue(newWord, forKey: "word")
                do{
                    //Save the managed object context
                    try managedContext.save()
                }
                catch let error as NSError {
                    print("Could not update the record! \(error), \(error.userInfo)")
                }
            }
            catch let error as NSError {
                print("Could not find the record to update! \(error), \(error.userInfo)")
            }
        }
    }



}
