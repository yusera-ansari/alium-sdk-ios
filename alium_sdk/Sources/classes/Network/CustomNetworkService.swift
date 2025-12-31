//
//  CustomNetworkService.swift
//  Pods
//
//  Created by yusera-ansari on 17/12/25.
//

enum CustomNetworkService {

    // MARK: - Follow-up Request

     static func getFollowUpQuestion(
         url: String,
         params: [String: Any],
         completion: @escaping (Result<AiFollowup, Error>) -> Void
     ) {
         guard let url = URL(string : url) else {
             print(" Invalid URL : \(url)")
             return
         }
         
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         request.timeoutInterval = 30

         // Headers
         request.setValue("application/json", forHTTPHeaderField: "Content-Type")
         request.setValue("application/json", forHTTPHeaderField: "Accept")
         
         
         // Body
         do {
             request.httpBody = try JSONSerialization.data(
                 withJSONObject: params,
                 options: []
             )
         } catch {
             print(" JSON serialization failed:", error)
             return
         }

         
         // Execute
         let task = URLSession.shared.dataTask(with: request) { data, response, error in

             if let error = error {
                 print(" Network error:", error)
                 return
             }

             guard let httpResponse = response as? HTTPURLResponse else {
                 print(" Invalid response")
                 return
             }

             print(" followup response status:", httpResponse.statusCode)

             if let data = data {
                 let body = String(data: data, encoding: .utf8) ?? ""
                 print("Followup Response body:", body)
                 do{
                     let followup = try JSONDecoder().decode(AiFollowup.self, from: data)
                     completion(.success(followup))
                     
                 }catch{
                     print(error.localizedDescription)
                     completion(.failure(error))
                 }
             }
         }

         task.resume()

//         CustomNetworkClient.post(url: url, body: jsonString) { result in
//             switch result {
//             case .success(let response):
//                 print(
//                     "followUp",
//                      "followUp request successful for payload: \(params)"
//                 )
//
//                 do {
//                     if let data = response.data(using: .utf8),
//                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
//                         completion(.success(json))
//                     } else {
//                         throw NSError(domain: "InvalidJSON", code: 0)
//                     }
//                 } catch {
//                     completion(.failure(error))
//                 }
//
//             case .failure(let error):
//                 print(error)
//                 completion(.failure(error))
//             }
//         }
     }
    static func postTrackRequest(_ urlString: String,
                                 _ parameters: [String: Any]) {

        guard let url = URL(string: urlString) else {
            print(" Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 30

        // Headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        // Body
        do {
            request.httpBody = try JSONSerialization.data(
                withJSONObject: parameters,
                options: []
            )
        } catch {
            print(" JSON serialization failed:", error)
            return
        }

        // Execute
        let task = URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                print(" Network error:", error)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print(" Invalid response")
                return
            }

            print(" Track response status:", httpResponse.statusCode)

            if let data = data {
                let body = String(data: data, encoding: .utf8) ?? ""
//                print("Response body:", body)
            }
        }

        task.resume()
    }
}
