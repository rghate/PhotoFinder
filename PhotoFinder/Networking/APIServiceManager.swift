//
//  APIServiceManager.swift
//  MyImageGallery
//
//  Created by RGhate on 08/10/18.
//

import Foundation

final class APIServiceManager {
    
    //singleton
    static let shared = APIServiceManager()
    
    //private initializer
    private init() { }
    
    private func getAPIKey() -> String {
        return "13197033-03eec42c293d2323112b4cca6" //TODO: Unit test for string length
    }
    
    private let scheme = "https"
    private let host = "pixabay.com"
    private let path = "/api/"
    
    //public methods
    /**
     Download gallery images.
     @params term - search keywords
     @params imageType - Currectly supports only one type - 'photo'
     @params order - How the results should be ordered.  Accepted values: "popular", "latest". Default: "popular"
     @params pageNumber - Returned search results are paginated. Use this parameter to select the page number.
     
     @return CustomError object(optional) and array of Picture object.
     */
    func getPictures(forSearchTerm term: String,
                     imageType: ImageType = .photo,
                     order: Order = .popular,
                     pageNumber: Int,
                     loadFreshData: Bool,
                     completion: @escaping (Result<[Picture], CustomError>) -> Void) -> CustomError? {
        
        var responseError: CustomError? = nil
        
        //check page number
        // TODO: Unit text for this condition
        if pageNumber < 0 {
            responseError = CustomError(description: "Invalid page")
            return responseError
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            
            guard let self = self else { return }
            
            let queryItems = [URLQueryItem(name: QueryItemKey.apiKey.rawValue, value: self.getAPIKey()),
                              URLQueryItem(name: QueryItemKey.searchTerm.rawValue, value: term),
                              URLQueryItem(name: QueryItemKey.imageType.rawValue, value: imageType.rawValue),
                              URLQueryItem(name: QueryItemKey.order.rawValue, value: order.rawValue),
                              URLQueryItem(name: QueryItemKey.page.rawValue, value: "\(pageNumber)"),
                              URLQueryItem(name: QueryItemKey.perPage.rawValue, value: "25")]
            
            // create an object of URLComponents to construct an url with all the query components and parameters
            let urlComponents = URLComponents(scheme: self.scheme, host: self.host, path: self.path, queryItems: queryItems)
            
            guard let url = urlComponents.url else {
                print("Invalid URL")
                return
            }
//            print(url)
            
            let requestTimeout: TimeInterval = 30
            
            // use cache-policy to load cached data(if available), else make network request to download
            let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: requestTimeout)
            


            let dataTask = URLSession.shared.dataTask(with: request) { data, response, err in
                //error handling
                if let err = err {
                    completion(.failure(CustomError(description: "Error: \(err.localizedDescription)")))
                    return
                }

                if data == nil {
                    completion(.failure(CustomError(description: "Response data error")))
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    completion(.failure(CustomError(description: "Server error")))
                    return
                }
                
                do {
                    // decode response
                    let pictureResult = try JSONDecoder().decode(PicturesResult.self, from: data!)
                    completion(.success(pictureResult.pictures))
                } catch {
                    completion(.failure(CustomError(description: "Data parsing error")))
                }
            }
            
            // clear cache if fresh data needs to be loaded(happen on using UIRefreshControl on collectionview)
            if loadFreshData {
                self.clearURLCache(for: request, dataTask: dataTask)
            }
            
            dataTask.resume()
        }
        return responseError
    }
    
    fileprivate func clearURLCache(for fetchRequest: URLRequest, dataTask: URLSessionDataTask) {
        URLCache.shared.removeCachedResponse(for: fetchRequest)
        URLCache.shared.removeCachedResponse(for: dataTask)
    }
}

