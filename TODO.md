
## TODO
- Pincode toevoegen:
De gebruiker logt in op zijn account middels firebase authentication. Deze sessie (de parent-session) blijft. Maar elke keer als de gebruiker de app opent, moet degene zijn fingerprint, of pincode invoeren om een child-session te krijgen. Let erop dat als de gebruiker inlogt voor zijn parent-session, alleen dan, hoeft er niet ook nog een pincode te laten zien worden.
- Gebruik caching om queryies naar de document store te verminderen
- Gebruik optimistic-updates om de UI sneller te laten reageren.