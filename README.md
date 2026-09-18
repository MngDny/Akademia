# Akademia

Platformă de pregătire pentru concursul biblic Talantul în negoț, cu portale pentru student, îndrumător și administrator.

## Dezvoltare

Testele necesită Node.js 22.22.2+, 24.15.0+ sau 26+ (conform versiunii jsdom instalate).

```sh
npm ci
npm run dev
```

Previzualizarea statică este disponibilă la http://localhost:4173. Autentificarea folosește integrarea Supabase existentă. Înregistrarea, administrarea conturilor, importul AI și mediul de învățare depind de funcțiile Netlify; pentru aceste fluxuri rulează `npx netlify-cli dev` cu variabilele de mediu ale proiectului. Serverul static nu simulează autentificarea sau datele.

### Planul de studiu

Pentru categoriile elevilor și bibliografia pe perioade, rulează o dată scriptul `final_json/study_plan.sql` în Supabase SQL Editor. Acesta adaugă `study_category` în `accounts` și atribuie categoria implicită `2-3` elevilor existenți fără categorie.

## Interfață

- `assets/css/layout.css`: culori, spațiere, navigare și adaptarea la telefon.
- `assets/css/components.css`: formulare, butoane, tabele, carduri și stări.
- `assets/js/core/portalShell.js`: navigare comună tuturor rolurilor, meniu mobil, gestionarea focusului și link de acces direct la conținut.
- `assets/js/core/bookAutocomplete.js`: selector de carte cu filtrare instant la tastare, selecție cu mouse-ul sau tastatura și buton de resetare.
- Stilurile din `portal/` conțin doar compoziția specifică paginilor.
- Pictogramele Lucide sunt locale; licența se află în `assets/icons/LICENSE`.

## Verificare

```sh
npm test
```

Testele verifică cele 15 pagini, referințele locale, sintaxa modulelor, navigarea pentru toate rolurile, formularele, filtrele cu autocomplete, editorul de întrebări, importul, testarea și învățarea. Supabase și funcțiile Netlify sunt simulate în teste: acestea nu citesc sau modifică date reale.

Testele DOM nu verifică aspectul randat. Înainte de publicare, verifică în browser la 1440, 960, 768 și 390 px, inclusiv tabelele, meniul cu tastatura și ecranele cu date reale. În sesiunea de refactorizare nu a fost disponibil un browser pentru această verificare vizuală.
