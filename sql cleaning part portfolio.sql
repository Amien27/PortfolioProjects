select * from dbo.NashvilleHousing

--standardize Date Format
 select SaleDateConverted, convert (Date, SaleDate)
 from dbo.NashvilleHousing

 Update NashvilleHousing
 Set SaleDate= Convert(date, SaleDate)

 Alter Table NashvilleHousing
 Add SaleDateConverted Date;

 Update NashvilleHousing
 set SaleDateConverted= convert(date,Saledate)


 --Populate Property Address data

 select *
 from dbo.NashvilleHousing
 --where PropertyAddress is null
 order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from dbo.NashvilleHousing a
JOIN dbo.NashvilleHousing b
 on a.ParcelID= b.ParcelID
 and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress= isnull(a.PropertyAddress,b.PropertyAddress)
from dbo.NashvilleHousing a
JOIN dbo.NashvilleHousing b
 on a.ParcelID= b.ParcelID
 and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


--Breaking out address into individual columns (address, city, state)
select PropertyAddress
 from dbo.NashvilleHousing
 --where PropertyAddress is null
-- order by ParcelID

Select
substring (PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1) as Address,
substring (PropertyAddress,CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address
from dbo.NashvilleHousing

Alter table NashvilleHousing
Add PropertySplitAddress nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = substring (PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1)

Alter table NashvilleHousing
Add PropertySplitCity nvarchar(255);

Update NashvilleHousing
Set PropertySplitCity = substring (PropertyAddress,CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

Select * from NashvilleHousing

Select OwnerAddress
From dbo.NashvilleHousing

Select 
PARSENAME(replace(owneraddress,',','.'),3),
PARSENAME(replace(owneraddress,',','.'),2),
PARSENAME(replace(owneraddress,',','.'),1)
from dbo.NashvilleHousing

Alter table NashvilleHousing
Add OwnerSplitAddress nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(replace(owneraddress,',','.'),3)

Alter table NashvilleHousing
Add OwnerSplitCity nvarchar(255);

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(replace(owneraddress,',','.'),2)

Alter table NashvilleHousing
Add OwnerSplitState nvarchar(255);

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(replace(owneraddress,',','.'),1)

Select * from dbo.NashvilleHousing



--Change Y and N in SoldAsVacant column
Select distinct(soldasvacant), count(soldasvacant)
from dbo.NashvilleHousing
group by SoldAsVacant
order by 2

select soldasvacant,
case when soldasvacant = 'Y' then 'Yes'
     when soldasvacant = 'N' then 'No'
     else soldasvacant
     end
from dbo.NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = case when soldasvacant = 'Y' then 'Yes'
     when soldasvacant = 'N' then 'No'
     else soldasvacant
     end

--Remove Duplicates

with RowNumCTE as(
select *,
 ROW_NUMBER() OVER (
 PARTITION BY ParcelID,
              PropertyAddress,
              SaleDate,
              LegalReference
              Order by
                UniqueID
                )row_num
from dbo.NashvilleHousing
--order by ParcelID
)

delete 
from RowNumCTE
where row_num >1
--Order by PropertyAddress

select *                --(yg ni takboleh guna sebb cte boleh guna sekali shj, kena ganti yg delete)
from RowNumCTE
where row_num >1
Order by PropertyAddress



--Delete unused columns

Select * from dbo.NashvilleHousing

alter table dbo.nashvillehousing
drop column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate









