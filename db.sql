-- Table Users
CREATE TABLE Users (
  user_id UUID PRIMARY KEY,
  email VARCHAR(255),
  password VARCHAR(150)
);

-- Table UserClient
CREATE TABLE UserClient (
  id_user_cl UUID PRIMARY KEY,
  id_main INTEGER,
  address VARCHAR(60),
  phone VARCHAR(20),
  birthday DATE,
  nombre VARCHAR(60)
  --empresa_id INTEGER -- Uncomment if Foreign Key needed
);

-- Table UserGroupAction
CREATE TABLE UserGroupAction (
  id_GrAc UUID PRIMARY KEY,
  id_client UUID REFERENCES UserClient(id_user_cl),
  id_group UUID,
  action VARCHAR(10)  -- 'enter' or 'leave'
);

-- Table GroupFijo
CREATE TABLE GroupFijo (
  id_gr UUID PRIMARY KEY,
  enter_code VARCHAR(10),
  capacidad INTEGER,
  current_quantity INTEGER,
  fecha_hora_comida_start TIMESTAMP,
  fecha_hora_comida_end TIMESTAMP
);

-- Table GroupCode
CREATE TABLE GroupCode (
  id_gr UUID PRIMARY KEY,
  enter_code UUID,
  capacidad INTEGER,
  current_quantity INTEGER,
  fecha_start TIMESTAMP,
  fecha_end TIMESTAMP,
  hora_star TIME,
  hora_end TIME
);

-- Table UserRestaurant
CREATE TABLE UserRestaurant (
  id_user_rst UUID PRIMARY KEY,
  id_usermain UUID,
  id_restaurant UUID,
  rst_name VARCHAR(50),
  sede VARCHAR(50)
);

-- Table UserWorker
CREATE TABLE UserWorker (
  id_user_worker UUID PRIMARY KEY,
  user_worker_password VARCHAR(255),
  id_U_R UUID REFERENCES UserRestaurant(id_user_rst),
  nombre_worker VARCHAR(50),
  apellido_worker VARCHAR(50),
  sede_current VARCHAR(20)
);

-- Table Restaurant
CREATE TABLE Restaurant (
  id_restaurant UUID PRIMARY KEY,
  name_restaurant VARCHAR(30),
  address_restaurant VARCHAR(50),
  type VARCHAR(30),
  rating FLOAT,
  phone_restaurant INTEGER,
  email VARCHAR(100)
);

-- Table Platillo
CREATE TABLE Platillo (
  id_plt UUID PRIMARY KEY,
  id_restaurant UUID REFERENCES Restaurant(id_restaurant)
  name_plt VARCHAR(35),
  price FLOAT
);

-- Table Bebida
CREATE TABLE Bebida (
  id_beb UUID PRIMARY KEY,
  id_restaurant UUID REFERENCES Restaurant(id_restaurant)
  name_beb VARCHAR(30),
  price FLOAT
);

-- Table PlatilloDescr
CREATE TABLE PlatilloDescr (
  id_platdscr UUID PRIMARY KEY,
  id_plat UUID REFERENCES Platillo(id_plt),
  id_descrip UUID
);

-- Table BebdDescr
CREATE TABLE BebdDescr (
  id_platdscr UUID PRIMARY KEY,
  id_bebd UUID REFERENCES Bebida(id_beb),
  id_descrip UUID
);

-- Table Description_Offer
CREATE TABLE Description_Offer (
  id_description UUID PRIMARY KEY,
  code_oferta VARCHAR(30) UNIQUE,  -- Aquí añadimos la restricción UNIQUE
  description_text TEXT,
  imagen_url VARCHAR(255)
);

-- Table Offer
CREATE TABLE Offer (
  id_offer UUID PRIMARY KEY,
  id_rst_offer UUID REFERENCES Restaurant(id_restaurant),
  code VARCHAR(20) REFERENCES Description_Offer(code_oferta),  -- Referencia a code_oferta que ahora es UNIQUE
  name VARCHAR(100),
  precio FLOAT,
  type VARCHAR(20)
);

-- Table Sede
CREATE TABLE Sede (
  id_sede UUID PRIMARY KEY,
  country VARCHAR(50),
  department VARCHAR(50),
  province VARCHAR(50),
  UNIQUE (country, department, province)
);

-- Table Restaurant_Sede
CREATE TABLE Restaurant_Sede (
  id UUID PRIMARY KEY,
  id_restaurant UUID REFERENCES Restaurant(id_restaurant),
  id_sede UUID REFERENCES Sede(id_sede),
  UNIQUE (id_restaurant, id_sede)
);

-- Foreign Key Relationships
ALTER TABLE UserClient ADD CONSTRAINT fk_user_client FOREIGN KEY (id_user_cl) REFERENCES Users(user_id);
ALTER TABLE UserRestaurant ADD CONSTRAINT fk_user_restaurant FOREIGN KEY (id_user_rst) REFERENCES Users(user_id);
ALTER TABLE UserGroupAction ADD CONSTRAINT fk_group_fijo FOREIGN KEY (id_group) REFERENCES GroupFijo(id_gr);
ALTER TABLE UserGroupAction ADD CONSTRAINT fk_group_code FOREIGN KEY (id_group) REFERENCES GroupCode(id_gr);
ALTER TABLE PlatilloDescr ADD CONSTRAINT fk_platillo_descr FOREIGN KEY (id_descrip) REFERENCES Description_Offer(id_description);
ALTER TABLE BebdDescr ADD CONSTRAINT fk_bebida_descr FOREIGN KEY (id_descrip) REFERENCES Description_Offer(id_description);
ALTER TABLE Offer ADD CONSTRAINT fk_offer_descr FOREIGN KEY (code) REFERENCES Description_Offer(code_oferta);
