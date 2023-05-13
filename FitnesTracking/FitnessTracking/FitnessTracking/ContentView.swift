//
//  ContentView.swift
//  FitnessTracking
//
//  Created by Radolina on 02/05/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm: HealthKitViewModel
    
    
    var body: some View {
        Home()
                 .environmentObject(HealthKitViewModel())
                 
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
    
    
    
}

struct Home : View{
    
   
    
    @EnvironmentObject var vm: HealthKitViewModel
    
   
    
    var body: some View{
        
        
        
        VStack{
            if vm.isAuthorized{
                
                ZStack{
                    Color("Color")
                        .edgesIgnoringSafeArea(.all)
                    VStack{
                        HStack{
                            Text("Fitness")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                            
                            Button(action:{
                                
                            }){
                                Image(systemName: "arrow.clockwise")
                                    .font(.title)
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Spacer()
                        
                        ZStack{
                            ProgressBar(height: 300, to: 0.8, color: .red)
                            ProgressBar(height: 230, to: CGFloat(CGFloat(vm.userStepCount.count)), color: .yellow)
                            ProgressBar(height: 160, to: 0.3, color: Color("Color1"))
                            
                        }
                        
                        HStack(spacing:20){
                            HStack{
                                Image("footsteps")
                                    .resizable()
                                    .frame(width: 55, height:55)
                                
                                VStack(alignment: .leading, spacing: 12){
                                    Text("Steps")
                                        .fontWeight(.bold)
                                        .foregroundColor(.red)
                                    
                                    Text("\(vm.userStepCount)/1000")
                                        .foregroundColor(.white)
                                    
                                }
                            }
                            
                            HStack{
                                Image("calories")
                                    .resizable()
                                    .frame(width: 55, height:55)
                                
                                VStack(alignment: .leading, spacing: 12){
                                    Text("Calories")
                                        .fontWeight(.bold)
                                        .foregroundColor(.yellow)
                                    
                                    Text("800/1500")
                                        .foregroundColor(.white)
                                    
                                }
                            }
                        }
                        .padding(.top, 40)
                        
                        HStack(spacing:20){
                            HStack{
                                Image("cycler")
                                    .resizable()
                                    .frame(width: 55, height:55)
                                
                                VStack(alignment: .leading, spacing: 12){
                                    Text("Cycling")
                                        .fontWeight(.bold)
                                        .foregroundColor(Color("Color1"))
                                    
                                    Text("1/5 KM")
                                        .foregroundColor(.white)
                                    
                                }
                            }
                            .offset(x:-20)
                            
                            HStack{
                                Image("bpm")
                                    .resizable()
                                    .frame(width: 55, height:55)
                                
                                VStack(alignment: .leading, spacing: 12){
                                    Text("Heart")
                                        .fontWeight(.bold)
                                        .foregroundColor(.red)
                                    
                                    Text("75 bpm")
                                        .foregroundColor(.white)
                                    
                                }
                            }
                            .offset(x:5)
                        }
                        .padding(.top, 20)
                        Spacer()
                    }
                    .padding()
                }
            }
            else{
                VStack {
                    
                                    Text("Please Authorize Health!")
                                        .font(.title3)
                                    
                                    Button {
                                        vm.healthRequest()
                                    } label: {
                                        Text("Authorize HealthKit")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                    }
                                    .frame(width: 320, height: 55)
                                    .background(Color(.orange))
                                    .cornerRadius(10)
                                }
            }
        }
    }
}
struct ProgressBar :View{
    var height :CGFloat
    var to : CGFloat
    var color : Color
    
    
    var body:some View{
        ZStack{
            Circle()
                .trim(from: 0, to: 1)
                .stroke(Color.black.opacity(0.25), style: (StrokeStyle(lineWidth: 30, lineCap: .round)))
                .frame(height: height)
            
            Circle()
                .trim(from: 0, to: to)
                .stroke(color, style: (StrokeStyle(lineWidth: 30, lineCap: .round)))
                .frame(height: height)
        }
        .rotationEffect(.init(degrees: 270)
        )
    }
    
    
    struct Datas{
        var steps : NSNumber
        var calories : NSNumber
        var cycling : NSNumber
        var bpms : NSNumber
        
    }
    
    
    
    
    
}
