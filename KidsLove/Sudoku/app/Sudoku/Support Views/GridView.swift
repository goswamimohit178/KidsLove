//
//  GridView.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 27/10/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import SwiftUI

struct GridView: View {
	
	@EnvironmentObject var grid: Grid
	@EnvironmentObject var settings: Settings
	@EnvironmentObject var viewRouter: ViewRouter
	@EnvironmentObject var pauseHolder: PauseHolder
	
    private let frameSize: CGFloat = min(Screen.cellWidth, UIScreen.main.bounds.height * 0.60) * 9
	
	@ViewBuilder
	var body: some View {
		ZStack {
			self.renderStructure(width: frameSize / 9)
			self.renderOverlayLines(width: frameSize / 9)
		}
		.disabled(self.isPaused() || grid.full())
		.opacity(self.isPaused() || grid.full() ? 0 : 1)
		.frame(width: frameSize,
			   height: frameSize,
			   alignment: .center)
	}
	
	private func renderStructure(width: CGFloat) -> some View {
		VStack(spacing: -1) {
			ForEach(0 ..< 9) { row in
				HStack(spacing: -1) {
					ForEach(0 ..< 9) { col in
						self.grid.render(
							row: row,
							col: col,
							fontSize: self.fontSize()
						)
							.frame(
								width: width,
								height: width
						)
							.border(Color.black, width: 1)
							.padding(.all, 0)
							.background(
								self.grid.colorAt(
									row: row,
									col: col
								)
						)
							.onTapGesture {
								self.grid.objectWillChange.send()
								self.grid.setActive(
									row: row,
									col: col,
									areas: self.settings.highlightAreas,
									similar: self.settings.highlightSimilar
								)
						}
					}
				}
			}
		}
	}
	
	private func renderOverlayLines(width: CGFloat) -> some View {
		GeometryReader { geometry in
			Path { path in
				let factor: CGFloat = width * 3
				let lines: [CGFloat] = [1, 2]
				
				for i: CGFloat in lines {
					let vpos: CGFloat = i * factor
					path.move(to: CGPoint(x: vpos, y: 4))
					path.addLine(to: CGPoint(x: vpos, y: geometry.size.height - 4))
				}
				
				for i: CGFloat in lines {
					let hpos: CGFloat = i * factor
					path.move(to: CGPoint(x: 4, y: hpos))
					path.addLine(to: CGPoint(x: geometry.size.width - 4, y: hpos))
				}
			}
			.stroke(lineWidth: Screen.lineThickness)
			.foregroundColor(.black)
		}
	}
	
	func fontSize() -> CGFloat {
		let size: Float = self.settings.fontSize
		return CGFloat(size as Float)
	}
	
	func isPaused() -> Bool {
		return self.pauseHolder.isPaused()
	}
}
