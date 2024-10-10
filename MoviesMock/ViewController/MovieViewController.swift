import UIKit

class MovieViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var collectionView: UICollectionView?
    private var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.size.width / 2 - 10, height: view.frame.size.width / 1.5)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.backgroundColor = .white
        
        guard let collectionView = collectionView else {
            return
        }
        
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        
        loadMovies()
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
                self.collectionView?.reloadData()
            }
        } catch {
            print("Failed to load movies: \(error)")
        }
    }
    
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
