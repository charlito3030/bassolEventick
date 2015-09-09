//
//  ViewControllerPeliculasViewController.swift
//  bassolEventik4
//
//  Created by charlie on 8/10/15.
//  Copyright (c) 2015 charlie. All rights reserved.
//

import UIKit

class ViewControllerPeliculasViewController: UIViewController,UIScrollViewDelegate
,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pager: UIPageControl!
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var imgViewBackground: UIImageView!
    
    @IBOutlet weak var labelLoading: UILabel!
    
    var iRef : Int = 0; //lleva la cuenta del pager...
    var aImagenes4ScrollView : Array<NSData?>?//contiene el array de imagenes para el scroller
    
    var loader:Loaders?//para capturar el json en un segundo hilo de ejecucion..
    
    //for collections...
    @IBOutlet weak var collectionView: UICollectionView!
    var aImagenes4Collection : Array<BeanJsonPelicula>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader = Loaders(viewControllerMain: self)
        loader!.getJsonAsNsData()
        
        let lat = Auxiliar.sigletonHelper.getLat()
        let lonj = Auxiliar.sigletonHelper.getLonj()
        
        //println("lat: \(lat), lonj: \(lonj))")
    }
    
    func jsonParseado(resultado:Bool){
        self.loadingView.removeFromSuperview()
        if resultado{
            self.labelLoading.removeFromSuperview()
            self.imgViewBackground.removeFromSuperview()
            //self.imgViewFillScreen.removeFromSuperview()//solo remueve la capa
            aImagenes4ScrollView = (self.loader?.getArray4ScrollView())!
            loadDataIntoScroller()
            aImagenes4Collection = self.loader?.getArray()
            self.collectionView.reloadData()
            //agregamos todo el array jsonParseado a Auxiliar
            Auxiliar.sigletonHelper.aImagenes4Collection = aImagenes4Collection;
        }else{
            self.labelLoading.text = "Error loading json"
            println("error loading el json...")
        }
    }
    
    //MARK: UIScrollViewDelegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        var pageWidth:CGFloat = CGRectGetWidth(scrollView.frame)
        var currentPage:CGFloat = floor((self.scrollView.contentOffset.x-pageWidth)/pageWidth)+1
        // Change the indicator
        //println("current page: \(currentPage)")
        iRef=Int(currentPage)
        self.pager.currentPage = Int(currentPage);
        
    }
    
    //scroll view y pager
    func loadDataIntoScroller(){
        self.scrollView.frame = CGRectMake(0, 0, self.view.frame.width, 150)
        ///println("heith: \(self.view.frame.height)")
        
        let scrollViewWidth:CGFloat = self.scrollView.frame.width
        //let scrollViewHeight:CGFloat = self.scrollView.frame.height
        let scrollViewHeight:CGFloat = 150
        //println("scroll width: \(scrollViewWidth),  scroll height: \(scrollViewHeight)")
        var imgOne = UIImageView(frame: CGRectMake(0, 0,scrollViewWidth, scrollViewHeight))
        if aImagenes4ScrollView![0] != nil {
            if let img4 = UIImage(data: aImagenes4ScrollView![0]!){
                imgOne.image = img4
            }
        }else{
            imgOne.image = UIImage(named: "img_not_found")
        }
        
        var imgTwo = UIImageView(frame: CGRectMake(scrollViewWidth, 0,scrollViewWidth, scrollViewHeight))
        if aImagenes4ScrollView![1] != nil {
            if let img4 = UIImage(data: aImagenes4ScrollView![1]!){
                imgTwo.image = img4
            }
        }else{
            imgTwo.image = UIImage(named: "img_not_found")
        }
        var imgThree = UIImageView(frame: CGRectMake(scrollViewWidth*2, 0,scrollViewWidth, scrollViewHeight))
        if aImagenes4ScrollView![2] != nil {
            if let img4 = UIImage(data: aImagenes4ScrollView![2]!){
                imgThree.image = img4
            }
        }else{
            imgThree.image = UIImage(named: "img_not_found")
        }
        var imgFor = UIImageView(frame: CGRectMake(scrollViewWidth*3, 0,scrollViewWidth, scrollViewHeight))
        if aImagenes4ScrollView![3] != nil {
            if let img4 = UIImage(data: aImagenes4ScrollView![3]!){
                imgFor.image = img4
            }
        }else{
            imgFor.image = UIImage(named: "img_not_found")
        }
        
        
        self.scrollView.addSubview(imgOne)
        self.scrollView.addSubview(imgTwo)
        self.scrollView.addSubview(imgThree)
        self.scrollView.addSubview(imgFor)
        //4
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.width * 4, scrollViewHeight / 2)
        self.scrollView.delegate = self
        //aki es para el scrollview con pager.. ahora sigue el touch enent
        
        var tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("movieTapped:"))
        //scrollView.addGestureRecognizer(tapGestureRecognizer)
        //scrollView.userInteractionEnabled = true
        self.scrollView.addGestureRecognizer(tapGestureRecognizer)
        self.scrollView.userInteractionEnabled = true
        //self.scrollView.reloadInputViews()
        //self.pager.reloadInputViews()
        //view.bringSubviewToFront(pager)
        
        
    }
    func movieTapped(sender:AnyObject){
        println("aki se cambia de pantalla..")
        //performSegueWithIdentifier("segueDetalles", sender: nil)
        let bean = aImagenes4Collection![iRef]
        Auxiliar.sigletonHelper.setBeanPelicula(bean)
        //
        performSegueWithIdentifier("segueDetalles", sender: nil)
    }
    
    //siguen los override del collections..
    //metodos del collection
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if aImagenes4Collection != nil {
            return aImagenes4Collection!.count
        }
        return 0;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : MyCell = collectionView.dequeueReusableCellWithReuseIdentifier("celda", forIndexPath: indexPath) as! MyCell
        
        let bean = aImagenes4Collection![indexPath.row]
        let nsdata = bean.getImgAsNSData()
        if nsdata == nil {
            cell.image.image = UIImage(named: "img_not_found")
            return cell
        }
        cell.image.image = UIImage(data: nsdata!)
        return cell
    }
    
    //del collection para detectar el click event
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let peliClicked = indexPath.item
        //println("psss se dio click en la peli numero : \(peliClicked)")
        
        let bean = aImagenes4Collection![peliClicked]
        Auxiliar.sigletonHelper.setBeanPelicula(bean)
        
        performSegueWithIdentifier("segueDetalles", sender: nil)
        
    }

}
