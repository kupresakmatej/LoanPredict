import Foundation

class AzureNetworking: ObservableObject {
    func invokeRequestResponseService(loanPrediction: LoanPrediction, completion: @escaping (Result<[WebServiceOutput], Error>) -> Void) {
        let restEndpoint = "http://4ebf1479-7030-4b60-a7a8-d5c5358e70ed.westeurope.azurecontainer.io/score"
        guard let url = URL(string: restEndpoint) else {
            print("Invalid URL")
            return
        }
        
        let inputData: [[String: Any]] = [
            [
                "Age": loanPrediction.age,
                "Experience": loanPrediction.experience,
                "Income": loanPrediction.income,
                "Zip": loanPrediction.zip,
                "Family": loanPrediction.family,
                "CCAvg": loanPrediction.CCAvg,
                "Education": loanPrediction.education,
                "Mortgage": loanPrediction.mortgage,
                "SecuritiesAccount": loanPrediction.securitiesAccount,
                "CDAccount": loanPrediction.cdAccount,
                "Online": loanPrediction.online,
                "CreditCard": loanPrediction.creditCard
            ]
        ]
        
        let requestBody: [String: Any] = [
            "Inputs": ["input1": inputData],
            "GlobalParameters": [:]
        ]
        
        guard let requestBodyData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            print("Failed to encode request body")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = requestBodyData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let apiKey = "52i4Q0eo52RTO6HWL3ovbZWQlUV9Npt2"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "InvalidResponse", code: 0, userInfo: nil)))
                return
            }
            
            print("Status code: \(httpResponse.statusCode)")
            
            if let data = data {
                do {
                    let predictionResult = try JSONDecoder().decode(PredictionResult.self, from: data)
                    let predictions = predictionResult.results.webServiceOutput
                    completion(.success(predictions))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}
