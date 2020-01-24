//
//  MoviesListViewModel.swift
//  YTS
//
//  Created by ahmed elmemy on 1/23/20.
//  Copyright © 2020 ElMeMy. All rights reserved.
//

import Foundation

class MoviesListViewModel {
    let apiService :APIServiceProtocol
    
    private var  movie: [Movie] = [Movie]()
    
    private var CellViewModel : [MovieListCellViewModel] = [MovieListCellViewModel]()
    {
        didSet{
            self.reloadTableViewClosure?()
        }
    }
    
    var state : State = .empty
    {
        didSet
        {
            self.updateLoadingStatus?()
        }
    }
    
    var numbeOfCells : Int
    {
        return CellViewModel.count
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var selectedMovie: Movie?
    
    
    var reloadTableViewClosure: (()->())?
    var updateLoadingStatus: (()->())?
    var showAlertClosure: (()->())?
    
    
    init( apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    
    
    func initFetch() {
        state = .loading
        apiService.fetchPopularMovies { [weak self] (success, movies, error) in
            guard let self = self else {
                return
            }
            
            guard error == nil else {
                self.state = .error
                self.alertMessage = error?.rawValue
                return
            }
            
            self.processFetchedMovies(movies: movies)
            self.state = .populated
        }
        
        
    }
    
    
    func createCellViewModel(movies : Movie)->MovieListCellViewModel
    {
        return MovieListCellViewModel(name: movies.title, image: movies.largeCoverImage, date: "\(movies.year)")
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> MovieListCellViewModel {
        return CellViewModel[indexPath.row]
    }
    
    private func processFetchedMovies( movies: [Movie] ) {
        self.movie = movies // Cache
        var vms = [MovieListCellViewModel]()
        for movie in movies {
            vms.append( createCellViewModel(movies: movie) )
        }
        self.CellViewModel = vms
    }
    
    
    
    
    
}
extension MoviesListViewModel
{
    func userPressed(at indexPath:IndexPath)  {
        let movie = self.movie[indexPath.row]
        selectedMovie = movie
        
    }
}
