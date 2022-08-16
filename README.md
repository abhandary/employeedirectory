# employeedirectory

## Build tools & versions used

* XCode 13.4.1

## Steps to run the app

* Run from XCode

## What areas of the app did you focus on?

Modularization & Inter Module Communication
* Consistent use of async and await and Tasks to do inter module communication with use of Combine as glue between View Model and View layer.
* Adhering to SOLID principles with each module having a single reponsibility usage of procols to achieve the 
* Layering of the app using MVVM architecture style with a separate service layer. 
* Use of a Repository, this enables abstraction of source of truth. Repo then can then fetch from Network of a local data store as needed.
* Use of protocols for repo and network module to enable LSP, interface segregation and dependency-inversion and use of mocks for unit testing.
* Use of Actors to provided isolated access to shared / exposed mutable state.

Asset Store
* Creation of a custom image store with persistent storage.

## What was the reason for your focus? What problems were you trying to solve?

## How long did you spend on this project?
* 10 hours

## Did you make any trade-offs for this project? What would you have done differently with more time?

UI
* Used a basic layout for the table view and a basic SwiftUI views for empty, error states. These could be improved to be visually more appealing. 
* Use of SwiftUI for the list view, this would have played well with use of Combine and may have enabled elimination of any mutable state such as the list of employees that are currently held in the view model and would have enabled removal of the Actors which are required to provide isolated acess to this shared mutable state. 

Image Store
* Use of batched writes, to reduce disk writes, this would speed up app’s overall performance, making it more responsive specially at startup, and reduces wear on users’ device storage
* Limiting the amount of batched up, pending writes and opportunistic flushing to disk to decrease overall memory use.

Inter Module Communication
* Use of Combine as glue between service layer and view model.

## What do you think is the weakest part of your project?

UI

## Did you copy any code or dependencies? Please make sure to attribute them here!

None. All written by me.

## Is there any other information you’d like us to know?
