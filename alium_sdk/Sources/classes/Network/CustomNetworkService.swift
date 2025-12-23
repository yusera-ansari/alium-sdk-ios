//
//  CustomNetworkService.swift
//  Pods
//
//  Created by yusera-ansari on 17/12/25.
//

enum CustomNetworkService {

    static func postTrackRequest(_ urlString: String,
                                 _ parameters: [String: Any]) {

        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL")
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
            print("❌ JSON serialization failed:", error)
            return
        }

        // Execute
        let task = URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                print("❌ Network error:", error)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid response")
                return
            }

            print("📡 Track response status:", httpResponse.statusCode)

            if let data = data {
                let body = String(data: data, encoding: .utf8) ?? ""
                print("📦 Response body:", body)
            }
        }

        task.resume()
    }
}
