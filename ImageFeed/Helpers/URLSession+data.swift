import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    func getData( for request: URLRequest, completion: @escaping (Result<Data,Error>) -> Void) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data,Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                    
                } else {
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            }
            else if let error = error {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            }
            else {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        }
        )
        return task
    }
    
    func objectTask<T: Decodable>(
        for request:URLRequest,
        completion: @escaping (Result<T, Error>)-> Void
    ) -> URLSessionTask {
        let jsonDecoder = JSONDecoder()
        
        let task = getData(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let tObject = try jsonDecoder.decode(T.self, from: data)
                    completion(.success(tObject))
                }
                catch DecodingError.dataCorrupted(let context) {
                    print("[objectTask]: DecodingError.dataCorrupted. \(context)")
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("[objectTask]: DecodingError.keyNotFound. Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.valueNotFound(let value, let context) {
                    print("[objectTask]: DecodingError.valueNotFound. Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("[objectTask]: DecodingError.typeMismatch. Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("[objectTask]: Error. \(error.localizedDescription)")
                }
            case .failure(let error):
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
        return task
    }
}
