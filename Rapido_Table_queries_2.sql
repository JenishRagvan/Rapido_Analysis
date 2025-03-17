create schema rapido ; 
use rapido ; 

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(255),
    phone_number VARCHAR(20) UNIQUE,
    email VARCHAR(255) UNIQUE,
    gender ENUM('Male', 'Female', 'Other'),
    age INT CHECK (age >= 18 AND age <= 100),
    registration_date DATE,
    total_rides INT DEFAULT 0,
    total_spent DECIMAL(10,2) DEFAULT 0.00
);

CREATE TABLE Drivers (
    driver_id INT PRIMARY KEY AUTO_INCREMENT,
    driver_name VARCHAR(255),
    phone_number VARCHAR(20) UNIQUE,
    email VARCHAR(255) UNIQUE,
    city VARCHAR(100),
    vehicle_type ENUM('Bike', 'Auto'),
    vehicle_number VARCHAR(20) UNIQUE,
    driver_rating DECIMAL(3,2) CHECK (driver_rating >= 1.0 AND driver_rating <= 5.0),
    total_rides_completed INT DEFAULT 0,
    earnings DECIMAL(10,2) DEFAULT 0.00
);
select * from customers ; 

CREATE TABLE Rides (
    ride_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    driver_id INT,
    pickup_location VARCHAR(255),
    drop_location VARCHAR(255),
    city VARCHAR(100),
    ride_date DATE,
    ride_time TIME,
    ride_status ENUM('Completed', 'Cancelled', 'Ongoing'),
    payment_status ENUM('Paid', 'Pending', 'Failed'),
    ride_distance_km DECIMAL(5,2),
    ride_duration_min INT,
    ride_fare DECIMAL(10,2),
    payment_method ENUM('Cash', 'UPI', 'Card', 'Wallet'),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id)
);

CREATE TABLE Ride_Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    ride_id INT,
    customer_id INT,
    amount_paid DECIMAL(10,2),
    payment_method ENUM('Cash', 'UPI', 'Card', 'Wallet'),
    transaction_status ENUM('Success', 'Failed', 'Pending'),
    transaction_date DATE,
    FOREIGN KEY (ride_id) REFERENCES Rides(ride_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Ride_Cancel (
    cancellation_id INT PRIMARY KEY AUTO_INCREMENT,
    ride_id INT,
    customer_id INT,
    driver_id INT,
    cancellation_reason VARCHAR(255),
    cancellation_time TIME,
    FOREIGN KEY (ride_id) REFERENCES Rides(ride_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id)
);

CREATE TABLE City_Wise_Demand (
    city VARCHAR(100) PRIMARY KEY,
    total_rides INT,
    average_fare DECIMAL(10,2),
    peak_hours ENUM('Morning', 'Evening', 'Night'),
    most_frequent_pickup_location VARCHAR(255)
);

CREATE TABLE Customer_Feedback (
    feedback_id INT PRIMARY KEY AUTO_INCREMENT,
    ride_id INT,
    customer_id INT,
    driver_id INT,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    review TEXT,
    FOREIGN KEY (ride_id) REFERENCES Rides(ride_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id)
);