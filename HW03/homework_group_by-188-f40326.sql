/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.
Занятие "02 - Оператор SELECT и простые фильтры, GROUP BY, HAVING".

Задания выполняются с использованием базы данных WideWorldImporters.

Бэкап БД можно скачать отсюда:
https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0
Нужен WideWorldImporters-Full.bak

Описание WideWorldImporters от Microsoft:
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-what-is
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-oltp-database-catalog
*/

-- ---------------------------------------------------------------------------
-- Задание - написать выборки для получения указанных ниже данных.
-- ---------------------------------------------------------------------------

USE WideWorldImporters

/*
1. Посчитать среднюю цену товара, общую сумму продажи по месяцам.
Вывести:
* Год продажи (например, 2015)
* Месяц продажи (например, 4)
* Средняя цена за месяц по всем товарам
* Общая сумма продаж за месяц

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

select year(si.InvoiceDate) год
	, MONTH(si.invoiceDate) месяц
	, avg(ct.TransactionAmount) 'средняя цена за месяц'
	, sum(ct.TransactionAmount) 'Общая сумма продаж за месяц'
	from [Sales].[Invoices] (nolock) si
	join [Sales].[CustomerTransactions] (nolock)ct on si.InvoiceID=ct.InvoiceID
	group by month(si.InvoiceDate), year(si.InvoiceDate)
	order by 1, 2

/*
2. Отобразить все месяцы, где общая сумма продаж превысила 4 600 000

Вывести:
* Год продажи (например, 2015)
* Месяц продажи (например, 4)
* Общая сумма продаж

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

select 
		year(si.invoiceDate) год
		, month(si.invoiceDate)
		, sum (ct.TransactionAmount)
	from [Sales].[Invoices] (nolock) si
	join [Sales].[CustomerTransactions] (nolock)ct on si.InvoiceID=ct.InvoiceID
	group by month(si.InvoiceDate), year(si.InvoiceDate)
	having sum (ct.TransactionAmount) > 4600000
	order by 1, 2

/*
3. Вывести сумму продаж, дату первой продажи
и количество проданного по месяцам, по товарам,
продажи которых менее 50 ед в месяц.
Группировка должна быть по году,  месяцу, товару.

Вывести:
* Год продажи
* Месяц продажи
* Наименование товара
* Сумма продаж
* Дата первой продажи
* Количество проданного

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

select year(si.invoiceDate) год
	, month(si.invoiceDate) месяц
	, wsi.StockItemName 'название товара' 
	, sum (ct.TransactionAmount) 'сумма продаж'
	, MIN(si.InvoiceDate)  'Дата первой продажи'
	, sum (il.Quantity) 'кол-во'
from [Sales].[Invoices] (nolock) si
	join [Sales].[CustomerTransactions] (nolock)ct on si.InvoiceID=ct.InvoiceID
	join [Sales].[InvoiceLines] (nolock) il on si.InvoiceID=il.InvoiceID
	join [Warehouse].[StockItems] (nolock) wsi on il.StockItemID=wsi.StockItemID
group by month(si.invoiceDate), wsi.StockItemName, year(si.invoiceDate)
HAVING SUM(il.Quantity) < 50


-- ---------------------------------------------------------------------------
-- Опционально
-- ---------------------------------------------------------------------------
/*
Написать запросы 2-3 так, чтобы если в каком-то месяце не было продаж,
то этот месяц также отображался бы в результатах, но там были нули.
*/
