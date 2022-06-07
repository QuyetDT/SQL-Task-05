IF EXISTS (SELECT * FROM sys.databases WHERE Name='Business')
DROP DATABASE Business
GO

CREATE DATABASE Business
GO

USE Business
GO

CREATE TABLE Customer (
	CustomerID int PRIMARY KEY NOT NULL,
	CustomerName varchar (50) NOT NULL,
	Address nvarchar (100),
	Tel int,
	Status nvarchar (100)
)
GO

CREATE TABLE Oder (
	OrderID int PRIMARY KEY NOT NULL,
	CustomerID int CONSTRAINT fk FOREIGN KEY (CustomerID) REFERENCES Customer (CustomerID) NOT NULL,
	OrderDate date,
	Status nvarchar (50)
)
GO

CREATE TABLE Product (
	ProductID int PRIMARY KEY NOT NULL,
	ProductName nvarchar (100) NOT NULL,
	Description nvarchar (100),
	Unit nvarchar (20) NOT NULL,
	Price money NOT NULL,
	Quantity int NOT NULL,
	Status nvarchar (100)
)
GO

CREATE TABLE OrderDetails (
	OrderID int CONSTRAINT fk1 FOREIGN KEY (OrderID) REFERENCES Oder (OrderID) NOT NULL,
	ProductID int CONSTRAINT fk2 FOREIGN KEY (ProductID) REFERENCES Product (ProductID) NOT NULL,
	Price money NOT NULL,
	Quantity int NOT NULL
)
GO

INSERT INTO Customer(CustomerID, CustomerName, Address, Tel, Status) VALUES (321, N'LOL Master TN', N'20 - Thái Nguyên chào anh em', '0368456654', N'fan cứng')
INSERT INTO Customer(CustomerID, CustomerName, Address, Tel, Status) VALUES (654, N'Roses A Rosie', N'Chợ Sắt - Hải Phòng', '0989134685', N'Khách vãng lai')
INSERT INTO Customer(CustomerID, CustomerName, Address, Tel, Status) VALUES (987, N'Bìn Bìn', N'số 12 - Thịt Chó Nhật Tân - Hà Lội', '0977487123', N'Tiềm năng')
INSERT INTO Customer(CustomerID, CustomerName, Address, Tel, Status) VALUES (357, N'ShinT', N'88 Vĩnh Phúc - 2 nửa củ lạc', '0989456789', N'Khách Sộp')
INSERT INTO Customer(CustomerID, CustomerName, Address, Tel, Status) VALUES (159, N'Bom Bom Bom', N'Gầm cầu Thăng Long', '0389334336', N'Hay mặc cả')
GO

INSERT INTO Oder (OrderID, CustomerID, OrderDate, Status) VALUES (1, 321, '07-15-2021', N'Đã thanh toán')
INSERT INTO Oder (OrderID, CustomerID, OrderDate, Status) VALUES (2, 654, '01-14-2022', N'Đã thanh toán')
INSERT INTO Oder (OrderID, CustomerID, OrderDate, Status) VALUES (3, 654, '04-25-2022', N'Chưa thanh toán')
GO

INSERT INTO Product (ProductID, ProductName, Description, Unit, Price, Quantity, Status) VALUES (9420, N'Điều hòa Daikin', N'Hàng Japan chất lượng China', N'Chiếc', 8000000, 101, N'Đắt như tôm tươi')
INSERT INTO Product (ProductID, ProductName, Description, Unit, Price, Quantity, Status) VALUES (1508, N'Quạt điều hòa MD', N'Hàng Việt Nam chất lượng cực cao', N'Chiếc', 2500000, 55, N'Ế lòi')
INSERT INTO Product (ProductID, ProductName, Description, Unit, Price, Quantity, Status) VALUES (1234, N'Tủ Lạnh Panasonic', N'Hàng HOT giá trên zời', N'Chiếc', 12000000, 13, N'Thi nhau mua')
INSERT INTO Product (ProductID, ProductName, Description, Unit, Price, Quantity, Status) VALUES (9812, N'Tivi Sony 80 inch', N'Hàng hiếm, cần Oder trước 2 tháng', N'Chiếc', 126000000, 0, N'Chuyên lừa mấy đại gia')
INSERT INTO Product (ProductID, ProductName, Description, Unit, Price, Quantity, Status) VALUES (2606, N'Quạt màn Vinakip', N'Cho không ai lấy', N'Chiếc', 250, 240, N'Chán...')
GO

INSERT INTO OrderDetails(OrderID, ProductID, Price, Quantity) VALUES (1, 9420, 7800000, 5)
INSERT INTO OrderDetails(OrderID, ProductID, Price, Quantity) VALUES (2, 1508, 2000000, 1)
INSERT INTO OrderDetails(OrderID, ProductID, Price, Quantity) VALUES (3, 2606, 240, 10)
GO

SELECT * FROM Customer
SELECT * FROM Oder
SELECT * FROM Product
SELECT * FROM OrderDetails
GO

SELECT CustomerName, Address, Tel FROM Customer
GO
SELECT ProductName, Quantity, Unit FROM Product
GO
SELECT OrderID, CustomerID, OrderDate FROM Oder
GO

SELECT * FROM Customer ORDER BY CustomerName ASC
GO
SELECT ProductName, Quantity, Unit FROM Product ORDER BY Quantity DESC
GO

SELECT ProductName FROM Product WHERE Product.ProductID IN (
	SELECT ProductID FROM OrderDetails WHERE OrderDetails.OrderID IN (
		SELECT OrderID FROM Oder WHERE Oder.CustomerID = (
			SELECT CustomerID FROM Customer WHERE Customer.CustomerName = 'Roses A Rosie'
		)
	)
);
GO

SELECT COUNT(DISTINCT customerName) FROM Customer
SELECT COUNT(DISTINCT ProductName) FROM Product
SELECT *, (OrderDetails.Price*OrderDetails.Quantity) as Total FROM OrderDetails
GO

ALTER TABLE Product ADD CONSTRAINT CHK_PR CHECK (Price > 0);
ALTER TABLE Oder ADD CONSTRAINT CHK_DT CHECK(DATEDIFF(second, OrderDate, GETDATE()) > 0 );
ALTER TABLE Product ADD StartDate date;
GO

CREATE INDEX PrName ON Product (ProductName);
CREATE INDEX CusName ON Customer (CustomerName);

CREATE VIEW view_kh AS SELECT CustomerName, Address, Tel FROM Customer;
SELECT * FROM view_kh;

CREATE VIEW view_sp AS SELECT ProductName, Price FROM Product;
SELECT * FROM view_sp;

CREATE VIEW view_kh_sp AS (
	Select 
		Customer.CustomerName, Customer.Tel, Product.ProductName, OrderDetails.Quantity, Oder.OrderDate
	from Customer 
	inner join Oder ON Customer.CustomerID = Oder.CustomerID
	inner join OrderDetails ON Oder.OrderID = OrderDetails.OrderID
	inner join Product ON OrderDetails.ProductID = Product.ProductID
);
SELECT * FROM view_kh_sp;
GO

CREATE PROCEDURE SP_TimKH_MaKH @MaKH int
AS
SELECT CustomerName FROM Customer WHERE CustomerID = @MaKH;
GO
EXEC SP_TimKH_MaKH @MaKH = 321;
GO

CREATE PROCEDURE SP_TimKH_MaHD @MaHD int
AS
SELECT CustomerName
	FROM
	Oder
	inner join Customer ON Oder.CustomerID = Customer.CustomerID
	WHERE OrderID = @MaHD;
GO
EXEC SP_TimKH_MaHD @MaHD = 3;
GO

CREATE PROCEDURE SP_SanPham_MaKH @MaKH2 int
AS
SELECT ProductName
	FROM Customer
	inner join Oder ON Customer.CustomerID = Oder.CustomerID
	inner join OrderDetails ON Oder.OrderID = OrderDetails.OrderID
	inner join Product ON OrderDetails.ProductID = Product.ProductID
	WHERE Customer.CustomerID = @MaKH2
GO
EXEC SP_SanPham_MaKH @MaKH2 = 654;