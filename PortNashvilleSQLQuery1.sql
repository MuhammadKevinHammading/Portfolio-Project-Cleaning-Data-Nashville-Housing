
Select top 100*
From PortfolioProject..NashvilleHousing

Select SaleDateConverted, convert(date,SaleDate)
From PortfolioProject..NashvilleHousing

update PortfolioProject..NashvilleHousing
set SaleDate = convert(date,SaleDate)

Alter table PortfolioProject..NashvilleHousing
Add SaleDateConverted date

Update PortfolioProject..NashvilleHousing
Set SaleDateConverted = convert(date,SaleDate)

Select *
From PortfolioProject..NashvilleHousing
--Where PropertyAddress is null
Order by 2

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Select PropertyAddress
From PortfolioProject..NashvilleHousing
--Where PropertyAddress is null
--Order by 2

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', propertyaddress)-1) as Addres,
SUBSTRING(PropertyAddress, CHARINDEX(',', propertyaddress)+1, LEN(PropertyAddress)) as Addres
From PortfolioProject..NashvilleHousing

Alter table PortfolioProject..NashvilleHousing
Add PropertySplitAddress nvarchar(255)

Update PortfolioProject..NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', propertyaddress)-1)

Alter table PortfolioProject..NashvilleHousing
Add PropertySplitCity nvarchar(255)

Update PortfolioProject..NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', propertyaddress)+1, LEN(PropertyAddress))

Select *
From PortfolioProject..NashvilleHousing

Select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From PortfolioProject..NashvilleHousing

Alter table PortfolioProject..NashvilleHousing
Add OwnerSplitAddress nvarchar(255)

Alter table PortfolioProject..NashvilleHousing
Add OwnerSplitCity nvarchar(255)

Alter table PortfolioProject..NashvilleHousing
Add OwnerSplitState nvarchar(255)

Update PortfolioProject..NashvilleHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

Update PortfolioProject..NashvilleHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

Update PortfolioProject..NashvilleHousing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

Select distinct(SoldAsVacant), COUNT(SoldAsVacant)
From PortfolioProject..NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant,
Case	when SoldAsVacant = 'Y' then 'Yes'
		When SoldAsVacant = 'N' then 'No'
		Else SoldAsVacant
		End
From PortfolioProject..NashvilleHousing

Update PortfolioProject..NashvilleHousing
Set SoldAsVacant = Case	when SoldAsVacant = 'Y' then 'Yes'
						When SoldAsVacant = 'N' then 'No'
						Else SoldAsVacant
						End

With Dupl as (
Select *,
ROW_NUMBER() over (partition by ParcelID, PropertyAddress, SaleDate, LegalReference order by UniqueID) RowNumber
From PortfolioProject..NashvilleHousing
--Order by ParcelID
)
Select *
From Dupl
Where RowNumber >1
Order by PropertyAddress

Select *
From PortfolioProject..NashvilleHousing

Alter table PortfolioProject..NashvilleHousing
Drop column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate