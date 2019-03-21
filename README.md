# Nequi mock

This project was developed as a basic **Virtual Wallet** app, particullary imitating the main functionalities of **Nequi**, which are:
* Users registration along with the assignment of a savings account
* Cushion: an emergency fund to get along through small financial crises
* Pockets: sub-accounts where the user can organize money for different purposes, but mainly for short-term use.
* Goals: sub-accounts used to save money for a specific purpose and deadline.
* Possibility to make transactions between accounts of the platform.
* Keeping of a transactions history

## Usage

1. Run Database/CreateDatabase.sql in a MySql 5.x server to create the required database.
2. Modify the connection properties in Model/DbConnection.rb to match the *username*, *password*, *host* and *port* of your server.
3. Start the program by running Presenter/Presenter.rb
```
ruby Presenter/Presenter.rb
```

## Demo
[![Watch the video](https://img.youtube.com/vi/F2zC9DPn74Q/maxresdefault.jpg)](https://youtu.be/F2zC9DPn74Q)

## Collaborators

- Sergio Fabián Álvarez Gómez
- Stiven Andrés Maldonado Bolívar
