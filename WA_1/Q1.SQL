
	
DROP DATABASE LawyerHelp;

CREATE DATABASE LawyerHelp;
USE LawyerHelp;

CREATE TABLE Demonstrator (
    D_ID VARCHAR(9) PRIMARY KEY,
    D_name VARCHAR(20),
    groupName VARCHAR(20),
    role VARCHAR(10)
);

CREATE TABLE Officer (
    O_ID VARCHAR(9) PRIMARY KEY,
    O_name VARCHAR(20)
);

CREATE TABLE Supenas (
    D_ID VARCHAR(9),
    O_ID VARCHAR(9),
    reason VARCHAR(100),
    claim VARCHAR(100),	
    arrestHouse VARCHAR(25),
    FOREIGN KEY (D_ID) REFERENCES Demonstrator(D_ID),
    FOREIGN KEY (O_ID) REFERENCES Officer(O_ID),
	PRIMARY KEY (D_ID, O_ID)
);
CREATE TABLE Lawyer (
	L_ID VARCHAR(9) PRIMARY KEY,
    L_name VARCHAR (20)
); 

CREATE TABLE helps (
	L_ID VARCHAR(9),
    D_ID VARCHAR(9),
    FOREIGN KEY (L_ID) REFERENCES Lawyer (L_ID),
    FOREIGN KEY (D_ID) REFERENCES Demonstrator (D_ID),
    PRIMARY KEY (L_ID, D_ID)
);

CREATE TABLE Demonstration (
	E_name VARCHAR (25) PRIMARY KEY,
    D_budget INT, 
    num_of_civilians INT
);

CREATE TABLE whoBringsWhat (
    E_name VARCHAR (25) PRIMARY KEY, 
    item VARCHAR (20),
    E_ID VARCHAR (25) ,
    FOREIGN KEY (E_name) REFERENCES Demonstration (E_name)
);

CREATE TABLE site (
	S_name VARCHAR (25) PRIMARY KEY,
    district VARCHAR (20)
);

CREATE TABLE happensInA (
		S_name VARCHAR (25) ,
		E_name VARCHAR (25) ,
        H_budget INT,
        H_ID VARCHAR(9),
        FOREIGN KEY (S_name) REFERENCES site (S_name),
		FOREIGN KEY (E_name) REFERENCES Demonstration (E_name),
        PRIMARY KEY (S_name, E_name)
);

CREATE TABLE goesToA (
	D_ID VARCHAR(9),
    E_name VARCHAR (25),
	FOREIGN KEY (D_ID) REFERENCES Demonstrator (D_ID),
	FOREIGN KEY (E_name) REFERENCES Demonstration (E_name),
	PRIMARY KEY (D_ID, E_name)
);

INSERT INTO Demonstrator (D_ID,D_name, groupName, role) VALUES
('0012154','LIOR', 'Group A', 'Leader'),
('0012155','ARIEL', 'Group B', 'Member'),
('0012156','ADI', 'Group C', 'Organizer'),
('0012147','NOA', 'Group D', 'Member'),
('0012158','ETI', 'Group E', 'Leader');

INSERT INTO Officer (O_ID, O_name) VALUES
('3012154', 'DANY'),
('4012154', 'OREN'),
('5012154', 'MIKI'),
('6012154', 'ELAD'),
('7012154', 'SHANI');


INSERT INTO Supenas (D_ID, O_ID, reason, claim, arrestHouse) VALUES
('0012158', '3012154', 'Reason 1', 'Claim 1', 'House 2'),
('0012154', '4012154', 'Reason 2', 'Claim 2', 'House 2'), 
('0012156', '5012154', 'Reason 3', 'Claim 3', 'House 3'), 
('0012147', '6012154', 'Reason 4', 'Claim 4', 'House 4'), 
('0012158', '7012154', 'Reason 5', 'Claim 5', 'House 5');


INSERT INTO Lawyer (L_ID, L_name) VALUES
('0012154', 'Lawyer A'),
('0012155', 'Lawyer B'),
('0212154', 'Lawyer C'),
('0312154', 'Lawyer D'),
('0412154', 'Lawyer E');

INSERT INTO helps (L_ID, D_ID) VALUES
('0012154', '0012154'),
('0012155', '0012155'),
('0312154', '0012156'),
('0312154', '0012147'),
('0412154', '0012158');



INSERT INTO Demonstration (E_name, D_budget, num_of_civilians) VALUES
('Demo1', 1000, 50),
('Demo2', 2000, 100),
('Demo3', 3000, 150),
('Demo4', 4000, 200),
('Demo5', 5000, 250);

INSERT INTO whoBringsWhat (E_name, item, E_ID) VALUES
('Demo1', 'Item1', '0012154'),
('Demo2', 'Item2', '0012154'),
('Demo3', 'Item3', '0012155'),
('Demo4', 'Item4', '0012157'),
('Demo5', 'Item5', '0012157');

INSERT INTO site (S_name, district) VALUES
('Site1', 'District1'),
('Site2', 'District2'),
('Site3', 'District3'),
('Site4', 'District4'),
('Site5', 'District5');

INSERT INTO happensInA (S_name, E_name, H_budget, H_ID) VALUES
('Site1', 'Demo1', 20000, '0012154'),
('Site2', 'Demo2', 15000, '0012154'),
('Site3', 'Demo3', 40000, '0012156'),
('Site4', 'Demo4', 40000, '0012157'),
('Site5', 'Demo5', 10000, '0012150');

INSERT INTO goesToA (D_ID, E_name) VALUES
('0012154', 'Demo1'),
('0012155', 'Demo2'),
('0012156', 'Demo3'),
('0012147', 'Demo4'),
('0012158', 'Demo5');



SELECT COUNT(DISTINCT arrestHouse) FROM Supenas;


SELECT @arestedDemo = D_ID FROM supenas ORDER BY arrestHouse;

select D_name FROM Demonstrator where @arestedDemo.D_ID=Demonstrator.D_ID  ;


SELECT COUNT(*) AS Total_Arrests
FROM Supenas;

SELECT COUNT(*) AS Arrests_Without_Lawyer
FROM supenas 
INNER JOIN helps ON supenas.D_ID = helps.D_ID
WHERE helps.L_ID IS NULL;

SELECT (COUNT(*) * 100 /
 (SELECT COUNT(*)
  FROM supenas))
FROM supenas
INNER JOIN helps ON supenas.D_ID = helps.D_ID
WHERE helps.L_ID IS NULL;

SELECT Demonstrator.D_name, sum(H_budget) 
FROM happensInA
INNER JOIN Demonstrator ON happensInA.H_ID = Demonstrator.D_ID     
GROUP BY H_ID,D_ID
HAVING SUM(H_budget) > 32000;




CREATE TABLE HighBudgetProtests (
    P_ID INT  PRIMARY KEY,
    D_name VARCHAR(25),
    Total_Budget INT
);


INSERT INTO HighBudgetProtests (P_ID, D_name,  Total_Budget)
SELECT H_ID,D_name, SUM(happensInA.H_budget) AS Total_Budget
FROM happensInA
INNER JOIN Demonstrator ON happensInA.H_ID = Demonstrator.D_ID     
GROUP BY H_ID,D_ID
HAVING SUM(H_budget) > 32000;

select * from HighBudgetProtests;



SET @avg_budget = (SELECT AVG(Total_Budget) FROM HighBudgetProtests);

select @avg_budget;





-- Deleting using a JOIN to bypass the MySQL limitation










 


        
        





