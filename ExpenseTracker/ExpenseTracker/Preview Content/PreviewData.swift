//
//  PreviewData.swift
//  ExpenseTracker
//
//  Created by Vinay Kumar Thapa on 2023-05-29.
//

import Foundation
import SwiftUI

var transactionPreviewData = Transaction(id: 1, date: "29/05/2023", institution: "CIBC", account: "Checking", merchant: "Apple", amount: 11.49, type: "debit", categoryId: 801, category: "Software", isPending: false, isTransfer: false, isExpense: true, isEdited: false)

var transactionListPreviewData = [Transaction](repeating: transactionPreviewData, count: 5)
