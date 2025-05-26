//
//  TodayPrice.swift
//  PopCoin
//
//  Created by Abdulrahman Foda on 26.05.25.
//

import SwiftUI

struct TodayPrice<ViewModel: BitcoinPriceListViewModelProtocol>: View {
    var viewModel: ViewModel

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
                Text("Today price is not available")
            }
           
            Button {
                Task {
                    await viewModel.refresh()
                }
            } label: {
                Image(systemName: "arrow.clockwise")
            }

        }
        .padding(.vertical, 8)
    }

}
