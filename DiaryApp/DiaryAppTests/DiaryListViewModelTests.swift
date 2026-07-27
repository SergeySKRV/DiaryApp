//
//  DiaryListViewModelTests.swift
//  DiaryAppTests
//
//  Created by Сергей Скориков on 27.07.2026.
//

import XCTest
@testable import DiaryApp

// MARK: - ViewModel Tests

final class DiaryListViewModelTests: XCTestCase {
    
    var viewModel: DiaryListViewModel!
    var mockRepository: MockDiaryRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockDiaryRepository()
        viewModel = DiaryListViewModel(repository: mockRepository)
    }
    
    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        super.tearDown()
    }
    
    private func createTestEntry(title: String, isFavorite: Bool) -> DiaryEntryModel {
        return DiaryEntryModel(
            id: UUID(),
            title: title,
            text: "Text",
            createdAt: Date(),
            updatedAt: Date(),
            isFavorite: isFavorite,
            mood: .neutral,
            dayKey: Date().dayKey()
        )
    }
    
    func testFetchAllEntries() {
        let expectation = XCTestExpectation(description: "Fetch all entries")
        
        mockRepository.mockEntries = [
            createTestEntry(title: "1", isFavorite: false),
            createTestEntry(title: "2", isFavorite: false)
        ]
        
        viewModel.onDataUpdated = {
            XCTAssertEqual(self.viewModel.entries.count, 2, "ViewModel должна загрузить 2 записи")
            expectation.fulfill()
        }
        
        viewModel.fetchEntries()
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFavoritesFilter() {
        let expectation = XCTestExpectation(description: "Filter favorites")
        
        mockRepository.mockEntries = [
            createTestEntry(title: "Не избранное", isFavorite: false),
            createTestEntry(title: "Избранное", isFavorite: true)
        ]
        
        viewModel.onDataUpdated = {
            XCTAssertEqual(self.viewModel.entries.count, 1, "Должна остаться 1 избранная запись")
            XCTAssertEqual(self.viewModel.entries.first?.title, "Избранное")
            expectation.fulfill()
        }
        
        viewModel.toggleFavoritesFilter()
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSearchQuery() {
        let expectation = XCTestExpectation(description: "Search query")
        
        mockRepository.mockEntries = [
            createTestEntry(title: "Поход в лес", isFavorite: false),
            createTestEntry(title: "Работа", isFavorite: false)
        ]
        
        viewModel.onDataUpdated = {
            XCTAssertEqual(self.viewModel.entries.count, 1, "Поиск должен найти 1 запись")
            XCTAssertEqual(self.viewModel.entries.first?.title, "Поход в лес")
            XCTAssertTrue(self.viewModel.isSearching, "Флаг isSearching должен быть true")
            expectation.fulfill()
        }
        
        viewModel.search("лес")
        wait(for: [expectation], timeout: 1.0)
    }
}
