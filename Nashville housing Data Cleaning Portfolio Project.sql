/*

Cleaning data in SQL Quaries

*/

SELECT * 
FROM Portfolioproject.dbo.Nashvillehousing

----------------------------------------------------------------------------

-- standardize Date Format

SELECT SaleDateConverted, CONVERT(Date,SaleDate)
FROM Portfolioproject.dbo.Nashvillehousing


UPDATE Nashvillehousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE Nashvillehousing
ADD SaleDateConverted Date

UPDATE Nashvillehousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


----------------------------------------------------------------


--Propulate PropertyAddress Data


SELECT *
FROM  Portfolioproject.dbo.Nashvillehousing
WHERE PropertyAddress is null
ORDER BY ParcelID


SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM  Portfolioproject.dbo.Nashvillehousing a
JOIN Portfolioproject.dbo.Nashvillehousing b
    ON a.ParcelID = b.ParcelID
    AND a.[UniqueID ]  <> b.[UniqueID ] 
WHERE a.PropertyAddress is null
 

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM  Portfolioproject.dbo.Nashvillehousing a
JOIN Portfolioproject.dbo.Nashvillehousing b
    ON a.ParcelID = b.ParcelID
    AND a.[UniqueID ]  <> b.[UniqueID ]	
WHERE a.PropertyAddress is null

	-----------------------------------------------------------------------------------------------------


--Breaking out Address into Individual Columns (Address,City,State)


SELECT PropertyAddress
FROM  Portfolioproject.dbo.Nashvillehousing
--wHERE PropertyAddress is null
ORDER BY ParcelID

SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS Address
,SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress)) as Address
FROM  Portfolioproject.dbo.Nashvillehousing



ALTER TABLE Nashvillehousing
ADD PropertySplitAddress Nvarchar(255)

UPDATE Nashvillehousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)


ALTER TABLE Nashvillehousing
ADD PropertySplitCity Nvarchar(255)

UPDATE Nashvillehousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))


SELECT *
FROM  Portfolioproject.dbo.Nashvillehousing



SELECT OwnerAddress
FROM Portfolioproject.dbo.Nashvillehousing


SELECT
PARSENAME(Replace(OwnerAddress,',' , '.'), 3)
,PARSENAME(Replace(OwnerAddress,',' , '.'), 2)
,PARSENAME(Replace(OwnerAddress,',' , '.'), 1)
FROM Portfolioproject.dbo.Nashvillehousing


ALTER TABLE Nashvillehousing
ADD OwnerSplitAddress Nvarchar(255)

UPDATE Nashvillehousing
SET OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',' , '.'), 3)

ALTER TABLE Nashvillehousing
ADD OwnerSplitCity Nvarchar(255)

UPDATE Nashvillehousing
SET OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',' , '.'), 2)



ALTER TABLE Nashvillehousing
ADD OwnerSplitState Nvarchar(255)

UPDATE Nashvillehousing
SET OwnerSplitState = PARSENAME(Replace(OwnerAddress,',' , '.'), 1)

SELECT*
FROM Portfolioproject.dbo.Nashvillehousing

---------------------------------------------------------------------

--Change Y and N to Yes and No in SoldAsVacant Field 

SELECT DISTINCT SoldAsVacant ,count(SoldAsVacant)
FROM Portfolioproject.dbo.Nashvillehousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
  CASE when SoldAsVacant ='Y' THEN 'Yes'
     when SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM Portfolioproject.dbo.Nashvillehousing

UPDATE Nashvillehousing
SET SoldAsVacant = CASE when SoldAsVacant ='Y' THEN 'Yes'
     when SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
	 
----------------------------------------------------------------------

--Remove Dublicates



WITH RownumCTE As
	(SELECT*,
	ROW_NUMBER() OVER(
		PARTITION BY ParcelID,
		PropertyAddress,
		SaleDate,
		SalePrice,
		LegalReference
		ORDER BY UniqueID) row_num
	 FROM Portfolioproject.dbo.Nashvillehousing)
 SELECT*
 FROM RownumCTE
 WHERE row_num > 1
 ORDER BY PropertyAddress






SELECT*
FROM Portfolioproject.dbo.Nashvillehousing


---------------------------------------------------------

--Delete Unused Columns



SELECT*
FROM Portfolioproject.dbo.Nashvillehousing



ALTER TABLE Portfolioproject.dbo.Nashvillehousing
DROP COLUMN OwnerAddress,PropertyAddress,TaxDistrict

ALTER TABLE Portfolioproject.dbo.Nashvillehousing
DROP COLUMN SaleDate









 