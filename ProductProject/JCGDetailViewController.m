//
//  JCGDetailViewController.m
//  ProductProject
//
//  Created by Jonathan on 7/9/14.
//  Copyright (c) 2014 Jonathan Goldsmith. All rights reserved.
//

#import "JCGDetailViewController.h"
#import "Product.h"

@interface JCGDetailViewController ()
@property (strong, nonatomic) Product *product;
@property (strong, nonatomic) NSMutableArray *colors;
@property (strong, nonatomic) NSMutableArray *stores;
@end

@implementation JCGDetailViewController

- (void)getProducts
{
    
    const char *dbpath = [_dBPath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT * FROM PRODUCTS WHERE PRODUCTNAME=\"%@\"", self.productName];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_contactDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                _product = [[Product alloc]init];
                NSString *productId = [[NSString alloc]
                                        initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 0)];
                _product.productId = productId;
                NSString *productName = [[NSString alloc]
                                         initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 1)];
                _product.productName = productName;
                NSString *productDescription = [[NSString alloc]
                                         initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 2)];
                _product.productDescription = productDescription;
                NSString *productRegularPrice = [[NSString alloc]
                                         initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 3)];
                _product.productRegularPrice = productRegularPrice;
                NSString *productSalePrice = [[NSString alloc]
                                         initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 4)];
                _product.productSalePrice = productSalePrice;
                NSString *productPhoto = [[NSString alloc]
                                          initWithUTF8String:(const char *)
                                          sqlite3_column_text(statement, 5)];
                _product.productPhoto = [UIImage imageNamed:productPhoto];
                NSLog(@"Match found");
            }
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(_contactDB);
    }
}

- (void)getProductColors
{
    
    const char *dbpath = [_dBPath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT PRODUCTCOLOR FROM COLORS WHERE PRODUCTID=\"%@\"", _product.productId];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_contactDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                _colors = [[NSMutableArray alloc]init];
                NSString *color = [[NSString alloc]
                                   initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement, 0)];
                [_colors addObject:color];
                NSLog(@"Match found");
            }
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(_contactDB);
    }
}

- (void)getProductStores
{
    
    const char *dbpath = [_dBPath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT STORENAME FROM STORES WHERE PRODUCTID=\"%@\"", _product.productId];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_contactDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                _stores = [[NSMutableArray alloc]init];
                NSString *store = [[NSString alloc]
                                   initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement, 0)];
                [_stores addObject:store];
                NSLog(@"Match found");
            }
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(_contactDB);
    }
}


- (void)configureView
{
    self.productRegularPrice.text = _product.productRegularPrice;
    self.productSalePrice.text = _product.productSalePrice;
    self.productDescription.text = _product.productDescription;
    self.productImage.image = _product.productPhoto;
    self.productDescription.text = _product.productDescription;
    for(int i=0;i<[_stores count];i++) {
        self.productStoreList.text = [NSString stringWithFormat:@"%@ %@", self.productStoreList.text, [_stores objectAtIndex:i]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getProducts];
    [self getProductColors];
    [self getProductStores];
    [self configureView];
}

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return _stores.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return _stores[row];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
