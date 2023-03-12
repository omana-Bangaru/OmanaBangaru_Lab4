use `order-directory`;
/*
3) Display the total number of customers based on gender who have placed orders of worth at least Rs.3000.
*/
SELECT 
    cus_gender, COUNT(*)
FROM
    `order`
        INNER JOIN
    customer ON `order`.cus_id = customer.cus_id
WHERE
    ord_amount >= 3000
GROUP BY customer.cus_gender;

/*
4) Display all the orders along with product name ordered by a customer having Customer_Id=2
*/
SELECT 
    *
FROM
    `order`
        INNER JOIN
    supplier_pricing ON `order`.pricing_id = supplier_pricing.pricing_id
        INNER JOIN
    product ON supplier_pricing.pro_id = product.pro_id
WHERE
    cus_id = 2;
    
/*
5) Display the Supplier details who can supply more than one product.
*/
SELECT 
    *
FROM
    `supplier`
WHERE
    supp_id IN (SELECT 
            supp_id
        FROM
            supplier_pricing
        GROUP BY supp_id
        HAVING COUNT(*) > 1);
    
/*
6) Find the least expensive product from each category and print the table with category id, name, product name and price of the product.
*/
SELECT 
    category.cat_id,
    category.cat_name,
    MIN(t3.min_price) AS min_price
FROM
    category
        INNER JOIN
    (SELECT 
        product.cat_id, product.pro_name, t2.*
    FROM
        product
    INNER JOIN (SELECT 
        pro_id, MIN(supp_price) AS min_price
    FROM
        supplier_pricing
    GROUP BY pro_id) AS t2
    WHERE
        t2.pro_id = product.pro_id) AS t3
WHERE
    t3.cat_id = category.cat_id
GROUP BY t3.cat_id;

/*
7) Display the Id and Name of the Product ordered after “2021-10-05”.
*/
SELECT 
    product.pro_id, product.pro_name
FROM
    `order`
        INNER JOIN
    supplier_pricing ON `order`.pricing_id = supplier_pricing.pricing_id
        INNER JOIN
    product ON supplier_pricing.pro_id = product.pro_id
WHERE
    `order`.ord_date > '2021-10-05';

/*
8) Display customer name and gender whose names start or end with character 'A'.
*/
SELECT 
    cus_name, cus_gender
FROM
    customer
WHERE
    cus_name LIKE 'A%' OR cus_name LIKE '%A';

/*
9) Create a stored procedure to display supplier id, name, rating and Type_of_Service. For Type_of_Service, 
If rating =5, print “Excellent Service”,If rating >4 print “Good Service”, If rating >2 print “Average Service” else print “Poor Service”.
*/
SELECT 
    report.supp_id,
    report.supp_name,
    report.Average,
    CASE
        WHEN report.Average = 5 THEN 'Excellent Service'
        WHEN report.Average > 4 THEN 'Good Service'
        WHEN report.Average > 2 THEN 'Average Service'
        ELSE 'Poor Service'
    END AS Type_of_Service
FROM
    (SELECT 
        final.supp_id, supplier.supp_name, final.Average
    FROM
        (SELECT 
        test2.supp_id, AVG(test2.rat_ratstars) AS Average
    FROM
        (SELECT 
        supplier_pricing.supp_id, test.ORD_ID, test.RAT_RATSTARS
    FROM
        supplier_pricing
    INNER JOIN (SELECT 
        `order`.pricing_id, rating.ORD_ID, rating.RAT_RATSTARS
    FROM
        `order`
    INNER JOIN rating ON rating.`ord_id` = `order`.ord_id) AS test ON test.pricing_id = supplier_pricing.pricing_id) AS test2
    GROUP BY supplier_pricing.supp_id) AS final
    INNER JOIN supplier
    WHERE
        final.supp_id = supplier.supp_id) AS report;
        
	call proc();