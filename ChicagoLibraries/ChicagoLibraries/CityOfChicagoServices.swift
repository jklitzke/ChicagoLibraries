//
//  CityOfChicagoServices.swift
//  ChicagoLibraries
//
//  Created by James Klitzke on 1/28/17.
//  Copyright © 2017 James Klitzke. All rights reserved.
//

import Foundation

typealias FailureClosure = (_ serviceError: Error, _ response: URLResponse) -> Void
typealias ListOfLibrariesClosure = (_ libraries : [Library]) -> Void

protocol CityOfChicagoServicesProtcol {
    
func getListOfLibraries(success : @escaping ListOfLibrariesClosure, failure: @escaping FailureClosure)

}

class CityOfChicagoServices : CityOfChicagoServicesProtcol {
    
    static let sharedInstnace = CityOfChicagoServices()

    let listOfLibrariesURL = URL(string: "https://data.cityofchicago.org/resource/x8fc-8rcq.json")
    let defaultSession = URLSession(configuration: .default)
    var dataTask : URLSessionTask!
    
    enum CityOfChicagoServiceErrors : Error {
        case ParsingError(String)
    }
    
    func getListOfLibraries(success : @escaping ListOfLibrariesClosure, failure: @escaping FailureClosure) {
        dataTask = defaultSession.dataTask(with: listOfLibrariesURL!) {
            data, response, error in
            
            guard let unWrapedResponse = response,
                  let urlResponse = unWrapedResponse as? HTTPURLResponse else {
                    failure(error!, response!)
                    return
            }

            guard urlResponse.statusCode == 200 else {
                failure(error!, urlResponse)
                return
            }
            
            do {
                if let parssedData = data,
                    let arrayResponse = try JSONSerialization.jsonObject(with: parssedData as Data, options: []) as? [Any] {
                    
                    let libraries = arrayResponse.map() { return Library(data: $0) }
                    success(libraries)
                    
                }
                else {
                   success([Library]())
                }
            }
            catch {
                failure(error, urlResponse)

            }
            
        }
        
        dataTask.resume()
    }
}

//Mocking class for unit testing purpsoes
class CityOfChicagoServicesMock : CityOfChicagoServicesProtcol {
    
    func getListOfLibraries(success : @escaping ListOfLibrariesClosure, failure: @escaping FailureClosure) {
        
        success([CityOfChicagoServicesMock.mockLibrary1(), CityOfChicagoServicesMock.mockLibrary2()])
        
    }
    
    static func mockLibrary1() -> Library {
        
        let lib = Library(data: nil)
        lib.name_ = "Test Library 1"
        lib.address = "1234 Main Street"
        lib.hours_of_operation = "No Hours Of Operation"
        lib.location = Location(data: nil)
        lib.location?.latitude = "41.8012136599335"
        lib.location?.longitude = "-87.72649071431441"
        
        return lib
    }
    
    static func mockLibrary2() -> Library {
        let lib2 = Library(data: nil)
        lib2.name_ = "My Test Library"
        lib2.address = "100 State Street"
        lib2.hours_of_operation = "No Hours Of Operation"
        lib2.location = Location(data: nil)
        lib2.location?.latitude = "41.975456"
        lib2.location?.longitude = "-87.71409"
        
        return lib2
    }
}
