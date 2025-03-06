select * from "Staging".dim_product;

TRUNCATE "Staging".dim_product;

INSERT INTO public.products(
	product_id, product_name, category, subcategory)
	VALUES ('PO750', 'test', 'testcategory', 'testimonio');

-- Looking at the problem
SELECT * FROM "Staging".dim_product;

-- Setting up schema & table structure
CREATE SCHEMA core;


CREATE TABLE core.dim_product (
    Product_PK int, 
    product_id varchar(5),
    product_name varchar(100),
    category varchar(50),
    subcategory varchar(50),
    brand varchar(50)
   );
   
-- Looking at the results
SELECT * FROM core.dim_product;


-- For the sake of the test
TRUNCATE TABLE "Staging".dim_product;

DELETE FROM "Staging".dim_product WHERE product_id > 'P0057';

---Test

INSERT INTO public.products(product_id, product_name, category, subcategory)
VALUES ('P0751', 'Red Apple (Milstaso)', 'Fruits & Vegetables', 'Fruits')
;

-- Looking at the results
SELECT * FROM core.dim_product;

----
----
----  CASE STUDY GUIDE
----
----

-- Setting up source data

CREATE TABLE public.sales
(
    transaction_id integer,
    transactional_date timestamp,
   product_id character varying,
    customer_id integer,
    payment character varying,
    credit_card bigint,
    loyalty_card character varying,
    cost character varying,
    quantity integer,
    price numeric,
    PRIMARY KEY (transaction_id)
);

SELECT * FROM public.sales;
