//
//  MainTableViewCell.swift
//  Ozinshe
//
//  Created by Alina Floccus on 24.02.2024.
//

import UIKit
import SDWebImage

// класс из интернета для настройки отображения элементов в collectionView
class TopAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)?
            .map { $0.copy() } as? [UICollectionViewLayoutAttributes]

        attributes?
            .reduce([CGFloat: (CGFloat, [UICollectionViewLayoutAttributes])]()) {
                guard $1.representedElementCategory == .cell else { return $0 }
                return $0.merging([ceil($1.center.y): ($1.frame.origin.y, [$1])]) {
                    ($0.0 < $1.0 ? $0.0 : $1.0, $0.1 + $1.1)
                }
            }
            .values.forEach { minY, line in
                line.forEach {
                    $0.frame = $0.frame.offsetBy(
                        dx: 0,
                        dy: minY - $0.frame.origin.y
                    )
                }
            }

        return attributes
    }
}

class MainTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var mainMovie = MainMovies()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = TopAlignedCollectionViewFlowLayout() // распределение элементов по верхнему краю
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24.0, bottom: 0, right: 24.0)
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.estimatedItemSize.width = 112
        layout.estimatedItemSize.height = 220
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for  the selected state
    }
    
    func setData(mainMovie: MainMovies) {
        categoryNameLabel.text = mainMovie.categoryName
        
        self.mainMovie = mainMovie // конкретный mainMovie, который мы присваиваем
        collectionView.reloadData()
    }
    
    // MARK: - collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainMovie.movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        //imageview размеры изображения в блоке (aspectFill - заполнение всей картинки)
        let transformer = SDImageResizingTransformer(size: CGSize(width: 112, height: 164), scaleMode: .aspectFill)
        
        let imageview = cell.viewWithTag(1000) as! UIImageView
        imageview.sd_setImage(with: URL(string: mainMovie.movies[indexPath.row].poster_link), placeholderImage: nil, context: [.imageTransformer: transformer]) // transformer - уменьшает оригинал до размера нашего imageview
        imageview.layer.cornerRadius = 8
        
        //movieNameLabel
        let movieNameLabel = cell.viewWithTag(1001) as! UILabel
        movieNameLabel.text = mainMovie.movies[indexPath.row].name
        
        let movieGenreNameLabel = cell.viewWithTag(1002) as! UILabel
        // if let - проверяем указал ли админ жанр, если нет, то пустота
        if let genrename = mainMovie.movies[indexPath.row].genres.first {
            movieGenreNameLabel.text = genrename.name
        } else {
            movieGenreNameLabel.text = ""
        }
        
        return cell
    }
    
    // выбор фильма
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }

}
