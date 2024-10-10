import UIKit

class MovieViewController: UIViewController {
    
    private var movies: [Movie] = []
    private var screen: MovieScreen?
    
    override func loadView() {
        screen = MovieScreen()
        view = screen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMovies()
        screen?.configProtocols(delegate: self, dataSource: self)
    }
    
    private func loadMovies() {
        guard let path = Bundle.main.path(forResource: "movies", ofType: "json") else {
            return
        }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let movieResponse = try decoder.decode(MovieResponse.self, from: data)
            self.movies = Array(movieResponse.results.prefix(10))
            DispatchQueue.main.async {
                self.screen?.collectionView.reloadData()
            }
        } catch {
            print("Failed to load movies: \(error)")
        }
    }
}

extension MovieViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: movies[indexPath.row])
        
        return cell
    }
}
