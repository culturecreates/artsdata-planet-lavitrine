# Data Pipelines for LaVitrine

The artsdata-planet-lavitrine pipeline transforms data in the Artsdata.ca data model into the LaVitrine data model.

The LaVitrine data model differs slightly from the Artsdata data model. This pipeline transforms data from the Artsdata model to better fit the LaVitrine model. For a discussion see [Github Discussions](https://github.com/culturecreates/artsdata-planet-lavitrine/discussions/categories/modelling-discussions)


# Grand Theatre de Québec 

https://grandtheatre.qc.ca

This website is crawled by an agent on the Artsdata Huginn platform. It also has a taxonomy [gtq-event-type-mapping.ttl](https://github.com/culturecreates/artsdata-lavitrine/blob/main/gtq-event-type-mapping.ttl) to map strings from the original website to Artsdata event types. See https://github.com/culturecreates/artsdata-planet-gtq for details.

## Compare source with Artsdata

One way to visually check if the event data looks good is to compare event images between the source website and Artsdata using the generic Artsdata Event viewer (new version coming end of 2023).

| Source | link |
|-----:|---------------|
|GTQ |  https://grandtheatre.qc.ca/programmation/  |
| Artsdata|    https://api.artsdata.ca/events?source=http://kg.artsdata.ca/culture-creates/huginn/derived-grandtheatre-qc-ca           |




 
## Output [![Dump GTQ JSON to S3 Production](https://github.com/culturecreates/artsdata-lavitrine-planet/actions/workflows/dump-gtq.yml/badge.svg?event=workflow_dispatch)](https://github.com/culturecreates/artsdata-lavitrine-planet/actions/workflows/dump-gtq.yml)

The GTQ event data from Artsdata is saved to a dump daily. To download the dump place call the Artsdata Databus and pass the name of the artifact. This will return the downloadUrl of the data dump. You can also generate the data in real-time.

Data dump [all artifacts](https://api.artsdata.ca/databus/artifact?artifact=http%3A%2F%2Fkg.artsdata.ca%2Fdatabus%2Fculture-creates%2Fartsdata-planet-lavitrine%2Fgrandtheatre-qc-ca) | [latest artifact](https://api.artsdata.ca/databus/artifact/latest?artifact=http%3A%2F%2Fkg.artsdata.ca%2Fdatabus%2Fculture-creates%2Fartsdata-planet-lavitrine%2Fgrandtheatre-qc-ca)

Real-time [5 events JSON](http://api.artsdata.ca/query.json?limit=5&frame=lavitrine/events3&sparql=lavitrine/events3&graph=http://kg.artsdata.ca/culture-creates/huginn/derived-grandtheatre-qc-ca) | [all JSON](http://api.artsdata.ca/query.json?limit=300&frame=lavitrine/events3&sparql=lavitrine/events3&graph=http://kg.artsdata.ca/culture-creates/huginn/derived-grandtheatre-qc-ca) | [JSON-LD all events](http://api.artsdata.ca/query.jsonld?limit=300&frame=lavitrine/events3&sparql=lavitrine/events3&graph=http://kg.artsdata.ca/culture-creates/huginn/derived-grandtheatre-qc-ca) 


# Place des Arts
https://placedesarts.com

This website is crawed using Footlight. Footligth is a managed service by Culture Creates.

Footlight Console
https://console.footlight.io/events?seedurl=placedesarts-com


## Compare source with Artsdata

One way to visually check if the event data looks good is to compare event images between the source website and Artsdata using the generic Artsdata Event viewer (new version coming end of 2023).

| Source | link |
|-----:|---------------|
|PDA |  https://placedesarts.com/fr/evenements  |
| Artsdata|  https://api.artsdata.ca/events?source=http://kg.artsdata.ca/culture-creates/footlight/placedesarts-com         |


## Output
You can generate the data in real-time.

Realtime [5 events JSON](http://api.artsdata.ca/query.json?limit=5&frame=event_footlight&sparql=lavitrine/events3&graph=http://kg.artsdata.ca/culture-creates/footlight/placedesarts-com) | [JSON](http://api.artsdata.ca/query.json?limit=300&frame=event_footlight&sparql=lavitrine/events3&graph=http://kg.artsdata.ca/culture-creates/footlight/placedesarts-com) | [JSON-LD](http://api.artsdata.ca/query.jsonld?limit=300&frame=event_footlight&sparql=lavitrine/events3&graph=http://kg.artsdata.ca/culture-creates/footlight/placedesarts-com) 

Note: Using frame=event_footlight

