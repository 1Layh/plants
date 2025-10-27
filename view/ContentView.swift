import SwiftUI
import UserNotifications

struct ContentView: View {
    // ViewModel مشترك بين ContentView و TodayReminderView
    @StateObject private var viewModel = TodayReminderViewModel()

    @State private var showAddSheet = false
    @State private var navigateToToday = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 20) {
                    VStack {
                        HStack {
                            Text("My Plants 🌱")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 60)

                        Divider()
                            .background(Color.white)
                            .padding(.horizontal)
                        Spacer()
                    }

                    Spacer()

                    Image("Image")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 160, height: 280)

                    Text("Start your plant journey!")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)

                    Text("Now all your plants will be in one place and we will help you take care of them :)🪴")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)

                    Spacer()
                    Spacer()
                    Spacer()

                    Button {
                        showAddSheet = true
                    } label: {
                        Text("Set Plant Reminder")
                            .font(.system(size: 17))
                            .frame(width: 280, height: 35)
                    }
                }
                .buttonStyle(.glassProminent)
                .tint(Color("green1"))
                .padding(.bottom, 140)
            }
            .preferredColorScheme(.dark)
            .sheet(isPresented: $showAddSheet) {
                SetReminderView(
                    reminderToEdit: nil,
                    onSave: { newPlant in
                        // أضف مباشرة إلى الـ ViewModel ثم انتقل
                        viewModel.add(newPlant)
                        showAddSheet = false
                        navigateToToday = true
                    },
                    onUpdate: nil,
                    onDelete: nil
                )
            }
            .navigationDestination(isPresented: $navigateToToday) {
                TodayReminderView(viewModel: viewModel)
                    .navigationBarBackButtonHidden(true)
            }
        }
        .onAppear {
            requestNotificationPermission()
        }
    }
}

private func requestNotificationPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
        if let error = error {
            print("Notification permission error: \(error)")
        } else {
            print("Permission granted: \(granted)")
        }
    }
}

#Preview {
    ContentView()
}
