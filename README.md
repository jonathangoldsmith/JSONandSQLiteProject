JSONandSQLiteProject
====================

Using a self created JSON library, this project creates a library of clothing products using SQLite to view in a table.
Select the product to see more info, click on the product image to see a full screen image.
SQLite Update function used to change the prices (Save button), SQLite Delete function used to delete the product (trashcan).
The UIPicker is implemented only for the socks, where selecting a different color will change the image posted.
The Create Product button is used to insert new products, but the only images allowed are those already in the app, 
set the product image as "shoes" for a new shoe product. Highlight colors/stores to associate them with the product.

A faulty ER diagram caused most of my issues, when I seperated the stores from the products everything more or less fell into place
I am unfamiliar with unit tests but would add them in a future installment. 
The stores/color selecting was my way of creating a multi-selection UISegemntedControl.  
