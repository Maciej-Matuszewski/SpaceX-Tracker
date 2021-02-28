//
//  SpaceX_TrackerTests.swift
//  SpaceX TrackerTests
//
//  Created by Maciej Matuszewski on 27/02/2021.
//

import XCTest
@testable import SpaceX_Tracker

class InfoLabelViewModelBuilderTests: XCTestCase {
    func test_build_mission() {
        // Given configuration
        let configuration: InfoLabelConfiguration = .mission(name: "Mission name")

        // When builder will prepare viewModel
        let viewModel = InfoLabelViewModelBuilder.build(with: configuration)

        // Then
        XCTAssertEqual(viewModel.title, "Mission:")
        XCTAssertEqual(viewModel.value, "Mission name")
    }

    func test_build_date() throws {
        // Given configuration

        let components = DateComponents(
            calendar: .current,
            timeZone: .current,
            year: 1952,
            month: 03,
            day: 23,
            hour: 10,
            minute: 15
        )
        let configuration: InfoLabelConfiguration = .date(date: try XCTUnwrap(components.date))

        // When builder will prepare viewModel
        let viewModel = InfoLabelViewModelBuilder.build(with: configuration)

        // Then
        XCTAssertEqual(viewModel.title, "Date/Time:")
        XCTAssertEqual(viewModel.value, "23 Mar 1952 at 10:15")
    }

    func test_build_rocket() {
        // Given configuration
        let configuration: InfoLabelConfiguration = .rocket(name: "Rocket Name", type: "Rocket Type")

        // When builder will prepare viewModel
        let viewModel = InfoLabelViewModelBuilder.build(with: configuration)

        // Then
        XCTAssertEqual(viewModel.title, "Rocket:")
        XCTAssertEqual(viewModel.value, "Rocket Name/Rocket Type")
    }

    func test_build_sinceNow() {
        // Given configuration
        let date = Date.init(timeIntervalSinceNow: -864000)

        let configuration: InfoLabelConfiguration = .daysSinceNow(date: date)

        // When builder will prepare viewModel
        let viewModel = InfoLabelViewModelBuilder.build(with: configuration)

        // Then
        XCTAssertEqual(viewModel.title, "Days since now:")
        XCTAssertEqual(viewModel.value, "10 Days")
    }

    func test_build_fromNow() {
        // Given configuration
        let date = Date.init(timeIntervalSinceNow: 864000)

        let configuration: InfoLabelConfiguration = .daysSinceNow(date: date)

        // When builder will prepare viewModel
        let viewModel = InfoLabelViewModelBuilder.build(with: configuration)

        // Then
        XCTAssertEqual(viewModel.title, "Days from now:")
        XCTAssertEqual(viewModel.value, "10 Days")
    }
}
