//
//  JCGDetailViewController.h
//  ProductProject
//
//  Created by Jonathan on 7/9/14.
//  Copyright (c) 2014 Jonathan Goldsmith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCGTableViewController.h"

@interface JCGDetailViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *productRegularPrice;
@property (weak, nonatomic) IBOutlet UITextField *productSalePrice;
@property (weak, nonatomic) IBOutlet UILabel *productDescription;
@property (weak, nonatomic) IBOutlet UILabel *productStoreList;
@property (weak, nonatomic) IBOutlet UIPickerView *colorPicker;
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteButton;

@property (nonatomic) NSString *dBPath;
@property (nonatomic) sqlite3 *contactDB;
@property (nonatomic) NSString *productName;

@end
