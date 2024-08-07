import SwiftUI

struct MenuView: View {
    
    @State private var isMusicOn: Bool = UserDefaults.standard.bool(forKey: "isMusicOn")
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("MenuBackground")
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
                
                VStack {
                    NavigationLink(destination: GameView()) {
                        Image("PlayButton")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200)
                    }
                    
                    NavigationLink(destination: ScoresView()) {
                        Image("ScoresButton")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 180)
                    }
                    
                    HStack {
                        Button(action: {
                            if !isMusicOn {
                                isMusicOn = true
                                UserDefaults.standard.set(isMusicOn, forKey: "isMusicOn")
                                SoundManager.shared.playSound()
                                print("Music On: \(isMusicOn)")
                            }
                        }) {
                            Image(isMusicOn ? "MusicOnDark" : "MusicOnLight")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70, height: 70)
                        }
                        
                        Button(action: {
                            if isMusicOn {
                                isMusicOn = false
                                UserDefaults.standard.set(isMusicOn, forKey: "isMusicOn")
                                SoundManager.shared.stopSound()
                                print("Music Off: \(isMusicOn)")
                            }
                        }) {
                            Image(isMusicOn ? "MusicOffLight" : "MusicOffDark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70, height: 70)
                        }
                    }
                }
                
                GeometryReader { geometry in
                    NavigationLink(destination: ShopView()) {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 100, height: 50)
                    }
                    .position(CGPoint(x: geometry.size.width * 0.83, y: geometry.size.height * 0.685))
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            isMusicOn = UserDefaults.standard.bool(forKey: "isMusicOn")
        }
    }
}

#Preview {
    MenuView()
}
