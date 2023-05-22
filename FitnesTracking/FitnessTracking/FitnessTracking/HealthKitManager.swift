import Foundation
import HealthKit


class HealthKitManager{
    func setUpHealthRequest(healthStore: HKHealthStore, readValues: @escaping () -> Void) {
        if HKHealthStore.isHealthDataAvailable(),
            let stepCount = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) ,
            let calories = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned) {
            healthStore.requestAuthorization(toShare: [stepCount, calories], read: [stepCount, calories]) { success, error in
                if success {
                    readValues()
                } else if error != nil {
                    // handle your error here
                }
            }
        }
        
    }
    
    
    func readStepCount(forToday: Date, healthStore: HKHealthStore, completion: @escaping (Double) -> Void) {
        guard let stepQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            
            completion(sum.doubleValue(for: HKUnit.count()))
        
        }
        
        healthStore.execute(query)
        
    }
    
    
    func readCaloriesBurned(forDate date: Date, healthStore: HKHealthStore, completion: @escaping (Double) -> Void) {
            guard let caloriesQuantityType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
                completion(0.0)
                return
            }
            
            let now = Date()
            let startOfDay = Calendar.current.startOfDay(for: now)
            let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
            
            let query = HKStatisticsQuery(quantityType: caloriesQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
                
                guard let result = result, let sum = result.sumQuantity() else {
                    completion(0.0)
                    return
                }
                
                completion(sum.doubleValue(for: HKUnit.kilocalorie()))
            }
            
            healthStore.execute(query)
        }
    
}

class HealthKitViewModel : ObservableObject{
    
    private var healthStore = HKHealthStore()
    private var healthKitManager = HealthKitManager()
    @Published var userStepCount = ""
    @Published var userCalories = ""
    @Published var isAuthorized = false
    @Published var isAuthorized2 = false
    func healthRequest() {
        healthKitManager.setUpHealthRequest(healthStore: healthStore) {
            self.changeAuthorizationStatus()
            self.readStepsTakenToday()
            self.readCaloriesBurnedToday()
        }
    }
    
    func readStepsTakenToday() {
        healthKitManager.readStepCount(forToday: Date(), healthStore: healthStore) { step in
            if step != 0.0 {
                DispatchQueue.main.async {
                    self.userStepCount = String(format: "%.0f", step)
                }
            }
        }
    }
    
    func readCaloriesBurnedToday() {
            healthKitManager.readCaloriesBurned(forDate: Date(), healthStore: healthStore) { calories in
                if calories != 0.0 {
                    DispatchQueue.main.async {
                        self.userCalories = String(format: "%.0f", calories)
                    }
                }
            }
        }
        
    
    func changeAuthorizationStatus() {
        
        guard let stepQtyType = HKObjectType.quantityType(forIdentifier: .stepCount) else{return}
                guard let caloriesQtyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)  else {return}
        
        let statusSteps = self.healthStore.authorizationStatus(for: stepQtyType)
        let statusCal = self.healthStore.authorizationStatus(for: caloriesQtyType)
        
        switch statusSteps {
        case .notDetermined:
            isAuthorized = false
        case .sharingDenied:
            isAuthorized = false
        case .sharingAuthorized:
            DispatchQueue.main.async {
                self.isAuthorized = true
            }
        @unknown default:
            isAuthorized = false
        }
        
        switch statusCal {
        case .notDetermined:
            isAuthorized = false
        case .sharingDenied:
            isAuthorized = false
        case .sharingAuthorized:
            DispatchQueue.main.async {
                self.isAuthorized = true
            }
        @unknown default:
            isAuthorized = false
        }
    }
   
}




