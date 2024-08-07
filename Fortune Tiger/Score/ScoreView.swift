import SwiftUI

struct ScoresView: View {
    
    var body: some View {
        let scores = ScoreManager.shared.topScores
        
        ZStack {
            NavigationView {
                GeometryReader { geometry in
                    ZStack {
                        Image("ScoresBackground")
                            .resizable()
                            .ignoresSafeArea()
                            .scaledToFill()
                        VStack(spacing: 100) {
                            Image("ScoresButton")
                                .resizable()
                                .frame(width: geometry.size.width / 2 , height: geometry.size.height / 6)
                            ZStack {
                                Image("ScoresView")
                                    .resizable()
                                    .frame(width: geometry.size.width / 1.8, height: geometry.size.height / 2.5)
                                    
                                
                                VStack {
                                    ForEach(scores.indices, id: \.self) { index in
                                        Text("\(scores[index].points)")
                                            .font(.custom("Chalkduster", size: 40))
                                            .foregroundColor(Color(red: 255/255, green: 191/255, blue: 128/255))
                                    }
                                }
                            }
                            NavigationLink(destination: MenuView()) {
                                Image("ExitButton")
                                    .resizable()
                                    .frame(width: geometry.size.width / 2 , height: geometry.size.height / 10)
                            }
                        }
                        .position(CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2))
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct ScoresView_Previews: PreviewProvider {
    static var previews: some View {
        ScoresView()
    }
}
