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

INSERT INTO Customer(CustomerID, Name, Address, Tel, Status) VALUES (321, N'LOL Master TN', N'20 - Thái Nguyên chào anh em', '0368456654', N'fan cứng')
INSERT INTO Customer(CustomerID, Name, Address, Tel, Status) VALUES (654, N'Roses A Rosie', N'Chợ Sắt - Hải Phòng', '0989134685', N'Khách vãng lai')
INSERT INTO Customer(CustomerID, Name, Address, Tel, Status) VALUES (987, N'Bìn Bìn', N'số 12 - Thịt Chó Nhật Tân - Hà Lội', '0977487123', N'Tiềm năng')
INSERT INTO Customer(CustomerID, Name, Address, Tel, Status) VALUES (357, N'ShinT', N'88 Vĩnh Phúc - 2 nửa củ lạc', '0989456789', N'Khách Sộp')
INSERT INTO Customer(CustomerID, Name, Address, Tel, Status) VALUES (159, N'Bom Bom Bom', N'Gầm cầu Thăng Long', '0389334336', N'Hay mặc cả')
GO

INSERT INTO Oder (OderID, CustomerID, OderDate, Status) VALUES (1, 321, '07-15-2021', N'Đã thanh toán')
INSERT INTO Oder (OderID, CustomerID, OderDate, Status) VALUES (2, 654, '01-14-2022', N'Đã thanh toán')
INSERT INTO Oder (OderID, CustomerID, OderDate, Status) VALUES (3, 654, '04-25-2022', N'Chưa thanh toán')
GO

INSERT INTO Product (ProductID, Name, Description, Unit, Price, Quantity, Status) VALUES (9420, N'Điều hòa Daikin', N'Hàng Japan chất lượng China', N'Chiếc', 8000000, 101, N'Đắt như tôm tươi')
INSERT INTO Product (ProductID, Name, Description, Unit, Price, Quantity, Status) VALUES (1508, N'Quạt điều hòa MD', N'Hàng Việt Nam chất lượng cực cao', N'Chiếc', 2500000, 55, N'Ế lòi')
INSERT INTO Product (ProductID, Name, Description, Unit, Price, Quantity, Status) VALUES (1234, N'Tủ Lạnh Panasonic', N'Hàng HOT giá trên zời', N'Chiếc', 12000000, 13, N'Thi nhau mua')
INSERT INTO Product (ProductID, Name, Description, Unit, Price, Quantity, Status) VALUES (9812, N'Tivi Sony 80 inch', N'Hàng hiếm, cần Oder trước 2 tháng', N'Chiếc', 126000000, 0, N'Chuyên lừa mấy đại gia')
INSERT INTO Product (ProductID, Name, Description, Unit, Price, Quantity, Status) VALUES (2606, N'Quạt màn Vinakip', N'Cho không ai lấy', N'Chiếc', 250, 240, N'Chán...')
GO

INSERT INTO OderDetails(OderID, ProductID, Price, Quanity) VALUES (1, 9420, 7800000, 5)
INSERT INTO OderDetails(OderID, ProductID, Price, Quanity) VALUES (2, 1508, 2000000, 1)
INSERT INTO OderDetails(OderID, ProductID, Price, Quanity) VALUES (3, 2606, 240, 10)
GO

SELECT * FROM Customer
SELECT * FROM Oder
SELECT * FROM Product
SELECT * FROM OderDetails
GO

SELECT Name, Address, Tel FROM Customer
GO
SELECT Name, Quantity, Unit FROM Product
GO
SELECT OderID, CustomerID, OderDate FROM Oder
GO

SELECT * FROM Customer ORDER BY Name ASC
GO
SELECT Name, Quantity, Unit FROM Product ORDER BY Quantity DESC
GO

SELECT Name FROM Product WHERE Product.ProductID IN (
	SELECT ProductID FROM OderDetails WHERE OderDetails.OderID IN (
		SELECT OderID FROM Oder WHERE Oder.CustomerID = (
			SELECT CustomerID FROM Customer WHERE Customer.Name = 'Roses A Rosie'
		)
	)
);
GO

SELECT COUNT(DISTINCT Name) FROM Customer
SELECT COUNT(DISTINCT Name) FROM Product
SELECT *, (OderDetails.Price*OderDetails.Quanity) as Total FROM OderDetails

ALTER TABLE Product ADD CONSTRAINT CHK_PR CHECK (Price > 0);
ALTER TABLE Oder ADD CONSTRAIN CHK_DT CHECK (OderDate < (SELECT CURRENT_TIMESTAMP));
ALTER TABLE Product ADD StartDate date;

CREATE INDEX PrName ON Product (Name);
CREATE INDEX CusName ON Customer (Name);
