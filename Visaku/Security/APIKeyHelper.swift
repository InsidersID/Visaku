//
//  APIKeyHelper.swift
//  Visaku
//
//  Created by Lonard Steven on 23/11/24.
//

import Foundation

class APIKeyProvider {
    private let keychainKey = "OPENAI_API_KEY"
    private(set) var apiKey: String?

    init() {
        // Try fetching the key from the Keychain first
        if let storedKey = KeychainManager.shared.fetch(key: keychainKey) {
            self.apiKey = storedKey
            print("OpenAI API Key loaded from Keychain.")
        } else if let configKey = Bundle.main.object(forInfoDictionaryKey: "OPENAI_API_KEY") as? String {
            // No key in Keychain, fallback to Info.plist
            let success = KeychainManager.shared.save(key: keychainKey, value: configKey)
            if success {
                self.apiKey = configKey
                print("OpenAI API Key fetched from configuration and saved to Keychain.")
            } else {
                print("Failed to save OpenAI API Key to Keychain.")
            }
        } else {
            print("OpenAI API Key not found in Info.plist or Keychain.")
        }
    }
}
