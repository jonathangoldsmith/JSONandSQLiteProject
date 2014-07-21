//
//  JCGAddProductViewController.h
//  ProductProject
//
//  Created by Jonathan on 7/21/14.
//  Copyright (c) 2014 Jonathan Goldsmith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"
#import "JCGMasterViewController.h"

@interface JCGAddProductViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *productId;
@property (weak, nonatomic) IBOutlet UITextField *productName;
@property (weak, nonatomic) IBOutlet UITextField *productRegularPrice;
@property (weak, nonatomic) IBOutlet UITextField *productSalePrice;
@property (weak, nonatomic) IBOutlet UITextField *productPhoto;
@property (weak, nonatomic) IBOutlet UITextField *productDescription;
@property (nonatomic) IBOutlet UIButton *blueButton;
@property (nonatomic) IBOutlet UIButton *greenButton;
@property (nonatomic) IBOutlet UIButton *redButton;
@property (nonatomic) IBOutlet UIButton *whiteButton;
@property (nonatomic) IBOutlet UIButton *blackButton;
@property (nonatomic) IBOutlet UIButton *NYCButton;
@property (nonatomic) IBOutlet UIButton *SFOButton;
@property (nonatomic) IBOutlet UIButton *DETButton;
@property (nonatomic) IBOutlet UIButton *STLButton;
@property (nonatomic) IBOutlet UIButton *ATLButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (strong, nonatomic) NSString *dBPath;
@property (nonatomic) sqlite3 *contactDB;

@end
