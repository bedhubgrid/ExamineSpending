//
//  ExaminerPresenter.swift
//  ExamineSpending
//
//  Copyright (c) 2018 Aleksi Sitomaniemi. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ExaminerPresentationLogic {
  func presentNode(node: ESNode, pathlen: Int, range: RangeOption?)
  func presentProgress(txnCount: Int, range: RangeOption)
  func presentError(error: ESError)
  func presentRequestActive(_ requestActive: Bool)
}

class ExaminerPresenter: ExaminerPresentationLogic {
  weak var viewController: ExaminerDisplayLogic?

  deinit {
    log.debug("")
  }

  // MARK: Do something
  func presentNode(node: ESNode, pathlen: Int, range: RangeOption?) {
    log.verbose("")
    viewController?.displayRequestActive(false)
    var blocks: [Block] = []
    for node in node.children {
      let block = Block.init(valueType: node.valueType,
                             expandable: (node.children.count > 0 || node.nodeType == .expandableAccount),
                             amount: String(node.totalValue()), title: node.title)
      blocks.append(block)
    }

    let viewModel = Examiner.TxnFetch.ViewModel(title: node.title, pathlen: pathlen, blocks: blocks)
    viewController?.displayBlocks(viewModel: viewModel)
  }

  func presentProgress(txnCount: Int, range: RangeOption) {
    log.verbose("")
    var message: String
    switch range {
    case .currentDay:
      message = "Range: Current Day"
    case .pastSevenDays:
      message = "Range: Past 7 Days"
    case .currentMonth:
      message = "Range: Current Month"
    case .pastThirtyDays:
      message = "Range: Past 30 Days"
    }

    message += "\nTransactions received: " + String(txnCount)
    let vm = Examiner.Progress.ViewModel(progressInfo: message)
    viewController?.displayProgress(viewModel: vm)
  }

  func presentError(error: ESError) {
    log.verbose("")
    viewController?.displayRequestActive(false)
    viewController?.displayError(message: error.message())
  }

  func presentRequestActive(_ requestActive: Bool) {
    log.verbose("")
    viewController?.displayRequestActive(requestActive)
  }
}