//
//  AllDoneView.swift
//  plant
//
//  Created by Layan on 04/05/1447 AH.
//


import SwiftUI

struct AllDoneView: View {
    
    var isListEmpty: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            
            VStack(spacing: 0) {
                HStack {
                    Text("My Plants 🌱")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                  
                }
                .padding(.horizontal)
                .padding(.top, 60)
                
                // إضافة الفاصل (Divider) إذا كنت تريده بعد
                
                Divider()
                    .background(Color.white)
                    .padding(.horizontal)
            }
            
            Spacer()
        
            
            ZStack {
                         Image("Image 2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 280)
                
                Image("all_done_plant")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .offset(y: -20)
            }
            .padding(.bottom, 20)
            
            Text(isListEmpty ? "All Done! 🎉" : "All Done! 🎉")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
            Text(isListEmpty ? "All Reminders Completed." : "All Reminders Completed")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    AllDoneView(isListEmpty: true)
}
