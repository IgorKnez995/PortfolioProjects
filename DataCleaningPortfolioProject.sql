SELECT *
FROM PortfolioProject..NashvilleHousing


SELECT SaleDateConverted, CONVERT (date,SaleDate)
FROM PortfolioProject..NashvilleHousing

UPDATE NashvilleHousing 
SET SaleDate = CONVERT(date, SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted date;


UPDATE NashvilleHousing 
SET SaleDateConverted = CONVERT(date, SaleDate)




--------------------------------------------------------------------------------------------------------------------------



--Populate Property Adress Data


SELECT *
FROM PortfolioProject..NashvilleHousing
--WHERE PropertyAddress is NULL
order by ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing B
	on	a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<> b.[UniqueID ]
WHERE a.PropertyAddress is NULL


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing B
	on	a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<> b.[UniqueID ]
WHERE a.PropertyAddress is NULL


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM PortfolioProject..NashvilleHousing
--WHERE PropertyAddress is NULL
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1,LEN(PropertyAddress)) as Address
FROM PortfolioProject..NashvilleHousing


ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);


UPDATE NashvilleHousing 
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)


ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255);


UPDATE NashvilleHousing 
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1,LEN(PropertyAddress))

SELECT *
FROM PortfolioProject..NashvilleHousing

-- The Other Way to Separate String

SELECT OwnerAddress
FROM PortfolioProject..NashvilleHousing
where OwnerAddress is not Null


SELECT
PARSENAME (REPLACE(OwnerAddress, ',','.') , 3 )
,PARSENAME (REPLACE(OwnerAddress, ',','.') , 2)
,PARSENAME (REPLACE(OwnerAddress, ',','.') , 1)
FROM PortfolioProject..NashvilleHousing
where OwnerAddress is not Null

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);


UPDATE NashvilleHousing 
SET OwnerSplitAddress = PARSENAME (REPLACE(OwnerAddress, ',','.') , 3 )


ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);


UPDATE NashvilleHousing 
SET OwnerSplitCity = PARSENAME (REPLACE(OwnerAddress, ',','.') , 2)


ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255);


UPDATE NashvilleHousing 
SET OwnerSplitState = PARSENAME (REPLACE(OwnerAddress, ',','.') , 1)


SELECT *
FROM PortfolioProject..NashvilleHousing
WHERE OwnerAddress is NOT NULL



--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


SELECT Distinct(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2






SELECT SoldAsVacant 
, CASE when SoldAsVacant = 'Y'  THEN 'Yes'
	   when SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM PortfolioProject..NashvilleHousing


UPDATE PortfolioProject..NashvilleHousing

SET SoldAsVacant = CASE when SoldAsVacant = 'Y'  THEN 'Yes'
	   when SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

------------------------------------------------------------------------------------------------------------

--Remove duplicates


WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From PortfolioProject.dbo.NashvilleHousing




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

SELECT *
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate




























