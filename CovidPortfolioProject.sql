Select * 
From PortfolioProject..CovidDeaths$
Where continent is not null --should add to all scripts
order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths$
order by 1,2

-- Total Cases vs Total Deaths
-- Total Cases vs Population shows what percentage of population got Covid

Select Location, date, total_cases, total_deaths, (total_cases/population)*100 as Contraction
From PortfolioProject..CovidDeaths$
where location like '%dominican%'
order by 1,2

--Countries with highest infection rate compared to population

Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths$
--where location like '%dominican%'
group by location, Population
order by PercentPopulationInfected desc

-- Showing Countries with Highest Death Count per Population--
--Breaking down by continent--
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount 
From PortfolioProject..CovidDeaths$
where continent is null
group by location
order by TotalDeathCount desc

--Continents with highest death count per population--

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
Where continent is not null
Group by continent
Order by TotalDeathCount desc

--Global Numbers--

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
where continent is not null
group by date
order by 1,2


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as RollingVaccinations
--, (RollingVaccinations/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
Order by 2,3

--Use CTE--

With PopvsVac (continent, location, date, population, new_vaccinations, rollingvaccinations)
as
(Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as RollingVaccinations
--, (RollingVaccinations/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--Order by 2,3
)
Select *, (rollingvaccinations/population)*100
From PopvsVac


--Temp Table--
Drop Table if exists #PercentPopVaccinations
Create Table #PercentPopVaccinations
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingVaccinations numeric,
)

Insert Into #PercentPopVaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as RollingVaccinations
--, (RollingVaccinations/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--Order by 2,3

Select *, (RollingVaccinations/Population)*100
From #PercentPopVaccinations

--Creating View to store data for visualization--

Create View PercentPopVaccinations as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as RollingVaccinations
--, (RollingVaccinations/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--Order by 2,3

Select * 
From PercentPopVaccinations