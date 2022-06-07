IF EXISTS (SELECT * FROM sys.databases WHERE Name='Business')
DROP DATABASE Business
GO

CREATE DATABASE Business
GO

USE Business
GO

CREATE TABLE Customer (
	CustomerID int PRIMARY KEY NOT NULL,
	Name varchar (50) NOT NULL,
	Address nvarchar (100),
	Tel int,
	Status nvarchar (100)
)
GO

CREATE TABLE Oder (
	OderID int PRIMARY KEY NOT NULL,
	CustomerID int CONSTRAINT fk FOREIGN KEY (CustomerID) REFERENCES Customer (CustomerID) NOT NULL,
	OderDate date,
	Status nvarchar (50)
)
GO

CREATE TABLE Product (
	ProductID int PRIMARY KEY NOT NULL,
	Name nvarchar (100) NOT NULL,
	Description nvarchar (100),
	Unit nvarchar (20) NOT NULL,
	Price money NOT NULL,
	Quantity int NOT NULL,
	Status nvarchar (100)
)
GO

CREATE TABLE OderDetails (
	OderID int CONSTRAINT fk1 FOREIGN KEY (OderID) REFERENCES Oder (OderID) NOT NULL,
	ProductID int CONSTRAINT fk2 FOREIGN KEY (ProductID) REFERENCES Product (ProductID) NOT NULL,
	Price money NOT NULL,
	Quanity int NOT NULL
)
GO

INSERT INTO Customer(CustomerID, Name, Address, Tel, Status) VALUES (321, N'Trương Thúy A', N'Phú Bình - Thái Nguyên', '0368456654', N'fan cứng')
INSERT INTO Customer(CustomerID, Name, Address, Tel, Status) VALUES (654, N'Nguyễn Văn B', N'Hiệp Hòa - Bắc Giang', '0989134685', N'Khách vãng lai')
GO

INSERT INTO Oder (OderID, CustomerID, OderDate, Status) VALUES (1, 321, '07-15-2021', N'Đã thanh toán')
INSERT INTO Oder (OderID, CustomerID, OderDate, Status) VALUES (2, 654, '01-04-2022', N'Chưa thanh toán')
GO

INSERT INTO Product (ProductID, Name, Description, Unit, Price, Quantity, Status) VALUES (9420, N'Điều hòa Daikin', N'Hàng Japan chất lượng China', N'Chiếc', 8000000, 101, N'Đắt như tôm tươi')
INSERT INTO Product (ProductID, Name, Description, Unit, Price, Quantity, Status) VALUES (1508, N'Quạt điều hòa MD', N'Hàng Việt Nam chất lượng cực cao', N'Chiếc', 2500000, 55, N'Ế lòi')
GO

INSERT INTO OderDetails(OderID, ProductID, Price, Quanity) VALUES (1, 9420, 7800000, 5)
INSERT INTO OderDetails(OderID, ProductID, Price, Quanity) VALUES (2, 1508, 2000000, 1)
GO

SELECT * FROM Customer
SELECT * FROM Oder
SELECT * FROM Product
SELECT * FROM OderDetails
GO