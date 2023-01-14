//
//  ContentView.swift
//  CryptoAsyncAwait
//
//  Created by Stephan Dowless on 1/5/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    @State private var showAtlert = false
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.coins) { coin in
                    CoinRowView(coin: coin)
                        .onAppear {
                            if coin.id == viewModel.coins.last?.id {
                                //print("DEBUG: Paginate here...")
                                viewModel.loadData()
                            }
                        }
                }
            }
            .refreshable {
                viewModel.handleRefresh()
            }
            .onReceive(viewModel.$error, perform: { error in
                if error != nil {
                    showAtlert.toggle()
                }
            })
            .alert(isPresented: $showAtlert, content: {
                Alert(title: Text("Error"),
                      message: Text(viewModel.error?.localizedDescription ?? ""))
            })
            .navigationTitle("Live Prices")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
