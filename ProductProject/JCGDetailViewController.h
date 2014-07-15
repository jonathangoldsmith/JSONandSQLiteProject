//
//  JCGDetailViewController.h
//  ProductProject
//
//  Created by Jonathan on 7/9/14.
//  Copyright (c) 2014 Jonathan Goldsmith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCGTableViewController.h"

@interface JCGDetailViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *productRegularPrice;
@property (weak, nonatomic) IBOutlet UITextView *productDescription;
@property (weak, nonatomic) IBOutlet UILabel *productSalePrice;
@property (weak, nonatomic) IBOutlet UILabel *productStoreList;
@property (weak, nonatomic) IBOutlet UIPickerView *colorPicker;
@property (weak, nonatomic) IBOutlet UIImageView *productImage;

@property (strong, nonatomic) NSString *dBPath;
@property (nonatomic) sqlite3 *contactDB;
@property (nonatomic) NSString *productName;

@end
