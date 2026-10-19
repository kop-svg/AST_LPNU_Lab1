IF DB_ID(N'CalcTestsDb') IS NULL
    CREATE DATABASE CalcTestsDb;
GO

USE CalcTestsDb;
GO

IF OBJECT_ID(N'dbo.IsOperatorData') IS NOT NULL DROP TABLE dbo.IsOperatorData;
IF OBJECT_ID(N'dbo.InsertSymbolData') IS NOT NULL DROP TABLE dbo.InsertSymbolData;
GO

-- Дані для IsOperator(string s)
CREATE TABLE dbo.IsOperatorData
(
    Id          INT IDENTITY(1,1) PRIMARY KEY,
    Input       NVARCHAR(50) NOT NULL,   -- вхідний рядок
    Expected    BIT          NOT NULL,   -- очікуваний результат
    Description NVARCHAR(200) NULL
);

-- Дані для InsertSymbol(string input, char symbol, int position)
CREATE TABLE dbo.InsertSymbolData
(
    Id          INT IDENTITY(1,1) PRIMARY KEY,
    Input       NVARCHAR(100) NOT NULL,  -- вхідний рядок
    Symbol      NCHAR(1)      NOT NULL,  -- символ для підстановки
    Position    INT           NOT NULL,  -- позиція
    Expected    NVARCHAR(100) NOT NULL,  -- очікуваний рядок
    Description NVARCHAR(200) NULL
);
GO

INSERT INTO dbo.IsOperatorData (Input, Expected, Description) VALUES
(N'+',   1, N'Бінарний плюс'),
(N'-',   1, N'Бінарний мінус'),
(N'*',   1, N'Множення'),
(N'/',   1, N'Ділення'),
(N'%',   1, N'Залишок від ділення'),
(N'(',   1, N'Відкриваюча дужка'),
(N')',   1, N'Закриваюча дужка'),
(N'm',   1, N'Унарний мінус'),
(N'p',   1, N'Унарний плюс'),
(N'',    0, N'Порожній рядок (Length != 1)'),
(N' ',   0, N'Пробіл'),
(N'a',   0, N'Літера, що не є оператором'),
(N'M',   0, N'Велика M - не унарний мінус (регістр)'),
(N'P',   0, N'Велика P - не унарний плюс (регістр)'),
(N'5',   0, N'Цифра'),
(N'=',   0, N'Невідомий символ ='),
(N'^',   0, N'Невідомий символ ^'),
(N'.',   0, N'Крапка'),
(N'[',   0, N'Квадратна дужка не підтримується'),
(N'{',   0, N'Фігурна дужка не підтримується'),
(N'++',  0, N'Два оператори - Length != 1'),
(N'+-',  0, N'Два оператори різних'),
(N'()',  0, N'Пара дужок'),
(N'+ ',  0, N'Оператор з пробілом - Length == 2'),
(N'mod', 0, N'Специфікація каже "mod", у коді використано %'),
(N'12',  0, N'Число');

INSERT INTO dbo.InsertSymbolData (Input, Symbol, Position, Expected, Description) VALUES
(N'abc',   N'X',  0, N'Xbc',   N'Заміна першого символу'),
(N'abc',   N'X',  1, N'aXc',   N'Заміна середнього символу'),
(N'abc',   N'X',  2, N'abX',   N'Заміна останнього символу'),
(N'abc',   N'X',  3, N'abc',   N'Позиція == Length - без змін'),
(N'abc',   N'X', -1, N'abc',   N'Від''ємна позиція - без змін'),
(N'abc',   N'X', 100, N'abc',  N'Позиція далеко за межами - без змін'),
(N'abc',   N'X', 2147483647, N'abc', N'Позиція int.MaxValue - без змін'),
(N'abc',   N'X', -2147483648, N'abc', N'Позиція int.MinValue - без змін'),
(N'',      N'X',  0, N'',      N'Порожній рядок'),
(N'a',     N'X',  0, N'X',     N'Рядок з одного символу'),
(N'a',     N'X',  1, N'a',     N'Один символ, позиція за межами'),
(N'1+2',   N'p',  1, N'1p2',   N'Заміна + на унарний плюс'),
(N'5-3',   N'm',  1, N'5m3',   N'Заміна - на унарний мінус'),
(N'(+5)',  N'p',  1, N'(p5)',  N'Заміна + після дужки'),
(N'(-5)',  N'm',  1, N'(m5)',  N'Заміна - після дужки'),
(N'abc',   N'a',  0, N'abc',   N'Заміна символу на такий самий'),
(N'12345', N'0',  4, N'12340', N'Заміна цифри цифрою'),
(N'a b',   N'_',  1, N'a_b',   N'Заміна пробілу'),
(N'abc',   N' ',  1, N'a c',   N'Підстановка пробілу'),
(N'abcde', N'Z',  3, N'abcZe', N'Заміна у довшому рядку');
GO

SELECT * FROM dbo.IsOperatorData;
SELECT * FROM dbo.InsertSymbolData;
GO
