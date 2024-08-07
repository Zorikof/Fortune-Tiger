import SwiftUI

struct ShopView: View {
    @State private var currentIndex: Int = 0
    @State private var selectedImage: Int = UserDefaults.standard.integer(forKey: "SelectedCatImageIndex")
    @State private var money: Int = UserDefaults.standard.integer(forKey: "Money")
    @State private var purchasedCats: [Bool] = UserDefaults.standard.array(forKey: "PurchasedCats") as? [Bool] ?? [true, false, false, false]
    
    private let catImages = ["CatV1", "CatV2", "CatV3", "CatV4"]
    private let catCost = 500
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("ShopBackground")
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
                VStack {
                    VStack {
                        Image("ShopLabel")
                            .resizable()
                            .frame(width: geometry.size.width / 2 , height: geometry.size.height / 6)
                        ZStack {
                            Rectangle()
                                .frame(width: geometry.size.width, height: geometry.size.height / 15)
                                .opacity(0.5)
                            HStack {
                                Image("Money")
                                Text("\(money)")
                                    .font(.system(size: 30))
                                    .foregroundColor(Color(red: 255/255, green: 191/255, blue: 128/255))
                            }
                        }
                    }
                    
                    HStack {
                        Button(action: {
                            if currentIndex > 0 {
                                currentIndex -= 1
                            }
                        }) {
                            Image("Left")
                                .resizable()
                                .frame(width: geometry.size.width / 5, height: geometry.size.width / 5)
                        }
                        
                        ZStack {
                            Image("ShopItemBack")
                                .resizable()
                                .frame(width: geometry.size.width / 1.8, height: geometry.size.height / 2.5)
                            
                            Image(catImages[currentIndex])
                                .resizable()
                                .frame(width: geometry.size.width / 2, height: geometry.size.height / 3)
                                .opacity(purchasedCats[currentIndex] ? 1.0 : 0.5)
                            
                            if !purchasedCats[currentIndex] {
                                Image("Lock")
                                    .resizable()
                                    .frame(width: geometry.size.width / 2, height: geometry.size.height / 6)
                                    .onTapGesture {
                                        if money >= catCost {
                                            money -= catCost
                                            purchasedCats[currentIndex] = true
                                            UserDefaults.standard.set(money, forKey: "Money")
                                            UserDefaults.standard.set(purchasedCats, forKey: "PurchasedCats")
                                        }
                                    }
                            }
                            
                            VStack {
                                Spacer()
                                if currentIndex == selectedImage && purchasedCats[currentIndex] {
                                    Image("Selected")
                                        .resizable()
                                        .frame(width: geometry.size.width / 2.5 , height: geometry.size.height / 5)
                                        .padding(.top)
                                        
                                } else if purchasedCats[currentIndex] {
                                    Button(action: {
                                        selectedImage = currentIndex
                                        UserDefaults.standard.set(selectedImage, forKey: "SelectedCatImageIndex")
                                    }) {
                                        Image("Select")
                                            .resizable()
                                            .frame(width: geometry.size.width / 2.5 , height: geometry.size.height / 5)
                                            .padding(.top)
                                    }
                                }
                            }
                        }
                        .padding(.bottom, 50)
                        
                        Button(action: {
                            if currentIndex < catImages.count - 1 {
                                currentIndex += 1
                            }
                        }) {
                            Image("Right")
                                .resizable()
                                .frame(width: geometry.size.width / 5, height: geometry.size.width / 5)
                        }
                    }
                    
                    NavigationLink(destination: MenuView()) {
                        Image("ExitButton")
                            .resizable()
                            .frame(width: geometry.size.width / 2 , height: geometry.size.height / 10)
                            .padding(.bottom, 20)
                    }
                }
            }
            .position(CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2))
        }
        .onAppear {
            currentIndex = selectedImage
            money = UserDefaults.standard.integer(forKey: "Money")
            if let savedPurchasedCats = UserDefaults.standard.array(forKey: "PurchasedCats") as? [Bool] {
                purchasedCats = savedPurchasedCats
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ShopView()
}
