//
//  YWScrollerView.swift
//  CustomCollectionLayout
//
//  Created by 天轩 on 2018/7/18.
//  Copyright © 2018年 天轩. All rights reserved.
//

import UIKit
let YWScrollIdent:String = "ywscrollIdent";
class YWScrollerView: UIView ,UICollectionViewDelegate,UICollectionViewDataSource{
    var collectionV:UICollectionView!
    var delegate:YWScrollerLayoutDelegate?
    var dataSource:[String]? {
        willSet{
//            print(newValue!);
        }
        didSet{
//            print(oldValue ?? []);
            //刷新数据
            self.collectionV.reloadData();
        }
    }
    init(frame: CGRect,registerCell:AnyClass,isXib:Bool,delegate:YWScrollerLayoutDelegate) {
        super.init(frame: frame);
        self.creatUI(frame: frame,registerCell
            :registerCell,isXib: isXib,delgate: delegate);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func creatUI(frame:CGRect,registerCell:AnyClass,isXib:Bool,delgate:YWScrollerLayoutDelegate)  {
        
        let flayLayout = YWScrollerLayout();
        self.delegate = delgate;
        if self.delegate != nil {
           flayLayout.rows = delegate!.numberOfRowsInYWLayout(layout: flayLayout);
           flayLayout.colum = delegate!.numberOfColumsInYWLayout(layout: flayLayout)
        }
        let collectonView = UICollectionView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height), collectionViewLayout: flayLayout)
        collectonView.backgroundColor = UIColor.white;
        collectonView.delegate = self;
        collectonView.dataSource = self;
        self.addSubview(collectonView);
        if isXib == true {
            collectonView.register(UINib.init(nibName: NSStringFromClass(registerCell), bundle: .main), forCellWithReuseIdentifier: YWScrollIdent)
        }else{
             collectonView.register(registerCell, forCellWithReuseIdentifier: YWScrollIdent)
        }
       
        self.collectionV = collectonView;
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource?.count ?? 0;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: YWScrollIdent, for: indexPath);
        if self.delegate != nil {
            cell = (self.delegate?.YWScrollerCellForRow(registerCell: cell, IndexPath: indexPath))!;
        }
        return cell;
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.delegate != nil {
            delegate?.YWScrollerViewDidSelect(index: indexPath);
        }
    }
}
protocol YWScrollerLayoutDelegate {
    func YWScrollerCellForRow(registerCell:UICollectionViewCell,IndexPath:IndexPath) -> UICollectionViewCell;
    //传入列数
    func numberOfRowsInYWLayout(layout:YWScrollerLayout) -> Int;
    //传入行数
    func numberOfColumsInYWLayout(layout:YWScrollerLayout) -> Int;
    //点击事件
    func YWScrollerViewDidSelect(index:IndexPath) -> Void;
}
class YWScrollerLayout: UICollectionViewFlowLayout {
    var rows:Int = 0;
    var colum:Int = 0;
    override func prepare() {
        super.prepare()
        self.scrollDirection = UICollectionViewScrollDirection.vertical;
        self.collectionView?.showsVerticalScrollIndicator = false;
        self.collectionView?.showsHorizontalScrollIndicator = false;
        self.collectionView?.bounces = false;
        self.collectionView?.isPagingEnabled = true;
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        //.返回rect中的所有的元素的布局属性
        let numCount = self.collectionView?.numberOfItems(inSection: 0) ?? 0;
        
        var array:[UICollectionViewLayoutAttributes] = [];
        for i in 0..<numCount {
            let att = self.layoutAttributesForItem(at: NSIndexPath(row: i, section: 0) as IndexPath)
            array.append(att!);
        }
        return array;
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr:UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath);
        let rows = self.rows;
        let colum = self.colum;
        let page = indexPath.item/(rows*colum)
        let cellW = (self.collectionView?.bounds.size.width)!/CGFloat(colum)
        let itemRow = (indexPath.item - page*(colum*rows))/colum
        let itemCol = (indexPath.item - page*(colum*rows))%colum;
        let cellX = CGFloat(page) * (self.collectionView?.bounds.size.width)!+CGFloat(itemCol)*cellW + self.sectionInset.left;
        
        /*不计算间距
         */
        //        CGFloat cellW=self.collectionView.bounds.size.width/colum;
        
        //        NSInteger  itemRow = (indexPath.item - page*(colum*rows))/ colum;//行数
        //        NSInteger itemCol = (indexPath.item - page*(colum*rows))% colum;//列数
        //        CGFloat cellX = page * self.collectionView.bounds.size.width + itemCol * (cellW) + self.sectionInset.left;
        /*
         同上
         */
        //    CGFloat cellH = (self.collectionView.bounds.size.height - self.sectionInset.top - self.sectionInset.bottom - (rows - 1) * self.minimumLineSpacing) / rows;
        //        CGFloat cellH =self.collectionView.bounds.size.height/rows;
        let cellH = (self.collectionView?.bounds.size.height)!/CGFloat(rows);
        //        CGFloat cellY = itemRow * (cellH + self.sectionInset.top) + self.sectionInset.top;
        let cellY = CGFloat(itemRow) * (cellH+self.sectionInset.top)+self.sectionInset.top;
        attr.frame = CGRect(x: cellX, y: cellY, width: cellW, height: cellH);
        
        return attr;
    }
    
    override var collectionViewContentSize: CGSize{
        let  itemCount = self.collectionView?.numberOfItems(inSection: 0);
        let page:Int;
        if itemCount!%(self.colum*self.rows) == 0 {
            page = itemCount!/(self.colum*self.rows);
        }else{
            page = itemCount!/(self.colum*self.rows)+1
        }
        return CGSize(width: self.collectionView!.bounds.size.width*CGFloat(page), height: self.collectionView!.frame.size.height);
    }
}
