//
//  STFactory.swift
//  SwiftTestDemo
//
//  Created by yunzhang on 2018/7/13.
//  Copyright © 2018年 TianXuan. All rights reserved.
//

import UIKit
let kScreenHeight = UIScreen.main.bounds.size.height
let kScreenWidth = UIScreen.main.bounds.size.width
let NavBarHeight:CGFloat = UIApplication.shared.statusBarFrame.size.height==20 ? 64.0 : 88.0;
class STFactory: NSObject {
    //静态修饰的 和class修饰的 用类名调用
    //class 适用于class 中 static适用于任何中 struct enum class
    /**普通创建Label*/
    @discardableResult
    static func creatLabel(title:String,textColor:UIColor,font:CGFloat,textAlgint:NSTextAlignment)->UILabel{
        let label = UILabel();
        label.text = title;
        label.textAlignment = textAlgint;
        label.font = UIFont.systemFont(ofSize: font);
        label.textColor = textColor;
        return label;
    }
    /**普通创建btn*/
    @discardableResult
    final class func creatButton(title:String,font:CGFloat,textColor:UIColor)->UIButton {
        let btn = UIButton();
        btn.setTitle(title, for: .normal);
        btn.titleLabel?.font = UIFont.systemFont(ofSize: font);
        btn.setTitleColor(textColor, for: .normal);
        return btn;
    }
    /**支持图片btn*/
    @discardableResult
    final class func creatButton(title:String,font:CGFloat,textColor:UIColor,img:String)->UIButton {
        let btn = UIButton();
        btn.setTitle(title, for: .normal);
        btn.titleLabel?.font = UIFont.systemFont(ofSize: font);
        btn.setTitleColor(textColor, for: .normal);
        btn.setImage(UIImage.init(named: img), for: .normal);
        return btn;
    }
    /**创建TextFiled*/
    @discardableResult
    final class func creatTextField(placeTitle placeHodel:String,font:CGFloat,textColor:UIColor,GbColor:UIColor)->UITextField{
        let textFiled = UITextField();
        textFiled.placeholder = placeHodel;
        textFiled.textColor = textColor;
        textFiled.font = UIFont.systemFont(ofSize: font)
        textFiled.tintColor = GbColor;
        return textFiled;
    }
    
    @discardableResult
    final class func creatLineView()-> UIView{
        let view = UIView();
        view.backgroundColor = UIColor(hexString: 0xeeeeee)
        return view;
    }
    
    @discardableResult
    final class func creatImgeView(image:String)-> UIImageView {
        let imageV = UIImageView(image: UIImage(named: image));
        return imageV;
    }
}
class CommondClass: NSObject {
    /**
     NSString *MOBILE = @"";
     NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
     return [regextestmobile evaluateWithObject:mobileNum];
     */
    /**验证手机号码*/
   class func stringIsTelephoneNumber(num telephone:String) -> Bool {
        if telephone.count != 11 {
            return false;
        }
        let zzString:String = "^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
        let regexMobile = NSPredicate(format: "SELF MATCHES %@",zzString)
        return regexMobile.evaluate(with:telephone);
    }
}
extension UIColor {
    //线条颜色
  open class var lineColor: UIColor {
        return UIColor.init(hexString: 0xeeeeee);
    }
    //文字颜色
  open class  var textColor:UIColor {
        return UIColor.init(hexString: 0x333333)
    }
    //主颜色
   open class var mainColor : UIColor {
        return UIColor.init(hexString: 0x7fccea)
    }
    //填充颜色
    open class var fillColor:UIColor {
        return UIColor.init(hexString: 0xf9f9f9)
    }
}
