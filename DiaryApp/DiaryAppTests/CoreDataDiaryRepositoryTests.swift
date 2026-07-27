//
//  CoreDataDiaryRepositoryTests.swift
//  DiaryAppTests
//
//  Created by Сергей Скориков on 27.07.2026.
//

import XCTest
import CoreData
@testable import DiaryApp

final class CoreDataDiaryRepositoryTests: XCTestCase {
    
    var coreDataStack: CoreDataStack!
    var repository: CoreDataDiaryRepository!
    
    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataStack(inMemory: true)
        repository = CoreDataDiaryRepository(coreDataStack: coreDataStack)
    }
    
    override func tearDown() {
        coreDataStack = nil
        repository = nil
        super.tearDown()
    }
    
    func testCreateAndFetchAllEntries() {
        let expectation = XCTestExpectation(description: "Fetch entries after creation")
        
        repository.create(title: "Тест 1", text: "Текст 1", mood: .happy) { [weak self] result in
            XCTAssertTrue(result.isSuccess, "Создание записи должно быть успешным")
            
            self?.repository.fetchAll { fetchResult in
                switch fetchResult {
                case .success(let entries):
                    XCTAssertEqual(entries.count, 1, "Должна быть одна запись в БД")
                    XCTAssertEqual(entries.first?.title, "Тест 1")
                    XCTAssertEqual(entries.first?.mood, .happy)
                case .failure(let error):
                    XCTFail("Ошибка при получении записей: \(error)")
                }
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testSearchEntryByTitle() {
        let expectation = XCTestExpectation(description: "Search entry")
        
        repository.create(title: "Уникальный заголовок", text: "Обычный текст", mood: nil) { [weak self] result in
            XCTAssertTrue(result.isSuccess)
            
            self?.repository.search(query: "Уникальный") { searchResult in
                switch searchResult {
                case .success(let entries):
                    XCTAssertEqual(entries.count, 1, "Поиск должен найти 1 запись")
                    XCTAssertEqual(entries.first?.title, "Уникальный заголовок")
                case .failure(let error):
                    XCTFail("Ошибка поиска: \(error)")
                }
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testToggleFavoriteStatus() {
        let expectation = XCTestExpectation(description: "Toggle favorite")
        
        repository.create(title: "Избранная", text: "Текст", mood: nil) { [weak self] result in
            XCTAssertTrue(result.isSuccess)
            
            self?.repository.fetchAll { fetchResult in
                guard let entryId = try? fetchResult.get().first?.id else {
                    XCTFail("Не удалось получить ID записи")
                    return expectation.fulfill()
                }
                
                self?.repository.toggleFavorite(id: entryId) { toggleResult in
                    XCTAssertTrue(toggleResult.isSuccess)
                    
                    self?.repository.fetchAll { finalFetchResult in
                        let entry = try? finalFetchResult.get().first
                        XCTAssertTrue(entry?.isFavorite == true, "Запись должна стать избранной")
                        expectation.fulfill()
                    }
                }
            }
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
}
