
## TODO

- Pincode opslaan naar user entity, en optie biometrie in- uitschakelen via profiel... Pincode moet geëncrypt zijn in firestore.

## Could have's
- Momenteel updaten de categories nooit, ze blijven maar in de cache staan. Zorg ervoor dat deze een lifetime hebben, en na een paar dagen opnieuw gefetched worden.
- Als je gefiltered bent op categorie, en je opent de add modal, moet je defaulten naar die categorie.