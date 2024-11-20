//
//  AIGenerator.swift
//  Visaku
//
//  Created by Nur Nisrina on 19/11/24.
//

import SwiftUI
import OpenAI

class ChatController: ObservableObject {
    @Published var messages: [MessageModel] = []

    let openAI = OpenAI(apiToken: "secret")
    
    init() {
        
    }
    
    func sendNewMessage(content: String) {
        let userMessage = MessageModel(content: content, isUser: true)
        self.messages.append(userMessage)
        getBotReply()
    }
    
    func getBotReply() {
        let initialPrompt = """
        You are an itinerary generator that creates personalized travel plans in valid JSON format in bahasa indonesia. Given the following inputs: the country or city name, the hotel name, and the number of days for the trip, generate a complete daily itinerary. Each day includes a title (e.g., Day 1, Day 2), the date, and morning, afternoon, and night activities. For each activity, provide the place name, latitude, longitude, and a description of the activity, denotated by 1 to 6 words in bahasa indoensia. Your output must strictly follow this JSON structure without any additional text or characters:
        {
          "day1": {
            "title": "Day 1",
            "date": "YYYY-MM-DD",
            "morning": {
              "placeName": "string",
              "placeLatitude": "float",
              "placeLongitude": "float",
              "activity": "string"
            },
            "afternoon": {
              "placeName": "string",
              "placeLatitude": "float",
              "placeLongitude": "float",
              "activity": "string"
            },
            "night": {
              "placeName": "string",
              "placeLatitude": "float",
              "placeLongitude": "float",
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
                    return
                }
                guard let message = choice.message.content?.string else { return }
                DispatchQueue.main.async {
                    self.messages.append(MessageModel(content: message, isUser: false))
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
}



struct AIGenerator: View {
    @StateObject var chatController: ChatController = .init()
    @State var string: String = ""
    var body: some View {
        VStack {
            ScrollView {
                ForEach(chatController.messages) { message in
                    MessageView(message: message)
                        .padding(5)
                }
            }
            Divider()
            HStack {
                TextField("Contoh: BSD 3 hari 24-26 nov 2024", text: self.$string, axis: .vertical)
                    .padding(5)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                Button {
                    self.chatController.sendNewMessage(content: string)
                    string = ""
                } label: {
                    Image(systemName: "paperplane")
                }
            }
            .padding()
        }
    }
}

struct MessageView: View {
    var message: MessageModel
    var body: some View {
        Group {
            if message.isUser {
                HStack {
                    Spacer()
                    Text(message.content)
                        .padding()
                        .background(Color.primary5)
                        .foregroundColor(Color.white)
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                }
            } else {
                HStack {
                    Text(message.content)
                        .padding()
                        .background(Color.primary4)
                        .foregroundColor(Color.white)
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    AIGenerator()
}
