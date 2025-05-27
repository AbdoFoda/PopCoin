//
//  BitcoinPriceListView.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 23.05.25.
//


import SwiftUI

struct BitcoinPriceListView<ViewModel: BitcoinPriceListViewModelProtocol>: View {
    @StateObject private var viewModel: ViewModel
    
    init(viewModel: @autoclosure @escaping () -> ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                header
                
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                    Button("Retry") {
                        Task {
                            await viewModel.fetchData()
                        }
                    }
                }
                mainContent
                
            }
            .padding(.horizontal)
            .task {
                await viewModel.fetchData()
            }
        }
    }
    
    private var header: some View {
        Text("Bitcoin Prices (EUR)")
            .font(.largeTitle)
            .bold()
            .padding(.top)
    }
    
    private var mainContent: some View {
        List {
            Section {
                TodayPrice(viewModel: viewModel)
            }
            historicalData
        }
        .listStyle(.plain)
        .refreshable {
            await viewModel.fetchData()
        }
    }
    
    private var historicalData: some View {
        ForEach(viewModel.priceHistory) { price in
            NavigationLink {
                ViewFactory.shared.makePriceDetailsView(for: price.date)
            } label: {
                HStack {
                    Text(price.formattedRelativeDate)
                    Spacer()
                    Text(price.formattedPrice)
                        .foregroundColor(.primary)
                }
            }
        }
    }
}
