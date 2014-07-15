//
//  Product.m
//  ProductProject
//
//  Created by Jonathan on 7/9/14.
//  Copyright (c) 2014 Jonathan Goldsmith. All rights reserved.
//

#import "Product.h"

@implementation Product

- (id)initWithNameAndPhoto:(NSString *)name photo:(UIImage *)photo
{
    if ((self = [super init])) {
        self.productName = name;
        self.productPhoto = photo;
    }
    return self;
}

@end
