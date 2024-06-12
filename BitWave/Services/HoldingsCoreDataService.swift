//
//  HoldingsCoreDataService.swift
//  BitWave
//
//  Created by Deniz Dilbilir on 16/07/2024.
//

import Foundation
import CoreData

class HoldingsCoreDataService {
    
    private let persistentContainer: NSPersistentContainer
    private let persistentContainerName: String = "UserHoldingsDataModel"
    private let entityName: String = "Holdings"
    @Published var savedEntity: [Holdings] = []
    
    init() {
        persistentContainer = NSPersistentContainer(name: persistentContainerName)
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                print("Loading Core Data Error \(error)")
            }
            self.fetchUserHoldings()
        }
    }
    
    func updateHoldings(coin: Coin, amount: Double) {
        if let entity = savedEntity.first(where: { $0.coinID == coin.id }) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
            }
        } else {
            append(coin: coin, amount: amount)
        }
    }
    
    private func fetchUserHoldings() {
        let fetchRequest = NSFetchRequest<Holdings>(entityName: entityName)
        do {
            savedEntity = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error {
            print("Fetching holdings entity error. \(error)")
        }
    }
    private func append(coin: Coin, amount: Double) {
        let entity = Holdings(context: persistentContainer.viewContext)
        entity.coinID = coin.id
        entity.activeHoldingsAmount = amount
        performChanges()
    }
    
    private func update(entity: Holdings, amount: Double) {
        entity.activeHoldingsAmount = amount
        performChanges()
    }
    
    private func delete(entity: Holdings) {
        persistentContainer.viewContext.delete(entity)
        performChanges()
    }
    
    private func save() {
        do {
            try persistentContainer.viewContext.save()
        } catch let error {
            print("Core Data Saving Error \(error)")
        }
    }
    private func performChanges() {
        save()
        fetchUserHoldings()
    }
}
