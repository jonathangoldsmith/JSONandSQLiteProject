//
//  JCGAddProductViewController.m
//  ProductProject
//
//  Created by Jonathan on 7/21/14.
//  Copyright (c) 2014 Jonathan Goldsmith. All rights reserved.
//
// The is the VC to add a product

#import "JCGAddProductViewController.h"
@interface JCGAddProductViewController ()

@end

@implementation JCGAddProductViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Create Product";
}
- (void)insertColorIntoDatabase:(NSString *)productId color:(NSString *)color
{
    sqlite3_stmt    *statement;
    const char *dbpath = [_dBPath UTF8String];
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO COLORS (IDCOLOR, PRODUCTID, PRODUCTCOLOR) VALUES (\"%@\", \"%@\", \"%@\")",
                               [NSString stringWithFormat:@"%@/%@", productId, color], productId, color];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_contactDB, insert_stmt,
                           -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Color added");
        } else {
            NSLog(@"Failed to add Color");
        }
        sqlite3_finalize(statement);
        
        sqlite3_close(_contactDB);
    }
}

- (void)insertStoreIntoDatabase:(NSString *)storeId productId:(NSString *)productId storeName:(NSString *)storeName
{
    sqlite3_stmt    *statement;
    const char *dbpath = [_dBPath UTF8String];
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO STORES (STOREPRODUCT, STOREID, PRODUCTID, STORENAME) VALUES (\"%@\", \"%@\", \"%@\", \"%@\")",
                               [NSString stringWithFormat:@"%@/%@", storeName, productId], storeId, productId, storeName];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_contactDB, insert_stmt,
                           -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Store added");
        } else {
            NSLog(@"Failed to add Store");
        }
        sqlite3_finalize(statement);
        
        sqlite3_close(_contactDB);
    }
}

# pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)optionSelected:(UIButton *)sender {
    sender.selected = !sender.selected;
}


- (IBAction)submit:(id)sender {
    sqlite3_stmt    *statement;
    const char *dbpath = [_dBPath UTF8String];
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO PRODUCTS (PRODUCTID, PRODUCTNAME, PRODUCTDESCRIPTION, PRODUCTREGULARPRICE, PRODUCTSALEPRICE, PRODUCTPHOTO) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", self.productId.text,
                               self.productName.text, self.productDescription.text, self.productRegularPrice.text, self.productSalePrice.text, self.productPhoto.text];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_contactDB, insert_stmt,
                           -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Product added");
        } else {
            NSLog(@"Failed to add Product");
        }
        sqlite3_finalize(statement);
        
        sqlite3_close(_contactDB);
    }
    
    if([self.blueButton isSelected]) {
        [self insertColorIntoDatabase:self.productId.text color:@"Blue"];
    }if([self.greenButton isSelected]) {
        [self insertColorIntoDatabase:self.productId.text color:@"Green"];
    }if([self.redButton isSelected]) {
        [self insertColorIntoDatabase:self.productId.text color:@"Red"];
    }if([self.whiteButton isSelected]) {
        [self insertColorIntoDatabase:self.productId.text color:@"White"];
    }if([self.blackButton isSelected]) {
        [self insertColorIntoDatabase:self.productId.text color:@"Black"];
    }
    
    if([self.NYCButton isSelected]) {
        [self insertStoreIntoDatabase:@"001" productId:self.productId.text storeName:@"NYC"];
    }if([self.SFOButton isSelected]) {
        [self insertStoreIntoDatabase:@"002" productId:self.productId.text storeName:@"SFO"];
    }if([self.DETButton isSelected]) {
        [self insertStoreIntoDatabase:@"003" productId:self.productId.text storeName:@"DET"];
    }if([self.STLButton isSelected]) {
        [self insertStoreIntoDatabase:@"004" productId:self.productId.text storeName:@"STL"];
    }if([self.ATLButton isSelected]) {
        [self insertStoreIntoDatabase:@"005" productId:self.productId.text storeName:@"ATL"];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Insert completed"
                                                    message:@"The product has been entered into the database" delegate:self cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
