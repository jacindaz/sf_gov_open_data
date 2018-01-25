# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

data_sources = [
  {
    title: "Affordable Housing Pipeline",
    data_sf_uuid: "aaxw-2cb8",
    url: "https://data.sfgov.org/Housing-and-Buildings/Affordable-Housing-Pipeline/aaxw-2cb8",
    table_name: "affordable_housing_pipeline",
    date_downloaded: Date.new(2018, 1, 24),
    data_freshness_date: Date.new(2017, 8, 9),
    description: "Snapshot of the Mayor’s Office of Housing and Community Development (MOHCD) and the Office of Community Investment and Infrastructure (OCII) affordable housing pipeline projects. The projects listed are in the process of development--or are anticipated to be developed--in partnership with non-profit or for-profit developers and financed through city funding agreements, ground leases, disposition and participation agreements and conduit bond financing. The Affordable Housing Pipeline also includes housing units produced by private developers through the Inclusionary Affordable Housing Program. Data reflects all projects as of FY2016-17."
  },
  {
    title: "Assessor Historical Secured Property Tax Rolls",
    data_sf_uuid: "wv5m-vpq2",
    url: "https://data.sfgov.org/Housing-and-Buildings/Assessor-Historical-Secured-Property-Tax-Rolls/wv5m-vpq2",
    table_name: "assessor_historical_secured_property_tax_roles",
    date_downloaded: Date.new(2018, 1, 24),
    data_freshness_date: Date.new(2017, 8, 17),
    description: "This data set includes the Office of the Assessor-Recorder’s secured property tax roll spanning from 2007 to 2016. It includes all legally disclosable information, including location of property, value of property, the unique property identifier, and specific property characteristics. The data is used to accurately and fairly appraise all taxable property in the City and County of San Francisco. The Office of the Assessor-Recorder makes no representation or warranty that the information provided is accurate and/or has no errors or omissions. Please see the attached documentation under About for more."
  },
  {
    title: "Buyout agreements",
    data_sf_uuid: "wmam-7g8d",
    url: "https://data.sfgov.org/Housing-and-Buildings/Buyout-agreements/wmam-7g8d",
    table_name: "buyout_agreements",
    date_downloaded: Date.new(2018, 1, 24),
    data_freshness_date: Date.new(2017, 12, 28),
    description: "Contains buyout declarations and buyout agreements filed at the Rent Board. Rent Ordinance Section 37.9E, effective March 7, 2015, is a new provision that regulates 'buyout agreements' between landlords and tenants under which landlords pay tenants money or other consideration to vacate their rent-controlled rental units. For more information, please see: http://sfrb.org/new-ordinance-amendment-regulating-buyout-agreements"
  },
  {
    title: "Eviction Notices",
    data_sf_uuid: "5cei-gny5",
    url: "https://data.sfgov.org/Housing-and-Buildings/Eviction-Notices/5cei-gny5",
    table_name: "eviction_notices",
    date_downloaded: Date.new(2018, 1, 24),
    data_freshness_date: Date.new(2017, 12, 28),
    description: "Data includes eviction notices filed with the San Francisco Rent Board per San Francisco Administrative Code 37.9(c). A notice of eviction does not necessarily indicate that the tenant was eventually evicted, so the notices below may differ from actual evictions. Notices are published since January 1, 1997."
  },
  {
    title: "Building Permits",
    data_sf_uuid: "i98e-djp9",
    url: "https://data.sfgov.org/Housing-and-Buildings/Building-Permits/i98e-djp9",
    table_name: "building_permits",
    date_downloaded: Date.new(2018, 1, 24),
    data_freshness_date: Date.new(2018, 1, 20),
    description: "This data set pertains to all types of structural permits. Data includes details on application/permit numbers, job addresses, supervisorial districts, and the current status of the applications. Data is uploaded weekly by DBI. Users can access permit information online through DBI’s Permit Tracking System which is 24/7 at www.sfdbi.org/dbipts."
  },
]

DataSource.create(data_sources)
