DROP DATABASE IF EXISTS QA;
CREATE DATABASE QA;

use QA;

-- Role utilisateur 
-- Valeur de base a intégrer
-- ROLE_CUSTOMER / ROLE_ADMIN
-- peut être modifié (CRUD)
CREATE TABLE user_role (
	row_id int(11) not null primary key auto_increment,
    label varchar(50) not null unique
);

-- Allergène
-- Valeur de base a intégrer
-- Produits à base de : céréales, crustacées, oeufs, arachides, poissons, sojas,
-- coques, céléri, moutardes, sésames, lupin, mollusques, lait, anhydride et sulfites 
-- Inchangeable
CREATE TABLE allergen (
	row_id int(11) not null primary key auto_increment,
    label varchar(100) not null
);

-- Utilisateur
-- Aucune valeur de base
CREATE TABLE users (
	row_id int(11) not null primary key auto_increment,
    email varchar(250) not null unique,
    pass binary(64) not null,
    lastname varchar(50) not null,
    firstname varchar(50) not null,
    role_id int(11) not null,
    foreign key (role_id) references user_role(row_id)
);

-- Client
-- Aucune valeur de base
CREATE TABLE customer (
	row_id int(11) not null primary key, 
    phone varchar(10),
    default_covers tinyint not null,
    foreign key (row_id) references users(row_id)
);

-- Admin
-- Valeur de base à intégrer :
-- Compte réceptionniste
CREATE TABLE administrator (
	row_id int(11) not null primary key,
    foreign key (row_id) references users(row_id)
);

-- Réservation
-- Aucune valeur de base
CREATE TABLE booking (
	row_id int(11) not null primary key auto_increment,
    booking_date datetime not null,
    covers tinyint not null,
    customer_id int(11),
    customer_firstname varchar(100) not null,
    customer_lastname varchar(100) not null,
    customer_phone varchar(20) not null,
    customer_mail varchar(200) not null,
    message longtext,
    foreign key (customer_id) references customer(row_id)
);

-- Relation client allergène
CREATE TABLE customer_allergen (
	customer_id int(11) not null,
    allergen_id int(11) not null,
    primary key (customer_id, allergen_id),
    foreign key (customer_id) references customer(row_id),
    foreign key (allergen_id) references allergen(row_id)
);

-- Relation réservation allergène
CREATE TABLE booking_allergen (
	booking_id int(11) not null,
    allergen_id int(11) not null,
    primary key (booking_id, allergen_id),
    foreign key (booking_id) references booking(row_id),
    foreign key (allergen_id) references allergen(row_id)
);

-- Menu
-- Aucune valeur de base
-- Peut être modifié CRUD
CREATE TABLE menu (
	row_id int(11) not null primary key auto_increment,
    set_menu_id int(11) not null,
    title varchar(100) not null,
    foreign key (set_menu_id) references set_menu(row_id)
);

-- Formule
-- Aucune valeur de base
-- Peut être modifié CRUD
CREATE TABLE set_menu (
	row_id int(11) not null primary key auto_increment,
    title varchar(100) not null,
    summary longtext not null,
    price smallint not null
);

-- Catégorie de Plat
-- Valeur de base à intégrer:
-- Entrées, Plat chaud, Dessert, 
CREATE TABLE course_cat (
	row_id int(11) not null primary key auto_increment,
    label varchar(100) not null
);

-- Plat
-- Aucune valeur de base
-- Peut être modifié par CRUD
CREATE TABLE course (
	row_id int(11) not null primary key auto_increment,
    title varchar(100) not null,
    summary longtext not null,
    price smallint not null,
    category_id int(11) not null,
    foreign key (category_id) references course_cat(row_id)
);

CREATE TABLE category_course_set_menu (
	category_id int(11) not null,
    set_menu_id int(11) not null,
    primary key (category_id, set_menu_id),
    foreign key (category_id) references course_cat(row_id),
    foreign key (set_menu_id) references set_menu(row_id)
);

CREATE TABLE menu_course (
	course_id int(11) not null,
    menu_id int(11) not null,
    primary key (course_id, menu_id),
    foreign key (course_id) references course(row_id),
    foreign key (menu_id) references menu(row_id)
);

-- Horaires
-- Valeur de base à intégrer :
-- les jours de la semaine
-- Peut être modifié (pas de création de jour)
-- et label_day inchangeable
CREATE TABLE hours (
	row_id int(11) not null primary key auto_increment,
    label_day varchar(20) not null,						-- version affichée du jour
    opening varchar(5) not null,
    closure varchar(5) not null,
    is_open tinyint,									-- ouvert ce jour ?
    lunch tinyint,										-- true => midi , false => dinner
    label varchar(20) not null,							-- version anglophone du jour utilisée dans le code php
    max_booking tinyint
);

INSERT INTO user_role (label) VALUES
	('ROLE_ADMIN'),
    ('ROLE_CUSTOMER');
    
INSERT INTO users (email, pass, lastname, firstname, role_id) VALUES 
	( 'reception-quaiantique@mail.com', 'binarypass', 'Jean', 'Martin', 1);

INSERT INTO allergen (label) VALUES
	('Produit à base de céréales'),
    ('Produit à base de crustacées'),
    ('Produit à base d\'oeufs'),
    ('Produit à base d\'arachides'),
    ('Produit à base de poissons'),
    ('Produit à base de soja'),
    ('Produit laitiers'),
    ('Produit à base de fruits à coque'),
    ('Produit à base de Céleri'),
    ('Produit à base de moutarde'),
    ('Produit à base de graines de sésame'),
    ('Anhydride sulfureux et sulfites'),
    ('Produit à base de lupin'),
    ('Produit à base de mollusques');
    
INSERT INTO course_at (label) VALUES
	('Entrées'),
    ('Plats'),
    ('Desserts'),
    ('Vins'),
    ('Apéritifs');
    
INSERT INTO hours (label_day, opening, closure, is_open, lunch, label, max_booking) VALUES
	('Lundi', '00:00', '00:00', 0, 1, 'monday', 5),
	('Lundi', '00:00', '00:00', 0, 0, 'monday', 5),
	('Mardi', '00:00', '00:00', 0, 1, 'tuesday', 5),
	('Mardi', '18:30', '22:00', 1, 0, 'tuesday', 5),
	('Mercredi', '12:00', '14:00', 1, 1, 'wednesday', 5),
	('Mercredi', '18:30', '22:00', 1, 0, 'wednesday', 5),
	('Jeudi', '12:00', '14:00', 1, 1, 'thursday', 5),
	('Jeudi', '18:30', '22:00', 1, 0, 'thursday', 5),
	('Vendredi', '12:00', '14:00', 1, 1, 'friday', 5),
	('Vendredi', '18:30', '22:00', 1, 0, 'friday', 5),
	('Samedi', '11:20', '14:30', 1, 1, 'saturday', 5),
	('Samedi', '18:30', '22:30', 1, 0, 'saturday', 5),
	('Dimanche', '11:20', '14:30', 1, 1, 'sunday', 5),
	('Dimanche', '00:00', '00:00', 0, 0, 'sunday', 5);
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    