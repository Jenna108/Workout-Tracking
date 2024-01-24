--Create the postgis extension so it can be used, verify version if needed
CREATE EXTENSION postgis;
--SELECT PostGIS_Full_Version();

--Drop tables if they already exist
DROP TABLE IF EXISTS gym_type;
DROP TABLE IF EXISTS gym;
DROP TABLE IF EXISTS gym_location;
DROP TABLE IF EXISTS app;
DROP TABLE IF EXISTS youtube_channel;
DROP TABLE IF EXISTS friend;
DROP TABLE IF EXISTS instructor;
DROP TABLE IF EXISTS instructor_list;
DROP TABLE IF EXISTS workout_type;
DROP TABLE IF EXISTS intensity;
DROP TABLE IF EXISTS live_class;
DROP TABLE IF EXISTS recorded_class;
DROP TABLE IF EXISTS registered_program;
DROP TABLE IF EXISTS workshop;
DROP TABLE IF EXISTS workout;

--Create all tables
CREATE TABLE gym_type (
	id INT GENERATED ALWAYS AS IDENTITY,
	description VARCHAR(50) NOT NULL,
	PRIMARY KEY(id)
);

CREATE TABLE gym (
	id INT GENERATED ALWAYS AS IDENTITY,
	type_id INT,
	name VARCHAR(50) NOT NULL,
	parent_company VARCHAR(50),
	PRIMARY KEY(id),
	CONSTRAINT fk_type
      FOREIGN KEY(type_id) 
		REFERENCES gym_type(id)
		ON UPDATE CASCADE
	  	ON DELETE CASCADE
);

CREATE TABLE gym_location (
	id INT GENERATED ALWAYS AS IDENTITY,
	gym_id INT,
	address VARCHAR(100) NOT NULL,
	city VARCHAR(50) NOT NULL,
	geolocation GEOGRAPHY(Point, 4326),
	is_current BOOLEAN,
	PRIMARY KEY(id),
	CONSTRAINT fk_gym
      FOREIGN KEY(gym_id) 
		REFERENCES gym(id)
		ON UPDATE CASCADE
	  	ON DELETE CASCADE
);

CREATE TABLE app (
	id INT GENERATED ALWAYS AS IDENTITY,
	name VARCHAR(50) NOT NULL,
	PRIMARY KEY(id)
);

CREATE TABLE youtube_channel (
	id INT GENERATED ALWAYS AS IDENTITY,
	app_id INT,
	channel_name VARCHAR(50) NOT NULL,
	instructor_id INT,
	PRIMARY KEY(id),
	CONSTRAINT fk_instructor FOREIGN KEY (instructor_id) 
		REFERENCES instructor(id)
		ON UPDATE CASCADE
	  	ON DELETE CASCADE
);

CREATE TABLE friend (
	id INT GENERATED ALWAYS AS IDENTITY,
	f_name VARCHAR(50) NOT NULL,
	l_name VARCHAR(50),
	PRIMARY KEY(id)
);

CREATE TABLE instructor (
	id INT GENERATED ALWAYS AS IDENTITY,
	f_name VARCHAR(50) NOT NULL,
	l_name VARCHAR(50),
	PRIMARY KEY(id)
);

CREATE TABLE instructor_list (
	instructor_id INT,
	gym_id INT,
	PRIMARY KEY (instructor_id, gym_id),
	CONSTRAINT fk_instructor FOREIGN KEY (instructor_id) 
		REFERENCES instructor(id)
		ON UPDATE CASCADE
	  	ON DELETE CASCADE,
	CONSTRAINT fk_gym FOREIGN KEY (gym_id) 
		REFERENCES gym(id)
		ON UPDATE CASCADE
	  	ON DELETE CASCADE
);

CREATE TABLE workout_type (
	id INT GENERATED ALWAYS AS IDENTITY,
	main_type VARCHAR(50) NOT NULL,
	sub_type VARCHAR(50),
	PRIMARY KEY(id)
);

CREATE TABLE intensity (
	id INT GENERATED ALWAYS AS IDENTITY,
	zone_name VARCHAR(50) NOT NULL,
	effort_level VARCHAR(200) NOT NULL,
	PRIMARY KEY(id)
);

CREATE TABLE live_class (
	id INT GENERATED ALWAYS AS IDENTITY,
	workout_type_id INT,
	gym_id INT,
	intensity INT,
	name VARCHAR(50) NOT NULL,
	duration_mins INT NOT NULL,
	PRIMARY KEY (id),
	CONSTRAINT fk_workout_type FOREIGN KEY (workout_type_id) 
		REFERENCES workout_type(id)
		ON UPDATE CASCADE
	  	ON DELETE CASCADE,
	CONSTRAINT fk_gym FOREIGN KEY (gym_id) 
		REFERENCES gym(id)
		ON UPDATE CASCADE
	  	ON DELETE CASCADE,
	CONSTRAINT fk_intensity FOREIGN KEY (intensity) 
		REFERENCES intensity(id)
		ON UPDATE CASCADE
	  	ON DELETE CASCADE
);

CREATE TABLE recorded_class (
	id INT GENERATED ALWAYS AS IDENTITY,
	workout_type_id INT,
	app_id INT,
	channel_id INT,
	gym_id INT,
	intensity INT,
	name VARCHAR(50) NOT NULL,
	duration_mins INT NOT NULL,
	url VARCHAR(250),
	PRIMARY KEY (id),
	CONSTRAINT fk_workout_type FOREIGN KEY (workout_type_id) 
		REFERENCES workout_type(id)
		ON UPDATE CASCADE
	  	ON DELETE CASCADE,
	CONSTRAINT fk_app FOREIGN KEY (app_id) 
		REFERENCES app(id)
		ON UPDATE CASCADE
	  	ON DELETE CASCADE,
	CONSTRAINT fk_channel FOREIGN KEY (channel_id) 
		REFERENCES youtube_channel(id)
		ON UPDATE CASCADE
	  	ON DELETE CASCADE,
	CONSTRAINT fk_gym FOREIGN KEY (gym_id) 
		REFERENCES gym(id)
		ON UPDATE CASCADE
	  	ON DELETE CASCADE,
	CONSTRAINT fk_intensity FOREIGN KEY (intensity) 
		REFERENCES intensity(id)
		ON UPDATE CASCADE
	  	ON DELETE CASCADE
);

CREATE TABLE registered_program (
	id INT GENERATED ALWAYS AS IDENTITY,
	workout_type_id INT,
	gym_id INT,
	intensity INT,
	name VARCHAR(50) NOT NULL,
	duration_mins INT NOT NULL,
	PRIMARY KEY (id),
	CONSTRAINT fk_workout_type FOREIGN KEY (workout_type_id) 
		REFERENCES workout_type(id)
		ON UPDATE CASCADE
	  	ON DELETE CASCADE,
	CONSTRAINT fk_gym FOREIGN KEY (gym_id) 
		REFERENCES gym(id)
		ON UPDATE CASCADE
	  	ON DELETE CASCADE,
	CONSTRAINT fk_intensity FOREIGN KEY (intensity) 
		REFERENCES intensity(id)
		ON UPDATE CASCADE
	  	ON DELETE CASCADE
);

CREATE TABLE workshop (
	id INT GENERATED ALWAYS AS IDENTITY,
	workout_type_id INT,
	gym_id INT,
	intensity INT,
	name VARCHAR(50) NOT NULL,
	duration_mins INT NOT NULL,
	PRIMARY KEY (id),
	CONSTRAINT fk_workout_type FOREIGN KEY (workout_type_id) 
		REFERENCES workout_type(id)
		ON UPDATE CASCADE
	  	ON DELETE CASCADE,
	CONSTRAINT fk_gym FOREIGN KEY (gym_id) 
		REFERENCES gym(id)
		ON UPDATE CASCADE
	  	ON DELETE CASCADE,
	CONSTRAINT fk_intensity FOREIGN KEY (intensity) 
		REFERENCES intensity(id)
		ON UPDATE CASCADE
	  	ON DELETE CASCADE
);

CREATE TABLE workout (
	id INT GENERATED ALWAYS AS IDENTITY,
	live_class_id INT,
	recorded_class_id INT,
	workshop_id INT,
	registered_program_id INT,
	workout_type_id INT,
	gym_id INT,
	gym_location_id INT,
	instructor_id INT,
	co_instructor_id INT,
	personal_trainer_id INT,
	friend_id INT,
	is_self_directed BOOLEAN,
	is_pt BOOLEAN,
	is_recorded_class BOOLEAN,
	is_virtual_class BOOLEAN,
	date DATE,
	start_time TIME,
	end_time TIME,
	duration_mins INT,
	PRIMARY KEY (id),
	CONSTRAINT fk_live_class FOREIGN KEY (live_class_id) 
		REFERENCES live_class(id)
		ON UPDATE CASCADE
	  	ON DELETE CASCADE,
	CONSTRAINT fk_recorded_class FOREIGN KEY (recorded_class_id) 
		REFERENCES recorded_class(id)
		ON UPDATE CASCADE
	  	ON DELETE CASCADE,
	CONSTRAINT fk_workshop FOREIGN KEY (workshop_id) 
		REFERENCES workshop(id)
		ON UPDATE CASCADE
	  	ON DELETE CASCADE,
	CONSTRAINT fk_program FOREIGN KEY (registered_program_id) 
		REFERENCES registered_program(id)
		ON UPDATE CASCADE
	  	ON DELETE CASCADE,
	CONSTRAINT fk_workout_type FOREIGN KEY (workout_type_id) 
		REFERENCES workout_type(id)
		ON UPDATE CASCADE
	  	ON DELETE CASCADE,
	CONSTRAINT fk_gym FOREIGN KEY (gym_id) 
		REFERENCES gym(id)
		ON UPDATE CASCADE
	  	ON DELETE CASCADE,
	CONSTRAINT fk_location FOREIGN KEY (gym_location_id) 
		REFERENCES gym_location(id)
		ON UPDATE CASCADE
	  	ON DELETE CASCADE,
	CONSTRAINT fk_instructor FOREIGN KEY (instructor_id) 
		REFERENCES instructor(id)
		ON UPDATE CASCADE
	  	ON DELETE CASCADE,
	CONSTRAINT fk_co_instructor FOREIGN KEY (co_instructor_id) 
		REFERENCES instructor(id)
		ON UPDATE CASCADE
	  	ON DELETE CASCADE,
	CONSTRAINT fk_personal_trainer FOREIGN KEY (personal_trainer_id) 
		REFERENCES instructor(id)
		ON UPDATE CASCADE
	  	ON DELETE CASCADE,
	CONSTRAINT fk_friend FOREIGN KEY (friend_id) 
		REFERENCES friend(id)
		ON UPDATE CASCADE
	  	ON DELETE CASCADE
);