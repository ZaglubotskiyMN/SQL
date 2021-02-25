CREATE TABLE timezone
( timezone_id SERIAL NOT NULL,
  time_offset TEXT NOT NULL,
 CONSTRAINT timezone__pk PRIMARY KEY(timezone_id),
 CONSTRAINT timezone__offset__uk UNIQUE(time_offset)
);

CREATE TABLE city
( city_id SERIAL NOT NULL,
 name VARCHAR(30) NOT NULL,
 timezone_id INTEGER NOT NULL,
 CONSTRAINT city__pk PRIMARY KEY(city_id),
 CONSTRAINT store__pk__city__to__timezone FOREIGN KEY(timezone_id) REFERENCES timezone(timezone_id) 
);

CREATE TABLE store
(store_id SERIAL NOT NULL,
 name VARCHAR(30) NOT NULL,
 site_url TEXT,
 CONSTRAINT store__pk PRIMARY KEY (store_id),
 CONSTRAINT store__name__uk UNIQUE (name)
);

CREATE TABLE store_address 
( store_address_id SERIAL NOT NULL,
 store_id INTEGER NOT NULL,
 city_id INTEGER NOT NULL,
 address TEXT NOT NULL,
 opening_hours TEXT,
 phone TEXT,
 CONSTRAINT store_address__pk PRIMARY KEY(store_address_id),
 CONSTRAINT store_address__address__UK UNIQUE (store_id,city_id,address),
 CONSTRAINT store_address__to__store FOREIGN KEY (store_id) REFERENCES store (store_id),
 CONSTRAINT store_address__to__city FOREIGN KEY (city_id) REFERENCES city (city_id)
);

CREATE INDEX store_address__city_id ON store_address(city_id);
CREATE TABLE category 
( category_id SERIAL NOT NULL,
 parent_category_id INTEGER,
 name VARCHAR(30) NOT NULL,
 CONSTRAINT category__pk PRIMARY KEY(category_id),
 CONSTRAINT category__parent__fk FOREIGN KEY (parent_category_id) REFERENCES category (category_id),
 CONSTRAINT category__name__uk UNIQUE (parent_category_id, name)
);

CREATE INDEX category__parent_category_id ON category (parent_category_id);
CREATE TABLE product 
( product_id SERIAL NOT NULL,
 category_id INTEGER NOT NULL,
 name VARCHAR(30),
 description TEXT,
 CONSTRAINT product__pk PRIMARY KEY(product_id),
 CONSTRAINT product__to__category FOREIGN KEY (category_id) REFERENCES category (category_id),
 CONSTRAINT product__name__uk UNIQUE (category_id,name)
);

CREATE INDEX product__name ON product (name);

CREATE TABLE product_price
( product_id INTEGER NOT NULL,
 store_id INTEGER NOT NULL,
 price NUMERIC (15,2) NOT NULL,
 CONSTRAINT product_price__pk PRIMARY KEY(product_id, store_id),
 CONSTRAINT product_price__price__ck CHECK (price >0)
);

CREATE INDEX product_price__store_id ON product_price (store_id);

CREATE TABLE rank
( store_id INTEGER NOT NULL,
 rank_id INTEGER NOT NULL,
 name TEXT NOT NULL,
 CONSTRAINT rank__pk PRIMARY KEY (store_id,rank_id),
 CONSTRAINT rank_to_store FOREIGN KEY (store_id) REFERENCES store (store_id)
);

CREATE TABLE employee 
( employee_id SERIAL NOT NULL,
 store_id INTEGER NOT NULL,
 rank_id INTEGER NOT NULL,
 first_name TEXT NOT NULL,
 last_name TEXT NOT NULL,
 middle_name TEXT,
 manager_id INTEGER,
 CONSTRAINT employee__pk PRIMARY KEY(employee_id),
 CONSTRAINT employee__to__renk FOREIGN KEY (store_id,rank_id) REFERENCES rank (store_id,rank_id),
 CONSTRAINT employee_manager__fk FOREIGN KEY (manager_id) REFERENCES employee (employee_id)
 );
 
 CREATE INDEX employee__manager_id ON employee (manager_id);
 
 CREATE TABLE purchase 
 ( purchase_id SERIAL NOT NULL,
  purchase_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
  store_id INTEGER NOT NULL,
  employee_id INTEGER,
  CONSTRAINT purchase__pk PRIMARY KEY (purchase_id),
  CONSTRAINT purchase__to__employee FOREIGN KEY (employee_id) REFERENCES employee (employee_id),
  CONSTRAINT purchase__to__store FOREIGN KEY (store_id) REFERENCES store (store_id)
  );
  
  CREATE INDEX purchase__employee_id ON purchase (employee_id);
  CREATE TABLE purchase_item 
  ( purchase_item_id SERIAL NOT NULL,
   purchase_id INTEGER NOT NULL,
   product_id INTEGER NOT NULL,
   price NUMERIC (15,2) NOT NULL,
   count INTEGER NOT NULL,
   CONSTRAINT purchase_item__pk PRIMARY KEY (purchase_item_id),
   CONSTRAINT purchase_item__product__uk UNIQUE (purchase_id, product_id),
   CONSTRAINT purchase_item__to__purchase FOREIGN KEY (purchase_id) REFERENCES purchase (purchase_id),
   CONSTRAINT purchase_item__to__product FOREIGN KEY (product_id) REFERENCES product (product_id),
   CONSTRAINT purchase_item__price__ck CHECK (price >0),
   CONSTRAINT purchase_item__count__ck CHECK (count >0)
  );
  
  CREATE INDEX purchase_item__product_id ON purchase_item (product_id);
  
