//
//  PriceDetailsView.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 27.05.25.
//

import SwiftUI

struct PriceDetailsView<ViewModel: PriceDetailsViewModelProtocol>: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        VStack(alignment: .leading) {
            List {
                Section {
                    Text(viewModel.dateToShow)
                }
                if viewModel.isLoading {
                    ProgressView()
                }else if let error = viewModel.errorMessage {
                    Text("Error : \(error)")
                }else {
                    ForEach(viewModel.prices) { coinPrice in
                        Section {
                            HStack {
                                Text(coinPrice.currency.presentationValue)
                                Spacer()
                                Text(coinPrice.formattedPrice)
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
        }
        .task {
            await viewModel.fetch()
        }
    }
}
