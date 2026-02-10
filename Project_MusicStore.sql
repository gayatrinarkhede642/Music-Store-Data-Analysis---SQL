-- creating a database
create database music_store;

-- use databse
use music_store;

-- 1. create table genre and media_type
create table genre(
genre_id int primary key,	
name varchar(100)
);
-- 2. create table  media_type
create table media_type(
media_type_id int primary key,	
name varchar(100)
);

-- 3. create table employee
create table employee(
employee_id int primary key,	
last_name varchar(100),
first_name varchar(100),	
title varchar(120),	
reports_to int,
levels varchar(255),	
birthdate date,
hire_date date,
address varchar(255),	
city varchar(100),	
state varchar(50),
country varchar(100),	
postal_code varchar(50),	
phone varchar(50),
fax varchar(50),
email varchar(100)
);

-- 4. create table customer
create table customer(
customer_id int primary key,	
first_name varchar(100),	
last_name varchar(100),	
company varchar(255),	
address varchar(255),	
city varchar(120),	
state varchar(50),	
country varchar(100),	
postal_code varchar(20),	
phone varchar(50),	
fax varchar(50),	
email varchar(100),	
support_rep_id int,
foreign key (support_rep_id) references employee(employee_id)
);

-- 5. create table artist
create table artist(
artist_id int primary key,
name varchar(100)
);


-- 6. create tabel album
create table album(
album_id int primary key,	
title varchar(255),	
artist_id int,
foreign key (artist_id) references artist(artist_id)
);

-- 7. create table track
create table track(
track_id int primary key,	
name varchar(255),	
album_id int,
foreign key (album_id) references album(album_id),
media_type_id int,	
foreign key (media_type_id) references media_type(media_type_id),
genre_id int,
foreign key (genre_id) references genre(genre_id),
composer varchar(255),	
milliseconds int,	
bytes int,	
unit_price decimal(10,2)
);


-- 8. create table invoice
create table invoice(
invoice_id int primary key,	
customer_id int,
foreign key (customer_id) references customer(customer_id),
invoice_date date,	
billing_address varchar(200),	
billing_city varchar(100),	
billing_state varchar(100),	
billing_country varchar(50),	
billing_postal_code varchar(50),	
total decimal(10,2)
);

-- 9 create table invoice_line
create table invoice_line(
invoice_line_id int primary key,	
invoice_id int,
foreign key (invoice_id) references invoice(invoice_id),
track_id int,
foreign key (track_id) references track(track_id),	
unit_price decimal(10,2),	
quantity int
);

-- 10. create table playlist
create table playlist(
playlist_id int primary key,	
name varchar(100)
);

-- 11. create table playlist_track
create table playlist_track(
playlist_id int,
foreign key (playlist_id) references playlist(playlist_id),
track_id int,
foreign key (track_id) references track(track_id)
); 

select * from genre;
select * from media_type;
select * from employee;
select * from customer;
select * from artist;
select * from album;
select * from track;
select * from invoice;
select * from invoice_line;
select * from playlist;
select * from playlist_track;


-- Import track
LOAD DATA INFILE  'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/track.csv'
INTO TABLE  track
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(track_id, name, album_id, media_type_id, genre_id, composer, milliseconds, bytes, unit_price);



select count(*) from track;