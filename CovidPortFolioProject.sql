--Select * from PortfolioProject..CovidData1
--Select * from PortfolioProject..CovidData2

--Select data we are going to be using
--CovidDeaths
Select location, date, total_cases, new_cases, total_deaths, population 
from PortfolioProject..CovidData1 order by 1,2

--Looking at total cases vs total deaths
Select location, date, total_cases, total_deaths, (Cast(total_deaths as float)/Cast(total_cases as float))*100 
as DeathPercentage from PortfolioProject..CovidData1
where location = 'India'
order by 1,2

--Looking at total cases vs population
Select location, date, population, total_cases, (Cast(total_deaths as float)/Cast(population as float))*100 
as PercentagePopulationInfected from PortfolioProject..CovidData1
where location = 'India'
order by 1,2

--Looking at countries with highest death count per population
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidData1 where continent is not null 
Group by location order by TotalDeathCount desc

--Breaking down by Continent
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidData1 where continent is not null 
Group by continent order by TotalDeathCount desc

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidData1 where continent is null 
Group by location order by TotalDeathCount desc

--Global Numbers
Select date, SUM(new_cases) TotalCases, SUM(new_deaths) TotalDeaths, 
(SUM(new_deaths)/Nullif(SUM(new_cases), 0)*100) DeathPercentage
from PortfolioProject..CovidData1 where continent is not null
Group by date order by 1, 2
--Without Grouping finding total cases, deaths and the overall percentage of the world
Select SUM(new_cases) TotalCases, SUM(new_deaths) TotalDeaths, 
(SUM(new_deaths)/Nullif(SUM(new_cases), 0)*100) DeathPercentage
from PortfolioProject..CovidData1 where continent is not null
order by 1, 2

--Total Population VS Total Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from PortfolioProject..CovidData1 dea
Join PortfolioProject..CovidData2 vac 
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 1,2,3

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Convert(bigint, vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.date rows unbounded preceding) RollingPeopleVaccinated
from PortfolioProject..CovidData1 dea
Join PortfolioProject..CovidData2 vac 
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 2,3

--Using CTE(Common Table Expression) Population VS Vaccination
With PopvsVac(Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) as
(Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Convert(bigint, vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.date rows unbounded preceding) RollingPeopleVaccinated
from PortfolioProject..CovidData1 dea
Join PortfolioProject..CovidData2 vac 
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentageRollinPeopleVaccinated
from PopvsVac

--Temp Table
Drop table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
Continent nvarchar(500),
Location nvarchar(500),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Convert(bigint, vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.date rows unbounded preceding) RollingPeopleVaccinated
from PortfolioProject..CovidData1 dea
Join PortfolioProject..CovidData2 vac 
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null

Select *, (RollingPeopleVaccinated/Population)*100 as PercentageRollinPeopleVaccinated
from #PercentPopulationVaccinated

--View
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Convert(bigint, vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.date rows unbounded preceding) RollingPeopleVaccinated
from PortfolioProject..CovidData1 dea
Join PortfolioProject..CovidData2 vac 
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null

Select * from PercentPopulationVaccinated