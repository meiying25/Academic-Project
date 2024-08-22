-- DROP DATABASE DB_PROJECT;

CREATE DATABASE DB_PROJECT;
SHOW DATABASES;
USE DB_PROJECT;


# Entrepreneur_Nationality moved to ALTER TABLE, near UPDATE part. Don't touch it yet.
CREATE TABLE Entrepreneur(
	Entrepreneur_ID VARCHAR(50) NOT NULL,
    Entrepreneur_Name VARCHAR(50),
    Entrepreneur_Age INT,
    PRIMARY KEY(Entrepreneur_ID)
);

DESCRIBE Entrepreneur;

CREATE TABLE Company(
	Company_ID VARCHAR(20) NOT NULL,
    Entrepreneur_ID VARCHAR(50),
    Company_Name VARCHAR(50),
    Company_Add VARCHAR(50),
    Company_Age INT,
    PRIMARY KEY(Company_ID),
    FOREIGN KEY(Entrepreneur_ID) REFERENCES Entrepreneur(Entrepreneur_ID)
);
DESCRIBE Company;

CREATE TABLE Product(
	Product_ID VARCHAR(50) NOT NULL,
    Company_ID VARCHAR(20),
    Product_Name VARCHAR(50),
    Product_Price DECIMAL(7,2),
    PRIMARY KEY(Product_ID),
    FOREIGN KEY(Company_ID) REFERENCES Company(Company_ID)
);
DESCRIBE Product;

CREATE TABLE Product_Buyer(
	P_Buyer_ID VARCHAR(50) NOT NULL,
    P_Buyer_Name VARCHAR(50),
    PRIMARY KEY (P_Buyer_ID)
);
DESCRIBE Product_Buyer;

CREATE TABLE Product_Transaction(
    Product_ID VARCHAR(50) NOT NULL,
    P_Buyer_ID VARCHAR(50) NOT NULL,
    P_Processing_Fees DECIMAL(6,2),
    P_Delivery_Fees DECIMAL(6,2),
    P_Trans_Date DATE,
	PRIMARY KEY (Product_ID, P_Buyer_ID),
    FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID),
	FOREIGN KEY (P_Buyer_ID) REFERENCES Product_Buyer(P_Buyer_ID)
);
DESCRIBE Product_Transaction;

CREATE TABLE Service(
    Service_ID VARCHAR(20) NOT NULL,
    Service_Name VARCHAR(50),
    Service_Price DECIMAL(7,2),
    Company_ID VARCHAR(20),
    PRIMARY KEY (Service_ID),
    FOREIGN KEY (Company_ID) REFERENCES Company(Company_ID)
);

CREATE TABLE Service_Buyer(
    S_Buyer_ID VARCHAR(20) NOT NULL,
    S_Buyer_Name VARCHAR(50),
    PRIMARY KEY (S_Buyer_ID)
);

CREATE TABLE Service_Transaction(
    Service_ID VARCHAR(20) NOT NULL,
    S_Buyer_ID VARCHAR(20) NOT NULL,
    S_Transaction_Fees DECIMAL(6,2),
    S_Date DATE,
    PRIMARY KEY (Service_ID, S_Buyer_ID),
    FOREIGN KEY (Service_ID) REFERENCES Service(Service_ID),
	FOREIGN KEY (S_Buyer_ID) REFERENCES Service_Buyer(S_Buyer_ID)
);


CREATE TABLE Finance(
    Finance_ID VARCHAR(20) NOT NULL,
    Revenue DECIMAL(15,2),
    Profit DECIMAL(15,2),
    Operating_Cost DECIMAL(15,2),
    Finance_Date DATE,
    Company_ID VARCHAR(20),
    PRIMARY KEY (Finance_ID),
    FOREIGN KEY (Company_ID) REFERENCES Company(Company_ID)
);

CREATE TABLE Project(
    Project_ID VARCHAR(20) NOT NULL,
    Project_Title VARCHAR(100),
    Project_Description VARCHAR(350),
    Start_Date DATE,
    End_Date DATE,
    Company_ID  VARCHAR(20),
    PRIMARY KEY (Project_ID),
    FOREIGN KEY (Company_ID) REFERENCES Company(Company_ID)
);

CREATE TABLE Funding(
    Funding_ID VARCHAR(20) NOT NULL,
    Funding_Date DATE,
    Amount DECIMAL(8,2),
    Project_ID VARCHAR(20),
    Funding_Type VARCHAR(20),
    PRIMARY KEY (Funding_ID),
    FOREIGN KEY (Project_ID) REFERENCES Project(Project_ID)
);

CREATE TABLE Debt_Funding(
	Funding_ID VARCHAR(20) NOT NULL,
    Borrower_Name VARCHAR(50),
    Interest_Rate Decimal(4,3),
    Loan_Term_Year INT,
    PRIMARY KEY (Funding_ID)
);

CREATE TABLE Equity_Funding(
	Funding_ID VARCHAR(20) NOT NULL,
    Investor_Name VARCHAR(50),
    Equity_Stake INT,
    PRIMARY KEY (Funding_ID)
);

CREATE TABLE Dummy(
	DummyChar VARCHAR(20)
);

DROP TABLE Dummy;

INSERT INTO Entrepreneur value
('E001', 'John Smith', 35),
('E002', 'Emily Chen', 32),
('E003', 'Abilashree', 40),
('E004', 'Sophie Martin', 32),
('E005', 'Aishah Abdullah', 15),
('E006', 'Ryan Gosling', 43);

INSERT INTO Company value
('RS321', 'E001', 'The IBR Asia Group Sdn Bhd (service)', '163, Jalan Ampang, Kuala Lumpur', 3),
('XY654', 'E005', 'Altios Malaysia Sdn Bhd (service)', 'Lot 101, Jalan Sultan Ismail, Johor Bahru', 1),
('ZU982', 'E002', 'SparkLiving (Product)', '79, Jalan Tun Razak, Penang', 2),
('CY333', 'E005', 'Nexus (Product)', '11A, Jalan Sultan Hishamuddin, Klang', 2),
('EK331', 'E001', 'Titian Kotamas Sdn Bhd (service)', '25, Jalan Merpati, Taiping', 5),
('KT228', 'E004', 'M&T (Product)', '19A, Jalan Meru, Klang', 3),
('TE476', 'E002', 'Prime Technology (Product)', '45, Jalan Tun Tan Cheng Lock, Melaka', 6),
('JK652', 'E003', 'PureLuxe (Product)', '13A, Jalan Telawi, Kuala Lumpur', 4);

INSERT INTO Product value
('PMB126-003', 'TE476', 'Power Bank', 70.00),
('OLQ263-457', 'TE476', 'Smartwatch', 3600.00),
('JYT012-611', 'JK652', 'Skincare Serum', 98.20),
('WGF530-233', 'JK652', 'Hair Colour', 35.50),
('TUY341-579', 'ZU982', 'Kitchen Blender', 56.00),
('UTR257-388', 'CY333', 'Massage Chair', 8999.00),
('WVR202-056', 'ZU982', 'Electric Toothbrush', 949.00),
('ARI526-787', 'TE476', 'Laptop', 3999.99),
('FGS639-841', 'KT228', 'Water Bottle', 48.00),
('PJB549-630', 'KT228', 'Outdoor Backpack', 69.99);

INSERT INTO Product_Buyer value
('HG49200', 'Rowen'),
('VB12348', 'Zaina'),
('GY93888', 'Yi Sheng'),
('SF34457', 'Amirtha'),
('YX03589', 'Zelda'),
('RD45098', 'Nazra'),
('ZQ17825', 'Diana');

INSERT INTO Product_Transaction value
('PJB549-630', 'ZQ17825', 2.30, 5.90, '2022-11-15'),
('FGS639-841', 'SF34457', 1.20, 4.90, '2022-12-19'),
('PMB126-003', 'SF34457', 8.00, 12.00, '2023-02-06'),
('JYT012-611', 'VB12348', 3.50, 8.00, '2023-03-10'),
('ARI526-787', 'RD45098', 100.00, 56.00, '2023-03-26'),
('TUY341-579', 'YX03589', 9.80, 7.60, '2023-04-13'),
('WGF530-233', 'VB12348', 2.50, 5.60, '2023-05-16'),
('OLQ263-457', 'HG49200', 89.00, 54.00, '2023-05-20'),
('ARI526-787', 'GY93888', 100.00, 68.00, '2023-06-04'),
('FGS639-841', 'YX03589', 1.20, 5.60, '2023-07-10');

INSERT INTO Service value
('SRV-IT-027', 'IT Consultation Service', 595.00, 'TE476'),
('SRV-FM-104', 'Financial Management Consulting Service', 420.00, 'XY654'),
('SRV-HC-168', 'Healthcare ', 280.00, 'EK331'),
('SRV-AS-234', 'Advertising Service', 1800.00, 'RS321'),
('SRV-IA-147', 'Insurance Advisory Service', 950.00, 'XY654'),
('SRV-PS-441', 'Publishing Service', 889.00, 'RS321'),
('SRV-BC-110', 'Business Consulting Service', 249.00, 'XY654'),
('SRV-SD-810', 'Software Development Service', 2500.00, 'TE476'),
('SRV-PR-541', 'Printing and Reproduction Service', 59.00, 'RS321'),
('SRV-BP-089', 'Beauty and Physical Well Being Service', 200.00, 'EK331');

INSERT INTO Service_Buyer value
('RT23812', 'Tanusha'),
('HD45196', 'Yu Chen'),
('JO142870', 'Vimalan'),
('WQ75012', 'Fatimah'),
('MB12378', 'Andrew'),
('CC36789', 'Raymon');

INSERT INTO Service_Transaction value
('SRV-HC-168', 'HD45196', 5.50, '2022-10-10'),
('SRV-AS-234', 'RT23812', 12.50, '2022-11-26'),
('SRV-SD-810', 'JO142870', 16.50, '2023-12-12'),
('SRV-IA-147', 'WQ75012', 20.50, '2023-01-20'),
('SRV-BP-089', 'MB12378', 15.50, '2023-02-28'),
('SRV-IA-147', 'CC36789', 5.00, '2023-03-12'),
('SRV-SD-810', 'HD45196', 4.50, '2023-03-23'),
('SRV-SD-810', 'CC36789', 6.50, '2023-04-07'),
('SRV-FM-104', 'MB12378', 3.50, '2023-04-15'),
('SRV-IT-027', 'HD45196', 2.50, '2023-04-30');

INSERT INTO Finance value
('ZU-NOV-020', 15000.00, 9800.00,5200.00, '2023-11-30', 'ZU982'),
('RS-NOV-030', 17500.00, 10300.00, 7200.00, '2023-11-28', 'RS321'),
('XY-OCT-067', 11000.00, 7500.00, 3500.00, '2023-10-12', 'XY654'),
('KT-AUG-016', 9800.00, 5900.00, 3900.00, '2023-08-25', 'KT228'),
('TE-SEP-123', 29000.00, 20000.00, 9000.00, '2023-09-28', 'TE476'),
('CY-OCT-142', 25000.00, 18000.00, 7000.00, '2023-10-15', 'CY333'),
('TE-NOV-247', 36000.00, 25000.00, 11000.00, '2023-11-23', 'TE476'),
('EK-SEP-117', 24000.00, 18500.00, 5500.00, '2023-09-25', 'EK331'),
('KT-NOV-126', 8900.00, 5320.00, 3580.00, '2023-11-29', 'KT228'),
('JK-OCT-025', 12000.00, 6999.00, 5001.00, '2023-10-24', 'JK652');

INSERT INTO Project value
('P001', 'VivaVerve Wellness Studio: Nurturing Beauty Inside Out', 'VivaVerve Wellness Studio is dedicated to holistic Beauty 
and Physical Well-being Services, promoting self-care and 
enhancing natural beauty through a range of rejuvenating treatments.', '2024-06-01', '2024-10-29', 'JK652'),
('P002', 'SmartLife Companion: Fusion of Style and Functionality', 'Our SmartLife Companion project introduces a cutting-edge 
smartwatch that seamlessly integrates style and functionality, 
keeping you connected and enhancing your lifestyle', '2024-08-25', '2024-11-23', 'TE476'),
('P003', 'FinEdge Advisory: Mastering Financial Excellence', 'FinEdge Advisory provides expert Financial Management 
Consulting Services, empowering organizations to navigate 
financial landscapes, enhance decision-making, and achieve long-term financial success.', '2025-01-29', '2025-09-30', 'XY654'),
('P004', 'CodeForge Innovations: Crafting Digital Excellence', 'CodeForge Innovations specializes in Software Development 
Services, creating bespoke software solutions that drive innovation, 
efficiency, and digital transformation.', '2024-07-19', '2024-12-23', 'TE476'),
('P005', 'SerenitySeat:Your Personal Relaxation Oasis', 'SerenitySeat brings the spa experience to your home, 
offering a luxurious and customizable massage chair 
that becomes your personal relaxation oasis.', '2025-03-15', '2025-07-28', 'CY333'),
('P006', 'BrandVista Media Solutions: Crafting Your Brand Story', 'BrandVista Media Solutions specializes in Advertising Services,
 creating compelling narratives and impactful campaigns that resonate with your audience, 
 driving brand awareness and engagement.', '2024-11-22', '2025-02-23', 'RS321'),
 ('P007', 'InsureInsight Advisors: Securing Your Future', 'InsureInsight Advisors offers personalized Insurance Advisory 
Services, guiding individuals and businesses to make informed 
decisions for a secure and resilient financial future.', '2025-01-26', '2025-06-28', 'XY654');

INSERT INTO Funding value
('FD001', '2023-07-21', 13000.00, 'P005', 'debt_funding'),
('FD002', '2023-06-05', 200000.00, 'P005', 'equity_funding'),
('FD003', '2023-02-17', 15000.00, 'P001', 'debt_funding'),
('FD004', '2023-06-24', 250000.00, 'P002', 'equity_funding'),
('FD005', '2023-01-23', 100000.00, 'P007', 'equity_funding'),
('FD006', '2023-02-15', 150000.00, 'P001', 'equity_funding'),
('FD007', '2023-04-26', 20000.00, 'P006', 'debt_funding'),
('FD008', '2023-02-25', 64000.00, 'P004', 'equity_funding'),
('FD009', '2023-09-10', 78000.00, 'P002', 'debt_funding'),
('FD010', '2023-05-15', 34500.00, 'P003', 'debt_funding');

INSERT INTO Debt_Funding value
('FD001', 'Phoebe', 0.040, 4),
('FD003', 'Quine', 0.035, 7),
('FD007', 'Mikayla', 0.055, 6),
('FD009', 'Xiao Ning', 0.080, 1),
('FD010', 'Melinda', 0.025, 8);

INSERT INTO Equity_Funding value
('FD002', 'Siow Wei', 10),
('FD004', 'Daniel', 9),
('FD005', 'Sam', 20),
('FD006', 'Ophilia', 5),
('FD008', 'Elly', 15);

# The 10 query statements can start below

# UPDATE and DELETE (2 query)
ALTER TABLE Entrepreneur
ADD Entrepreneur_Nationality VARCHAR(50);
UPDATE Entrepreneur
SET Entrepreneur_Nationality = 'American'
WHERE Entrepreneur_ID = 'E001';
UPDATE Entrepreneur
SET Entrepreneur_Nationality = 'Malaysian'
WHERE Entrepreneur_ID = 'E002';
UPDATE Entrepreneur
SET Entrepreneur_Nationality = 'Indian'
WHERE Entrepreneur_ID = 'E003';
UPDATE Entrepreneur
SET Entrepreneur_Nationality = 'French'
WHERE Entrepreneur_ID = 'E004';
UPDATE Entrepreneur
SET Entrepreneur_Nationality = 'Malaysia'
WHERE Entrepreneur_ID = 'E005';

DELETE FROM Entrepreneur WHERE Entrepreneur_ID = 'E006';


# Company_Name and Total number of Service with Total number of Service > 2
SELECT c.Company_Name, COUNT(s.Service_ID) AS ServiceNum
FROM Company c, Service s
WHERE c.Company_ID = s.Company_ID
GROUP BY c.Company_Name
HAVING  ServiceNum>2 ;
 
# Project_Title and Project_Duration(End_Date - Start_Date) with Project_Duration > 100 days and descending order
SELECT Project_Title, DATEDIFF(End_Date, Start_Date) AS Project_Duration
FROM Project 
WHERE DATEDIFF(End_Date, Start_Date) > 100
ORDER BY Project_Duration DESC;

# Service_Buyer_ID and Min_Service_Transaction_Fees with Service_Name (IT Consultation Service & Software Development Service)
SELECT s.S_Buyer_ID AS Service_Buyer_ID, MIN(st.S_Transaction_Fees) AS Min_Service_Transaction_Fees
FROM Service_Buyer s, Service_Transaction st, Service sv
WHERE  s.S_Buyer_ID = st.S_Buyer_ID AND sv.Service_ID = st.Service_ID AND sv.Service_Name IN ('IT Consultation Service','Software Development Service')
GROUP BY s.S_Buyer_ID;

--  A query that retrieve Product ID, Product Name, Product Buyer Name and Product Transaction Date between March and April of 2023
SELECT p.Product_ID, p.Product_Name, pb.P_Buyer_Name, pt.P_Trans_Date
FROM Product p, Product_Buyer pb, Product_Transaction pt
WHERE p.Product_ID = pt.Product_ID 
AND pt.P_Buyer_ID = pb.P_Buyer_ID
AND pt.P_Trans_Date BETWEEN '2023-03-01' AND '2023-04-30';

-- A query that gets Project ID and total amount of funding for each project
SELECT Project_ID, sum(Amount) AS Total_Funding
FROM Funding
GROUP BY Project_ID;

-- A query that get Entrepreneur ID, minimum profit and maximum profit of company for each entrepreneur
SELECT e.Entrepreneur_ID, min(f.Profit), max(f.Profit)
FROM Entrepreneur e, Company c, Finance f
WHERE e.Entrepreneur_ID = c.Entrepreneur_ID 
AND c.Company_ID = f.Company_ID
GROUP BY e.Entrepreneur_ID;


# A query that gets the name of company, address of company, with revenue more than 10000 and profit more than 10000
SELECT c.Company_Name, c.Company_Add, f.Revenue, f.Profit
FROM Company c
INNER JOIN Finance f
WHERE c.Company_ID = f.Company_ID
AND f.Revenue > 10000
AND f.Profit > 10000;

# A query that gets the name of service name, service buyer, the sum of service price and transaction fees as 'total service fee' and date
# where total service fee is more than 1000
SELECT s.Service_Name, sb.S_Buyer_Name, s.service_price + st.S_Transaction_Fees AS Total_Service_Fee, st.S_Date
FROM Service_Transaction st
INNER JOIN Service s, Service_Buyer sb
WHERE s.Service_ID = st.Service_ID 
AND sb.S_Buyer_ID = st.S_Buyer_ID
AND s.service_price + st.S_Transaction_Fees > 1000;


-- A query that gets the Company Name and Company Age for Entrepreneur Age more than 32 years old by using sub-query method.
SELECT c.Company_Name, c.Company_Age
FROM Company c
WHERE c.Entrepreneur_ID IN(
 SELECT e.Entrepreneur_ID 
 FROM Entrepreneur e
 WHERE e.Entrepreneur_Age > 32
);










