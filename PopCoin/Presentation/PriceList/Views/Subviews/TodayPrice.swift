//
//  TodayPrice.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 26.05.25.
//

import SwiftUI

struct TodayPrice<ViewModel: BitcoinPriceListViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let price = viewModel.todayPrice {
                Text("Today: " + price.formattedPrice)
                    .font(.title)
                    .bold()
                Text("Updated \(price.formattedTime)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }else {
                Text("Today price is being loaded...")
            }
           
            Button {
                Task { @MainActor in
                    await viewModel.refresh()
                }
            } label: {
                if viewModel.isLoadingTodayPrice {
                    ProgressView()
                }else {
                    Image(systemName: "arrow.clockwise")
                }
            }
            .buttonStyle(.plain)
            .contentShape(.rect)

        }
        .padding(.vertical, 8)
    }

}
