//
//  CodeCheckingToolViewController.swift
//  TableVwCellExpandCollapse
//
//  Created by MAC on 12/07/25.
//

import UIKit
import Alamofire

class CodeCheckingToolViewController: UIViewController {
    @IBOutlet weak var codeTextView: UITextView!
    @IBOutlet weak var outputTextView: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        codeTextView.text = "print('Hello, world!')"
    }
    
    @IBAction func runCodeButtonTapped(_ sender: UIButton) {
        let userCode = codeTextView.text ?? ""
            runCodeAfterLanguageDetection(code: userCode)
        }
    
    // MARK: - Step 1: Detect Language via Guesslang
        func detectLanguageViaAPI(code: String, completion: @escaping (String?) -> Void) {
            guard let url = URL(string: "https://guesslang-api.fly.dev/guess") else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let payload: [String: Any] = ["code": code]
            request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

            URLSession.shared.dataTask(with: request) { data, _, _ in
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let detectedLanguage = json["language"] as? String else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }

                DispatchQueue.main.async {
                    completion(detectedLanguage)
                }
            }.resume()
        }
    
    // MARK: - Step 2: Fetch Judge0 Languages
        func fetchJudge0Languages(completion: @escaping ([String: Int]) -> Void) {
            let url = URL(string: "https://judge0-ce.p.rapidapi.com/languages")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("ed6f702d6emsh70d4da24ba42ee1p1f2d25jsna98836d94574", forHTTPHeaderField: "X-RapidAPI-Key") // Replace with your key
            request.addValue("judge0-ce.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")

            URLSession.shared.dataTask(with: request) { data, _, _ in
                guard let data = data,
                      let jsonArray = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
                    completion([:]) // return empty on error
                    return
                }

                var languageMap: [String: Int] = [:]
                for entry in jsonArray {
                    if let name = entry["name"] as? String,
                       let id = entry["id"] as? Int {
                        languageMap[name] = id
                    }
                }

                completion(languageMap)
            }.resume()
        }
    
    // MARK: - Step 3: Match Language ➝ Judge0 ID & Run
        func runCodeAfterLanguageDetection(code: String) {
            detectLanguageViaAPI(code: code) { detectedLanguage in
                guard let language = detectedLanguage else {
                    self.outputTextView.text = "⚠️ Language detection failed."
                    return
                }

                self.fetchJudge0Languages { languageMap in
                    let matchedEntry = languageMap.first { (key, _) in
                        key.lowercased().contains(language.lowercased())
                    }

                    guard let (matchedName, matchedID) = matchedEntry else {
                        DispatchQueue.main.async {
                            self.outputTextView.text = "⚠️ Could not match '\(language)' to Judge0 languages."
                        }
                        return
                    }

                    DispatchQueue.main.async {
                        print("✅ Detected: \(language) ➝ Matched: \(matchedName) ➝ ID: \(matchedID)")
                        self.runCode(sourceCode: code, languageID: matchedID)
                    }
                }
            }
        }
    
    // MARK: - Step 4: Run Code via Judge0 API
        func runCode(sourceCode: String, languageID: Int) {
            let url = URL(string: "https://judge0-ce.p.rapidapi.com/submissions?base64_encoded=false&wait=true")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("ed6f702d6emsh70d4da24ba42ee1p1f2d25jsna98836d94574", forHTTPHeaderField: "X-RapidAPI-Key") // Replace with your key
            request.addValue("judge0-ce.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")

            let payload: [String: Any] = [
                "source_code": sourceCode,
                "language_id": languageID
            ]

            request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

            URLSession.shared.dataTask(with: request) { data, _, _ in
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    DispatchQueue.main.async {
                        self.outputTextView.text = "❌ Error submitting code"
                    }
                    return
                }

                let output = json["stdout"] as? String
                let compileError = json["compile_output"] as? String
                let stderr = json["stderr"] as? String

                DispatchQueue.main.async {
                    if let output = output {
                        self.outputTextView.text = "✅ Output:\n\(output)"
                    } else if let compileError = compileError {
                        self.outputTextView.text = "❌ Compilation Error:\n\(compileError)"
                    } else if let stderr = stderr {
                        self.outputTextView.text = "❌ Runtime Error:\n\(stderr)"
                    } else {
                        self.outputTextView.text = "⚠️ No output received"
                    }
                }
            }.resume()
        }
}
