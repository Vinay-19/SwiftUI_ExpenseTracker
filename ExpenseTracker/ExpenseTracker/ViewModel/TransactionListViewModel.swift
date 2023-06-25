//
//  TransactionListViewModel.swift
//  ExpenseTracker
//
//  Created by Vinay Kumar Thapa on 2023-05-29.
//

import Combine
import Foundation
import Collections

typealias TransactionGroup = OrderedDictionary<String, [Transaction]>
typealias  TransactionPrefixSum = [(String, Double)] // String represents date, double represents amount

final class TransactionListViewModel: ObservableObject {
    
    @Published var transactions: [Transaction] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        getTransactions()
    }
    
    func getTransactions() {
        
        guard let url = URL(string: "https://designcode.io/data/transactions.json") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url).tryMap { (data, response) -> Data in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                dump(response)
                throw URLError(.badServerResponse)
            }
            
            return data
        }
        .decode(type: [Transaction].self, decoder: JSONDecoder())
        .receive(on: DispatchQueue.main)
        .sink { completion in
            switch completion {
            case .failure(let error):
                print("Error fetching transactions", error.localizedDescription)
            case .finished:
                print("Finished fetching transactions")
            }
        } receiveValue: { [weak self] result in
            self?.transactions = result
            dump(self?.transactions)
        }
        .store(in: &cancellables)

        
        
    }
    
    
    func groupTransactionByMonth() -> TransactionGroup {
        
        guard !transactions.isEmpty else {return [:]}
        
       let groupedTransactions = TransactionGroup.init(grouping: transactions) { $0.month }
        
        return groupedTransactions
    }
    
    
    func accumulateTransactions() -> TransactionPrefixSum {
        
        print ("accumulateTransactions")
        
        guard !transactions.isEmpty else { return [] }
        
        let today = "02/17/2022".dateParsed() //Date()
        
//        let currentDate = Date()
//        let today = currentDate.description.dateParsed()
        
        let dateInterval = Calendar.current.dateInterval (of: .month, for: today)!
        print ("dateInterval", dateInterval)
        
        var sum: Double = .zero
        var cumulativeSum = TransactionPrefixSum()
        
        for date in stride(from: dateInterval.start, to: today, by: 60 * 60 * 24) {
            let dailyExpenses = transactions.filter { $0.dateParsed == date && $0.isExpense }
            let dailyTotal = dailyExpenses.reduce (0) { $0 - $1.signedAmount }
            
            sum += dailyTotal
            cumulativeSum.append((date.formatted(), sum))
            print(date.formatted(),"dailyTotall: ", dailyTotal, "sum: ", sum)
        }
        return cumulativeSum
    }
}
