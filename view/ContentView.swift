//
//  ContentView.swift
//  plant
//
//  Created by Layan on 27/04/1447 AH.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        ZStack {
            Color.black
                .ignoresSafeArea()
            
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
                    
                    // هذا هو الخط الأفقي المطلوب
                    Divider()
                        .background(Color.white) // لجعل الخط مرئيًا على الخلفية السوداء
                        .padding(.horizontal) // للحفاظ على نفس الهامش الأفقي
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
                
                Button(action: {
                    print("Set Reminder button tapped")
                }) {
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
    }
}

#Preview {
    ContentView()
}
