//
//  JCGMasterViewController.m
//  ProductProject
//
//  Created by Jonathan on 7/9/14.
//  Copyright (c) 2014 Jonathan Goldsmith. All rights reserved.
//  Does all the necessary JSON and SQLLite preperation for the other controllers to use
//

#import "JCGMasterViewController.h"
#import "JCGDetailViewController.h"
#import "Product.h"
#import "JCGTableViewController.h"
#import "JCGAddProductViewController.h"

@interface JCGMasterViewController ()
@end


@implementation JCGMasterViewController

- (void)setUpDatabase
{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _dBPath = [[NSString alloc]
               initWithString: [docsDir stringByAppendingPathComponent:
                                @"product.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: _dBPath ] == NO)
    {
        const char *dbpath = [_dBPath UTF8String];
        
        if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt =
            "CREATE TABLE IF NOT EXISTS PRODUCTS (PRODUCTID INTEGER PRIMARY KEY AUTOINCREMENT, PRODUCTNAME TEXT, PRODUCTDESCRIPTION TEXT, PRODUCTREGULARPRICE TEXT, PRODUCTSALEPRICE TEXT, PRODUCTPHOTO TEXT)";
            
            if (sqlite3_exec(_contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table");
            }
            sql_stmt =
            "CREATE TABLE IF NOT EXISTS COLORS (IDCOLOR TEXT PRIMARY KEY, PRODUCTID INTEGER FOREIGNKEY, PRODUCTCOLOR TEXT)";
            
            if (sqlite3_exec(_contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table");
            }
            sql_stmt =
            "CREATE TABLE IF NOT EXISTS STORES (STOREPRODUCT TEXT PRIMARY KEY, STOREID INTEGER FOREIGNKEY, PRODUCTID INTEGER FOREIGNKEY, STORENAME TEXT)";
            
            if (sqlite3_exec(_contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table");
            }

            sqlite3_close(_contactDB);
        } else {
            NSLog(@"Failed to connect to DB");
        }
    }
}

- (void)insertProductIntoDatabase:(Product *)product
{
    sqlite3_stmt    *statement;
    const char *dbpath = [_dBPath UTF8String];
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO PRODUCTS (PRODUCTID, PRODUCTNAME, PRODUCTDESCRIPTION, PRODUCTREGULARPRICE, PRODUCTSALEPRICE, PRODUCTPHOTO) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")",
                               product.productId, product.productName, product.productDescription, product.productRegularPrice, product.productSalePrice, product.productPhoto];
        
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

- (void)populateDatabase
{
    
    NSError* err = nil;
    NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"productModels" ofType:@"json"];
    
    NSString *myJSON = [[NSString alloc] initWithContentsOfFile:dataPath encoding:NSUTF8StringEncoding error:NULL];
    if (!myJSON) {
        NSLog(@"File couldn't be read!");
        return;
    }
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[myJSON dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&err];
    
    NSArray *items = [json valueForKeyPath:@"products"];
    Product *product = [[Product alloc] init];
    [items enumerateObjectsUsingBlock:^(NSDictionary *item , NSUInteger idx, BOOL *stop) {
        product.productId = [item objectForKey:@"productId"];
        product.productName = [item objectForKey:@"productName"];
        product.productDescription = [item objectForKey:@"productDescription"];
        product.productRegularPrice =  [item objectForKey:@"productRegularPrice"];
        product.productSalePrice = [item objectForKey:@"productSalePrice"];
        product.productPhoto =  [item objectForKey:@"productPhoto"];
        product.productColors =  [item objectForKey:@"productColors"];
        product.productStores = [item objectForKey:@"productStores"];
        NSArray *storesIdArray = [product.productStores allKeys];
        NSArray *storesNamesArray = [product.productStores allValues];
        [self insertProductIntoDatabase:product];
        for(int i=0;i<[product.productColors count];i++) {
            [self insertColorIntoDatabase:product.productId color:[product.productColors objectAtIndex:i]];
        }
        for(int i=0;i<[product.productStores count];i++) {
            [self insertStoreIntoDatabase:[storesIdArray objectAtIndex:i] productId:product.productId storeName:[storesNamesArray objectAtIndex:i]];
        }
    }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpDatabase];
    [self populateDatabase];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showProduct"]){
        JCGTableViewController *controller = (JCGTableViewController *)segue.destinationViewController;
        controller.dBPath = _dBPath;
        controller.contactDB = _contactDB;
    }
    if([segue.identifier isEqualToString:@"createProduct"]){
        JCGAddProductViewController *controller = (JCGAddProductViewController *)segue.destinationViewController;
        controller.dBPath = _dBPath;
        controller.contactDB = _contactDB;
    }
}


@end
