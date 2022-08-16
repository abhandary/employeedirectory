# employeedirectory

## Build tools & versions used

* XCode 13.4.1

## Steps to run the app

* Run from XCode

## What areas of the app did you focus on?

* Modularization & Inter Module Communication
* Asset Store 
* UI updates

## What was the reason for your focus? What problems were you trying to solve?

**Modularization & Inter Module Communication**
* Consistent use of async and await and Tasks to enable inter module communications that require awaiting of results.
* Use of Actors to provided isolated access to internal as well as exposed / shared mutable state.
* Use of Combine as glue between View Model and View layer.
* Adhering to SOLID principles with each module having a single reponsibility. Use of protocols for repo and network module to enable dependency injection, LSP, interface segregation and dependency-inversion, this also supports use of mocks for unit testing.
* Layering of the app using MVVM architecture style with a separate service layer. 
* Use of a Repository, this enables abstraction of source of truth. Repo then can then fetch from Network or a local data store as needed. This also can create a parallel with Android where the repository can mirror the work done by an Android service enabling an Android version of this app to use a similar and consistent architecture. 

**Asset Store**
* Creation of a custom asset store for fetching and storing images, with use of in memory caching backed by persistent storage.
* Reducing battery consumption and minimizing network bandwidth usage by minimizing network calls and using in-memory and on disk cached assets to service image requests.
* Use of a custom asset store also minimizes code and app size bloat that would result from pulling in a third party framework that may have had features this project wouldn't need. 
* Use of a custom asset store also enables tuning of performance, especially for app launch time by minimizing and defering non-critical I/O operations during app launch.

**UI Updates**
* Not doing any UI updates unless the data has changed by use of a diffable data source. 


## How long did you spend on this project?
* 10 hours

## Did you make any trade-offs for this project? What would you have done differently with more time?

**UI**
* Used a basic layout for the table view and a basic SwiftUI views for empty, error states. These could be improved to be visually more appealing. 

**Inter Module Communication**
* Potential use of Combine as glue between service layer and view model to have consistency in inter module communication

**Asset Store**
* Use of batched writes, to reduce disk writes, this would speed up app’s overall performance, making it more responsive specially at app cold-start, and reduces wear on users’ device storage
* Limiting the amount of batched up, pending writes and use of opportunistic flushing to disk to decrease overall memory use.

## What do you think is the weakest part of your project?

* UI, could make it visually more appealing.

## Did you copy any code or dependencies? Please make sure to attribute them here!

None. All written by me, reuse of some code for the asset store from a different demo project. 

## Is there any other information you’d like us to know?
- 