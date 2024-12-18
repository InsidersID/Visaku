//
//  AIGenerator.swift
//  Visaku
//
//  Created by Nur Nisrina on 19/11/24.
//

import SwiftUI
import OpenAI

class AIGeneratorController: ObservableObject {
    @Published var messages: [MessageModel] = []
    
    private let openAiKey: String
    private let openAI: OpenAI

    init() {
        let apiKeyProvider = APIKeyProvider()
        if let apiKey = apiKeyProvider.apiKey {
            print("Using API Key: \(apiKey)")
            let openAIPlatform = OpenAI(apiToken: apiKey)
            
            self.openAiKey = apiKey
            print("OpenAI API Key loaded successfully from Keychain")

            self.openAI = openAIPlatform
        } else {
            fatalError("API Key is unavailable. Check configuration.")
        }
    }
    
    func sendNewMessage(content: String, completion: @escaping (String?) -> Void) {
        let userMessage = MessageModel(content: content, isUser: true)
        self.messages.append(userMessage)
        getBotReply { reply in
            if let reply = reply {
                completion(reply)
            } else {
                print("Failed to fetch reply.")
                completion(nil)
            }
        }
    }
    
    func getBotReply(completion: @escaping (String?) -> Void) {
        let initialPrompt = """
        You are an itinerary generator that creates personalized travel plans in valid JSON format in english. Given the following inputs: city name is the city of the activity not the country, the hotel name, and the number of days for the trip, generate a complete daily itinerary. Each day includes a title (e.g., Day 1, Day 2), the date, and morning, afternoon, and night activities. For each activity, provide the place name, latitude, longitude, and a description of the activity, denotated by 1 to 6 words in bahasa indoensia. Your output must strictly follow this JSON structure without any additional text or characters:
        {
          "day1": {
            "title": "Day 1",
            "date": "YYYY-MM-DD",
            "city": "string",
            "morning": {
              "placeName": "string",
              "placeLatitude": "string",
              "placeLongitude": "string",
              "activity": "string"
            },
            "afternoon": {
              "placeName": "string",
              "placeLatitude": "string",
              "placeLongitude": "string",
              "activity": "string"
            },
            "night": {
              "placeName": "string",
              "placeLatitude": "string",
              "placeLongitude": "string",
              "activity": "string"
            }
          },
          "day2": {
            ...
          }
        }
        
        Do not include any other letters or text in your response other than the JSON, do not include "\n" or other symbol other than in JSON format, just response in JSON format so i can fetch the itinerary easily. You must strictly follow a JSON format.
        """
        
        let combinedMessages = [MessageModel(content: initialPrompt, isUser: false)] + self.messages
        
        let query = ChatQuery(
            messages: combinedMessages.map({
                .init(role: $0.isUser ? .user : .system, content: $0.content)!
            }),
            model: .gpt4_o_mini
        )
        
        openAI.chats(query: query) { result in
            switch result {
            case .success(let success):
                guard let choice = success.choices.first else {
                    completion(nil)
                    return
                }
                guard let message = choice.message.content?.string else { return }
                completion(message)
            case .failure(let failure):
                print(failure)
                completion(nil)
            }
        }
    }
}
