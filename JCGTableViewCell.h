//
//  JCGTableViewCell.h
//  ProductProject
//
//  Created by Jonathan on 7/14/14.
//  Copyright (c) 2014 Jonathan Goldsmith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCGTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *productImage;
@property (strong, nonatomic) IBOutlet UILabel *productName;

@end
