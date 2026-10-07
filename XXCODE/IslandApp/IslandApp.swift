import SwiftUI

@main
struct IslandApp: App {
    var body: some Scene {
        WindowGroup { RootView().preferredColorScheme(.dark) }
    }
}

struct RootView: View {
    @State private var selected = 0
    var body: some View {
        TabView(selection: $selected) {
            DashboardView().tabItem { Label("Island", systemImage: "capsule.fill") }.tag(0)
            AssistantView().tabItem { Label("Assistant", systemImage: "waveform") }.tag(1)
            WallpaperView().tabItem { Label("Wallpapers", systemImage: "sparkles") }.tag(2)
            AutomationView().tabItem { Label("Automate", systemImage: "bolt.fill") }.tag(3)
            SettingsView().tabItem { Label("Settings", systemImage: "gearshape.fill") }.tag(4)
        }.tint(.cyan)
    }
}

struct AppBackground: View {
    var body: some View {
        LinearGradient(colors: [Color(red: 0.035, green: 0.03, blue: 0.09), Color(red: 0.08, green: 0.02, blue: 0.16)], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
    }
}

struct DashboardView: View {
    @State private var islandEnabled = true
    @State private var expanded = true
    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Header(title: "Island", subtitle: "Your in-app command surface")
                        HStack {
                            Image(systemName: "circle.hexagongrid.fill").font(.system(size: 30)).foregroundStyle(.cyan)
                            VStack(alignment: .leading) { Text("Assistant ready").font(.headline); Text("System integration: unavailable").font(.caption).foregroundStyle(.secondary) }
                            Spacer()
                            Toggle("", isOn: $islandEnabled).labelsHidden().tint(.cyan)
                        }.glassCard()
                        VStack(spacing: 14) {
                            Text("LIVE PREVIEW").font(.caption.weight(.bold)).foregroundStyle(.cyan).frame(maxWidth: .infinity, alignment: .leading)
                            Capsule().fill(.black).frame(height: expanded ? 116 : 54).overlay {
                                HStack {
                                    Circle().fill(.green).frame(width: 10, height: 10)
                                    VStack(alignment: .leading) { Text(expanded ? "Assistant" : "Island").font(.headline); if expanded { Text("Ready for a command").font(.caption).foregroundStyle(.secondary) } }
                                    Spacer()
                                    Image(systemName: expanded ? "waveform" : "sparkles").foregroundStyle(.cyan)
                                }.padding(.horizontal, 22)
                            }.animation(.spring, value: expanded)
                            Toggle("Expanded preview", isOn: $expanded).tint(.purple)
                        }.glassCard()
                        SectionCard(title: "Available now", items: [("App Island preview", "In-app UI"), ("Assistant actions", "Shortcuts-ready"), ("Wallpaper library", "Local assets"), ("Theme engine", "App appearance")])
                        SectionCard(title: "Requires elevated access", items: [("System-wide Island overlay", "Jailbreak / private API"), ("Control Centre modules", "Private API"), ("True Always-On Display", "Hardware / system")])
                    }.padding()
                }
            }.toolbar(.hidden, for: .navigationBar)
        }
    }
}

struct AssistantView: View {
    @State private var prompt = ""
    @State private var messages = ["Assistant is ready. Try “show my Island status”.", "Actions only report success when the underlying operation succeeds."]
    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()
                VStack {
                    Header(title: "Assistant", subtitle: "Provider: Local demo")
                    ScrollView { VStack(alignment: .leading, spacing: 12) { ForEach(messages, id: \.self) { Text($0).padding().background(.white.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16)) } }.frame(maxWidth: .infinity, alignment: .leading).padding() }
                    HStack {
                        TextField("Ask Assistant…", text: $prompt).textFieldStyle(.roundedBorder)
                        Button { guard !prompt.isEmpty else { return }; messages.append("You: \(prompt)"); messages.append("Demo response: \(prompt)"); prompt = "" } label: { Image(systemName: "arrow.up.circle.fill").font(.title).foregroundStyle(.cyan) }
                    }.padding()
                }.padding(.top)
            }.toolbar(.hidden, for: .navigationBar)
        }
    }
}

struct WallpaperView: View {
    @State private var selected = 0
    let wallpapers = [("Aurora", "moon.stars.fill"), ("Cyber Purple", "circle.hexagongrid.fill"), ("Minimal", "circle.fill"), ("Anime Library", "sparkles")]
    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        Header(title: "Wallpapers", subtitle: "Validated local library")
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                            ForEach(Array(wallpapers.enumerated()), id: \.offset) { index, item in
                                Button { selected = index } label: { RoundedRectangle(cornerRadius: 20).fill(LinearGradient(colors: [.purple.opacity(0.7), .cyan.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)).frame(height: 150).overlay { VStack { Image(systemName: item.1).font(.largeTitle); Text(item.0).font(.headline) } }.overlay { RoundedRectangle(cornerRadius: 20).stroke(selected == index ? .cyan : .clear, lineWidth: 3) } }.buttonStyle(.plain)
                            }
                        }
                        Button("Set selected wallpaper") {}.buttonStyle(.borderedProminent).tint(.purple).frame(maxWidth: .infinity)
                        Text("The app can preview and manage assets. Changing the system wallpaper still requires the user-authorized iOS flow.").font(.caption).foregroundStyle(.secondary)
                    }.padding()
                }
            }.toolbar(.hidden, for: .navigationBar)
        }
    }
}

struct AutomationView: View {
    @State private var enabled = true
    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()
                List {
                    Section("Rules") {
                        RuleRow(trigger: "Music starts", action: "Show Island", enabled: $enabled)
                        RuleRow(trigger: "AI command received", action: "Run Shortcut", enabled: .constant(true))
                        RuleRow(trigger: "Time is 22:00", action: "Change wallpaper", enabled: .constant(false))
                    }
                    Section { Text("Automation uses Shortcuts/App Intents where iOS permits. Restricted actions are not simulated.").font(.caption).foregroundStyle(.secondary) }
                }.scrollContentBackground(.hidden)
            }.navigationTitle("Automation")
        }
    }
}

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()
                List {
                    Section("Configuration") { Label("General", systemImage: "slider.horizontal.3"); Label("Voice", systemImage: "mic.fill"); Label("Music", systemImage: "music.note"); Label("Privacy", systemImage: "lock.fill") }
                    Section("Diagnostics") { Label("iOS app mode: available", systemImage: "checkmark.circle.fill").foregroundStyle(.green); Label("Jailbreak: not detected", systemImage: "xmark.circle.fill").foregroundStyle(.orange); Label("System injection: unavailable", systemImage: "exclamationmark.triangle.fill").foregroundStyle(.orange) }
                    Section("About") { Text("IslandPlatform 0.2.0"); Text("Capability-gated prototype for iOS customization.") }
                }.scrollContentBackground(.hidden)
            }.navigationTitle("Settings")
        }
    }
}

struct Header: View {
    let title: String; let subtitle: String
    var body: some View { VStack(alignment: .leading, spacing: 4) { Text(title).font(.system(size: 34, weight: .bold, design: .rounded)); Text(subtitle).foregroundStyle(.secondary) }.frame(maxWidth: .infinity, alignment: .leading) }
}

struct SectionCard: View {
    let title: String; let items: [(String, String)]
    var body: some View { VStack(alignment: .leading, spacing: 12) { Text(title).font(.headline); ForEach(items, id: \.0) { item in HStack { Text(item.0); Spacer(); Text(item.1).font(.caption).foregroundStyle(.secondary) } } }.glassCard() }
}

struct RuleRow: View {
    let trigger: String; let action: String; @Binding var enabled: Bool
    var body: some View { HStack { VStack(alignment: .leading) { Text("IF \(trigger)").font(.subheadline); Text("THEN \(action)").font(.caption).foregroundStyle(.cyan) }; Spacer(); Toggle("", isOn: $enabled).labelsHidden().tint(.purple) } }
}

extension View {
    func glassCard() -> some View { padding().background(.white.opacity(0.07)).clipShape(RoundedRectangle(cornerRadius: 20)).overlay { RoundedRectangle(cornerRadius: 20).stroke(.white.opacity(0.08)) } }
}
