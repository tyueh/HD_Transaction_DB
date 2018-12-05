-- Drop tables
DROP TABLE orders;
DROP TABLE items;
DROP TABLE invoices;
DROP TABLE ccinfo;
DROP TABLE employees;
DROP TABLE customers;
DROP TABLE stores;
DROP TABLE zipcodes;


-- DDL generated from physical model
--------------------------------------------------------------------
CREATE TABLE ccinfo (
    ccno                   CHAR(16) NOT NULL,
    type                   VARCHAR2(10),
    exp                    CHAR(5),
    customers_customerno   VARCHAR2(10) NOT NULL
);

ALTER TABLE ccinfo ADD CONSTRAINT ccinfo_pk PRIMARY KEY ( ccno );

CREATE TABLE customers (
    customerno         VARCHAR2(10) NOT NULL,
    name               VARCHAR2(30),
    street             VARCHAR2(30),
    phone              CHAR(10),
    workphone          CHAR(10),
    ext                VARCHAR2(10),
    fax                CHAR(10),
    taxexempt          CHAR(1),
    pono               CHAR(9),
    taxno              CHAR(10),
    account            CHAR(5),
    zipcodes_zipcode   CHAR(5) NOT NULL
);

ALTER TABLE customers ADD CONSTRAINT customers_pk PRIMARY KEY ( customerno );

CREATE TABLE employees (
    employee      CHAR(3) NOT NULL,
    stores_name   VARCHAR2(40) NOT NULL
);

ALTER TABLE employees ADD CONSTRAINT employees_pk PRIMARY KEY ( employee );

ALTER TABLE employees ADD CONSTRAINT employees_employee_un UNIQUE ( employee );

CREATE TABLE invoices (
    invoiceno              VARCHAR2(10) NOT NULL,
    invoicedate            DATE,
    invoicetime            VARCHAR2(8),
    discount               FLOAT,
    deductible             FLOAT,
    shippingcharge         FLOAT,
    flatcharge             FLOAT,
    downpmt                FLOAT,
    layawaypmt             FLOAT,
    paymentmethodcash      FLOAT,
    paymentmethodcheck     FLOAT,
    paymentmethodcc        FLOAT,
    paymentmethodgc        FLOAT,
    onaccount              FLOAT,
    ckno                   FLOAT,
    customers_customerno   VARCHAR2(10) NOT NULL,
    stores_name            VARCHAR2(40) NOT NULL,
    employees_employee     CHAR(3) NOT NULL,
    ccinfo_ccno            CHAR(16)
);

ALTER TABLE invoices ADD CONSTRAINT invoices_pk PRIMARY KEY ( invoiceno );

CREATE TABLE items (
    itemno        VARCHAR2(10) NOT NULL,
    description   VARCHAR2(20),
    retailprice   FLOAT
);

ALTER TABLE items ADD CONSTRAINT items_pk PRIMARY KEY ( itemno );

CREATE TABLE orders (
    items_itemno         VARCHAR2(10) NOT NULL,
    invoices_invoiceno   VARCHAR2(10) NOT NULL,
    del_qty              INTEGER,
    so_qty               INTEGER
);

ALTER TABLE orders ADD CONSTRAINT orders_pk PRIMARY KEY ( items_itemno,invoices_invoiceno );

CREATE TABLE stores (
    name               VARCHAR2(40) NOT NULL,
    street             VARCHAR2(30),
    phone              CHAR(10),
    fax                CHAR(10),
    console            CHAR(3),
    policy             VARCHAR2(256),
    zipcodes_zipcode   CHAR(5) NOT NULL
);

ALTER TABLE stores ADD CONSTRAINT stores_pk PRIMARY KEY ( name );

CREATE TABLE zipcodes (
    zipcode   CHAR(5) NOT NULL,
    city      VARCHAR2(20),
    state     CHAR(2),
    rate      FLOAT
);

ALTER TABLE zipcodes ADD CONSTRAINT zipcodes_pk PRIMARY KEY ( zipcode );

ALTER TABLE ccinfo
    ADD CONSTRAINT ccinfo_customers_fk FOREIGN KEY ( customers_customerno )
        REFERENCES customers ( customerno );

ALTER TABLE customers
    ADD CONSTRAINT customers_zipcodes_fk FOREIGN KEY ( zipcodes_zipcode )
        REFERENCES zipcodes ( zipcode );

ALTER TABLE employees
    ADD CONSTRAINT employees_stores_fk FOREIGN KEY ( stores_name )
        REFERENCES stores ( name );

ALTER TABLE invoices
    ADD CONSTRAINT invoices_ccinfo_fk FOREIGN KEY ( ccinfo_ccno )
        REFERENCES ccinfo ( ccno );

ALTER TABLE invoices
    ADD CONSTRAINT invoices_customers_fk FOREIGN KEY ( customers_customerno )
        REFERENCES customers ( customerno );

ALTER TABLE invoices
    ADD CONSTRAINT invoices_employees_fk FOREIGN KEY ( employees_employee )
        REFERENCES employees ( employee );

ALTER TABLE invoices
    ADD CONSTRAINT invoices_stores_fk FOREIGN KEY ( stores_name )
        REFERENCES stores ( name );

ALTER TABLE orders
    ADD CONSTRAINT orders_invoices_fk FOREIGN KEY ( invoices_invoiceno )
        REFERENCES invoices ( invoiceno );

ALTER TABLE orders
    ADD CONSTRAINT orders_items_fk FOREIGN KEY ( items_itemno )
        REFERENCES items ( itemno );

ALTER TABLE stores
    ADD CONSTRAINT stores_zipcodes_fk FOREIGN KEY ( zipcodes_zipcode )
        REFERENCES zipcodes ( zipcode );



-- populate data
--------------------------------------------------------------------
insert into zipcodes values('60626', 'GLENVIEW', 'IL', 0.082500);
insert into zipcodes values('60645', 'CHICAGO', 'IL', 0.087500);
insert into zipcodes values('60604', 'CHICAGO', 'IL', null);

insert into customers values('2250', 'JIM SHOE', '1 E JACKSON BLVD', '3123628381', '0000000000','', '0000000000','N', '', '', '', '60604');
insert into customers values('30086', 'SPEED RACER', '243 S WABASH AVE', '3125551212', '0000000000','', '0000000000', 'N', '', '', '', '60604');

insert into ccinfo values('XXXXXXXXXXXX0866', 'MC', '11/04', '30086');

insert into stores values('CHICAGO H-D SHOP', '2929 PATRIOT BLVD', '8474182929', '8474126868', '020', 'AAA', '60626');
insert into stores values('CHICAGO HARLEY-DAVIDSON, INC.', '6868 N. WESTERN AVE.', '7733386868', '7733388868', '010', 'BBB', '60645');

insert into employees values('EOS', 'CHICAGO H-D SHOP');
insert into employees values('RPF', 'CHICAGO HARLEY-DAVIDSON, INC.');

insert into items values('16554-92A', 'CYLINDER, SILVER', 139.95);
insert into items values('22698-01', 'SE XL 883/1200 PIS', 279.95);
insert into items values('59263-79', 'REFLECTOR', 2.50);
insert into items values('59988-72A', 'REFLECTOR, RED', 4.20);
insert into items values('70404-99Y', 'SWITCH ASSY, R.H', 21.80);
insert into items values('M0737.M', 'DECAL, TAIL SECTI', 5.95);
insert into items values('69112-95B', 'HORN KIT, CHROM', 79.95);
insert into items values('17048-98', 'GASKET KIT,EXHA', 7.95);
insert into items values('17056-01', 'KIT, HEAD GASKET', 24.95);

insert into invoices values('36107', '11-NOV-2006', '3:16 PM', 0.30, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 424.21, 0.00, 0.00, '0', '2250','CHICAGO H-D SHOP','EOS', null);
insert into invoices values('346221', '10-NOV-2003', '12:31 PM', 0.20, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 69.56, 0.00, 0.00, '0', '30086','CHICAGO HARLEY-DAVIDSON, INC.', 'RPF', 'XXXXXXXXXXXX0866');
insert into invoices values('38804', '12-APR-2006', '6:45 PM', 0.25, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 26.70, 0.00, 0.00, '0','2250', 'CHICAGO H-D SHOP','EOS', null);

insert into orders values('16554-92A','36107', 2, 0);
insert into orders values('22698-01','36107', 1, 0);
insert into orders values('59263-79','36107', 0, 5);
insert into orders values('59988-72A','36107', 0, 2);
insert into orders values('70404-99Y','36107', 0, 1);
insert into orders values('M0737.M','36107', 0, 2);
insert into orders values('69112-95B','346221', 1, 0);
insert into orders values('17048-98','38804', 1, 0);
insert into orders values('17056-01','38804', 1, 0);



-- SQL queries
--------------------------------------------------------------------
-- How many parts did Jim Shoe purchase in November, 2006?
select  sum(orders.del_qty) as parts_purchase_count
from    invoices,
        customers,
        orders
where   invoices.CUSTOMERS_CUSTOMERNO = customers.CUSTOMERNO
and     invoices.INVOICENO = orders.INVOICES_INVOICENO
and     customers.name = 'JIM SHOE'
and     invoices.INVOICEDATE between '01-NOV-06' and '30-NOV-06';

-- What was the total amount of all purchases by Speed Racer?
select  round(sum(invoices.DEDUCTIBLE + invoices.SHIPPINGCHARGE + invoices.FLATCHARGE + 
        sum((ITEMS.RETAILPRICE*ORDERS.DEL_QTY) * (1-invoices.discount) * (1+zipcodes.rate))),2) as all_time_total_amount_Due
from    customers,
        invoices,
        orders,
        stores,
        zipcodes,
        items
where   invoices.CUSTOMERS_CUSTOMERNO = customers.CUSTOMERNO
and     invoices.invoiceno = orders.INVOICES_INVOICENO
and     items.itemno = orders.ITEMS_ITEMNO
and     invoices.stores_name = stores.NAME
and     stores.ZIPCODES_ZIPCODE = zipcodes.ZIPCODE
and     customers.name = 'SPEED RACER'
group by invoices.INVOICENO, invoices.DEDUCTIBLE, invoices.SHIPPINGCHARGE, invoices.FLATCHARGE;

