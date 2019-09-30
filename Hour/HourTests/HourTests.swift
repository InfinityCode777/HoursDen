//
//  HourTests.swift
//  HourTests
//
//  Created by Jing Wang on 8/21/19.
//  Copyright © 2019 Jackalope. All rights reserved.
//

import XCTest
@testable import Hour

class HourTests: XCTestCase {

    let elapsedTimeList: [TimeInterval] = [123, 1861, 23, 453, 4672, 83484]
//    let expectedTimeForDisplayList: [String] = ["00:02:03", "00:31:01", "00:00:23", "00:07:33", "01:17:52", "23:11:24"]
    let expectedTimeForDisplayList: [String] = ["02:03", "31:01", "00:23", "07:33", "01:17", "23:11"]

    let expectedAllFalseArray = [false, false, false, false]
    let expectedAllTrueArray = [true, true, true, true]
    
    var originSize = CGSize(width: 1280, height: 1024)

    override func setUp() {

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUtilities() {
//        for idx in 0..<elapsedTimeList.count {
//            XCTAssertEqual(convertSecsToTime(elapsedTimeList[idx]), expectedTimeForDisplayList[idx], "Does not match expected format!")
//        }
        
        for idx in 0..<elapsedTimeList.count {
            XCTAssertEqual(elapsedTimeList[idx].toDisplayTime(), expectedTimeForDisplayList[idx], "Does not match expected format!")
        }
        
        let allTrueArray = getArray(of: true, count: expectedAllTrueArray.count)
        XCTAssertEqual(allTrueArray, expectedAllTrueArray, "Error!")
        
        let allFalseArray = getArray(of: false, count: expectedAllFalseArray.count)
        XCTAssertEqual(allFalseArray, expectedAllFalseArray, "Error!")
        
            
        var newSize = CGSize()
        let dx: CGFloat = 10
        let dy: CGFloat = 35
        newSize = originSize.changeBy(dx: dx, dy: dy)
        XCTAssertEqual(CGSize(width: originSize.width + dx, height: originSize.height + dy), newSize, "Size does not adjust properly!")

        let sx: CGFloat = 0.2
        let sy: CGFloat = 0.3

        newSize = originSize.scaleBy(sx: sx, sy: sy)
        XCTAssertEqual(originSize.width*sx, newSize.width, accuracy: 0.001)
        XCTAssertEqual(originSize.height*sy, newSize.height, accuracy: 0.001)
        

    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
//    func convertSecsToTime(_ elapsedTime: TimeInterval) -> String {
//        let hour = Int(elapsedTime)/3600
//        let minute = (Int(elapsedTime) % 3600)/60
//        let second = (Int(elapsedTime) % 3600) % 60
//        return String(format: "%02i:%02i:%02i", hour, minute, second)
//    }
//
//
    func getArray<T>(of value: T, count: Int) -> [T] {
        var array = [T]()
        array = Array(repeating: value, count: count)
        return array
    }
    
}


