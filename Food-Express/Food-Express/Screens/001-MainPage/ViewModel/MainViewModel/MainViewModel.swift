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
    func retriveFood(with id: String) -> Foods?
    func searchHandler(contains searchText: String)
}

final class MainViewModel {
    weak var view: MainViewInterface?
    var dataSource: MainPageModel?
    var cellDataSource: Observable<[FoodViewModel]> = Observable(nil)

    private var allFoods: [FoodViewModel] = []
}

extension MainViewModel: MainViewModelInterface {
    func viewDidAppear() {
    }
    
    func viewDidLoad() {
        view?.setUI()
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
        APICaller.getAllFoods { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                self.dataSource = data
                self.mapCellData()
            case .failure:
                print("Error from -> (getData)")
            }
        }
    }
    func mapCellData() {
        self.allFoods = self.dataSource?.yemekler?.compactMap( {FoodViewModel(food: $0)} ) ?? []
        self.cellDataSource.value = self.allFoods
    }

    func retriveFood(with id: String) -> Foods? {
        guard let food = dataSource?.yemekler?.first(where: {$0.yemek_id == id}) else { return nil }
        return food
    }
    
    func searchHandler(contains searchText: String) {
        guard !searchText.isEmpty else {
            self.cellDataSource.value = allFoods
            return
        }
        
        let filteredData = allFoods.filter { food in
            return food.yemekAdi.lowercased().contains(searchText.lowercased())
        }

        self.cellDataSource.value = filteredData
    }
}
