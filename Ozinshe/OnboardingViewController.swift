//
//  OnboardingViewController.swift
//  Ozinshe
//
//  Created by Alina Floccus on 26.03.2024.
//
// UICollectionViewDelegateFlowLayout - настройки размеров ячеек

import UIKit

class OnboardingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var arraySlides = [["firstSlide", "ÖZINŞE-ге қош келдің!", "Фильмдер, телехикаялар, ситкомдар, анимациялық жобалар, телебағдарламалар мен реалити-шоулар, аниме және тағы басқалары"],
                       ["secondSlide", "ÖZINŞE-ге қош келдің!", "Кез келген құрылғыдан қара Сүйікті фильміңді  қосымша төлемсіз телефоннан, планшеттен, ноутбуктан қара"],
                       ["thirdSlide", "ÖZINŞE-ге қош келдің!", "Тіркелу оңай. Қазір тіркел де қалаған фильміңе қол жеткіз"]]
  
    // переменная, которую поставим в pagecontrol
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // когда только ViewController открылся - скрываем navigationController "кнопочка назад "
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // когда перейдем на след.экран - navigationController отобразим
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.title = " " // если не будет, то у кнопки пояаится текст "назад"
    }
    
    // функция при нажатии на кнопку, связка с кнопкой прописывается при отрисовки collectionView
    @objc func nextButtonTouched() {
        let singInViewController = storyboard?.instantiateViewController(withIdentifier: "SingInViewController")
        navigationController?.show(singInViewController!, sender: self)
    }
    
    // MARK: - collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arraySlides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let imageview = cell.viewWithTag(1000) as! UIImageView
        imageview.image = UIImage(named: arraySlides[indexPath.row][0]) // первый в строке
        
        let titleLabel = cell.viewWithTag(1001) as! UILabel
        titleLabel.text = arraySlides[indexPath.row][1]
        
        let descriptionLabel = cell.viewWithTag(1002) as! UILabel
        descriptionLabel.text = arraySlides[indexPath.row][2]
        
        let button = cell.viewWithTag(1003) as! UIButton
        button.layer.cornerRadius = 8
        if indexPath.row == 2 { // если 3-ий слайд, то скрываем кнопку
            button.isHidden = true
        }
        button.addTarget(self, action: #selector(nextButtonTouched), for: .touchUpInside)
        
        let nextbutton = cell.viewWithTag(1004) as! UIButton
        nextbutton.layer.cornerRadius = 12
        if indexPath.row != 2 {
            nextbutton.isHidden = true
        }
        nextbutton.addTarget(self, action: #selector(nextButtonTouched), for: .touchUpInside)
        
        return cell
    }
    
    // задаем фиксированные размеры нашего cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    // чтобы правильно закрвшивать точечки в pageControl
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}
