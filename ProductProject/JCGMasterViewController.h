//
//  JCGMasterViewController.h
//  ProductProject
//
//  Created by Jonathan on 7/9/14.
//  Copyright (c) 2014 Jonathan Goldsmith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@class JCGDetailViewController;

@interface JCGMasterViewController : UIViewController

//@property (nonatomic) NSMutableArray *products;
@property (strong, nonatomic) NSString *dBPath;
@property (nonatomic) sqlite3 *contactDB;

@end
