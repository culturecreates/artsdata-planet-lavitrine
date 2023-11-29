# Data Pipelines for LaVitrine
[![Artsdata Export](https://github.com/culturecreates/artsdata-planet-lavitrine/actions/workflows/artsdata-export.yml/badge.svg)](https://github.com/culturecreates/artsdata-planet-lavitrine/actions/workflows/artsdata-export.yml)

The artsdata-planet-lavitrine pipeline transforms data from Artsdata.ca into the LaVitrine data model. All the configs and batch scripts are managed in this repo.

The LaVitrine data model differs slightly from the Artsdata data model. This pipeline transforms data from the Artsdata model to better fit the LaVitrine model. For a discussion see [Github Discussions](https://github.com/culturecreates/artsdata-planet-lavitrine/discussions/categories/modelling-discussions)

## Artifacts
This repo generates the following artifacts derived from Artsdata and refreshes them on a regular schedule:

### External websites
* [grandtheatre-qc-ca](https://api.artsdata.ca/databus/artifact/latest?artifact=http%3A%2F%2Fkg.artsdata.ca%2Fdatabus%2Fculture-creates%2Fartsdata-planet-lavitrine%2Fgrandtheatre-qc-ca)
* [placedesarts-com](https://api.artsdata.ca/databus/artifact/latest?artifact=http%3A%2F%2Fkg.artsdata.ca%2Fdatabus%2Fculture-creates%2Fartsdata-planet-lavitrine%2Fplacedesarts-com)
* [dia-logGraphs](https://api.artsdata.ca/databus/artifact/latest?artifact=http%3A%2F%2Fkg.artsdata.ca%2Fdatabus%2Fculture-creates%2Fartsdata-planet-lavitrine%2Fdia-logGraphs) - see websites that are [part of dia-log](https://kg.artsdata.ca/resource/dia-logGraphs) 
* [hector-charland-com](https://api.artsdata.ca/databus/artifact/latest?artifact=http%3A%2F%2Fkg.artsdata.ca%2Fdatabus%2Fculture-creates%2Fartsdata-planet-lavitrine%2Fhector-charland-com) 
* [theatredumarais-com](https://api.artsdata.ca/databus/artifact/latest?artifact=http%3A%2F%2Fkg.artsdata.ca%2Fdatabus%2Fculture-creates%2Fartsdata-planet-lavitrine%2Ftheatredumarais-com) 
* Tout Culture - coming soon
* Signé Laval - coming soon

### Artsdata Entities in Quebec
* Organizations - coming soon
* Venues - coming soon
* Artists - coming soon

# Grand Théâtre de Québec

https://grandtheatre.qc.ca

This website is crawled by an agent on the Artsdata platform. See https://github.com/culturecreates/artsdata-planet-gtq for details. It also has a taxonomy [gtq-event-type-mapping.ttl](https://github.com/culturecreates/artsdata-planet-gtq/blob/main/gtq-event-type-mapping.ttl) to map strings from the original website to Artsdata event types. 

## Compare sources

One way to visually check if the event data looks good is to compare event images between the source website and Artsdata using the generic Artsdata Viewer (new version coming end of 2023).

| Source | link |
|-----:|---------------|
|GTQ |  https://grandtheatre.qc.ca/programmation/  |
| Artsdata Viewer|    https://api.artsdata.ca/events?source=http://kg.artsdata.ca/culture-creates/huginn/derived-grandtheatre-qc-ca           |

 
## Output 

The GTQ event data from Artsdata is saved to a dump daily using Github workflows managed in this repo. To download a dump you must call the Artsdata Databus API and pass the URI of the artifact. This will return the downloadUrl to download the data dump. 

Data dump [latest artifact](https://api.artsdata.ca/databus/artifact/latest?artifact=http%3A%2F%2Fkg.artsdata.ca%2Fdatabus%2Fculture-creates%2Fartsdata-planet-lavitrine%2Fgrandtheatre-qc-ca) | [all artifacts](https://api.artsdata.ca/databus/artifact?artifact=http%3A%2F%2Fkg.artsdata.ca%2Fdatabus%2Fculture-creates%2Fartsdata-planet-lavitrine%2Fgrandtheatre-qc-ca) 


# Place des Arts
https://placedesarts.com

This website is crawed using Footlight. Footlight is a managed service by Culture Creates. Here is a link to the Footlight Console
https://console.footlight.io/events?seedurl=placedesarts-com


## Compare sources

One way to visually check if the event data looks good is to compare event images between the source website and Artsdata using the generic Artsdata Event viewer (new version coming end of 2023).

| Source | link |
|-----:|---------------|
|PDA |  https://placedesarts.com/fr/evenements  |
| Footlight | https://console.footlight.io/events?seedurl=placedesarts-com&view=mosaic |
| Artsdata|  https://api.artsdata.ca/events?source=http://kg.artsdata.ca/culture-creates/footlight/placedesarts-com         |


## Output 

The PDA event data from Artsdata is saved to a dump daily using Github workflows managed in this repo. To download a dump you must call the Artsdata Databus API and pass the URI of the artifact. This will return the downloadUrl to download the data dump. 

Data dump [latest artifact](https://api.artsdata.ca/databus/artifact/latest?artifact=http%3A%2F%2Fkg.artsdata.ca%2Fdatabus%2Fculture-creates%2Fartsdata-planet-lavitrine%2Fplacedesarts-com) | [all artifacts](https://api.artsdata.ca/databus/artifact?artifact=http%3A%2F%2Fkg.artsdata.ca%2Fdatabus%2Fculture-creates%2Fartsdata-planet-lavitrine%2Fplacedesarts-com) 
