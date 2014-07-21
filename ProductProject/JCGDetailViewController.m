//
//  JCGDetailViewController.m
//  ProductProject
//
//  Created by Jonathan on 7/9/14.
//  Copyright (c) 2014 Jonathan Goldsmith. All rights reserved.
//
// The details of the selected product are displayed

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
            
            _colors = [[NSMutableArray alloc]init];
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                
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
            
            _stores = [[NSMutableArray alloc]init];
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
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
    self.title = _product.productName;
    self.productRegularPrice.text = _product.productRegularPrice;
    self.productSalePrice.text = _product.productSalePrice;
    self.productDescription.text = _product.productDescription;
    self.productImage.image = _product.productPhoto;
    self.productDescription.text = _product.productDescription;
    NSString *storeString = @"Available stores: ";
    for(int i=0;i<[_stores count];i++) {
        storeString = [NSString stringWithFormat:@"%@ %@", storeString, [_stores objectAtIndex:i]];
    }
    self.productStoreList.text = storeString;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getProducts];
    [self getProductColors];
    [self getProductStores];
    [self configureView];
    self.productRegularPrice.delegate = self;
    self.productSalePrice.delegate = self;
    UITapGestureRecognizer *tapOnce =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapOnce:)];
    UITapGestureRecognizer *tapTwice =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapTwice:)];
    
    tapOnce.numberOfTapsRequired = 1;
    tapTwice.numberOfTapsRequired = 2;
    [tapOnce requireGestureRecognizerToFail:tapTwice];
    [self.productImage addGestureRecognizer:tapOnce];
    [self.productImage addGestureRecognizer:tapTwice];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)updateOnSaveClick:(id)sender {
    const char *dbpath = [_dBPath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"UPDATE PRODUCTS SET PRODUCTREGULARPRICE='%@', PRODUCTSALEPRICE='%@' WHERE PRODUCTID='%@'", self.productRegularPrice.text, self.productSalePrice.text, _product.productId];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_contactDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Update completed"
                                                            message:@"Prices saved to the database!" delegate:self cancelButtonTitle: @"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            
            
        }
        int success = sqlite3_step(statement);
        if (success == SQLITE_ERROR) {
            NSAssert1(0, @"Error: Failed to update the database with message '%s'.", sqlite3_errmsg(_contactDB));
        }
        sqlite3_finalize(statement);
        sqlite3_close(_contactDB);
    }
    [self getProducts];
    [self configureView];

}

- (IBAction)deleteOnDeleteClick:(id)sender {
    const char *dbpath = [_dBPath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"DELETE FROM PRODUCTS WHERE PRODUCTID=\"%@\"", _product.productId];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_contactDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Update completed"
                                                            message:@"The product has been removed from the database" delegate:self cancelButtonTitle: @"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            
            
        }
        int success = sqlite3_step(statement);
        if (success == SQLITE_ERROR) {
            NSAssert1(0, @"Error: Failed to update the database with message '%s'.", sqlite3_errmsg(_contactDB));
        }
        sqlite3_finalize(statement);
        sqlite3_close(_contactDB);
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tapOnce:(UIGestureRecognizer *)gesture
{
    //on a single  tap, call zoomToRect in UIScrollView
    self.productImage.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
}
- (void)tapTwice:(UIGestureRecognizer *)gesture
{
    //on a double tap, call zoomToRect in UIScrollView
    self.productImage.frame = CGRectMake(8,73,180,128);
}

# pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

//To make sure the text entered into the prices is a number
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString*)string {
    //Credit to Matthias Bauch here: (http://stackoverflow.com/questions/342181/whats-the-best-way-to-validate-currency-input-in-uitextfield) for currency validation
    static NSString *numbers = @"0123456789";
    static NSString *numbersPeriod = @"01234567890.";
    static NSString *numbersComma = @"0123456789,";
    
    if (range.length > 0 && [string length] == 0) {
        // enable delete
        return YES;
    }
    
    NSString *symbol = [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator];
    if (range.location == 0 && [string isEqualToString:symbol]) {
        // decimalseparator should not be first
        return NO;
    }
    NSCharacterSet *characterSet;
    NSRange separatorRange = [textField.text rangeOfString:symbol];
    if (separatorRange.location == NSNotFound) {
        if ([symbol isEqualToString:@"."]) {
            characterSet = [[NSCharacterSet characterSetWithCharactersInString:numbersPeriod] invertedSet];
        }
        else {
            characterSet = [[NSCharacterSet characterSetWithCharactersInString:numbersComma] invertedSet];
        }
    }
    else {
        // allow 2 characters after the decimal separator
        if (range.location > (separatorRange.location + 2)) {
            return NO;
        }
        characterSet = [[NSCharacterSet characterSetWithCharactersInString:numbers] invertedSet];
    }
    return ([[string stringByTrimmingCharactersInSet:characterSet] length] > 0);
 
}

# pragma mark UIPickerDelegate

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return _colors.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return _colors[row];
}


//Option only availble for the socks
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    if([_product.productName isEqualToString:@"Socks"])
    {
        if([_colors[row] isEqualToString:@"White"]) {
            self.productImage.image = _product.productPhoto;
        } else if([_colors[row] isEqualToString:@"Black"]) {
            self.productImage.image = [UIImage imageNamed:@"blackSocks"];
        }
    }
}

@end
