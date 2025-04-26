//
//  Median.swift
//  MovieQuiz
//
//  Created by Анжелика Забазнова on 26.04.2025.
//

import Foundation

func calcMedian(movies: [MostPopularMovie]) -> Float {
    let sorted = movies.sorted(by: {a, b in
        return Float(a.rating) ?? 0 > Float(b.rating) ?? 0
    })
    let middleIndex = sorted.count / 2
    return Float(sorted[middleIndex].rating) ?? 0
}
