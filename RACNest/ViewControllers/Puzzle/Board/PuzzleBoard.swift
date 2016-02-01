//
//  PuzzleBoard.swift
//  RACNest
//
//  Created by Rui Peres on 31/01/2016.
//  Copyright © 2016 Rui Peres. All rights reserved.
//

import UIKit
import ReactiveCocoa

struct PuzzleBoardDimension {
    let numberOfRows: Int
    let numberOfColumns: Int
}

final class PuzzleBoard: UIView {
    
    private let boardDimension: PuzzleBoardDimension
    private let puzzlePieceSize: CGSize
    
    var puzzleBoardLinesColor = UIColor.grayColor()
    var puzzleBoardBackgroudColor = UIColor.whiteColor()
    
    weak var dataSource: PuzzleBoardDataSource? {
        didSet {
            
            subviews.forEach { $0.removeFromSuperview() }
            
            dataSource?.piecesViewModels
                .map { (position,viewModel) in (position, viewModel, self.puzzlePieceSize) }
                .observeOn(QueueScheduler.mainQueueScheduler)
                .startWithNext(addPiece)
        }
    }
    
    init(boardDimension: PuzzleBoardDimension, puzzlePieceSize: CGSize = CGSize(width: 100, height: 100)) {
        
        self.boardDimension = boardDimension
        self.puzzlePieceSize = puzzlePieceSize
        
        let width = Int(puzzlePieceSize.width) * boardDimension.numberOfRows
        let height = Int(puzzlePieceSize.height) * boardDimension.numberOfColumns
        
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        backgroundColor = puzzleBoardBackgroudColor
        
        self.defineBorder()
        self.defineSquares(boardDimension)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Board Construction
    
    private func addPiece(position: PuzzlePiecePosition, viewModel: PuzzlePieceViewModel, size: CGSize) {
        
        let piece = PuzzlePiece(size: puzzlePieceSize, viewModel: viewModel)
        self.addSubview(piece)
        let x = position.row * Int(puzzlePieceSize.width)
        let y = position.column * Int(puzzlePieceSize.height)
        piece.frame = CGRect(origin: CGPoint(x: x, y: y), size: puzzlePieceSize)
    }
    
    private func defineBorder() {
        
        layer.borderColor = puzzleBoardLinesColor.CGColor
        layer.borderWidth = 1.0
    }
    
    private func defineSquares(dimension: PuzzleBoardDimension) {
        
        for i in 0..<dimension.numberOfColumns {
            
            let column = CALayer()
            let columnHeight = dimension.numberOfRows * Int(puzzlePieceSize.height)
            column.frame = CGRect(origin: CGPoint(x: i * Int(puzzlePieceSize.width), y: 0), size: CGSize(width: 1, height: columnHeight))
            
            column.backgroundColor = puzzleBoardLinesColor.CGColor
            layer.addSublayer(column)
        }
        
        for i in 0..<dimension.numberOfRows {
            
            let row = CALayer()
            let rownWidth = dimension.numberOfColumns * Int(puzzlePieceSize.width)
            row.frame = CGRect(origin: CGPoint(x: 0, y:  i * Int(puzzlePieceSize.width)), size: CGSize(width: rownWidth, height: 1))
            
            row.backgroundColor = puzzleBoardLinesColor.CGColor
            layer.addSublayer(row)
        }
    }
}

