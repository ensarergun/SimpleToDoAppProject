//
//  SimpleToDoAppApp.swift
//  SimpleToDoApp
//
//  Created by Ensar Ergün on 15.06.2025.
//

import SwiftUI
import UserNotifications // BU SATIRI EKLE

@main
struct SimpleToDoAppApp: App {
    init() {
        // BİLDİRİM İZNİ ALMA KODU
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Bildirim izni verildi.")
            } else {
                print("Bildirim izni reddedildi.")
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: TaskItem.self)
    }
}
