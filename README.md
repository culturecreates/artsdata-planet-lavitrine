# artsdata-lavitrine

Website prepared for loading into LaVitrine.

Each website is loaded into Artsdata and has an input pipeline and output pipline.  The input pipeline transforms the original website data into the Artsdata data model. The output pipeline transforms Artsdata data model into the LaVitrine data model.


# Grand Theatre de Québec

## Input pipeline

This website is crawled by an agent on the Artsdata Huginn platform.

It also has a taxonomy (file gtq0 to map strings from the original website to Artsdata event types.

### Internal Links

Link to Huggin https://huginn-staging.herokuapp.com/scenarios/26/diagram


### Compare event images between original website and Artsdata
https://api.artsdata.ca/events?source=http://kg.artsdata.ca/culture-creates/huginn/derived-grandtheatre-qc-ca

https://grandtheatre.qc.ca/programmation/


## Output pipeline

JSON-LD download 
http://api.artsdata.ca/query.jsonld?limit=300&frame=lavitrine/events3&sparql=lavitrine/events3&graph=http://kg.artsdata.ca/culture-creates/huginn/derived-grandtheatre-qc-ca

JSON download
http://api.artsdata.ca/query.json?limit=300&frame=lavitrine/events3&sparql=lavitrine/events3&graph=http://kg.artsdata.ca/culture-creates/huginn/derived-grandtheatre-qc-ca


# Place des Arts

## Datafeed

Footlight Console
https://console.footlight.io/events?seedurl=placedesarts-com



## Compare event images between Artsdata and website
https://api.artsdata.ca/events?source=http://kg.artsdata.ca/culture-creates/footlight/placedesarts-com

https://placedesarts.com/fr/evenements
