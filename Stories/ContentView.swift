//
//  ContentView.swift
//  Stories
//
//  Created by Yuan on 02/10/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    
    @State private var index: Int = 0
    @State var stories = [
        Story(id: 0, image: "p0", offset: 0,title: "Jack the Persian and the Black Castel"),
        Story(id: 1, image: "p1", offset: 0,title: "The Dreaming Moon"),
        Story(id: 2, image: "p2", offset: 0,title: "Fallen In Love"),
        Story(id: 3, image: "p3", offset: 0,title: "Hounted Ground"),
    ]
    @State var scrolled: Int = 0
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                HStack {
                    Button(action: {}, label: {
                        Image("menu")
                            .renderingMode(.template)
                            .foregroundColor(.white)
                    })
                    
                    Spacer()
                    
                    Button(action: {}, label: {
                        Image("search")
                            .renderingMode(.template)
                            .foregroundColor(.white)
                    })
                }
                .padding()
                
                HStack {
                    Text("Trending")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                    Spacer(minLength: 0)
                                        
                    Button(action: {}, label: {
                        Image("dots")
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .rotationEffect(.init(degrees: 90))
                    })
                }
                .padding(.horizontal)
                
                HStack {
                    Text("Animated")
                        .font(.system(size: 15))
                        .foregroundColor(index == 0 ? .white : Color("Color1").opacity(0.85))
                        .fontWeight(.bold)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 20)
                        .background(Color("Color").opacity(index == 0 ? 1 : 0))
                        .clipShape(Capsule())
                        .onTapGesture {
                            index = 0
                        }
                    
                    Text("25+ Series")
                        .font(.system(size: 15))
                        .foregroundColor(index == 1 ? .white : Color("Color1").opacity(0.85))
                        .fontWeight(.bold)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 20)
                        .background(Color("Color").opacity(index == 1 ? 1 : 0))
                        .clipShape(Capsule())
                        .onTapGesture {
                            index = 1
                        }
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                // Card View
                ZStack{
                    
                    // Zstack Will Overlap Views So Last WIll Become First...
                    
                    ForEach(stories.reversed()){story in
                        
                        HStack{
                            
                            ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)){
                                
                                Image(story.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    // dynamic frame....
                                    // dynamic height...
                                    .frame(width: calculateWidth(), height: (UIScreen.main.bounds.height / 1.8) - CGFloat(story.id - scrolled) * 50)
                                    .cornerRadius(15)
                                    // based on scrolled changing view size...
                                    
                                
                                VStack(alignment: .leading,spacing: 18){
                                    
                                    HStack{
                                        
                                        Text(story.title)
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                    }
                                    
                                    Button(action: {}) {
                                        
                                        Text("Read Later")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .padding(.vertical,6)
                                            .padding(.horizontal,25)
                                            .background(Color("Color1"))
                                            .clipShape(Capsule())
                                    }
                                }
                                .frame(width: calculateWidth() - 40)
                                .padding(.leading,20)
                                .padding(.bottom,20)
                            }
                            .offset(x: story.id - scrolled <= 2 ? CGFloat(story.id - scrolled) * 30 : 60)
                            
                            Spacer(minLength: 0)
                        }
                        .contentShape(Rectangle())
                        // adding gesture...
                        .offset(x: story.offset)
                        .gesture(DragGesture().onChanged({ (value) in
                            
                            withAnimation{
                                
                                // disabling drag for last card...
                                
                                if value.translation.width < 0 && story.id != stories.last!.id{
                                    
                                    stories[story.id].offset = value.translation.width
                                }
                                else{
                                    
                                    // restoring cards...
                                    
                                    if story.id > 0{
                                        
                                        stories[story.id - 1].offset = -(calculateWidth() + 60) + value.translation.width
                                    }
                                }
                                
                                
                            }
                            
                        }).onEnded({ (value) in
                            
                            withAnimation{
                            
                                if value.translation.width < 0{
                                    
                                    if -value.translation.width > 180 && story.id != stories.last!.id{
                                        
                                        // moving view away...
                                        
                                        stories[story.id].offset = -(calculateWidth() + 60)
                                        scrolled += 1
                                    }
                                    else{
                                        
                                        stories[story.id].offset = 0
                                    }
                                }
                                else{
                                    
                                    // restoring card...
                                    
                                    if story.id > 0{
                                        
                                        if value.translation.width > 180{
                                            
                                            stories[story.id - 1].offset = 0
                                            scrolled -= 1
                                        }
                                        else{
                                            
                                            stories[story.id - 1].offset = -(calculateWidth() + 60)
                                        }
                                    }
                                }
                            }
                            
                        }))
                    }
                }
                .frame(height: UIScreen.main.bounds.height / 1.8)
                .padding(.horizontal, 25)
                .padding(.top, 25)
                
                Spacer()
            }
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color("top"), Color("bottom")]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
    }
    
    private func calculateWidth() -> CGFloat {
        let screen = UIScreen.main.bounds.width - 50
        let width = screen - (2 * 50)
        return width
    }
}

// Sample Data....

struct Story : Identifiable {
    
    var id : Int
    var image : String
    var offset : CGFloat
    var title : String
}

