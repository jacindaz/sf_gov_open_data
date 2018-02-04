[![Code Climate](https://codeclimate.com/github/jacindaz/sf_gov_open_data/badges/gpa.svg)](https://codeclimate.com/github/jacindaz/sf_gov_open_data)
[![Test Coverage](https://codeclimate.com/github/jacindaz/sf_gov_open_data/badges/coverage.svg)](https://codeclimate.com/github/jacindaz/sf_gov_open_data/coverage)
[ ![Codeship Status for jacindaz/sf_gov_open_data](https://app.codeship.com/projects/c8866160-75ad-0135-b3ad-0ebb57710284/status?branch=master)](https://app.codeship.com/projects/244281)

# Using SF Public Safety Data

https://data.sfgov.org/Public-Safety/Police-Department-Incidents-Explorer/vsk2-um2x
https://datasf.org/showcase/

## Technical To Do's:
* switch to using new bundler filenames, Gemfile => gems.rb, Gemfile.lock => gems.locked
(https://depfu.com/blog/2017/09/06/gemfiles-new-clothes)


## To Do's
* make `select <col1>, <col2>` work
* export query results to csv
* refactor: do i really need a `QueriesController` ?
* queue query jobs to sidekiq
* tests for importing eviction notices csv data
* normalize with other police data sets
* grab 2017 data: https://data.sfgov.org/Public-Safety/Police-Department-Incidents-Current-Year-2017-/9v2m-8wqu

## Notes
* expand CleanupData class to be for all tables (right now for only 1 table)
* add a cleanup_data.perform method
* rake task shouldn't need to know which methods to call
* also then perform can handle knowing which columns we've already checked. like if a column is not type "text" then we've already checked, and can skip
* also, should add some high level tests to make sure data was transformed properly
* add logging to an errors logfile like SetupTable

## Resources and Links
* https://data.sfgov.org/browse?category=Housing+and+Buildings
* https://data.sfgov.org/Housing-and-Buildings/Eviction-Notices/5cei-gny5
* https://github.com/socrata/soda-ruby
* https://www.opendatanetwork.com/dataset/data.sfgov.org/5cei-gny5
* https://socratadiscovery.docs.apiary.io/#reference/0/text-search
* https://dev.socrata.com/docs/queries/
