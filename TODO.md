
## TODO
- Pincode toevoegen:
De gebruiker logt in op zijn account middels firebase authentication. Deze sessie (de parent-session) blijft. Maar elke keer als de gebruiker de app opent, moet degene zijn fingerprint, of pincode invoeren om een child-session te krijgen. Let erop dat als de gebruiker inlogt voor zijn parent-session, alleen dan, hoeft er niet ook nog een pincode te laten zien worden.
- Momenteel updaten de categories nooit, ze blijven maar in de cache staan. Zorg ervoor dat deze een lifetime hebben, en na een paar dagen opnieuw gefetched worden.
- Als je gefiltered bent op categorie, en je opent de add modal, moet je defaulten naar die categorie.