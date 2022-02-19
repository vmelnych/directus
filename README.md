# directus
It is a repository for Directus Headless CMS (https://directus.io/)

## Installation
1. Docker and docker-compose are the pre-requisites.
2. Clone the repository
3. Copy `_env` to `.env`
4. Edit `.env` file and replace the values in `DIR_KEY`, `DIR_SECRET`, `PGADMIN_PASSWORD`, `DB_PASSWORD`, `ADMIN_PASSWORD` parameters by running for each a separate bash command `openssl rand -base64 16`
5. Update the `docker-compose.yml` file, image name (currently `directus/directus:latest`) to the particular version if required
6. Start with the command `./start.sh` (respectively stop by `./stop.sh`)

---

## REST API

REST API can be reached by the URL (for collections):
`http://localhost:8055/items/customers/` where
    - `localhost:8055` - a host and a port (see `DIR_PORT`)
    - `customers` - a collection name

---

## GraphQL

GQL is a powerful query language for the GraphQL API endpoint:
`http://localhost:8055/graphql?access_token=mysecretpass` where
    - `localhost:8055` - a host and a port (see `DIR_PORT`)
    - `mysecretpass` - personal user token, defined by the admin in a user profile


Get all records from the collection `customers` where field `rec_id` is equal to "3453676575676":
```gql
query {
  customers (filter: { rec_id: { _eq: "3453676575676" } })
  {
    	rec_id
    	kyc_level
  }
}
```

search the collection `customers` for any field matching the value "435":
```gql
query {
  customers (search: "435")
  {
    	rec_id
    	kyc_level
  }
}
```

get the record from the collection `customers` where the id field is "1":
```gql
query {
  customers_by_id (id: 1)
  {
    	rec_id
    	kyc_level
  }
}
```

get the record from the collection `customers` where the id field is "1" and show branch name where the customer is registered:
```gql
query {
  customers_by_id (id: 1)
  {
    	id
    	rec_id
    	kyc_level
    	branch_id {branch_name}
  }
}
```