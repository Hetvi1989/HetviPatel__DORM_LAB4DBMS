create database e_commerce;
use e_commerce;
create table if not exists supplier (
supp_id int unsigned primary key,
supp_name varchar(50) not null,
supp_city varchar(50) not null,
supp_phone varchar(50) not null
);
create table if not exists customer(
cus_id int unsigned primary key,
cus_name varchar(50) not null,
cus_phone varchar (15) not null,
cus_gender enum('M','F') not null,
cus_city varchar(15) not null,
cus_email varchar(20) not null unique
);
create table if not exists category (
cat_id int unsigned primary key,
cat_name varchar(20) not null,
parent_cat_id int unsigned ,
foreign key(parent_cat_id) references category(cat_id)
);
create table if not exists product(
pro_id int unsigned primary key,
pro_name varchar(50) not null default'dummy',
pro_desc varchar(60),
cat_id int unsigned not null,
foreign key (cat_id) references category(cat_id)
);
create table if not exists supplier_pricing(
pricing_id int unsigned primary key,
pro_id int unsigned,
supp_id int unsigned,
supp_price int default 0,
foreign key(pro_id) references product(pro_id),
foreign key(supp_id) references supplier(supp_id)
);
create table if not exists `order`(
 ord_id int unsigned primary key,
 ord_amount int not null,
 ord_date date not null,
 cust_id int unsigned,
 pricing_id int unsigned,
 foreign key(cust_id) references customer(cus_id),
 foreign key(pricing_id) references supplier_pricing(pricing_id)
);
create table if not exists rating(
	rat_id int unsigned primary key,
    ord_id int unsigned,
    rat_ratstars int not null,
    foreign key (ord_id) references `order`(ord_id)
);
INSERT INTO supplier VALUES
(1,"Rajesh Retails","Delhi",'1234567890'),
(2,"Appario Ltd.","Mumbai",'2589631470'),
(3,"Knome products","Banglore",'9785462315'),
(4,"Bansal Retails","Kochi",'8975463285'),
(5,"Mittal Ltd.","Lucknow",'7898456532');
alter table customer modify cus_email varchar(30);
INSERT INTO customer VALUES
(1,"AAKASH",'9999999999','M', "DELHI","aakash@gmail.com");
use e_commerce;
INSERT INTO customer VALUES
(2,"AMAN",'9823456781','M',"NOIDA","aman@gmail.com"),
(3,"NEHA",'9234678921','F',"MUMBAI","neha@gmail.com"),
(4,"MEGHA",'9342184563','F',"KOLKATA","megha@gnail.con"),
(5,"PULKIT",'9234578695','M',"LUCKNOW","pulkit@gmail.com");

INSERT INTO category VALUES
( 1,"BOOKS",1),
(2,"GAMES",2),
(3,"GROCERIES",3),
(4,"ELECTRONICS",4),
(5,"CLOTHES",5);

INSERT INTO product VALUES
(1,"GTA V","Windows 7 and above with i5 processor and 8GB RAM",2),
(2,"TSHIRT","SIZE-L with Black, Blue and White variations",5),
(3,"ROG LAPTOP","Windows 10 with 15inch screen, i7 processor, 1TB SSD",4),
(4,"OATS","Highly Nutritious from Nestle",3),
(5,"HARRY POTTER","Best Collection of all time by J.K Rowling",1),
(6,"MILK","1L Toned MIlk",3),
(7,"Boat EarPhones","1.5Meter long Dolby Atmos",4),
(8,"Jeans","Stretchable Denim Jeans with various sizes and color",5),
(9,"Project IGI","compatible with windows 7 and above",2),
(10,"Hoodie","Black GUCCI for 13 yrs and above",5),
(11,"Rich Dad Poor Dad","Written by RObert Kiyosaki",1),
(12,"Train Your Brain","By Shireen Stephen",1);

INSERT INTO supplier_pricing VALUES
(1,1,2,1500),
(3,5,1,3000),
(4,2,3,2500),
(5,4,1,1000),
(6,12,2,780),
(7,12,4,789),
(8,3,1,31000),
(9,1,5,1450),
(10,4,2,999),
(11,7,3,549),
(12,7,4,529),
(13,6,2,105),
(14,6,1,99),
(15,2,5,2999),
(16,5,2,2999);

INSERT INTO `order` VALUES 
(101,1500,"2021-10-06",2,1),
(102,1000,"2021-10-12",3,5),
(103,30000,"2021-09-16",5,3),
(104,1500,"2021-10-05",1,1),
(105,3000,"2021-08-16",4,3),
(106,1450,"2021-08-18",1,9),
(107,789,"2021-09-01",3,7),
(108,780,"2021-09-07",5,6),
(109,3000,"2021-09-10",5,3),
(110,2500,"2021-09-10",2,4),
(111,1000,"2021-09-15",4,5),
(112,789,"2021-09-16",4,7),
(113,31000,"2021-09-16",1,8),
(114,1000,"2021-09-16",3,5),
(115,3000,"2021-09-16",5,3),
(116,99,"2021-09-17",2,14);

INSERT INTO rating VALUES
(1,101,4),
(2,102,3),
(3,103,1),
(4,104,2),
(5,105,4),
(6,106,3),
(7,107,4),
(8,108,4),
(9,109,3),
(10,110,5),
(11,111,3),
(12,112,4),
(13,113,2),
(14,114,1),
(15,115,1),
(16,116,0);

-- Query no.:3 --
select  c.cus_gender as Customer_Gender, count(*) as Order_Count, sum(o.ord_amount) as Order_amount from customer as c 
inner join `order` as o on o.cust_id = c.cus_id where 
ord_amount >= 3000 group by c.cus_gender;

-- Query no.: 4 --
select * from product as p where p.pro_id IN
(select pro_id from `order` as o inner join supplier_pricing as s on o.pricing_id = s.pricing_id and o.cust_id = 2);

-- Query no.: 5 --
select supplier.* from supplier where supplier.supp_id in
(select supp_id from supplier_pricing group by supp_id having count(supp_id)>1) 
group by supplier.supp_id;

-- Query no.: 6 --
select c.cat_id, c. cat_name, p.pro_name, min(sp.supp_price) from supplier_pricing as sp
left join product as p on sp.pro_id = p.pro_id
left join category as c on p.cat_id= c.cat_id group by c.cat_id order by c.cat_id asc;

-- Query no.: 7 --
select p.pro_id, p.pro_name,o.ord_id,o.ord_date from product as p 
right join supplier_pricing as sp on p.pro_id=sp.pro_id 
left join `order` as o on (sp.pricing_id = o.pricing_id) group by o.ord_date having o.ord_date > '2021-10-05';

-- Query no.: 8 --
select customer.cus_name,customer.cus_gender from customer where customer.cus_name like 'A%' ;

-- Query no.: 9 --
DELIMITER &&
create procedure Type_of_Service()
BEGIN
select s.supp_id as supplier_id,s.supp_name as supplier_name, avg(r.rat_ratstars) as supplier_rating,
case
when r.rat_ratstars = 5 then "Excellent Service"
when r.rat_ratstars > 4 then "Good Service"
when r.rat_ratstars > 2 then "Average Service"
else "Poor Service"
end as `Type_of_Service`
from supplier as s, rating as r, supplier_pricing as sp, `order` as o
where r.ord_id = o.ord_id and o.pricing_id = sp.pricing_id
and sp.supp_id = s.supp_id
group by s.supp_id
order by s.supp_id asc;
END&& 
call Type_of_Service();