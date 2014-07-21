//
//  JCGTableViewController.h
//  ProductProject
//
//  Created by Jonathan on 7/14/14.
//  Copyright (c) 2014 Jonathan Goldsmith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCGMasterViewController.h"

@interface JCGTableViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSString *dBPath;
@property (nonatomic) sqlite3 *contactDB;

@end
