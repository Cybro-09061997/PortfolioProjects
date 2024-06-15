Select * from PortfolioProject..[Nashville Housing]
--Standardize Date Format
Select SaleDate, CONVERT(date, SaleDate) as SaleDateProper from PortfolioProject..[Nashville Housing]

Update [Nashville Housing] SET SaleDate = CONVERT(date,SaleDate)

Select SaleDateConverted from PortfolioProject..[Nashville Housing]

Alter Table [Nashville Housing] Add SaleDateConverted Date;

Update [Nashville Housing] SET SaleDateConverted = CONVERT(date,SaleDate)

--Populate Property Address Date
Select PropertyAddress from PortfolioProject..[Nashville Housing]
Select PropertyAddress from PortfolioProject..[Nashville Housing] where PropertyAddress is null

Select * from PortfolioProject..[Nashville Housing] order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress 
from PortfolioProject..[Nashville Housing] a
Join PortfolioProject..NashvilleHousingFilterDatabase b on 
a.ParcelID = b.ParcelID And a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, 
ISNULL(a.PropertyAddress, b.PropertyAddress) 
from PortfolioProject..[Nashville Housing] a
Join PortfolioProject..NashvilleHousingFilterDatabase b on 
a.ParcelID = b.ParcelID And a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress) 
from PortfolioProject..[Nashville Housing] a
Join PortfolioProject..NashvilleHousingFilterDatabase b on
a.ParcelID = b.ParcelID And a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is Null

--Breaking out Address into individual columns(Address, City, State)
Select PropertyAddress from PortfolioProject..[Nashville Housing]

Select SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress) -1) as Address
from PortfolioProject..[Nashville Housing]

Select SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, Len(PropertyAddress)) as City
from PortfolioProject..[Nashville Housing]

Alter Table [Nashville Housing] Add PropertySplitAddress Nvarchar(255)

Update [Nashville Housing]
Set PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress) -1)

Alter Table [Nashville Housing] Add PropertySplitCity Nvarchar(255)

Update [Nashville Housing]
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

Select PropertySplitAddress, PropertySplitCity from PortfolioProject..[Nashville Housing]

--Parsing
Select OwnerAddress from PortfolioProject..[Nashville Housing]
Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) as State,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) as City,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) as Adress
from PortfolioProject..[Nashville Housing]

Alter Table [Nashville Housing] Add OwnerSplitAddress Nvarchar(255)

Update [Nashville Housing]
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

Alter Table [Nashville Housing] Add OwnerSplitCity Nvarchar(255)

Update [Nashville Housing]
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

Alter Table [Nashville Housing] Add OwnerSplitState Nvarchar(255)

Update [Nashville Housing]
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

Select OwnerSplitAddress, OwnerSplitCity, OwnerSplitState from PortfolioProject..[Nashville Housing]

Select * from PortfolioProject..[Nashville Housing]

--Change Y and N to Yes and No in "Sold as vacant" Field
Select Distinct(SoldAsVacant), Count(SoldAsVacant) from PortfolioProject..[Nashville Housing]
Group By SoldAsVacant Order by 2

Select SoldAsVacant,
Case When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
End
from PortfolioProject..[Nashville Housing]

Update [Nashville Housing]
Set SoldAsVacant = Case when SoldAsVacant = 'Y' Then 'Yes'
						When SoldAsVacant = 'N' Then 'No'
						Else SoldAsVacant
					End

Select Distinct(SoldAsVacant),COUNT(SoldAsVacant) from PortfolioProject..[Nashville Housing]
Group by SoldAsVacant Order by 2

--Remove Duplicates
With RowNumCTE As(
Select *,
	ROW_NUMBER() over(Partition By
	ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	Order By UniqueID
	) row_num
from PortfolioProject..[Nashville Housing]
)

Select * from RowNumCTE
where row_num > 1 order by PropertyAddress

With RowNumCTE As(
Select *,
	ROW_NUMBER() over(Partition By
	ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	Order By UniqueID
	) row_num
from PortfolioProject..[Nashville Housing]
)

Delete from RowNumCTE
where row_num > 1

--Drop unused columns
Select * from [Nashville Housing]

Alter Table [Nashville Housing]
Drop Column OwnerAddress, PropertyAddress, SaleDate, TaxDistrict