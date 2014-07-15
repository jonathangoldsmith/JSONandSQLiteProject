//
//  Product.h
//  ProductProject
//
//  Created by Jonathan on 7/9/14.
//  Copyright (c) 2014 Jonathan Goldsmith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (nonatomic) NSString *productId;
@property (nonatomic) NSString *productName;
@property (nonatomic) NSString *productDescription;
@property (nonatomic) NSString *productRegularPrice;
@property (nonatomic) NSString *productSalePrice;
@property (nonatomic) UIImage *productPhoto;
@property (nonatomic) NSArray *productColors;
@property (nonatomic) NSDictionary *productStores;

- (id)initWithNameAndPhoto:(NSString *)name photo:(UIImage *)photo;

@end
