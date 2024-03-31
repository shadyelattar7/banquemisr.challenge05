//
//  PopularViewModel.swift
//  MovieTask
//
//  Created by Al-attar on 31/03/2024.
//

import Foundation

//MARK: - ViewController -> ViewModel
protocol PopularVInputs{
    func viewDidLoad()
}


//MARK: - ViewController <- ViewModel
protocol PopularVOutputs{
    func numberOfMovies() -> Int
}

class PopularViewModel: BaseViewModel, PopularVInputs, PopularVOutputs {
    
    //MARK: - Puplic Properties
    let movies: Box<[MovieData]> = Box([])
    
    //MARK: - Private Properties
    private let moviesRepo: PopularWorkerProtocol
    
    //MARK: - Init
    init(movies: PopularWorkerProtocol) {
        self.moviesRepo = movies
    }
    
    //MARK: - Inputs
    func viewDidLoad() {
        getPopular()
    }
    
    // MARK: - Outputs
    func numberOfMovies() -> Int {
        return movies.value.count
    }
    
    func getMovieDataModel(_ row: Int) -> MovieData {
        return movies.value[row]
    }
    
    // MARK: - API Calls
    private func getPopular() {
        moviesRepo.popular { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movies):
                print("Received movies:", movies)
                self.movies.value = movies.results
            case .failure(let error):
                print("Error fetching movies:", error)
            }
        }
    }
    
    // MARK: - configration Cell
    func configrationCell( _ cell : MovieCell , index : Int){
        let modelOfCell = movies.value[index]
        let poster = "https://image.tmdb.org/t/p/w342/\(modelOfCell.poster_path ?? "")"
        let roundedVoteAverage = (modelOfCell.vote_average * 10).rounded() / 10
        let year = modelOfCell.release_date.extractYear()
        
        let movieCellAdapter = MovieCellAdapter(
            id: modelOfCell.id,
            title: modelOfCell.title,
            posterPath: poster,
            voteAverage: roundedVoteAverage,
            releaseDate: year ?? ""
        )
        cell.configuration(viewModel: movieCellAdapter)
    }
}
