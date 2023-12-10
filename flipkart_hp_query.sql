# 1:- Using Database?
use flipkart_hp_db;

# 2:- View All Record From Table?
select * from flipkart_hp;

# 3:- Find The Occurance Of The Number Of Records In The Table?
select count(*) as number_of_records from flipkart_hp;

# 4:- Show Only The Headphones Details From Boat,Zebronics,Noise Brands?
select * from flipkart_hp where company in ('boat','zebronics','noise');

# 5:- Show Only The Headphones Details From Boat,Zebronics,Noise Brands And Colour Should Be Red,Black?
select * from flipkart_hp where company in ('boat','zebronics','noise') and color in ('red','black');

# 6:- Find The Occurance Of Number Of Headphones From Each Brands For Top Three Brands?
select company,count(company) as number_of_headphones_by_each_brands from flipkart_hp group by company order by number_of_headphones_by_each_brands desc limit 3;

# 7:- Find The Occurance Of Number Of Colours Of Headphones Having Occurance Higher Than 100?
select color,count(color) as number_of_color_headphones from flipkart_hp group by color having number_of_color_headphones>100;

# 8:- Find The Occurance Of Number Of Types Of Headphones From Each Brands From Higher To Lower?
select company,type,count(type) as count_of_type_brands from flipkart_hp group by company,type order by count_of_type_brands desc;

# 9:- Find The Occurance Of The Maximum And Minimum Average Rating Of Company Headphones From Higher To Lower? 
select company,max(`Average Rating`) as maximum_average_rating,min(`Average Rating`) minimum_average_rating from flipkart_hp group by company order by maximum_average_rating desc,minimum_average_rating desc;

# 10:- Find The Discount Percentage On Each Headphone?
alter table flipkart_hp add column discount_percentage float;
delete from flipkart_hp where `Maximum Retail Price`=0;
update flipkart_hp set discount_percentage=((`Maximum Retail Price`-`Selling Price`)/`Maximum Retail Price`)*100 where discount_percentage is null;
select * from flipkart_hp limit 5;

# 11:- Apply Discount With Category discount_percentage(>=70(High Discount),>=50 and <70(Medium Discount),>=30 and <50(Low Discount),<30(Very Low Discount))
create table flipkart_hp_1
(select *,case
when discount_percentage>=70 then 'High Discount'
when (discount_percentage>=50) and (discount_percentage<70) then 'Medium Discount'
when (discount_percentage>=30) and (discount_percentage<50) then 'Low Discount'
else 'Very Low Discount'
end as discount_category
from flipkart_hp);

# 12:- Find The Occurance Of Products With Their Discount Category?
create view discount as (select discount_category,count(discount_category) as discount_category_count from flipkart_hp_1 group by discount_category);

# 13:- Assign Rank To Each Discount Category On Basis Of Their Occurance?
select *,rank() over(order by discount_category_count desc) as rank_discount_category_count from discount;
select *,row_number() over(order by discount_category_count desc) as rank_discount_category_count from discount;
select *,dense_rank() over(order by discount_category_count desc) as rank_discount_category_count from discount;