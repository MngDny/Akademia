begin;

alter table public.questions_tf add column if not exists source_references text[] not null default '{}';

alter table public.questions_abc_one add column if not exists source_references text[] not null default '{}';

alter table public.questions_abc_multi add column if not exists source_references text[] not null default '{}';

alter table public.questions_match add column if not exists source_references text[] not null default '{}';

update public.questions_tf as existing
set status = incoming.status
from (values
  ('1 Samuel', 7, ARRAY['7:1']::text[], 'pending_review', 'Locuitorii din Chiriat-Iearim au dus chivotul Domnului în casa lui Abinadab, pe deal.'),
  ('1 Samuel', 7, ARRAY['7:1']::text[], 'pending_review', 'Fiul lui Abinadab, Eleazar, a fost sfințit ca să păzească chivotul Domnului.'),
  ('1 Samuel', 7, ARRAY['7:2']::text[], 'pending_review', 'După ce chivotul a ajuns la Chiriat-Iearim, toată casa lui Israel a plâns după Domnul.'),
  ('1 Samuel', 7, ARRAY['7:3']::text[], 'pending_review', 'Samuel le-a spus israeliților să-și îndrepte inima spre Domnul și să-I slujească numai Lui.'),
  ('1 Samuel', 7, ARRAY['7:3']::text[], 'pending_review', 'Samuel a spus că întoarcerea la Domnul cerea îndepărtarea dumnezeilor străini și a Astarteelor.'),
  ('1 Samuel', 7, ARRAY['7:3']::text[], 'pending_review', 'Samuel le-a promis că Domnul îi va izbăvi de filisteni dacă se întorc la El și Îi slujesc numai Lui.'),
  ('1 Samuel', 7, ARRAY['7:4']::text[], 'pending_review', 'După cuvintele lui Samuel, copiii lui Israel au îndepărtat Baalii și Astarteele și au slujit Domnului numai Lui.'),
  ('1 Samuel', 7, ARRAY['7:5']::text[], 'pending_review', 'Samuel a chemat tot Israelul la Mițpa și a spus că se va ruga Domnului pentru ei.'),
  ('1 Samuel', 7, ARRAY['7:6']::text[], 'pending_review', 'La Mițpa, poporul a scos apă, a vărsat-o înaintea Domnului, a postit și și-a mărturisit păcatul.'),
  ('1 Samuel', 7, ARRAY['7:6']::text[], 'pending_review', 'La Mițpa, Samuel a judecat pe copiii lui Israel.'),
  ('1 Samuel', 7, ARRAY['7:7']::text[], 'pending_review', 'Când filistenii au aflat că Israelul era adunat la Mițpa, domnitorii lor au pornit împotriva lui Israel.'),
  ('1 Samuel', 7, ARRAY['7:7']::text[], 'pending_review', 'Când au auzit că filistenii vin împotriva lor, copiii lui Israel s-au bucurat și nu s-au temut.'),
  ('1 Samuel', 7, ARRAY['7:8']::text[], 'pending_review', 'Copiii lui Israel i-au cerut lui Samuel să nu înceteze să strige către Domnul pentru ca El să-i scape din mâna filistenilor.'),
  ('1 Samuel', 7, ARRAY['7:9']::text[], 'pending_review', 'Samuel a adus ca ardere-de-tot un berbec adult și s-a rugat pentru Israel.'),
  ('1 Samuel', 7, ARRAY['7:9']::text[], 'pending_review', 'Domnul l-a ascultat pe Samuel în timp ce acesta aducea arderea-de-tot.'),
  ('1 Samuel', 7, ARRAY['7:10']::text[], 'pending_review', 'Domnul a făcut să răsune tunete împotriva filistenilor și i-a pus pe fugă înaintea lui Israel.'),
  ('1 Samuel', 7, ARRAY['7:11']::text[], 'pending_review', 'Bărbații lui Israel au urmărit filistenii până sub Bet-Car și i-au înfrânt acolo.'),
  ('1 Samuel', 7, ARRAY['7:12']::text[], 'pending_review', 'Samuel a pus piatra numită Eben-Ezer la Mițpa, chiar în mijlocul cetății.'),
  ('1 Samuel', 7, ARRAY['7:12']::text[], 'pending_review', 'Samuel a numit piatra dintre Mițpa și Șen Eben-Ezer și a spus că Domnul îi ajutase până aici.'),
  ('1 Samuel', 7, ARRAY['7:13']::text[], 'pending_review', 'Filistenii au fost smeriți și nu au mai intrat în ținutul lui Israel.'),
  ('1 Samuel', 7, ARRAY['7:13']::text[], 'pending_review', 'Mâna Domnului a fost împotriva filistenilor în tot timpul vieții lui Samuel.'),
  ('1 Samuel', 7, ARRAY['7:14']::text[], 'pending_review', 'Cetățile luate de filisteni au rămas la ei, de la Ecron până la Gat.'),
  ('1 Samuel', 7, ARRAY['7:15']::text[], 'pending_review', 'Samuel a judecat pe Israel în toate zilele vieții lui.'),
  ('1 Samuel', 7, ARRAY['7:16', '7:17']::text[], 'pending_review', 'În fiecare an, Samuel făcea un circuit prin Betel, Ghilgal și Mițpa, apoi se întorcea la Rama.')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_tf (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Locuitorii din Chiriat-Iearim au dus chivotul Domnului în casa lui Abinadab, pe deal.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 7, 1, '1 Samuel', ARRAY['7:1']::text[], 'pending_review', 'Codex'),
  ('Fiul lui Abinadab, Eleazar, a fost sfințit ca să păzească chivotul Domnului.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 7, 1, '1 Samuel', ARRAY['7:1']::text[], 'pending_review', 'Codex'),
  ('După ce chivotul a ajuns la Chiriat-Iearim, toată casa lui Israel a plâns după Domnul.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 7, 1, '1 Samuel', ARRAY['7:2']::text[], 'pending_review', 'Codex'),
  ('Samuel le-a spus israeliților să-și îndrepte inima spre Domnul și să-I slujească numai Lui.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:3']::text[], 'pending_review', 'Codex'),
  ('Samuel a spus că întoarcerea la Domnul cerea îndepărtarea dumnezeilor străini și a Astarteelor.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:3']::text[], 'pending_review', 'Codex'),
  ('Samuel le-a promis că Domnul îi va izbăvi de filisteni dacă se întorc la El și Îi slujesc numai Lui.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:3']::text[], 'pending_review', 'Codex'),
  ('După cuvintele lui Samuel, copiii lui Israel au îndepărtat Baalii și Astarteele și au slujit Domnului numai Lui.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 7, 1, '1 Samuel', ARRAY['7:4']::text[], 'pending_review', 'Codex'),
  ('Samuel a chemat tot Israelul la Mițpa și a spus că se va ruga Domnului pentru ei.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 7, 1, '1 Samuel', ARRAY['7:5']::text[], 'pending_review', 'Codex'),
  ('La Mițpa, poporul a scos apă, a vărsat-o înaintea Domnului, a postit și și-a mărturisit păcatul.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:6']::text[], 'pending_review', 'Codex'),
  ('La Mițpa, Samuel a judecat pe copiii lui Israel.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 7, 1, '1 Samuel', ARRAY['7:6']::text[], 'pending_review', 'Codex'),
  ('Când filistenii au aflat că Israelul era adunat la Mițpa, domnitorii lor au pornit împotriva lui Israel.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:7']::text[], 'pending_review', 'Codex'),
  ('Când au auzit că filistenii vin împotriva lor, copiii lui Israel s-au bucurat și nu s-au temut.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:7']::text[], 'pending_review', 'Codex'),
  ('Copiii lui Israel i-au cerut lui Samuel să nu înceteze să strige către Domnul pentru ca El să-i scape din mâna filistenilor.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:8']::text[], 'pending_review', 'Codex'),
  ('Samuel a adus ca ardere-de-tot un berbec adult și s-a rugat pentru Israel.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:9']::text[], 'pending_review', 'Codex'),
  ('Domnul l-a ascultat pe Samuel în timp ce acesta aducea arderea-de-tot.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:9']::text[], 'pending_review', 'Codex'),
  ('Domnul a făcut să răsune tunete împotriva filistenilor și i-a pus pe fugă înaintea lui Israel.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:10']::text[], 'pending_review', 'Codex'),
  ('Bărbații lui Israel au urmărit filistenii până sub Bet-Car și i-au înfrânt acolo.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:11']::text[], 'pending_review', 'Codex'),
  ('Samuel a pus piatra numită Eben-Ezer la Mițpa, chiar în mijlocul cetății.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 7, 3, '1 Samuel', ARRAY['7:12']::text[], 'pending_review', 'Codex'),
  ('Samuel a numit piatra dintre Mițpa și Șen Eben-Ezer și a spus că Domnul îi ajutase până aici.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:12']::text[], 'pending_review', 'Codex'),
  ('Filistenii au fost smeriți și nu au mai intrat în ținutul lui Israel.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:13']::text[], 'pending_review', 'Codex'),
  ('Mâna Domnului a fost împotriva filistenilor în tot timpul vieții lui Samuel.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:13']::text[], 'pending_review', 'Codex'),
  ('Cetățile luate de filisteni au rămas la ei, de la Ecron până la Gat.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:14']::text[], 'pending_review', 'Codex'),
  ('Samuel a judecat pe Israel în toate zilele vieții lui.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 7, 1, '1 Samuel', ARRAY['7:15']::text[], 'pending_review', 'Codex'),
  ('În fiecare an, Samuel făcea un circuit prin Betel, Ghilgal și Mițpa, apoi se întorcea la Rama.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:16', '7:17']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 7, ARRAY['7:1']::text[], 'pending_review', 'În casa cui a fost dus chivotul Domnului după ce l-au luat locuitorii din Chiriat-Iearim?'),
  ('1 Samuel', 7, ARRAY['7:1']::text[], 'pending_review', 'Pe cine au sfințit locuitorii ca să păzească chivotul Domnului?'),
  ('1 Samuel', 7, ARRAY['7:2']::text[], 'pending_review', 'Unde a rămas chivotul Domnului după ce a fost adus de la filisteni?'),
  ('1 Samuel', 7, ARRAY['7:3']::text[], 'pending_review', 'Ce i-a cerut Samuel lui Israel să îndepărteze dacă se întoarce la Domnul cu toată inima?'),
  ('1 Samuel', 7, ARRAY['7:3']::text[], 'pending_review', 'Cui trebuia să-I slujească Israel, potrivit îndemnului lui Samuel?'),
  ('1 Samuel', 7, ARRAY['7:3']::text[], 'pending_review', 'De cine a spus Samuel că îi va izbăvi Domnul, dacă Israel se întoarce la El și Îi slujește?'),
  ('1 Samuel', 7, ARRAY['7:4']::text[], 'pending_review', 'Ce dumnezei au îndepărtat copiii lui Israel după ce Samuel i-a îndemnat să se întoarcă la Domnul?'),
  ('1 Samuel', 7, ARRAY['7:5']::text[], 'pending_review', 'Unde a chemat Samuel tot Israelul ca să se roage Domnului pentru popor?'),
  ('1 Samuel', 7, ARRAY['7:5']::text[], 'pending_review', 'Ce a spus Samuel că va face când Israel se va aduna la Mițpa?'),
  ('1 Samuel', 7, ARRAY['7:6']::text[], 'pending_review', 'Ce a vărsat poporul înaintea Domnului la Mițpa?'),
  ('1 Samuel', 7, ARRAY['7:6']::text[], 'pending_review', 'Ce mărturisire au făcut israeliții în ziua adunării de la Mițpa?'),
  ('1 Samuel', 7, ARRAY['7:7']::text[], 'pending_review', 'Cum au reacționat copiii lui Israel când filistenii au venit împotriva lor la Mițpa?'),
  ('1 Samuel', 7, ARRAY['7:8']::text[], 'pending_review', 'Ce i-au cerut israeliții lui Samuel să facă în fața amenințării filistenilor?'),
  ('1 Samuel', 7, ARRAY['7:9']::text[], 'pending_review', 'Ce animal a luat Samuel pentru arderea-de-tot adusă Domnului?'),
  ('1 Samuel', 7, ARRAY['7:10']::text[], 'pending_review', 'Ce a făcut Domnul când filistenii s-au apropiat în timp ce Samuel aducea arderea-de-tot?'),
  ('1 Samuel', 7, ARRAY['7:11']::text[], 'pending_review', 'Până unde au urmărit bărbații lui Israel pe filisteni după ce aceștia au fugit de la Mițpa?'),
  ('1 Samuel', 7, ARRAY['7:12']::text[], 'pending_review', 'Cum a numit Samuel piatra așezată între Mițpa și Șen?'),
  ('1 Samuel', 7, ARRAY['7:12']::text[], 'pending_review', 'Ce a spus Samuel când a pus piatra numită Eben-Ezer?'),
  ('1 Samuel', 7, ARRAY['7:14']::text[], 'pending_review', 'Ce s-a întâmplat cu cetățile luate de filisteni, de la Ecron până la Gat?'),
  ('1 Samuel', 7, ARRAY['7:14']::text[], 'pending_review', 'Între cine a fost pace după ce Israel a luat înapoi cetățile de la filisteni?'),
  ('1 Samuel', 7, ARRAY['7:17']::text[], 'pending_review', 'În ce cetate era casa lui Samuel și unde a ridicat el un altar Domnului?'),
  ('1 Samuel', 7, ARRAY['7:16']::text[], 'pending_review', 'Ce cetăți vizita Samuel în fiecare an ca să judece pe Israel?')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_abc_one (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('În casa cui a fost dus chivotul Domnului după ce l-au luat locuitorii din Chiriat-Iearim?', '[{"text":"În casa lui Abinadab","correct":true},{"text":"În casa lui Samuel","correct":false},{"text":"În casa lui Eleazar","correct":false}]'::jsonb, 7, 1, '1 Samuel', ARRAY['7:1']::text[], 'pending_review', 'Codex'),
  ('Pe cine au sfințit locuitorii ca să păzească chivotul Domnului?', '[{"text":"Pe Eleazar, fiul lui Abinadab","correct":true},{"text":"Pe Samuel, fiul lui Elcana","correct":false},{"text":"Pe unul dintre domnitorii filistenilor","correct":false}]'::jsonb, 7, 1, '1 Samuel', ARRAY['7:1']::text[], 'pending_review', 'Codex'),
  ('Unde a rămas chivotul Domnului după ce a fost adus de la filisteni?', '[{"text":"La Chiriat-Iearim","correct":true},{"text":"La Mițpa","correct":false},{"text":"La Bet-Șemeș","correct":false}]'::jsonb, 7, 1, '1 Samuel', ARRAY['7:2']::text[], 'pending_review', 'Codex'),
  ('Ce i-a cerut Samuel lui Israel să îndepărteze dacă se întoarce la Domnul cu toată inima?', '[{"text":"Dumnezeii străini și Astarteele","correct":true},{"text":"Chivotul și altarul Domnului","correct":false},{"text":"Cetățile dintre Ecron și Gat","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:3']::text[], 'pending_review', 'Codex'),
  ('Cui trebuia să-I slujească Israel, potrivit îndemnului lui Samuel?', '[{"text":"Domnului numai Lui","correct":true},{"text":"Domnului și Baalilor","correct":false},{"text":"Domnului și Astarteelor","correct":false}]'::jsonb, 7, 1, '1 Samuel', ARRAY['7:3']::text[], 'pending_review', 'Codex'),
  ('De cine a spus Samuel că îi va izbăvi Domnul, dacă Israel se întoarce la El și Îi slujește?', '[{"text":"De filisteni","correct":true},{"text":"De amoriți","correct":false},{"text":"De egipteni","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:3']::text[], 'pending_review', 'Codex'),
  ('Ce dumnezei au îndepărtat copiii lui Israel după ce Samuel i-a îndemnat să se întoarcă la Domnul?', '[{"text":"Baalii și Astarteele","correct":true},{"text":"Dagon și Chemoș","correct":false},{"text":"Dumnezeii egiptenilor și ai amoriților","correct":false}]'::jsonb, 7, 1, '1 Samuel', ARRAY['7:4']::text[], 'pending_review', 'Codex'),
  ('Unde a chemat Samuel tot Israelul ca să se roage Domnului pentru popor?', '[{"text":"La Mițpa","correct":true},{"text":"La Betel","correct":false},{"text":"La Rama","correct":false}]'::jsonb, 7, 1, '1 Samuel', ARRAY['7:5']::text[], 'pending_review', 'Codex'),
  ('Ce a spus Samuel că va face când Israel se va aduna la Mițpa?', '[{"text":"Se va ruga Domnului pentru popor","correct":true},{"text":"Va duce chivotul la Bet-Car","correct":false},{"text":"Va cere cetățile de la amoriți","correct":false}]'::jsonb, 7, 1, '1 Samuel', ARRAY['7:5']::text[], 'pending_review', 'Codex'),
  ('Ce a vărsat poporul înaintea Domnului la Mițpa?', '[{"text":"Apă","correct":true},{"text":"Untdelemn","correct":false},{"text":"Sângele mielului","correct":false}]'::jsonb, 7, 1, '1 Samuel', ARRAY['7:6']::text[], 'pending_review', 'Codex'),
  ('Ce mărturisire au făcut israeliții în ziua adunării de la Mițpa?', '[{"text":"„Am păcătuit împotriva Domnului.”","correct":true},{"text":"„Am înfrânt pe filisteni.”","correct":false},{"text":"„Am luat înapoi cetățile noastre.”","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:6']::text[], 'pending_review', 'Codex'),
  ('Cum au reacționat copiii lui Israel când filistenii au venit împotriva lor la Mițpa?', '[{"text":"S-au temut de filisteni","correct":true},{"text":"I-au urmărit imediat până la Bet-Car","correct":false},{"text":"Au dus chivotul la Rama","correct":false}]'::jsonb, 7, 1, '1 Samuel', ARRAY['7:7']::text[], 'pending_review', 'Codex'),
  ('Ce i-au cerut israeliții lui Samuel să facă în fața amenințării filistenilor?', '[{"text":"Să strige către Domnul pentru ca El să-i scape","correct":true},{"text":"Să se întoarcă singur la Chiriat-Iearim","correct":false},{"text":"Să încheie pace cu filistenii","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:8']::text[], 'pending_review', 'Codex'),
  ('Ce animal a luat Samuel pentru arderea-de-tot adusă Domnului?', '[{"text":"Un miel care încă sugea","correct":true},{"text":"Un berbec adult","correct":false},{"text":"Două vaci tinere","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:9']::text[], 'pending_review', 'Codex'),
  ('Ce a făcut Domnul când filistenii s-au apropiat în timp ce Samuel aducea arderea-de-tot?', '[{"text":"A făcut să răsune tunete împotriva lor","correct":true},{"text":"A trimis ploaie peste Mițpa","correct":false},{"text":"A făcut să se deschidă porțile cetății","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:10']::text[], 'pending_review', 'Codex'),
  ('Până unde au urmărit bărbații lui Israel pe filisteni după ce aceștia au fugit de la Mițpa?', '[{"text":"Până sub Bet-Car","correct":true},{"text":"Până la Ecron","correct":false},{"text":"Până la Chiriat-Iearim","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:11']::text[], 'pending_review', 'Codex'),
  ('Cum a numit Samuel piatra așezată între Mițpa și Șen?', '[{"text":"Eben-Ezer","correct":true},{"text":"Bet-Car","correct":false},{"text":"Chiriat-Iearim","correct":false}]'::jsonb, 7, 1, '1 Samuel', ARRAY['7:12']::text[], 'pending_review', 'Codex'),
  ('Ce a spus Samuel când a pus piatra numită Eben-Ezer?', '[{"text":"„Până aici Domnul ne-a ajutat.”","correct":true},{"text":"„Domnul ne-a dat cetățile filistenilor.”","correct":false},{"text":"„Israel va locui la Mițpa.”","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:12']::text[], 'pending_review', 'Codex'),
  ('Ce s-a întâmplat cu cetățile luate de filisteni, de la Ecron până la Gat?', '[{"text":"S-au întors la Israel împreună cu ținuturile lor","correct":true},{"text":"Au fost date amoriților","correct":false},{"text":"Au rămas sub stăpânirea filistenilor","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:14']::text[], 'pending_review', 'Codex'),
  ('Între cine a fost pace după ce Israel a luat înapoi cetățile de la filisteni?', '[{"text":"Între Israel și amoriți","correct":true},{"text":"Între Israel și filisteni","correct":false},{"text":"Între Mițpa și Rama","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:14']::text[], 'pending_review', 'Codex'),
  ('În ce cetate era casa lui Samuel și unde a ridicat el un altar Domnului?', '[{"text":"La Rama","correct":true},{"text":"La Mițpa","correct":false},{"text":"La Betel","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:17']::text[], 'pending_review', 'Codex'),
  ('Ce cetăți vizita Samuel în fiecare an ca să judece pe Israel?', '[{"text":"Betel, Ghilgal și Mițpa","correct":true},{"text":"Mițpa, Ecron și Gat","correct":false},{"text":"Rama, Bet-Car și Șen","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:16']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 7, ARRAY['7:1']::text[], 'pending_review', 'Ce detalii despre aducerea chivotului la Chiriat-Iearim sunt consemnate?'),
  ('1 Samuel', 7, ARRAY['7:2']::text[], 'pending_review', 'Ce spune capitolul despre perioada în care chivotul a rămas la Chiriat-Iearim?'),
  ('1 Samuel', 7, ARRAY['7:3']::text[], 'pending_review', 'Ce le-a cerut Samuel israeliților pentru întoarcerea lor la Domnul?'),
  ('1 Samuel', 7, ARRAY['7:4']::text[], 'pending_review', 'Ce acțiuni ale lui Israel sunt relatate după îndemnul lui Samuel?'),
  ('1 Samuel', 7, ARRAY['7:5']::text[], 'pending_review', 'Ce a spus Samuel despre adunarea de la Mițpa?'),
  ('1 Samuel', 7, ARRAY['7:6']::text[], 'pending_review', 'Ce au făcut israeliții în ziua adunării de la Mițpa?'),
  ('1 Samuel', 7, ARRAY['7:7']::text[], 'pending_review', 'Ce s-a întâmplat când filistenii au auzit că Israel era adunat la Mițpa?'),
  ('1 Samuel', 7, ARRAY['7:8']::text[], 'pending_review', 'Ce i-au cerut copiii lui Israel lui Samuel în timp ce se temeau de filisteni?'),
  ('1 Samuel', 7, ARRAY['7:9']::text[], 'pending_review', 'Ce a făcut Samuel în timpul jertfei aduse pentru Israel?'),
  ('1 Samuel', 7, ARRAY['7:10']::text[], 'pending_review', 'Ce evenimente au avut loc în timp ce Samuel aducea arderea-de-tot?'),
  ('1 Samuel', 7, ARRAY['7:11']::text[], 'pending_review', 'Ce au făcut bărbații lui Israel după fuga filistenilor?'),
  ('1 Samuel', 7, ARRAY['7:12']::text[], 'pending_review', 'Ce detalii sunt date despre piatra numită Eben-Ezer?'),
  ('1 Samuel', 7, ARRAY['7:13']::text[], 'pending_review', 'Ce spune capitolul despre urmările înfrângerii filistenilor?'),
  ('1 Samuel', 7, ARRAY['7:14']::text[], 'pending_review', 'Ce s-a întâmplat cu cetățile și ținuturile pe care filistenii le luaseră de la Israel?'),
  ('1 Samuel', 7, ARRAY['7:15', '7:17']::text[], 'pending_review', 'Ce două detalii despre Samuel sunt menționate la sfârșitul capitolului?'),
  ('1 Samuel', 7, ARRAY['7:16', '7:17']::text[], 'pending_review', 'Care sunt locurile numite în legătură cu lucrarea de judecător a lui Samuel?'),
  ('1 Samuel', 7, ARRAY['7:6', '7:7']::text[], 'pending_review', 'Ce combinație descrie adunarea și mărturisirea poporului la Mițpa?'),
  ('1 Samuel', 7, ARRAY['7:9', '7:10']::text[], 'pending_review', 'Ce legătură face capitolul între rugăciunea lui Samuel și intervenția Domnului?')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_abc_multi (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Ce detalii despre aducerea chivotului la Chiriat-Iearim sunt consemnate?', '[{"text":"Chivotul a fost dus în casa lui Abinadab, pe deal.","correct":true},{"text":"Eleazar, fiul lui Abinadab, a fost sfințit să-l păzească.","correct":true},{"text":"Chivotul a fost dus în casa lui Samuel, iar Elcana a fost pus să-l păzească.","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:1']::text[], 'pending_review', 'Codex'),
  ('Ce spune capitolul despre perioada în care chivotul a rămas la Chiriat-Iearim?', '[{"text":"Au trecut douăzeci de ani de când fusese așezat acolo.","correct":true},{"text":"Toată casa lui Israel plângea după Domnul.","correct":true},{"text":"În acea perioadă, filistenii au dus chivotul la Mițpa.","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:2']::text[], 'pending_review', 'Codex'),
  ('Ce le-a cerut Samuel israeliților pentru întoarcerea lor la Domnul?', '[{"text":"Să îndepărteze dumnezeii străini și Astarteele.","correct":true},{"text":"Să-și îndrepte inima spre Domnul și să-I slujească numai Lui.","correct":true},{"text":"Să păstreze Baalii, dar să nu se mai adune la Mițpa.","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:3']::text[], 'pending_review', 'Codex'),
  ('Ce acțiuni ale lui Israel sunt relatate după îndemnul lui Samuel?', '[{"text":"Au îndepărtat Baalii și Astarteele.","correct":true},{"text":"Au slujit Domnului numai Lui.","correct":true},{"text":"Au trimis chivotul înapoi la filisteni.","correct":false}]'::jsonb, 7, 1, '1 Samuel', ARRAY['7:4']::text[], 'pending_review', 'Codex'),
  ('Ce a spus Samuel despre adunarea de la Mițpa?', '[{"text":"A chemat tot Israelul să se adune acolo.","correct":true},{"text":"A spus că se va ruga Domnului pentru popor.","correct":true},{"text":"A cerut ca doar domnitorii lui Israel să vină, fără popor.","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:5']::text[], 'pending_review', 'Codex'),
  ('Ce au făcut israeliții în ziua adunării de la Mițpa?', '[{"text":"Au scos apă și au vărsat-o înaintea Domnului.","correct":true},{"text":"Au postit și au spus că au păcătuit împotriva Domnului.","correct":true},{"text":"Au adus chivotul din casa lui Abinadab și l-au pus pe piatra cea mare.","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:6']::text[], 'pending_review', 'Codex'),
  ('Ce s-a întâmplat când filistenii au auzit că Israel era adunat la Mițpa?', '[{"text":"Domnitorii filistenilor au pornit împotriva lui Israel.","correct":true},{"text":"Copiii lui Israel s-au temut de filisteni.","correct":true},{"text":"Filistenii au cerut lui Samuel să se roage pentru ei.","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:7']::text[], 'pending_review', 'Codex'),
  ('Ce i-au cerut copiii lui Israel lui Samuel în timp ce se temeau de filisteni?', '[{"text":"Să nu înceteze să strige către Domnul pentru ei.","correct":true},{"text":"Să ceară Domnului să-i scape din mâna filistenilor.","correct":true},{"text":"Să-i conducă pe filisteni la Chiriat-Iearim.","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:8']::text[], 'pending_review', 'Codex'),
  ('Ce a făcut Samuel în timpul jertfei aduse pentru Israel?', '[{"text":"A luat un miel care încă sugea și l-a adus ca ardere-de-tot.","correct":true},{"text":"A strigat către Domnul pentru Israel.","correct":true},{"text":"A adus două vaci tinere și le-a trimis spre Bet-Șemeș.","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:9']::text[], 'pending_review', 'Codex'),
  ('Ce evenimente au avut loc în timp ce Samuel aducea arderea-de-tot?', '[{"text":"Domnul a făcut să răsune tunete împotriva filistenilor.","correct":true},{"text":"Filistenii au fost puși pe fugă și înfrânți înaintea lui Israel.","correct":true},{"text":"Samuel a dus piatra Eben-Ezer la Rama.","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:10']::text[], 'pending_review', 'Codex'),
  ('Ce au făcut bărbații lui Israel după fuga filistenilor?', '[{"text":"Au ieșit din Mițpa și i-au urmărit.","correct":true},{"text":"I-au înfrânt până sub Bet-Car.","correct":true},{"text":"Au urmărit filistenii până la Gat și Ecron.","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:11']::text[], 'pending_review', 'Codex'),
  ('Ce detalii sunt date despre piatra numită Eben-Ezer?', '[{"text":"Samuel a așezat-o între Mițpa și Șen.","correct":true},{"text":"Samuel a spus: „Până aici Domnul ne-a ajutat.”","correct":true},{"text":"Piatra a fost ridicată de Eleazar lângă casa lui Abinadab.","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:12']::text[], 'pending_review', 'Codex'),
  ('Ce spune capitolul despre urmările înfrângerii filistenilor?', '[{"text":"Filistenii au fost smeriți și nu au mai intrat în ținutul lui Israel.","correct":true},{"text":"Mâna Domnului a fost împotriva filistenilor în tot timpul vieții lui Samuel.","correct":true},{"text":"Filistenii au stăpânit toate cetățile dintre Ecron și Gat până la moartea lui Samuel.","correct":false}]'::jsonb, 7, 3, '1 Samuel', ARRAY['7:13']::text[], 'pending_review', 'Codex'),
  ('Ce s-a întâmplat cu cetățile și ținuturile pe care filistenii le luaseră de la Israel?', '[{"text":"Cetățile s-au întors la Israel, de la Ecron până la Gat.","correct":true},{"text":"Israel a luat înapoi ținuturile lor din mâna filistenilor.","correct":true},{"text":"Cetățile au fost împărțite între Israel și amoriți.","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:14']::text[], 'pending_review', 'Codex'),
  ('Ce două detalii despre Samuel sunt menționate la sfârșitul capitolului?', '[{"text":"A judecat pe Israel în toate zilele vieții lui.","correct":true},{"text":"A ridicat la Rama un altar Domnului.","correct":true},{"text":"A locuit la Bet-Car și a judecat doar în fiecare an.","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:15', '7:17']::text[], 'pending_review', 'Codex'),
  ('Care sunt locurile numite în legătură cu lucrarea de judecător a lui Samuel?', '[{"text":"Betel, Ghilgal și Mițpa făceau parte din circuitul lui anual.","correct":true},{"text":"La Rama, unde era casa lui, judeca pe Israel.","correct":true},{"text":"Ecron și Gat erau cetățile în care își ținea judecata anuală.","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:16', '7:17']::text[], 'pending_review', 'Codex'),
  ('Ce combinație descrie adunarea și mărturisirea poporului la Mițpa?', '[{"text":"Poporul a postit în ziua aceea.","correct":true},{"text":"Poporul a spus: „Am păcătuit împotriva Domnului.”","correct":true},{"text":"Poporul a sărbătorit biruința asupra filistenilor înainte ca aceștia să vină.","correct":false}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:6', '7:7']::text[], 'pending_review', 'Codex'),
  ('Ce legătură face capitolul între rugăciunea lui Samuel și intervenția Domnului?', '[{"text":"Samuel a strigat către Domnul pentru Israel, iar Domnul l-a ascultat.","correct":true},{"text":"În timp ce Samuel aducea arderea-de-tot, Domnul a tunat împotriva filistenilor.","correct":true},{"text":"Samuel a cerut filistenilor să se roage Domnului și ei au fost ascultați.","correct":false}]'::jsonb, 7, 3, '1 Samuel', ARRAY['7:9', '7:10']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 7, ARRAY['7:1', '7:2']::text[], 'pending_review', '[{"left":"Locuitorii care au luat chivotul","right":"Cei din Chiriat-Iearim"},{"left":"Casa în care au dus chivotul","right":"Casa lui Abinadab"},{"left":"Fiul sfințit ca păzitor al chivotului","right":"Eleazar"},{"left":"Locul unde a rămas chivotul","right":"Chiriat-Iearim"},{"left":"Perioada menționată după așezarea chivotului","right":"Douăzeci de ani"}]'::jsonb),
  ('1 Samuel', 7, ARRAY['7:3', '7:4']::text[], 'pending_review', '[{"left":"Ce trebuia îndepărtat din mijlocul poporului","right":"Dumnezeii străini și Astarteele"},{"left":"Încotro trebuia să-și îndrepte Israel inima","right":"Spre Domnul"},{"left":"Cui trebuia să-I slujească Israel","right":"Domnului numai Lui"},{"left":"De cine urma să-i izbăvească Domnul","right":"De filisteni"},{"left":"Dumnezeii pe care Israel i-a îndepărtat","right":"Baalii și Astarteele"}]'::jsonb),
  ('1 Samuel', 7, ARRAY['7:5', '7:6']::text[], 'pending_review', '[{"left":"Locul unde Samuel a chemat tot Israelul","right":"Mițpa"},{"left":"Ce a spus Samuel că va face pentru popor","right":"Se va ruga Domnului"},{"left":"Ce au vărsat israeliții înaintea Domnului","right":"Apă"},{"left":"Ce au făcut israeliții în ziua aceea","right":"Au postit"},{"left":"Mărturisirea făcută de popor","right":"„Am păcătuit împotriva Domnului.”"}]'::jsonb),
  ('1 Samuel', 7, ARRAY['7:7', '7:8']::text[], 'pending_review', '[{"left":"Cine a pornit împotriva lui Israel","right":"Domnitorii filistenilor"},{"left":"Unde era adunat Israelul","right":"La Mițpa"},{"left":"Cum s-a simțit Israel când a aflat de venirea filistenilor","right":"S-a temut"},{"left":"Ce i-au cerut lui Samuel să nu înceteze să facă","right":"Să strige către Domnul"},{"left":"Din mâna cui cereau să fie scăpați","right":"Din mâna filistenilor"}]'::jsonb),
  ('1 Samuel', 7, ARRAY['7:9', '7:10']::text[], 'pending_review', '[{"left":"Animalul adus de Samuel ca ardere-de-tot","right":"Un miel care încă sugea"},{"left":"Pentru cine a strigat Samuel către Domnul","right":"Pentru Israel"},{"left":"Cum a răspuns Domnul la strigătul lui Samuel","right":"L-a ascultat"},{"left":"Ce a făcut Domnul împotriva filistenilor","right":"A făcut să răsune tunete"},{"left":"Ce li s-a întâmplat filistenilor înaintea lui Israel","right":"Au fost puși pe fugă și înfrânți"}]'::jsonb),
  ('1 Samuel', 7, ARRAY['7:10', '7:11']::text[], 'pending_review', '[{"left":"Momentul în care Domnul a tunat împotriva filistenilor","right":"În timp ce Samuel aducea arderea-de-tot"},{"left":"Reacția filistenilor la tunetul Domnului","right":"Au fost puși pe fugă"},{"left":"Locul din care au ieșit bărbații lui Israel","right":"Mițpa"},{"left":"Ce au făcut bărbații lui Israel cu filistenii","right":"I-au urmărit și i-au înfrânt"},{"left":"Până unde au fost urmăriți filistenii","right":"Până sub Bet-Car"}]'::jsonb),
  ('1 Samuel', 7, ARRAY['7:12', '7:13']::text[], 'pending_review', '[{"left":"Locul dintre care a fost așezată piatra","right":"Mițpa și Șen"},{"left":"Numele dat pietrei de Samuel","right":"Eben-Ezer"},{"left":"Ce a spus Samuel despre ajutorul primit","right":"„Până aici Domnul ne-a ajutat.”"},{"left":"Ce s-a întâmplat cu filistenii după înfrângere","right":"Au fost smeriți"},{"left":"Cât timp a fost mâna Domnului împotriva filistenilor","right":"În tot timpul vieții lui Samuel"}]'::jsonb),
  ('1 Samuel', 7, ARRAY['7:13', '7:14']::text[], 'pending_review', '[{"left":"Ce s-a întâmplat cu filistenii","right":"Au fost smeriți"},{"left":"Ce nu au mai făcut filistenii","right":"Nu au mai intrat în ținutul lui Israel"},{"left":"Cât timp a fost mâna Domnului împotriva filistenilor","right":"În tot timpul vieții lui Samuel"},{"left":"Intervalul cetăților întoarse la Israel","right":"De la Ecron până la Gat"},{"left":"Cu cine a fost pace","right":"Cu amoriții"}]'::jsonb),
  ('1 Samuel', 7, ARRAY['7:15', '7:16', '7:17']::text[], 'pending_review', '[{"left":"Cât timp a judecat Samuel pe Israel","right":"În toate zilele vieții lui"},{"left":"Cât de des făcea Samuel circuitul cetăților","right":"În fiecare an"},{"left":"Cetatea vizitată pe circuit, alături de Ghilgal și Mițpa","right":"Betel"},{"left":"Unde era casa lui Samuel","right":"La Rama"},{"left":"Ce a zidit Samuel la Rama","right":"Un altar Domnului"}]'::jsonb),
  ('1 Samuel', 7, ARRAY['7:5', '7:6', '7:16', '7:17']::text[], 'pending_review', '[{"left":"Locul adunării chemate de Samuel","right":"Mițpa"},{"left":"Locul unde Samuel judeca Israelul în circuitul anual","right":"Betel"},{"left":"Un alt loc de judecată din circuitul anual","right":"Ghilgal"},{"left":"Cetatea unde era casa lui Samuel și unde judeca","right":"Rama"},{"left":"Ce a zidit Samuel în cetatea unde era casa sa","right":"Un altar Domnului"}]'::jsonb),
  ('1 Samuel', 7, ARRAY['7:3', '7:4', '7:6', '7:8']::text[], 'pending_review', '[{"left":"Îndemnul despre închinare dat de Samuel","right":"Slujiți Domnului numai Lui"},{"left":"Răspunsul poporului la chemarea de a îndepărta idolii","right":"A îndepărtat Baalii și Astarteele"},{"left":"Atitudinea poporului în adunarea de la Mițpa","right":"A postit"},{"left":"Ce a mărturisit poporul la Mițpa","right":"Că a păcătuit împotriva Domnului"},{"left":"Cererea poporului către Samuel în fața filistenilor","right":"Să strige către Domnul pentru ei"}]'::jsonb)
) as incoming (book, chapter, source_references, status, pairs)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.pairs = incoming.pairs;

insert into public.questions_match (pairs, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.pairs, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('[{"left":"Locuitorii care au luat chivotul","right":"Cei din Chiriat-Iearim"},{"left":"Casa în care au dus chivotul","right":"Casa lui Abinadab"},{"left":"Fiul sfințit ca păzitor al chivotului","right":"Eleazar"},{"left":"Locul unde a rămas chivotul","right":"Chiriat-Iearim"},{"left":"Perioada menționată după așezarea chivotului","right":"Douăzeci de ani"}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:1', '7:2']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Ce trebuia îndepărtat din mijlocul poporului","right":"Dumnezeii străini și Astarteele"},{"left":"Încotro trebuia să-și îndrepte Israel inima","right":"Spre Domnul"},{"left":"Cui trebuia să-I slujească Israel","right":"Domnului numai Lui"},{"left":"De cine urma să-i izbăvească Domnul","right":"De filisteni"},{"left":"Dumnezeii pe care Israel i-a îndepărtat","right":"Baalii și Astarteele"}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:3', '7:4']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Locul unde Samuel a chemat tot Israelul","right":"Mițpa"},{"left":"Ce a spus Samuel că va face pentru popor","right":"Se va ruga Domnului"},{"left":"Ce au vărsat israeliții înaintea Domnului","right":"Apă"},{"left":"Ce au făcut israeliții în ziua aceea","right":"Au postit"},{"left":"Mărturisirea făcută de popor","right":"„Am păcătuit împotriva Domnului.”"}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:5', '7:6']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Cine a pornit împotriva lui Israel","right":"Domnitorii filistenilor"},{"left":"Unde era adunat Israelul","right":"La Mițpa"},{"left":"Cum s-a simțit Israel când a aflat de venirea filistenilor","right":"S-a temut"},{"left":"Ce i-au cerut lui Samuel să nu înceteze să facă","right":"Să strige către Domnul"},{"left":"Din mâna cui cereau să fie scăpați","right":"Din mâna filistenilor"}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:7', '7:8']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Animalul adus de Samuel ca ardere-de-tot","right":"Un miel care încă sugea"},{"left":"Pentru cine a strigat Samuel către Domnul","right":"Pentru Israel"},{"left":"Cum a răspuns Domnul la strigătul lui Samuel","right":"L-a ascultat"},{"left":"Ce a făcut Domnul împotriva filistenilor","right":"A făcut să răsune tunete"},{"left":"Ce li s-a întâmplat filistenilor înaintea lui Israel","right":"Au fost puși pe fugă și înfrânți"}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:9', '7:10']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Momentul în care Domnul a tunat împotriva filistenilor","right":"În timp ce Samuel aducea arderea-de-tot"},{"left":"Reacția filistenilor la tunetul Domnului","right":"Au fost puși pe fugă"},{"left":"Locul din care au ieșit bărbații lui Israel","right":"Mițpa"},{"left":"Ce au făcut bărbații lui Israel cu filistenii","right":"I-au urmărit și i-au înfrânt"},{"left":"Până unde au fost urmăriți filistenii","right":"Până sub Bet-Car"}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:10', '7:11']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Locul dintre care a fost așezată piatra","right":"Mițpa și Șen"},{"left":"Numele dat pietrei de Samuel","right":"Eben-Ezer"},{"left":"Ce a spus Samuel despre ajutorul primit","right":"„Până aici Domnul ne-a ajutat.”"},{"left":"Ce s-a întâmplat cu filistenii după înfrângere","right":"Au fost smeriți"},{"left":"Cât timp a fost mâna Domnului împotriva filistenilor","right":"În tot timpul vieții lui Samuel"}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:12', '7:13']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Ce s-a întâmplat cu filistenii","right":"Au fost smeriți"},{"left":"Ce nu au mai făcut filistenii","right":"Nu au mai intrat în ținutul lui Israel"},{"left":"Cât timp a fost mâna Domnului împotriva filistenilor","right":"În tot timpul vieții lui Samuel"},{"left":"Intervalul cetăților întoarse la Israel","right":"De la Ecron până la Gat"},{"left":"Cu cine a fost pace","right":"Cu amoriții"}]'::jsonb, 7, 3, '1 Samuel', ARRAY['7:13', '7:14']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Cât timp a judecat Samuel pe Israel","right":"În toate zilele vieții lui"},{"left":"Cât de des făcea Samuel circuitul cetăților","right":"În fiecare an"},{"left":"Cetatea vizitată pe circuit, alături de Ghilgal și Mițpa","right":"Betel"},{"left":"Unde era casa lui Samuel","right":"La Rama"},{"left":"Ce a zidit Samuel la Rama","right":"Un altar Domnului"}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:15', '7:16', '7:17']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Locul adunării chemate de Samuel","right":"Mițpa"},{"left":"Locul unde Samuel judeca Israelul în circuitul anual","right":"Betel"},{"left":"Un alt loc de judecată din circuitul anual","right":"Ghilgal"},{"left":"Cetatea unde era casa lui Samuel și unde judeca","right":"Rama"},{"left":"Ce a zidit Samuel în cetatea unde era casa sa","right":"Un altar Domnului"}]'::jsonb, 7, 2, '1 Samuel', ARRAY['7:5', '7:6', '7:16', '7:17']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Îndemnul despre închinare dat de Samuel","right":"Slujiți Domnului numai Lui"},{"left":"Răspunsul poporului la chemarea de a îndepărta idolii","right":"A îndepărtat Baalii și Astarteele"},{"left":"Atitudinea poporului în adunarea de la Mițpa","right":"A postit"},{"left":"Ce a mărturisit poporul la Mițpa","right":"Că a păcătuit împotriva Domnului"},{"left":"Cererea poporului către Samuel în fața filistenilor","right":"Să strige către Domnul pentru ei"}]'::jsonb, 7, 3, '1 Samuel', ARRAY['7:3', '7:4', '7:6', '7:8']::text[], 'pending_review', 'Codex')
) as incoming (pairs, chapter, difficulty, book, source_references, status, added_by)
where not exists (
  select 1 from public.questions_match existing
  where existing.book = incoming.book
    and existing.chapter = incoming.chapter
    and existing.source_references = incoming.source_references
    and existing.pairs = incoming.pairs
);

commit;
