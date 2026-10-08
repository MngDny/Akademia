begin;

alter table public.questions_tf add column if not exists source_references text[] not null default '{}';

alter table public.questions_abc_one add column if not exists source_references text[] not null default '{}';

alter table public.questions_abc_multi add column if not exists source_references text[] not null default '{}';

alter table public.questions_match add column if not exists source_references text[] not null default '{}';

update public.questions_tf as existing
set status = incoming.status
from (values
  ('1 Samuel', 14, ARRAY['14:1']::text[], 'pending_review', 'Ionatan i-a propus tânărului care-i purta armele să se apropie de straja filistenilor și nu i-a spus tatălui său despre plan.'),
  ('1 Samuel', 14, ARRAY['14:2']::text[], 'pending_review', 'Saul stătea la marginea cetății Ghibea, sub rodiul din Migron, iar oamenii de lângă el erau aproape șase sute.'),
  ('1 Samuel', 14, ARRAY['14:3']::text[], 'pending_review', 'Ahia, fiul lui Ahitub și urmaș al lui Fineas și Eli, purta efodul, iar poporul nu știa că Ionatan plecase.'),
  ('1 Samuel', 14, ARRAY['14:4', '14:5']::text[], 'pending_review', 'Cele două piscuri de stâncă dintre trecătorile căutate de Ionatan se numeau Boțeț și Sene; unul era la miazănoapte, față în față cu Micmaș, iar celălalt la miazăzi, față în față cu Gheba.'),
  ('1 Samuel', 14, ARRAY['14:6']::text[], 'pending_review', 'Ionatan a spus că Domnul poate da izbăvire printr-un număr mic sau mare și că nimic nu-L împiedică să lucreze pentru ei.'),
  ('1 Samuel', 14, ARRAY['14:7']::text[], 'pending_review', 'Purtătorul de arme i-a spus lui Ionatan să facă tot ce are în inimă și că îl va urma oriunde.'),
  ('1 Samuel', 14, ARRAY['14:8', '14:9', '14:10']::text[], 'pending_review', 'Ionatan a propus să se arate filistenilor: dacă aceștia le cereau să aștepte, rămâneau pe loc, iar dacă îi chemau să urce, se suiau la ei.'),
  ('1 Samuel', 14, ARRAY['14:11', '14:12']::text[], 'pending_review', 'Filistenii i-au văzut pe cei doi și au spus că evreii ieșeau din găurile unde se ascunseseră; apoi străjerii le-au cerut să se suie la ei.'),
  ('1 Samuel', 14, ARRAY['14:12', '14:13', '14:14']::text[], 'pending_review', 'După ce Ionatan s-a suit ajutându-se cu mâinile și picioarele, purtătorul de arme a mers după el, iar cei doi au ucis douăzeci de oameni pe întinderea a aproape o jumătate de pogon.'),
  ('1 Samuel', 14, ARRAY['14:15']::text[], 'pending_review', 'Groaza a cuprins tabăra, țara și poporul, iar textul spune că era groaza lui Dumnezeu.'),
  ('1 Samuel', 14, ARRAY['14:16', '14:17']::text[], 'pending_review', 'Străjerii lui Saul au văzut mulțimea filistenilor împrăștiindu-se, iar numărătoarea a arătat că lipseau Ionatan și purtătorul lui de arme.'),
  ('1 Samuel', 14, ARRAY['14:18', '14:19']::text[], 'pending_review', 'Saul i-a cerut lui Ahia să aducă chivotul lui Dumnezeu; în timp ce vorbea cu preotul, zarva din tabăra filistenilor creștea, iar Saul i-a spus preotului să-și tragă mâna.'),
  ('1 Samuel', 14, ARRAY['14:20', '14:21', '14:22', '14:23']::text[], 'pending_review', 'Saul și poporul au ajuns la locul luptei, filistenii și-au întors sabia unii împotriva altora, iar israeliții din mai multe grupuri li s-au alăturat în urmărire; Domnul a izbăvit Israelul până dincolo de Bet-Aven.'),
  ('1 Samuel', 14, ARRAY['14:24', '14:25', '14:26']::text[], 'pending_review', 'Saul pusese poporul să jure că nu va mânca până seara, iar oamenii au văzut mierea din pădure, dar n-au gustat din ea fiindcă țineau jurământul.'),
  ('1 Samuel', 14, ARRAY['14:27', '14:28', '14:29', '14:30']::text[], 'pending_review', 'Ionatan nu știa de jurământ, a gustat miere cu vârful toiagului și i s-au luminat ochii; apoi a spus că tatăl său tulburase poporul și că hrănirea cu prada ar fi putut mări înfrângerea filistenilor.'),
  ('1 Samuel', 14, ARRAY['14:31', '14:32']::text[], 'pending_review', 'După ce au bătut filistenii de la Micmaș până la Aialon, oamenii obosiți au luat oi, boi și viței și i-au mâncat cu sânge cu tot.'),
  ('1 Samuel', 14, ARRAY['14:33', '14:34', '14:35']::text[], 'pending_review', 'Când a aflat că poporul mânca cu sânge, Saul a cerut să fie rostogolită o piatră mare și a poruncit ca animalele să fie înjunghiate acolo; apoi a zidit Domnului primul altar.'),
  ('1 Samuel', 14, ARRAY['14:36', '14:37', '14:38', '14:40']::text[], 'pending_review', 'Saul a propus să-i urmărească pe filisteni noaptea, preotul a cerut să se apropie de Dumnezeu, Domnul nu i-a răspuns lui Saul, iar Saul a pus Israelul de o parte și pe el și Ionatan de cealaltă.'),
  ('1 Samuel', 14, ARRAY['14:41', '14:42', '14:43', '14:44', '14:45', '14:46']::text[], 'pending_review', 'După ce sorțul a căzut pe Ionatan, el a mărturisit că gustase puțină miere; Saul a amenințat că va muri, dar poporul l-a apărat, iar Saul a încetat urmărirea filistenilor.'),
  ('1 Samuel', 14, ARRAY['14:47', '14:48']::text[], 'pending_review', 'Saul a luptat împotriva mai multor vrăjmași ai lui Israel, a fost biruitor oriîncotro se întorcea, a bătut pe Amalec și a scăpat Israel din mâna celor ce-l jefuiau.'),
  ('1 Samuel', 14, ARRAY['14:1']::text[], 'pending_review', 'Ionatan i-a spus tatălui său Saul că urma să se apropie de straja filistenilor.'),
  ('1 Samuel', 14, ARRAY['14:2']::text[], 'pending_review', 'Saul se afla la Micmaș, împreună cu aproape șase mii de oameni.'),
  ('1 Samuel', 14, ARRAY['14:3']::text[], 'pending_review', 'Ahia nu purta efodul, iar poporul știa că Ionatan plecase.'),
  ('1 Samuel', 14, ARRAY['14:4', '14:5']::text[], 'pending_review', 'Piscurile de stâncă dintre trecători se numeau Betel și Gheba.'),
  ('1 Samuel', 14, ARRAY['14:6']::text[], 'pending_review', 'Ionatan a spus că Domnul poate da izbăvire numai printr-o oaste numeroasă.'),
  ('1 Samuel', 14, ARRAY['14:7']::text[], 'pending_review', 'Purtătorul de arme i-a cerut lui Ionatan să renunțe și a refuzat să-l urmeze.'),
  ('1 Samuel', 14, ARRAY['14:9', '14:10']::text[], 'pending_review', 'Ionatan hotărâse să rămână pe loc dacă filistenii îi chemau să se suie la ei și să urce numai dacă le cereau să aștepte.'),
  ('1 Samuel', 14, ARRAY['14:11']::text[], 'pending_review', 'Când i-au văzut pe cei doi, filistenii au spus: «Iată că evreii ies din corturile lor de lângă Ghilgal.»'),
  ('1 Samuel', 14, ARRAY['14:12']::text[], 'pending_review', 'Străjerii filistenilor le-au spus lui Ionatan și purtătorului de arme să se oprească până vor veni ei la cei doi.'),
  ('1 Samuel', 14, ARRAY['14:13']::text[], 'pending_review', 'Purtătorul de arme a urcat singur la straja filistenilor, iar Ionatan a rămas jos.'),
  ('1 Samuel', 14, ARRAY['14:14']::text[], 'pending_review', 'Ionatan și purtătorul de arme au ucis doar doi oameni în prima înfrângere.'),
  ('1 Samuel', 14, ARRAY['14:15']::text[], 'pending_review', 'Textul spune că panica din tabără și din țară era groaza provocată de oastea lui Saul.'),
  ('1 Samuel', 14, ARRAY['14:18']::text[], 'pending_review', 'Saul i-a cerut lui Ahia să aducă trâmbița, nu chivotul lui Dumnezeu.'),
  ('1 Samuel', 14, ARRAY['14:20']::text[], 'pending_review', 'La locul luptei, israeliții și-au întors sabia unii împotriva altora, iar filistenii au rămas uniți.'),
  ('1 Samuel', 14, ARRAY['14:21']::text[], 'pending_review', 'Evreii care fuseseră mai înainte printre filisteni au rămas de partea lor și au luptat împotriva israeliților.'),
  ('1 Samuel', 14, ARRAY['14:22']::text[], 'pending_review', 'Bărbații lui Israel ascunși în muntele lui Efraim au rămas ascunși și nu i-au urmărit pe filistenii care fugeau.'),
  ('1 Samuel', 14, ARRAY['14:24']::text[], 'pending_review', 'Saul a pus poporul să jure că nu va bea apă până la apusul soarelui.'),
  ('1 Samuel', 14, ARRAY['14:26', '14:27']::text[], 'pending_review', 'Ionatan știa de jurământul tatălui său și a refuzat să atingă mierea din pădure.'),
  ('1 Samuel', 14, ARRAY['14:32', '14:33']::text[], 'pending_review', 'Poporul a tăiat animalele pe piatra mare, a scurs sângele și le-a mâncat fără să păcătuiască.'),
  ('1 Samuel', 14, ARRAY['14:37']::text[], 'pending_review', 'Când Saul a întrebat dacă să coboare după filisteni, Dumnezeu i-a răspuns îndată că-i va da în mâinile lui Israel.')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_tf (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Ionatan i-a propus tânărului care-i purta armele să se apropie de straja filistenilor și nu i-a spus tatălui său despre plan.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:1']::text[], 'pending_review', 'Codex'),
  ('Saul stătea la marginea cetății Ghibea, sub rodiul din Migron, iar oamenii de lângă el erau aproape șase sute.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:2']::text[], 'pending_review', 'Codex'),
  ('Ahia, fiul lui Ahitub și urmaș al lui Fineas și Eli, purta efodul, iar poporul nu știa că Ionatan plecase.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:3']::text[], 'pending_review', 'Codex'),
  ('Cele două piscuri de stâncă dintre trecătorile căutate de Ionatan se numeau Boțeț și Sene; unul era la miazănoapte, față în față cu Micmaș, iar celălalt la miazăzi, față în față cu Gheba.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:4', '14:5']::text[], 'pending_review', 'Codex'),
  ('Ionatan a spus că Domnul poate da izbăvire printr-un număr mic sau mare și că nimic nu-L împiedică să lucreze pentru ei.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:6']::text[], 'pending_review', 'Codex'),
  ('Purtătorul de arme i-a spus lui Ionatan să facă tot ce are în inimă și că îl va urma oriunde.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:7']::text[], 'pending_review', 'Codex'),
  ('Ionatan a propus să se arate filistenilor: dacă aceștia le cereau să aștepte, rămâneau pe loc, iar dacă îi chemau să urce, se suiau la ei.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:8', '14:9', '14:10']::text[], 'pending_review', 'Codex'),
  ('Filistenii i-au văzut pe cei doi și au spus că evreii ieșeau din găurile unde se ascunseseră; apoi străjerii le-au cerut să se suie la ei.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:11', '14:12']::text[], 'pending_review', 'Codex'),
  ('După ce Ionatan s-a suit ajutându-se cu mâinile și picioarele, purtătorul de arme a mers după el, iar cei doi au ucis douăzeci de oameni pe întinderea a aproape o jumătate de pogon.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:12', '14:13', '14:14']::text[], 'pending_review', 'Codex'),
  ('Groaza a cuprins tabăra, țara și poporul, iar textul spune că era groaza lui Dumnezeu.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:15']::text[], 'pending_review', 'Codex'),
  ('Străjerii lui Saul au văzut mulțimea filistenilor împrăștiindu-se, iar numărătoarea a arătat că lipseau Ionatan și purtătorul lui de arme.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:16', '14:17']::text[], 'pending_review', 'Codex'),
  ('Saul i-a cerut lui Ahia să aducă chivotul lui Dumnezeu; în timp ce vorbea cu preotul, zarva din tabăra filistenilor creștea, iar Saul i-a spus preotului să-și tragă mâna.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:18', '14:19']::text[], 'pending_review', 'Codex'),
  ('Saul și poporul au ajuns la locul luptei, filistenii și-au întors sabia unii împotriva altora, iar israeliții din mai multe grupuri li s-au alăturat în urmărire; Domnul a izbăvit Israelul până dincolo de Bet-Aven.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:20', '14:21', '14:22', '14:23']::text[], 'pending_review', 'Codex'),
  ('Saul pusese poporul să jure că nu va mânca până seara, iar oamenii au văzut mierea din pădure, dar n-au gustat din ea fiindcă țineau jurământul.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:24', '14:25', '14:26']::text[], 'pending_review', 'Codex'),
  ('Ionatan nu știa de jurământ, a gustat miere cu vârful toiagului și i s-au luminat ochii; apoi a spus că tatăl său tulburase poporul și că hrănirea cu prada ar fi putut mări înfrângerea filistenilor.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:27', '14:28', '14:29', '14:30']::text[], 'pending_review', 'Codex'),
  ('După ce au bătut filistenii de la Micmaș până la Aialon, oamenii obosiți au luat oi, boi și viței și i-au mâncat cu sânge cu tot.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:31', '14:32']::text[], 'pending_review', 'Codex'),
  ('Când a aflat că poporul mânca cu sânge, Saul a cerut să fie rostogolită o piatră mare și a poruncit ca animalele să fie înjunghiate acolo; apoi a zidit Domnului primul altar.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:33', '14:34', '14:35']::text[], 'pending_review', 'Codex'),
  ('Saul a propus să-i urmărească pe filisteni noaptea, preotul a cerut să se apropie de Dumnezeu, Domnul nu i-a răspuns lui Saul, iar Saul a pus Israelul de o parte și pe el și Ionatan de cealaltă.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:36', '14:37', '14:38', '14:40']::text[], 'pending_review', 'Codex'),
  ('După ce sorțul a căzut pe Ionatan, el a mărturisit că gustase puțină miere; Saul a amenințat că va muri, dar poporul l-a apărat, iar Saul a încetat urmărirea filistenilor.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:41', '14:42', '14:43', '14:44', '14:45', '14:46']::text[], 'pending_review', 'Codex'),
  ('Saul a luptat împotriva mai multor vrăjmași ai lui Israel, a fost biruitor oriîncotro se întorcea, a bătut pe Amalec și a scăpat Israel din mâna celor ce-l jefuiau.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:47', '14:48']::text[], 'pending_review', 'Codex'),
  ('Ionatan i-a spus tatălui său Saul că urma să se apropie de straja filistenilor.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:1']::text[], 'pending_review', 'Codex'),
  ('Saul se afla la Micmaș, împreună cu aproape șase mii de oameni.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:2']::text[], 'pending_review', 'Codex'),
  ('Ahia nu purta efodul, iar poporul știa că Ionatan plecase.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:3']::text[], 'pending_review', 'Codex'),
  ('Piscurile de stâncă dintre trecători se numeau Betel și Gheba.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:4', '14:5']::text[], 'pending_review', 'Codex'),
  ('Ionatan a spus că Domnul poate da izbăvire numai printr-o oaste numeroasă.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:6']::text[], 'pending_review', 'Codex'),
  ('Purtătorul de arme i-a cerut lui Ionatan să renunțe și a refuzat să-l urmeze.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:7']::text[], 'pending_review', 'Codex'),
  ('Ionatan hotărâse să rămână pe loc dacă filistenii îi chemau să se suie la ei și să urce numai dacă le cereau să aștepte.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:9', '14:10']::text[], 'pending_review', 'Codex'),
  ('Când i-au văzut pe cei doi, filistenii au spus: «Iată că evreii ies din corturile lor de lângă Ghilgal.»', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:11']::text[], 'pending_review', 'Codex'),
  ('Străjerii filistenilor le-au spus lui Ionatan și purtătorului de arme să se oprească până vor veni ei la cei doi.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:12']::text[], 'pending_review', 'Codex'),
  ('Purtătorul de arme a urcat singur la straja filistenilor, iar Ionatan a rămas jos.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:13']::text[], 'pending_review', 'Codex'),
  ('Ionatan și purtătorul de arme au ucis doar doi oameni în prima înfrângere.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:14']::text[], 'pending_review', 'Codex'),
  ('Textul spune că panica din tabără și din țară era groaza provocată de oastea lui Saul.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:15']::text[], 'pending_review', 'Codex'),
  ('Saul i-a cerut lui Ahia să aducă trâmbița, nu chivotul lui Dumnezeu.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:18']::text[], 'pending_review', 'Codex'),
  ('La locul luptei, israeliții și-au întors sabia unii împotriva altora, iar filistenii au rămas uniți.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:20']::text[], 'pending_review', 'Codex'),
  ('Evreii care fuseseră mai înainte printre filisteni au rămas de partea lor și au luptat împotriva israeliților.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:21']::text[], 'pending_review', 'Codex'),
  ('Bărbații lui Israel ascunși în muntele lui Efraim au rămas ascunși și nu i-au urmărit pe filistenii care fugeau.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:22']::text[], 'pending_review', 'Codex'),
  ('Saul a pus poporul să jure că nu va bea apă până la apusul soarelui.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:24']::text[], 'pending_review', 'Codex'),
  ('Ionatan știa de jurământul tatălui său și a refuzat să atingă mierea din pădure.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:26', '14:27']::text[], 'pending_review', 'Codex'),
  ('Poporul a tăiat animalele pe piatra mare, a scurs sângele și le-a mâncat fără să păcătuiască.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:32', '14:33']::text[], 'pending_review', 'Codex'),
  ('Când Saul a întrebat dacă să coboare după filisteni, Dumnezeu i-a răspuns îndată că-i va da în mâinile lui Israel.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:37']::text[], 'pending_review', 'Codex')
) as incoming (text, options, chapter, difficulty, book, source_references, status, added_by)
where not exists (
  select 1 from public.questions_tf existing
  where existing.book = incoming.book
    and existing.chapter = incoming.chapter
    and existing.source_references = incoming.source_references
    and existing.text = incoming.text
);

update public.questions_abc_one as existing
set status = incoming.status
from (values
  ('1 Samuel', 14, ARRAY['14:1']::text[], 'pending_review', 'Cu cine a vorbit Ionatan când i-a propus să se apropie de straja filistenilor?'),
  ('1 Samuel', 14, ARRAY['14:1']::text[], 'pending_review', 'Ce i-a spus Ionatan tatălui său despre plecarea spre straja filistenilor?'),
  ('1 Samuel', 14, ARRAY['14:2']::text[], 'pending_review', 'Unde stătea Saul când poporul era cu el la Ghibea?'),
  ('1 Samuel', 14, ARRAY['14:2']::text[], 'pending_review', 'Câți oameni erau aproape cu Saul lângă rodiul din Migron?'),
  ('1 Samuel', 14, ARRAY['14:3']::text[], 'pending_review', 'Ce purta Ahia, preotul Domnului la Silo, în timpul acestei întâmplări?'),
  ('1 Samuel', 14, ARRAY['14:3']::text[], 'pending_review', 'Ce nu știa poporul în timp ce Ionatan se dusese spre straja filistenilor?'),
  ('1 Samuel', 14, ARRAY['14:4']::text[], 'pending_review', 'Cum se numeau cele două piscuri de stâncă dintre trecătorile spre straja filistenilor?'),
  ('1 Samuel', 14, ARRAY['14:5']::text[], 'pending_review', 'În ce direcții se aflau piscurile față de Micmaș și Gheba?'),
  ('1 Samuel', 14, ARRAY['14:6']::text[], 'pending_review', 'Ce a spus Ionatan despre puterea Domnului de a da izbăvire?'),
  ('1 Samuel', 14, ARRAY['14:7']::text[], 'pending_review', 'Cum i-a răspuns purtătorul de arme lui Ionatan?'),
  ('1 Samuel', 14, ARRAY['14:8']::text[], 'pending_review', 'Ce le-a propus Ionatan să facă atunci când s-au apropiat de straja filistenilor?'),
  ('1 Samuel', 14, ARRAY['14:9']::text[], 'pending_review', 'Ce hotărâseră Ionatan și purtătorul de arme să facă dacă filistenii le spuneau să aștepte până veneau la ei?'),
  ('1 Samuel', 14, ARRAY['14:10']::text[], 'pending_review', 'Ce urma să facă Ionatan dacă străjerii le spuneau: «Suiți-vă la noi»?'),
  ('1 Samuel', 14, ARRAY['14:11']::text[], 'pending_review', 'Cum au descris filistenii apariția celor doi evrei la straja lor?'),
  ('1 Samuel', 14, ARRAY['14:12']::text[], 'pending_review', 'Ce le-au spus străjerii filisteni lui Ionatan și celui care-i purta armele?'),
  ('1 Samuel', 14, ARRAY['14:13']::text[], 'pending_review', 'Cum s-a suit Ionatan la straja filistenilor?'),
  ('1 Samuel', 14, ARRAY['14:14']::text[], 'pending_review', 'Câți oameni au ucis Ionatan și purtătorul de arme în prima înfrângere?'),
  ('1 Samuel', 14, ARRAY['14:15']::text[], 'pending_review', 'Cum numește textul groaza care a cuprins tabăra, țara și poporul?'),
  ('1 Samuel', 14, ARRAY['14:17']::text[], 'pending_review', 'Pe cine au constatat Saul și poporul că nu-l mai aveau printre ei?'),
  ('1 Samuel', 14, ARRAY['14:18']::text[], 'pending_review', 'Ce i-a cerut Saul preotului Ahia să aducă încoace?'),
  ('1 Samuel', 14, ARRAY['14:19']::text[], 'pending_review', 'Ce i-a spus Saul preotului să facă atunci când zarva din tabăra filistenilor creștea?'),
  ('1 Samuel', 14, ARRAY['14:20']::text[], 'pending_review', 'Ce au făcut filistenii între ei când Saul și oamenii lui au ajuns la locul luptei?'),
  ('1 Samuel', 14, ARRAY['14:21']::text[], 'pending_review', 'Cine s-a unit cu israeliții lui Saul și Ionatan în timpul luptei?'),
  ('1 Samuel', 14, ARRAY['14:22']::text[], 'pending_review', 'De unde au venit bărbații lui Israel care au început să-i urmărească pe filisteni?'),
  ('1 Samuel', 14, ARRAY['14:23']::text[], 'pending_review', 'Până unde s-a întins lupta după ce Domnul a izbăvit Israelul în acea zi?'),
  ('1 Samuel', 14, ARRAY['14:24']::text[], 'pending_review', 'Până când le-a interzis Saul oamenilor să mănânce pâine în ziua aceea?'),
  ('1 Samuel', 14, ARRAY['14:25']::text[], 'pending_review', 'Ce a găsit poporul pe fața pământului când a ajuns într-o pădure?'),
  ('1 Samuel', 14, ARRAY['14:26']::text[], 'pending_review', 'De ce nu a dus nimeni miere la gură după ce a văzut-o curgând?'),
  ('1 Samuel', 14, ARRAY['14:27']::text[], 'pending_review', 'Cum a luat Ionatan mierea pe care a gustat-o în pădure?'),
  ('1 Samuel', 14, ARRAY['14:28']::text[], 'pending_review', 'În ce stare era poporul când i s-a spus lui Ionatan despre jurământul tatălui său?'),
  ('1 Samuel', 14, ARRAY['14:29', '14:30']::text[], 'pending_review', 'Ce a spus Ionatan despre efectul mierii și al hranei luate din pradă?'),
  ('1 Samuel', 14, ARRAY['14:31']::text[], 'pending_review', 'Între ce două locuri i-au bătut israeliții pe filisteni în acea zi?'),
  ('1 Samuel', 14, ARRAY['14:32']::text[], 'pending_review', 'Ce animale a luat poporul din pradă și le-a mâncat cu sânge cu tot?'),
  ('1 Samuel', 14, ARRAY['14:33', '14:34']::text[], 'pending_review', 'Ce a cerut Saul să fie făcut după ce a aflat că poporul mânca cu sânge?'),
  ('1 Samuel', 14, ARRAY['14:35']::text[], 'pending_review', 'Ce a zidit Saul Domnului după această întâmplare?'),
  ('1 Samuel', 14, ARRAY['14:36']::text[], 'pending_review', 'Ce le-a propus Saul să facă în noaptea aceea cu filistenii?'),
  ('1 Samuel', 14, ARRAY['14:37']::text[], 'pending_review', 'Ce răspuns a primit Saul când L-a întrebat pe Dumnezeu dacă să coboare după filisteni?'),
  ('1 Samuel', 14, ARRAY['14:38']::text[], 'pending_review', 'Ce le-a cerut Saul căpeteniilor să afle despre păcatul din ziua aceea?'),
  ('1 Samuel', 14, ARRAY['14:39']::text[], 'pending_review', 'Ce a jurat Saul că urma să se întâmple chiar dacă Ionatan ar fi săvârșit păcatul din ziua aceea?'),
  ('1 Samuel', 14, ARRAY['14:41']::text[], 'pending_review', 'Ce i-a cerut Saul Dumnezeului lui Israel să arate înainte ca sorțul să cadă?')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_abc_one (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Cu cine a vorbit Ionatan când i-a propus să se apropie de straja filistenilor?', '[{"text":"Cu tânărul care-i purta armele","correct":true},{"text":"Cu preotul Ahia","correct":false},{"text":"Cu Saul și cu toți oamenii","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:1']::text[], 'pending_review', 'Codex'),
  ('Ce i-a spus Ionatan tatălui său despre plecarea spre straja filistenilor?', '[{"text":"Nu i-a spus nimic","correct":true},{"text":"I-a cerut voie înainte","correct":false},{"text":"I-a trimis vorbă prin Ahia","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:1']::text[], 'pending_review', 'Codex'),
  ('Unde stătea Saul când poporul era cu el la Ghibea?', '[{"text":"Sub rodiul din Migron, la marginea cetății","correct":true},{"text":"Sub un stejar la Ghilgal","correct":false},{"text":"Lângă straja filistenilor din Micmaș","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:2']::text[], 'pending_review', 'Codex'),
  ('Câți oameni erau aproape cu Saul lângă rodiul din Migron?', '[{"text":"Șase sute","correct":true},{"text":"Trei mii","correct":false},{"text":"Șase mii","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:2']::text[], 'pending_review', 'Codex'),
  ('Ce purta Ahia, preotul Domnului la Silo, în timpul acestei întâmplări?', '[{"text":"Efodul","correct":true},{"text":"Coroana lui Saul","correct":false},{"text":"Scutul lui Ionatan","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:3']::text[], 'pending_review', 'Codex'),
  ('Ce nu știa poporul în timp ce Ionatan se dusese spre straja filistenilor?', '[{"text":"Că Ionatan plecase","correct":true},{"text":"Că Saul se afla la Ghibea","correct":false},{"text":"Că Ahia purta efodul","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:3']::text[], 'pending_review', 'Codex'),
  ('Cum se numeau cele două piscuri de stâncă dintre trecătorile spre straja filistenilor?', '[{"text":"Boțeț și Sene","correct":true},{"text":"Micmaș și Bet-Aven","correct":false},{"text":"Gheba și Migron","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:4']::text[], 'pending_review', 'Codex'),
  ('În ce direcții se aflau piscurile față de Micmaș și Gheba?', '[{"text":"Unul la miazănoapte, față în față cu Micmaș, iar celălalt la miazăzi, față în față cu Gheba","correct":true},{"text":"Amândouă la miazănoapte de Micmaș","correct":false},{"text":"Amândouă la miazăzi de Gheba","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:5']::text[], 'pending_review', 'Codex'),
  ('Ce a spus Ionatan despre puterea Domnului de a da izbăvire?', '[{"text":"Nimic nu-L împiedică să izbăvească prin puțini sau prin mulți","correct":true},{"text":"Domnul poate izbăvi numai printr-o oaste numeroasă","correct":false},{"text":"Domnul va lucra doar dacă Saul vine cu tot poporul","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:6']::text[], 'pending_review', 'Codex'),
  ('Cum i-a răspuns purtătorul de arme lui Ionatan?', '[{"text":"Să facă ce are în inimă, iar el îl va urma oriunde","correct":true},{"text":"Să se întoarcă la Saul fără să se apropie de filisteni","correct":false},{"text":"Să aștepte până vin străjerii la ei","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:7']::text[], 'pending_review', 'Codex'),
  ('Ce le-a propus Ionatan să facă atunci când s-au apropiat de straja filistenilor?', '[{"text":"Să meargă la oamenii aceia și să se arate lor","correct":true},{"text":"Să se ascundă până la căderea nopții","correct":false},{"text":"Să se întoarcă la Micmaș","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:8']::text[], 'pending_review', 'Codex'),
  ('Ce hotărâseră Ionatan și purtătorul de arme să facă dacă filistenii le spuneau să aștepte până veneau la ei?', '[{"text":"Să rămână pe loc și să nu urce la ei","correct":true},{"text":"Să urce imediat la strajă","correct":false},{"text":"Să cheme întăriri din Ghilgal","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:9']::text[], 'pending_review', 'Codex'),
  ('Ce urma să facă Ionatan dacă străjerii le spuneau: «Suiți-vă la noi»?', '[{"text":"Să se suie, luând aceasta drept semn că Domnul îi dă în mâinile lui Israel","correct":true},{"text":"Să rămână pe loc până dimineață","correct":false},{"text":"Să se întoarcă la Saul fără să lupte","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:10']::text[], 'pending_review', 'Codex'),
  ('Cum au descris filistenii apariția celor doi evrei la straja lor?', '[{"text":"Au spus că evreii ieșeau din găurile în care se ascunseseră","correct":true},{"text":"Au spus că Saul îi trimisese în solie","correct":false},{"text":"Au spus că erau negustori veniți din Gheba","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:11']::text[], 'pending_review', 'Codex'),
  ('Ce le-au spus străjerii filisteni lui Ionatan și celui care-i purta armele?', '[{"text":"Să se suie la ei ca să le arate ceva","correct":true},{"text":"Să aștepte până când Saul va veni la ei","correct":false},{"text":"Să se întoarcă la Ghibea lui Beniamin","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:12']::text[], 'pending_review', 'Codex'),
  ('Cum s-a suit Ionatan la straja filistenilor?', '[{"text":"Ajutându-se cu mâinile și picioarele","correct":true},{"text":"Cu ajutorul unei scări aduse de purtătorul de arme","correct":false},{"text":"Pe o cărare pe care o arătaseră străjerii","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:13']::text[], 'pending_review', 'Codex'),
  ('Câți oameni au ucis Ionatan și purtătorul de arme în prima înfrângere?', '[{"text":"Douăzeci","correct":true},{"text":"Doisprezece","correct":false},{"text":"Două sute","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:14']::text[], 'pending_review', 'Codex'),
  ('Cum numește textul groaza care a cuprins tabăra, țara și poporul?', '[{"text":"Groaza lui Dumnezeu","correct":true},{"text":"Groaza lui Saul","correct":false},{"text":"Groaza filistenilor","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:15']::text[], 'pending_review', 'Codex'),
  ('Pe cine au constatat Saul și poporul că nu-l mai aveau printre ei?', '[{"text":"Pe Ionatan și pe purtătorul lui de arme","correct":true},{"text":"Pe Ahia și pe Saul","correct":false},{"text":"Pe toți cei șase sute de oameni","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:17']::text[], 'pending_review', 'Codex'),
  ('Ce i-a cerut Saul preotului Ahia să aducă încoace?', '[{"text":"Chivotul lui Dumnezeu","correct":true},{"text":"Trâmbița lui Saul","correct":false},{"text":"Efodul lui Ionatan","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:18']::text[], 'pending_review', 'Codex'),
  ('Ce i-a spus Saul preotului să facă atunci când zarva din tabăra filistenilor creștea?', '[{"text":"Să-și tragă mâna","correct":true},{"text":"Să sune din trâmbiță","correct":false},{"text":"Să se întoarcă la Ghibea","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:19']::text[], 'pending_review', 'Codex'),
  ('Ce au făcut filistenii între ei când Saul și oamenii lui au ajuns la locul luptei?', '[{"text":"Și-au întors sabia unii împotriva altora","correct":true},{"text":"S-au predat lui Saul fără luptă","correct":false},{"text":"Au fugit cu toții în Egipt","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:20']::text[], 'pending_review', 'Codex'),
  ('Cine s-a unit cu israeliții lui Saul și Ionatan în timpul luptei?', '[{"text":"Evreii care fuseseră mai dinainte la filisteni","correct":true},{"text":"Oștirea lui Moab","correct":false},{"text":"Preoții din Silo","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:21']::text[], 'pending_review', 'Codex'),
  ('De unde au venit bărbații lui Israel care au început să-i urmărească pe filisteni?', '[{"text":"Din ascunzătorile de pe muntele lui Efraim","correct":true},{"text":"De la trecătoarea Micmașului","correct":false},{"text":"Din țara lui Gad și Galaad","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:22']::text[], 'pending_review', 'Codex'),
  ('Până unde s-a întins lupta după ce Domnul a izbăvit Israelul în acea zi?', '[{"text":"Dincolo de Bet-Aven","correct":true},{"text":"Până la Ghibea lui Beniamin","correct":false},{"text":"Până la hotarul Egiptului","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:23']::text[], 'pending_review', 'Codex'),
  ('Până când le-a interzis Saul oamenilor să mănânce pâine în ziua aceea?', '[{"text":"Până seara, până se răzbuna pe vrăjmașii lui","correct":true},{"text":"Până când ajungeau la Ghilgal","correct":false},{"text":"Până la răsăritul soarelui următor","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:24']::text[], 'pending_review', 'Codex'),
  ('Ce a găsit poporul pe fața pământului când a ajuns într-o pădure?', '[{"text":"Miere","correct":true},{"text":"Pâine","correct":false},{"text":"Apă","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:25']::text[], 'pending_review', 'Codex'),
  ('De ce nu a dus nimeni miere la gură după ce a văzut-o curgând?', '[{"text":"Poporul ținea jurământul pus de Saul","correct":true},{"text":"Ionatan le spusese să nu mănânce","correct":false},{"text":"Mierea fusese păstrată pentru preot","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:26']::text[], 'pending_review', 'Codex'),
  ('Cum a luat Ionatan mierea pe care a gustat-o în pădure?', '[{"text":"A vârât vârful toiagului în fagure și a dus mâna la gură","correct":true},{"text":"A luat mierea cu o lingură de la Saul","correct":false},{"text":"A rupt un fagure și l-a dat purtătorului de arme","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:27']::text[], 'pending_review', 'Codex'),
  ('În ce stare era poporul când i s-a spus lui Ionatan despre jurământul tatălui său?', '[{"text":"Sleit de puteri","correct":true},{"text":"Odihnit după ospăț","correct":false},{"text":"Pregătit să plece la Silo","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:28']::text[], 'pending_review', 'Codex'),
  ('Ce a spus Ionatan despre efectul mierii și al hranei luate din pradă?', '[{"text":"Mierea i-a luminat ochii, iar dacă poporul ar fi mâncat, înfrângerea filistenilor putea fi mai mare","correct":true},{"text":"Mierea l-a făcut să uite lupta, iar prada trebuia lăsată filistenilor","correct":false},{"text":"Hrana nu ar fi schimbat nimic și ochii lui nu s-au luminat","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:29', '14:30']::text[], 'pending_review', 'Codex'),
  ('Între ce două locuri i-au bătut israeliții pe filisteni în acea zi?', '[{"text":"De la Micmaș până la Aialon","correct":true},{"text":"De la Ghilgal până la Silo","correct":false},{"text":"De la Bet-Aven până la Iordan","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:31']::text[], 'pending_review', 'Codex'),
  ('Ce animale a luat poporul din pradă și le-a mâncat cu sânge cu tot?', '[{"text":"Oi, boi și viței","correct":true},{"text":"Cămile, cai și măgari","correct":false},{"text":"Porumbei, capre și miei","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:32']::text[], 'pending_review', 'Codex'),
  ('Ce a cerut Saul să fie făcut după ce a aflat că poporul mânca cu sânge?', '[{"text":"Să se rostogolească o piatră mare și animalele să fie înjunghiate acolo","correct":true},{"text":"Să fie aduse animalele la filisteni","correct":false},{"text":"Să se arunce prada în pădure","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:33', '14:34']::text[], 'pending_review', 'Codex'),
  ('Ce a zidit Saul Domnului după această întâmplare?', '[{"text":"Primul altar pe care îl zidise Domnului","correct":true},{"text":"Un turn de strajă la Micmaș","correct":false},{"text":"Un palat la Ghibea","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:35']::text[], 'pending_review', 'Codex'),
  ('Ce le-a propus Saul să facă în noaptea aceea cu filistenii?', '[{"text":"Să coboare după ei, să-i jefuiască până la lumină și să nu lase pe niciunul","correct":true},{"text":"Să aștepte până când filistenii se întorc la Micmaș","correct":false},{"text":"Să trimită soli și să încheie pace","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:36']::text[], 'pending_review', 'Codex'),
  ('Ce răspuns a primit Saul când L-a întrebat pe Dumnezeu dacă să coboare după filisteni?', '[{"text":"Nu a primit niciun răspuns atunci","correct":true},{"text":"Dumnezeu i-a spus să se întoarcă","correct":false},{"text":"Dumnezeu i-a spus să-i urmărească până seara","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:37']::text[], 'pending_review', 'Codex'),
  ('Ce le-a cerut Saul căpeteniilor să afle despre păcatul din ziua aceea?', '[{"text":"De cine și cum fusese săvârșit","correct":true},{"text":"Câți filisteni trecuseră Iordanul","correct":false},{"text":"Cine luase mierea din pădure","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:38']::text[], 'pending_review', 'Codex'),
  ('Ce a jurat Saul că urma să se întâmple chiar dacă Ionatan ar fi săvârșit păcatul din ziua aceea?', '[{"text":"Că Ionatan va muri","correct":true},{"text":"Că Ionatan va fi împărat","correct":false},{"text":"Că Saul va opri lupta","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:39']::text[], 'pending_review', 'Codex'),
  ('Ce i-a cerut Saul Dumnezeului lui Israel să arate înainte ca sorțul să cadă?', '[{"text":"Adevărul","correct":true},{"text":"Locul unde se ascundea Ionatan","correct":false},{"text":"Numărul filistenilor rămași","correct":false}]'::jsonb, 14, 1, '1 Samuel', ARRAY['14:41']::text[], 'pending_review', 'Codex')
) as incoming (text, options, chapter, difficulty, book, source_references, status, added_by)
where not exists (
  select 1 from public.questions_abc_one existing
  where existing.book = incoming.book
    and existing.chapter = incoming.chapter
    and existing.source_references = incoming.source_references
    and existing.text = incoming.text
);

update public.questions_abc_multi as existing
set status = incoming.status
from (values
  ('1 Samuel', 14, ARRAY['14:1', '14:3']::text[], 'pending_review', 'Ce afirmații descriu ce știau tatăl lui Ionatan și poporul despre plecarea lui?'),
  ('1 Samuel', 14, ARRAY['14:4', '14:5']::text[], 'pending_review', 'Ce detalii sunt date despre cele două piscuri de stâncă dintre trecătorile spre straja filistenilor?'),
  ('1 Samuel', 14, ARRAY['14:6', '14:7', '14:8', '14:9', '14:10']::text[], 'pending_review', 'Ce afirmații redau încrederea lui Ionatan și semnul pe care l-a stabilit pentru apropierea de străjeri?'),
  ('1 Samuel', 14, ARRAY['14:11', '14:12', '14:13', '14:14']::text[], 'pending_review', 'Ce s-a întâmplat în înfruntarea lui Ionatan și a purtătorului de arme cu straja filistenilor?'),
  ('1 Samuel', 14, ARRAY['14:16', '14:17', '14:18', '14:19', '14:20']::text[], 'pending_review', 'Ce acțiuni ale lui Saul sunt menționate când a aflat că lupta se întețea?'),
  ('1 Samuel', 14, ARRAY['14:20', '14:21', '14:22', '14:23']::text[], 'pending_review', 'Ce grupuri de israeliți s-au alăturat luptei împotriva filistenilor care fugeau?'),
  ('1 Samuel', 14, ARRAY['14:24', '14:25', '14:26', '14:27', '14:28', '14:29', '14:30']::text[], 'pending_review', 'Ce afirmații arată cum au fost afectați oamenii de jurământul lui Saul și cum a gustat Ionatan mierea?'),
  ('1 Samuel', 14, ARRAY['14:31', '14:32', '14:33', '14:34', '14:35']::text[], 'pending_review', 'Ce lucruri s-au petrecut după ce poporul i-a bătut pe filisteni și a luat prada?'),
  ('1 Samuel', 14, ARRAY['14:36', '14:37', '14:38', '14:39']::text[], 'pending_review', 'Ce s-a întâmplat când Saul a vrut să urmărească filistenii și să cerceteze păcatul din popor?'),
  ('1 Samuel', 14, ARRAY['14:40', '14:41', '14:42', '14:43', '14:44', '14:45', '14:46']::text[], 'pending_review', 'Ce afirmații redau cercetarea prin sorți și ce s-a întâmplat apoi cu Ionatan?'),
  ('1 Samuel', 14, ARRAY['14:47', '14:48']::text[], 'pending_review', 'Ce este spus despre războaiele și izbânzile lui Saul după ce a luat domnia peste Israel?'),
  ('1 Samuel', 14, ARRAY['14:49', '14:50', '14:51', '14:52']::text[], 'pending_review', 'Ce afirmații despre familia lui Saul și evenimentele din timpul vieții lui sunt consemnate?')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_abc_multi (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Ce afirmații descriu ce știau tatăl lui Ionatan și poporul despre plecarea lui?', '[{"text":"Ionatan nu i-a spus tatălui său că urma să se apropie de straja filistenilor","correct":true},{"text":"Poporul nu știa că Ionatan plecase","correct":true},{"text":"Saul l-a trimis pe Ionatan la strajă împreună cu Ahia","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:1', '14:3']::text[], 'pending_review', 'Codex'),
  ('Ce detalii sunt date despre cele două piscuri de stâncă dintre trecătorile spre straja filistenilor?', '[{"text":"Unul se numea Boțeț și celălalt Sene","correct":true},{"text":"Unul se afla la miazănoapte, față în față cu Micmaș, iar celălalt la miazăzi, față în față cu Gheba","correct":true},{"text":"Piscurile se numeau Bet-Aven și Migron și amândouă erau la miazănoapte","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:4', '14:5']::text[], 'pending_review', 'Codex'),
  ('Ce afirmații redau încrederea lui Ionatan și semnul pe care l-a stabilit pentru apropierea de străjeri?', '[{"text":"Purtătorul de arme s-a declarat gata să-l urmeze oriunde","correct":true},{"text":"Dacă străjerii le spuneau să se suie, Ionatan urma să urce, luând aceasta drept semn","correct":true},{"text":"Dacă străjerii le spuneau să se suie, Ionatan hotărâse să rămână pe loc","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:6', '14:7', '14:8', '14:9', '14:10']::text[], 'pending_review', 'Codex'),
  ('Ce s-a întâmplat în înfruntarea lui Ionatan și a purtătorului de arme cu straja filistenilor?', '[{"text":"Străjerii le-au spus să se suie la ei, iar Ionatan a înțeles aceasta ca semn","correct":true},{"text":"Ionatan a urcat ajutându-se cu mâinile și picioarele, iar purtătorul de arme a mers după el","correct":true},{"text":"Cei doi au ucis două sute de filisteni pe o întindere de un pogon","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:11', '14:12', '14:13', '14:14']::text[], 'pending_review', 'Codex'),
  ('Ce acțiuni ale lui Saul sunt menționate când a aflat că lupta se întețea?', '[{"text":"A cerut să se numere poporul și s-a constatat lipsa lui Ionatan și a purtătorului de arme","correct":true},{"text":"I-a cerut lui Ahia să aducă chivotul, apoi i-a spus preotului să-și tragă mâna când zarva creștea","correct":true},{"text":"A cerut ca străjerii să se întoarcă la Ghilgal și nu a mers la locul luptei","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:16', '14:17', '14:18', '14:19', '14:20']::text[], 'pending_review', 'Codex'),
  ('Ce grupuri de israeliți s-au alăturat luptei împotriva filistenilor care fugeau?', '[{"text":"Evreii care fuseseră mai dinainte la filisteni și s-au unit cu oamenii lui Saul și Ionatan","correct":true},{"text":"Bărbații care se ascunseseră pe muntele lui Efraim și au pornit în urmărire","correct":true},{"text":"Oastea fiilor lui Amon și cea a Moabului","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:20', '14:21', '14:22', '14:23']::text[], 'pending_review', 'Codex'),
  ('Ce afirmații arată cum au fost afectați oamenii de jurământul lui Saul și cum a gustat Ionatan mierea?', '[{"text":"Poporul a găsit miere în pădure, dar nu a gustat fiindcă ținea jurământul","correct":true},{"text":"Ionatan nu știa de jurământ și a gustat miere cu vârful toiagului, iar ochii i s-au luminat","correct":true},{"text":"Saul le-a împărțit tuturor miere și poporul a fost odihnit","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:24', '14:25', '14:26', '14:27', '14:28', '14:29', '14:30']::text[], 'pending_review', 'Codex'),
  ('Ce lucruri s-au petrecut după ce poporul i-a bătut pe filisteni și a luat prada?', '[{"text":"Oamenii au mâncat oi, boi și viței cu sânge cu tot, iar Saul a cerut să fie adusă o piatră mare","correct":true},{"text":"Saul a poruncit ca fiecare să aducă un bou sau o oaie și să înjunghie animalul acolo, fără să mănânce cu sânge","correct":true},{"text":"Saul a zidit primul altar filistenilor","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:31', '14:32', '14:33', '14:34', '14:35']::text[], 'pending_review', 'Codex'),
  ('Ce s-a întâmplat când Saul a vrut să urmărească filistenii și să cerceteze păcatul din popor?', '[{"text":"Saul a propus urmărirea noaptea, iar preotul a spus să se apropie de Dumnezeu","correct":true},{"text":"Saul a întrebat pe Dumnezeu, dar nu a primit niciun răspuns în clipa aceea și a chemat căpeteniile să cerceteze păcatul","correct":true},{"text":"Dumnezeu i-a răspuns pe loc că Ionatan era vinovat, iar Saul a oprit cercetarea","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:36', '14:37', '14:38', '14:39']::text[], 'pending_review', 'Codex'),
  ('Ce afirmații redau cercetarea prin sorți și ce s-a întâmplat apoi cu Ionatan?', '[{"text":"După ce sorțul a căzut pe Ionatan, el a mărturisit că gustase puțină miere cu toiagul","correct":true},{"text":"Saul a amenințat că Ionatan va muri, dar poporul a spus că el lucrase cu Dumnezeu și l-a scăpat","correct":true},{"text":"Poporul a fost de acord cu moartea lui Ionatan și Saul a continuat urmărirea filistenilor","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:40', '14:41', '14:42', '14:43', '14:44', '14:45', '14:46']::text[], 'pending_review', 'Codex'),
  ('Ce este spus despre războaiele și izbânzile lui Saul după ce a luat domnia peste Israel?', '[{"text":"A luptat cu Moab, Amon, Edom, împărații din Țoba și filistenii și era biruitor oriîncotro se întorcea","correct":true},{"text":"A bătut pe Amalec și a scăpat Israel din mâna celor ce-l jefuiau","correct":true},{"text":"A făcut pace cu toți vrăjmașii și nu a mai purtat război","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:47', '14:48']::text[], 'pending_review', 'Codex'),
  ('Ce afirmații despre familia lui Saul și evenimentele din timpul vieții lui sunt consemnate?', '[{"text":"Fiii lui au fost Ionatan, Ișvi și Malchișua, fiicele lui Merab și Mical; Ahinoam i-a fost nevastă, iar Abner, fiul lui Ner, era căpetenia oștirii","correct":true},{"text":"Chis și Ner erau fiii lui Abiel, iar în timpul vieții lui Saul a fost război înverșunat cu filistenii și Saul îi lua cu el pe oamenii tari și voinici","correct":true},{"text":"Abner era fiul lui Saul, iar în timpul vieții lui Saul nu a mai fost război cu filistenii","correct":false}]'::jsonb, 14, 2, '1 Samuel', ARRAY['14:49', '14:50', '14:51', '14:52']::text[], 'pending_review', 'Codex')
) as incoming (text, options, chapter, difficulty, book, source_references, status, added_by)
where not exists (
  select 1 from public.questions_abc_multi existing
  where existing.book = incoming.book
    and existing.chapter = incoming.chapter
    and existing.source_references = incoming.source_references
    and existing.text = incoming.text
);

update public.questions_match as existing
set status = incoming.status
from (values
  ('1 Samuel', 14, ARRAY['14:1', '14:2', '14:3', '14:4', '14:7']::text[], 'pending_review', '[{"left":"Planul lui Ionatan","right":"Să se apropie de straja filistenilor fără să-i spună tatălui"},{"left":"Locul unde stătea Saul","right":"Sub rodiul din Migron, la marginea Ghibei"},{"left":"Ahia","right":"Purta efodul"},{"left":"Numele celor două piscuri","right":"Boțeț și Sene"},{"left":"Promisiunea purtătorului de arme","right":"Îl va urma pe Ionatan oriunde"}]'::jsonb),
  ('1 Samuel', 14, ARRAY['14:12', '14:13', '14:14', '14:15']::text[], 'pending_review', '[{"left":"Străjerii filistenilor","right":"Le-au spus lui Ionatan și purtătorului de arme să se suie la ei"},{"left":"Felul în care a urcat Ionatan","right":"S-a ajutat cu mâinile și picioarele"},{"left":"Purtătorul de arme","right":"A mers după Ionatan"},{"left":"Prima înfrângere","right":"Au fost uciși douăzeci de oameni"},{"left":"Groaza din tabără și țară","right":"Textul o numește groaza lui Dumnezeu"}]'::jsonb),
  ('1 Samuel', 14, ARRAY['14:24', '14:25', '14:27', '14:33', '14:34', '14:35']::text[], 'pending_review', '[{"left":"Jurământul pus de Saul","right":"Nimeni să nu mănânce pâine până seara"},{"left":"Ce se găsea în pădure","right":"Miere pe fața pământului"},{"left":"Gustarea lui Ionatan","right":"A atins fagurele cu vârful toiagului"},{"left":"Îndreptarea felului în care era mâncată carnea","right":"Animalele trebuiau înjunghiate pe piatra mare"},{"left":"Primul altar zidit de Saul","right":"A fost zidit Domnului"}]'::jsonb),
  ('1 Samuel', 14, ARRAY['14:49', '14:50']::text[], 'pending_review', '[{"left":"Fiii lui Saul","right":"Ionatan, Ișvi și Malchișua"},{"left":"Fiica mai mare","right":"Merab"},{"left":"Fiica mai mică","right":"Mical"},{"left":"Nevasta lui Saul","right":"Ahinoam, fata lui Ahimaaț"},{"left":"Căpetenia oştirii lui Saul","right":"Abner, fiul lui Ner, unchiul lui Saul"}]'::jsonb)
) as incoming (book, chapter, source_references, status, pairs)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.pairs = incoming.pairs;

insert into public.questions_match (pairs, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.pairs, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('[{"left":"Planul lui Ionatan","right":"Să se apropie de straja filistenilor fără să-i spună tatălui"},{"left":"Locul unde stătea Saul","right":"Sub rodiul din Migron, la marginea Ghibei"},{"left":"Ahia","right":"Purta efodul"},{"left":"Numele celor două piscuri","right":"Boțeț și Sene"},{"left":"Promisiunea purtătorului de arme","right":"Îl va urma pe Ionatan oriunde"}]'::jsonb, 14, 3, '1 Samuel', ARRAY['14:1', '14:2', '14:3', '14:4', '14:7']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Străjerii filistenilor","right":"Le-au spus lui Ionatan și purtătorului de arme să se suie la ei"},{"left":"Felul în care a urcat Ionatan","right":"S-a ajutat cu mâinile și picioarele"},{"left":"Purtătorul de arme","right":"A mers după Ionatan"},{"left":"Prima înfrângere","right":"Au fost uciși douăzeci de oameni"},{"left":"Groaza din tabără și țară","right":"Textul o numește groaza lui Dumnezeu"}]'::jsonb, 14, 3, '1 Samuel', ARRAY['14:12', '14:13', '14:14', '14:15']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Jurământul pus de Saul","right":"Nimeni să nu mănânce pâine până seara"},{"left":"Ce se găsea în pădure","right":"Miere pe fața pământului"},{"left":"Gustarea lui Ionatan","right":"A atins fagurele cu vârful toiagului"},{"left":"Îndreptarea felului în care era mâncată carnea","right":"Animalele trebuiau înjunghiate pe piatra mare"},{"left":"Primul altar zidit de Saul","right":"A fost zidit Domnului"}]'::jsonb, 14, 3, '1 Samuel', ARRAY['14:24', '14:25', '14:27', '14:33', '14:34', '14:35']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Fiii lui Saul","right":"Ionatan, Ișvi și Malchișua"},{"left":"Fiica mai mare","right":"Merab"},{"left":"Fiica mai mică","right":"Mical"},{"left":"Nevasta lui Saul","right":"Ahinoam, fata lui Ahimaaț"},{"left":"Căpetenia oştirii lui Saul","right":"Abner, fiul lui Ner, unchiul lui Saul"}]'::jsonb, 14, 3, '1 Samuel', ARRAY['14:49', '14:50']::text[], 'pending_review', 'Codex')
) as incoming (pairs, chapter, difficulty, book, source_references, status, added_by)
where not exists (
  select 1 from public.questions_match existing
  where existing.book = incoming.book
    and existing.chapter = incoming.chapter
    and existing.source_references = incoming.source_references
    and existing.pairs = incoming.pairs
);

commit;
