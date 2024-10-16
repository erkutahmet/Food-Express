//
//  HomeViewModel.swift
//  Food-Express
//
//  Created by erkut on 7.10.2024.
//

import Foundation

protocol MainViewModelInterface {
    var view: MainViewInterface? { get set }

    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
    func getData()
    func mapCellData()
    func numberOfItems() -> Int
    func retriveFood(with id: String) -> Yemekler?
    func searchHandler(contains searchText: String)
}

final class MainViewModel {
    weak var view: MainViewInterface?
    var dataSource: MainPageModel?
    var cellDataSource: Observable<[FoodViewModel]> = Observable(nil)
}

extension MainViewModel: MainViewModelInterface {
    func viewDidAppear() {
    }
    
    func viewDidLoad() {
        view?.setUIForSearch()
        view?.setDelegateUI()
        view?.setupTapGesture()
        getData()
        view?.bindViewModel()
    }

    func numberOfItems() -> Int {
        return cellDataSource.value?.count ?? 0
    }

    func viewWillAppear() {
        view?.setDarkModeUI()
    }

    func getData() {
        APICaller.getAllFoods { result in
            switch result {
            case .success(let data):
                self.dataSource = data
                self.mapCellData()
            case .failure(let error):
                print("This is error -> \(error.localizedDescription)")
            }
        }
    }
    func mapCellData() {
        self.cellDataSource.value = self.dataSource?.yemekler.compactMap({FoodViewModel(food: $0)})
    }

    func retriveFood(with id: String) -> Yemekler? {
        guard let food = dataSource?.yemekler.first(where: {$0.yemekID == id}) else { return nil }
        return food
    }
    
    func searchHandler(contains searchText: String) {
        guard !searchText.isEmpty else {
            mapCellData()
            return
        }
        
        let filteredData = dataSource?.yemekler.filter { food in
              return food.yemekAdi?.lowercased().contains(searchText.lowercased()) ?? false
          }

        self.cellDataSource.value = filteredData?.compactMap({ FoodViewModel(food: $0) })
    }
}