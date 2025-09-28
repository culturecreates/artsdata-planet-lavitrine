# Data Pipelines for LaVitrine
[![Batch LaVitrine Pipeline](https://github.com/culturecreates/artsdata-planet-lavitrine/actions/workflows/caller-batch-pipeline.yml/badge.svg)](https://github.com/culturecreates/artsdata-planet-lavitrine/actions/workflows/caller-batch-pipeline.yml)

The artsdata-planet-lavitrine pipeline transforms data from Artsdata.ca into the LaVitrine data model. All the configs and batch scripts are managed in this repo.

The LaVitrine data model differs slightly from the Artsdata data model. This pipeline transforms data from the Artsdata model to better fit the LaVitrine model. For a discussion see [Github Discussions](https://github.com/culturecreates/artsdata-planet-lavitrine/discussions/categories/modelling-discussions)

## Artifacts
This repo generates the following artifacts derived from Artsdata and refreshes them on a daily schedule. An artifact is a versioned dump of all events on a website including nested places, people, organizations and event types.

Table of source dataset uploads [here](http://kg.artsdata.ca/en/query/show?sparql=custom%2Flavitrine_sources_refresh_rate&title=LaVitrine+Pipeline).

View the history of daily workflow dumps [here](https://github.com/culturecreates/artsdata-planet-lavitrine/actions).



### External websites

The following websites are included:
http://kg.artsdata.ca/resource/LaVitrineSources

Websites are packaged into the following 8 artifacts. Click on any of the following artifacts to get a link to download the JSON data **file**.
* [grandtheatre-qc-ca](https://api.artsdata.ca/databus/artifact/latest?artifact=http%3A%2F%2Fkg.artsdata.ca%2Fdatabus%2Fculture-creates%2Fartsdata-planet-lavitrine%2Fgrandtheatre-qc-ca) - Website events from https://grandtheatre.qc.ca
* [placedesarts-com](https://api.artsdata.ca/databus/artifact/latest?artifact=http%3A%2F%2Fkg.artsdata.ca%2Fdatabus%2Fculture-creates%2Fartsdata-planet-lavitrine%2Fplacedesarts-com) - Website events from https://placedesarts.com
* [dia-logGraphs](https://api.artsdata.ca/databus/artifact/latest?artifact=http%3A%2F%2Fkg.artsdata.ca%2Fdatabus%2Fculture-creates%2Fartsdata-planet-lavitrine%2Fdia-logGraphs) - Selection of websites from  [dia-log](https://kg.artsdata.ca/resource/dia-logGraphs) 
* [hector-charland-com](https://api.artsdata.ca/databus/artifact/latest?artifact=http%3A%2F%2Fkg.artsdata.ca%2Fdatabus%2Fculture-creates%2Fartsdata-planet-lavitrine%2Fhector-charland-com) - Website events from https://hector-charland.com
* [theatredumarais-com](https://api.artsdata.ca/databus/artifact/latest?artifact=http%3A%2F%2Fkg.artsdata.ca%2Fdatabus%2Fculture-creates%2Fartsdata-planet-lavitrine%2Ftheatredumarais-com) - Website events from https://theatredumarais.com
* [tout-culture-cms-events](https://api.artsdata.ca/databus/artifact/latest?artifact=http%3A%2F%2Fkg.artsdata.ca%2Fdatabus%2Fculture-creates%2Fartsdata-planet-lavitrine%2Ftout-culture-cms-events) - Outaouais region events from https://toutculture.ca 
* [signe-laval-cms-events](https://api.artsdata.ca/databus/artifact/latest?artifact=http%3A%2F%2Fkg.artsdata.ca%2Fdatabus%2Fculture-creates%2Fartsdata-planet-lavitrine%2Fsigne-laval-cms-events) - Laval region events from https://signelaval.com/fr
* [culture-mauricie-cms-events](https://api.artsdata.ca/databus/artifact/latest?artifact=http%3A%2F%2Fkg.artsdata.ca%2Fdatabus%2Fculture-creates%2Fartsdata-planet-lavitrine%2Fculture-mauricie-cms-events) - Culture Mauricie region events

### Artsdata Entities in Quebec
* Organizations - coming soon
* Venues - coming soon
* Artists - coming soon

# Data Model

For a formal documentation of the classes and properties of the La Vitrine data model used in this pipeline, please consult the JSON-LD Frame  [lavitrine_event_frame.jsonld](https://github.com/culturecreates/artsdata-planet-lavitrine/blob/main/frame/lavitrine_event_frame.jsonld).

All event data is passed through this JSON-LD Frame. The concept is similar to GraphQL. The Frame selects the properties to be extracted for each class including nested classes.

The pipeline also checks the artifacts for violations based on the data model SHACL [here](https://github.com/culturecreates/artsdata-planet-lavitrine/tree/main/shacl). The list of violations for each artifact can be viewed by switching the extension of the download url from `.json` to `.yml`. If the file is empty then there are no violations. The list of violations contains a reference to the event URI and the related SHACL rules that are in violation.

As new data arrives, new violations will occur due to the distributed community based nature of Artsdata. Most issues can be fixed direclty in this pipeline. Other issues will have to be communicated to the source data contributor. 

> Please raise an issue in this Github repo if you find data model violations blocking your reuse of the data dumps.

# Specific Cases

## Grand Théâtre de Québec

https://grandtheatre.qc.ca

This website is crawled by an agent on the Artsdata platform. See https://github.com/culturecreates/artsdata-planet-gtq for details. It also has a taxonomy [gtq-event-type-mapping.ttl](https://github.com/culturecreates/artsdata-planet-gtq/blob/main/gtq-event-type-mapping.ttl) to map strings from the original website to Artsdata event types. 

### Compare sources

One way to visually check if the event data looks good is to compare event images between the source website and Artsdata using the generic Artsdata Viewer (new version coming end of 2023).

| Source | link |
|-----:|---------------|
|GTQ |  https://grandtheatre.qc.ca/programmation/  |
| Artsdata Viewer|    https://api.artsdata.ca/events?source=http://kg.artsdata.ca/culture-creates/huginn/derived-grandtheatre-qc-ca           |

 
### Output 

The GTQ event data from Artsdata is saved to a dump daily using Github workflows managed in this repo. To download a dump you must call the Artsdata Databus API and pass the URI of the artifact. This will return the downloadUrl to download the data dump. 

Data dump [latest artifact](https://api.artsdata.ca/databus/artifact/latest?artifact=http%3A%2F%2Fkg.artsdata.ca%2Fdatabus%2Fculture-creates%2Fartsdata-planet-lavitrine%2Fgrandtheatre-qc-ca) | [all artifacts](https://api.artsdata.ca/databus/artifact?artifact=http%3A%2F%2Fkg.artsdata.ca%2Fdatabus%2Fculture-creates%2Fartsdata-planet-lavitrine%2Fgrandtheatre-qc-ca) 


## Place des Arts
https://placedesarts.com

This website is crawed using Footlight. Footlight is a managed service by Culture Creates. Here is a link to the Footlight Console
https://console.footlight.io/events?seedurl=placedesarts-com


### Compare sources

One way to visually check if the event data looks good is to compare event images between the source website and Artsdata using the generic Artsdata Event viewer (new version coming end of 2023).

| Source | link |
|-----:|---------------|
|PDA |  https://placedesarts.com/fr/evenements  |
| Footlight | https://console.footlight.io/events?seedurl=placedesarts-com&view=mosaic |
| Artsdata|  https://api.artsdata.ca/events?source=http://kg.artsdata.ca/culture-creates/footlight/placedesarts-com         |


### Output 

The PDA event data from Artsdata is saved to a dump daily using Github workflows managed in this repo. To download a dump you must call the Artsdata Databus API and pass the URI of the artifact. This will return the downloadUrl to download the data dump. 

Data dump [latest artifact](https://api.artsdata.ca/databus/artifact/latest?artifact=http%3A%2F%2Fkg.artsdata.ca%2Fdatabus%2Fculture-creates%2Fartsdata-planet-lavitrine%2Fplacedesarts-com) | [all artifacts](https://api.artsdata.ca/databus/artifact?artifact=http%3A%2F%2Fkg.artsdata.ca%2Fdatabus%2Fculture-creates%2Fartsdata-planet-lavitrine%2Fplacedesarts-com) 


## Installation

The pipeline can be run locally for development and testing. You will need Ruby 3 installed.

1. Clone repository from Github.
2. `bundle install`
3. `rake test`
4. `cd src ; ./batch.sh`
