import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    static let identifier = "MovieCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let backdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
        contentView.addSubview(backdropImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(releaseDateLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = CGRect(x: 5, y: 5, width: contentView.frame.size.width - 10, height: contentView.frame.size.height / 2)
        backdropImageView.frame = CGRect(x: 5, y: posterImageView.frame.maxY + 5, width: contentView.frame.size.width - 10, height: contentView.frame.size.height / 4)
        titleLabel.frame = CGRect(x: 5, y: backdropImageView.frame.maxY + 5, width: contentView.frame.size.width - 10, height: 20)
        releaseDateLabel.frame = CGRect(x: 5, y: titleLabel.frame.maxY + 5, width: contentView.frame.size.width - 10, height: 20)
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        releaseDateLabel.text = movie.releaseDate
        
        if let posterPath = movie.posterPath {
            loadView(from: posterPath, imageView: posterImageView)
        }
        
        if let backdropPath = movie.backdropPath {
            loadView(from: backdropPath, imageView: backdropImageView)
        }
        
    }
    
    func loadView(from path: String, imageView: UIImageView) {
        let baseURL = "https://image.tmdb.org/t/p/w500"
        let imageURL = URL(string: baseURL + path)
        
        guard let url = imageURL else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                imageView.image = image
            }
        } .resume()
    }
}
