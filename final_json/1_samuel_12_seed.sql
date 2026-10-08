begin;

alter table public.questions_tf add column if not exists source_references text[] not null default '{}';

alter table public.questions_abc_one add column if not exists source_references text[] not null default '{}';

alter table public.questions_abc_multi add column if not exists source_references text[] not null default '{}';

alter table public.questions_match add column if not exists source_references text[] not null default '{}';

update public.questions_tf as existing
set status = incoming.status
from (values
  ('1 Samuel', 12, ARRAY['12:1']::text[], 'pending_review', 'Samuel a spus că i-a ascultat pe israeliți în tot ce i-au cerut și că a pus un împărat peste ei.'),
  ('1 Samuel', 12, ARRAY['12:2']::text[], 'pending_review', 'Samuel era bătrân și cărunt, fiii lui erau cu poporul, iar el umblase înaintea poporului din tinerețe până atunci.'),
  ('1 Samuel', 12, ARRAY['12:3']::text[], 'pending_review', 'Samuel a cerut ca poporul să mărturisească înaintea Domnului și a unsului Lui dacă luase boul sau măgarul cuiva, apăsase ori năpăstuit pe cineva sau luase mită.'),
  ('1 Samuel', 12, ARRAY['12:4']::text[], 'pending_review', 'Poporul i-a răspuns lui Samuel că nu îi apăsase, nu îi năpăstuise și nu primise nimic din mâna nimănui.'),
  ('1 Samuel', 12, ARRAY['12:5']::text[], 'pending_review', 'Samuel a spus că Domnul și unsul Lui sunt martori că nu s-a găsit nimic în mâinile lui, iar poporul a răspuns: «Sunt martori!»'),
  ('1 Samuel', 12, ARRAY['12:6']::text[], 'pending_review', 'Samuel a spus că Domnul i-a pus pe Moise și pe Aaron și i-a scos pe părinții poporului din Egipt.'),
  ('1 Samuel', 12, ARRAY['12:8']::text[], 'pending_review', 'După ce Iacov a venit în Egipt, părinții poporului au strigat către Domnul, iar Domnul i-a trimis pe Moise și pe Aaron.'),
  ('1 Samuel', 12, ARRAY['12:10']::text[], 'pending_review', 'Poporul a mărturisit că părăsise pe Domnul și slujise baalilor și astarteelor, cerând apoi izbăvire de vrăjmași.'),
  ('1 Samuel', 12, ARRAY['12:12']::text[], 'pending_review', 'Când au văzut că Nahaș mergea împotriva lor, israeliții au cerut un împărat, deși Domnul Dumnezeul lor era Împăratul lor.'),
  ('1 Samuel', 12, ARRAY['12:18']::text[], 'pending_review', 'Domnul a trimis tunete și ploaie chiar în ziua în care Samuel a strigat către El, iar poporul a avut o mare frică de Domnul și de Samuel.'),
  ('1 Samuel', 12, ARRAY['12:2']::text[], 'pending_review', 'Samuel a spus că împăratul era bătrân și cărunt, iar fiii împăratului umblaseră înaintea poporului din tinerețe.'),
  ('1 Samuel', 12, ARRAY['12:3']::text[], 'pending_review', 'Samuel a mărturisit că luase măgarul cuiva și s-a oferit să îl dea înapoi.'),
  ('1 Samuel', 12, ARRAY['12:4']::text[], 'pending_review', 'Poporul a spus că Samuel îi apăsase, îi năpăstuise și primise ceva din mâna oamenilor.'),
  ('1 Samuel', 12, ARRAY['12:5']::text[], 'pending_review', 'Când Samuel a spus că Domnul și unsul Lui sunt martori, poporul a răspuns că nu poate depune mărturie.'),
  ('1 Samuel', 12, ARRAY['12:9']::text[], 'pending_review', 'Samuel a spus că Domnul i-a vândut în mâinile lui Barac, ale filistenilor și ale împăratului Moabului.'),
  ('1 Samuel', 12, ARRAY['12:11']::text[], 'pending_review', 'În lista celor trimiși de Domnul să izbăvească poporul, Samuel l-a menționat pe Moise, dar nu și pe Ierubaal.'),
  ('1 Samuel', 12, ARRAY['12:12']::text[], 'pending_review', 'Când au văzut că Nahaș mergea împotriva lor, israeliții i-au cerut lui Samuel să domnească peste ei în locul unui împărat.'),
  ('1 Samuel', 12, ARRAY['12:14']::text[], 'pending_review', 'Samuel le-a spus că se vor alipi de Domnul dacă se vor împotrivi Cuvântului Lui și nu-I vor asculta glasul.'),
  ('1 Samuel', 12, ARRAY['12:17']::text[], 'pending_review', 'La seceratul grânelor, Samuel a spus că Domnul va trimite zăpadă și vânt, nu tunete și ploaie.'),
  ('1 Samuel', 12, ARRAY['12:25']::text[], 'pending_review', 'Samuel a spus că, dacă vor face răul, va pieri numai împăratul, iar poporul va rămâne în viață.')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_tf (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Samuel a spus că i-a ascultat pe israeliți în tot ce i-au cerut și că a pus un împărat peste ei.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 12, 1, '1 Samuel', ARRAY['12:1']::text[], 'pending_review', 'Codex'),
  ('Samuel era bătrân și cărunt, fiii lui erau cu poporul, iar el umblase înaintea poporului din tinerețe până atunci.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 12, 2, '1 Samuel', ARRAY['12:2']::text[], 'pending_review', 'Codex'),
  ('Samuel a cerut ca poporul să mărturisească înaintea Domnului și a unsului Lui dacă luase boul sau măgarul cuiva, apăsase ori năpăstuit pe cineva sau luase mită.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 12, 3, '1 Samuel', ARRAY['12:3']::text[], 'pending_review', 'Codex'),
  ('Poporul i-a răspuns lui Samuel că nu îi apăsase, nu îi năpăstuise și nu primise nimic din mâna nimănui.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 12, 2, '1 Samuel', ARRAY['12:4']::text[], 'pending_review', 'Codex'),
  ('Samuel a spus că Domnul și unsul Lui sunt martori că nu s-a găsit nimic în mâinile lui, iar poporul a răspuns: «Sunt martori!»', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 12, 2, '1 Samuel', ARRAY['12:5']::text[], 'pending_review', 'Codex'),
  ('Samuel a spus că Domnul i-a pus pe Moise și pe Aaron și i-a scos pe părinții poporului din Egipt.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 12, 2, '1 Samuel', ARRAY['12:6']::text[], 'pending_review', 'Codex'),
  ('După ce Iacov a venit în Egipt, părinții poporului au strigat către Domnul, iar Domnul i-a trimis pe Moise și pe Aaron.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 12, 2, '1 Samuel', ARRAY['12:8']::text[], 'pending_review', 'Codex'),
  ('Poporul a mărturisit că părăsise pe Domnul și slujise baalilor și astarteelor, cerând apoi izbăvire de vrăjmași.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 12, 2, '1 Samuel', ARRAY['12:10']::text[], 'pending_review', 'Codex'),
  ('Când au văzut că Nahaș mergea împotriva lor, israeliții au cerut un împărat, deși Domnul Dumnezeul lor era Împăratul lor.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 12, 2, '1 Samuel', ARRAY['12:12']::text[], 'pending_review', 'Codex'),
  ('Domnul a trimis tunete și ploaie chiar în ziua în care Samuel a strigat către El, iar poporul a avut o mare frică de Domnul și de Samuel.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 12, 2, '1 Samuel', ARRAY['12:18']::text[], 'pending_review', 'Codex'),
  ('Samuel a spus că împăratul era bătrân și cărunt, iar fiii împăratului umblaseră înaintea poporului din tinerețe.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 12, 2, '1 Samuel', ARRAY['12:2']::text[], 'pending_review', 'Codex'),
  ('Samuel a mărturisit că luase măgarul cuiva și s-a oferit să îl dea înapoi.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 12, 2, '1 Samuel', ARRAY['12:3']::text[], 'pending_review', 'Codex'),
  ('Poporul a spus că Samuel îi apăsase, îi năpăstuise și primise ceva din mâna oamenilor.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 12, 2, '1 Samuel', ARRAY['12:4']::text[], 'pending_review', 'Codex'),
  ('Când Samuel a spus că Domnul și unsul Lui sunt martori, poporul a răspuns că nu poate depune mărturie.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 12, 2, '1 Samuel', ARRAY['12:5']::text[], 'pending_review', 'Codex'),
  ('Samuel a spus că Domnul i-a vândut în mâinile lui Barac, ale filistenilor și ale împăratului Moabului.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 12, 3, '1 Samuel', ARRAY['12:9']::text[], 'pending_review', 'Codex'),
  ('În lista celor trimiși de Domnul să izbăvească poporul, Samuel l-a menționat pe Moise, dar nu și pe Ierubaal.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 12, 3, '1 Samuel', ARRAY['12:11']::text[], 'pending_review', 'Codex'),
  ('Când au văzut că Nahaș mergea împotriva lor, israeliții i-au cerut lui Samuel să domnească peste ei în locul unui împărat.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 12, 2, '1 Samuel', ARRAY['12:12']::text[], 'pending_review', 'Codex'),
  ('Samuel le-a spus că se vor alipi de Domnul dacă se vor împotrivi Cuvântului Lui și nu-I vor asculta glasul.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 12, 2, '1 Samuel', ARRAY['12:14']::text[], 'pending_review', 'Codex'),
  ('La seceratul grânelor, Samuel a spus că Domnul va trimite zăpadă și vânt, nu tunete și ploaie.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 12, 3, '1 Samuel', ARRAY['12:17']::text[], 'pending_review', 'Codex'),
  ('Samuel a spus că, dacă vor face răul, va pieri numai împăratul, iar poporul va rămâne în viață.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 12, 2, '1 Samuel', ARRAY['12:25']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 12, ARRAY['12:2']::text[], 'pending_review', 'Potrivit lui Samuel, cine urma să meargă înaintea poporului?'),
  ('1 Samuel', 12, ARRAY['12:3']::text[], 'pending_review', 'Ce animale a menționat Samuel când a întrebat dacă luase ceva de la cineva?'),
  ('1 Samuel', 12, ARRAY['12:4']::text[], 'pending_review', 'Ce au răspuns israeliții când Samuel i-a întrebat dacă îi apăsase ori îi năpăstuise?'),
  ('1 Samuel', 12, ARRAY['12:5']::text[], 'pending_review', 'Ce a răspuns poporul după ce Samuel a spus că Domnul și unsul Lui sunt martori?'),
  ('1 Samuel', 12, ARRAY['12:7']::text[], 'pending_review', 'Pentru ce le-a cerut Samuel israeliților să se înfățișeze înaintea Domnului?'),
  ('1 Samuel', 12, ARRAY['12:8']::text[], 'pending_review', 'Pe cine a trimis Domnul după ce părinții poporului au strigat către El în Egipt?'),
  ('1 Samuel', 12, ARRAY['12:9']::text[], 'pending_review', 'Cine era căpetenia oștii Hațorului în relatarea lui Samuel?'),
  ('1 Samuel', 12, ARRAY['12:9']::text[], 'pending_review', 'În mâinile cui, pe lângă Sisera, au fost vânduți israeliții?'),
  ('1 Samuel', 12, ARRAY['12:10']::text[], 'pending_review', 'Cărui grup de dumnezei au spus israeliții că slujiseră după ce Îl părăsiseră pe Domnul?'),
  ('1 Samuel', 12, ARRAY['12:11']::text[], 'pending_review', 'Cum spune Samuel că au locuit israeliții după ce Domnul i-a izbăvit de vrăjmași?'),
  ('1 Samuel', 12, ARRAY['12:12']::text[], 'pending_review', 'Cine era Nahaș, cel care mergea împotriva israeliților?'),
  ('1 Samuel', 12, ARRAY['12:13']::text[], 'pending_review', 'Cine a pus peste Israel împăratul pe care poporul îl alesese și îl ceruse?'),
  ('1 Samuel', 12, ARRAY['12:14']::text[], 'pending_review', 'Potrivit lui Samuel, cine urma să se alipească de Domnul dacă poporul Îl asculta și nu I se împotrivea?'),
  ('1 Samuel', 12, ARRAY['12:15']::text[], 'pending_review', 'Ce urma să fie împotriva poporului dacă nu asculta de glasul Domnului și se împotrivea Cuvântului Lui?'),
  ('1 Samuel', 12, ARRAY['12:16']::text[], 'pending_review', 'Ce le-a spus Samuel să aștepte ca să vadă sub ochii lor?'),
  ('1 Samuel', 12, ARRAY['12:17']::text[], 'pending_review', 'În ce perioadă a anului a spus Samuel că va striga către Domnul?'),
  ('1 Samuel', 12, ARRAY['12:19']::text[], 'pending_review', 'De ce i-a cerut tot poporul lui Samuel să se roage Domnului pentru ei?'),
  ('1 Samuel', 12, ARRAY['12:20']::text[], 'pending_review', 'Cu ce le-a spus Samuel să-I slujească Domnului?'),
  ('1 Samuel', 12, ARRAY['12:22']::text[], 'pending_review', 'Din ce pricină a spus Samuel că Domnul nu-Și va părăsi poporul?'),
  ('1 Samuel', 12, ARRAY['12:24']::text[], 'pending_review', 'Cum le-a cerut Samuel să-I slujească Domnului?')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_abc_one (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Potrivit lui Samuel, cine urma să meargă înaintea poporului?', '[{"text":"Împăratul","correct":true},{"text":"Samuel","correct":false},{"text":"Aaron","correct":false}]'::jsonb, 12, 1, '1 Samuel', ARRAY['12:2']::text[], 'pending_review', 'Codex'),
  ('Ce animale a menționat Samuel când a întrebat dacă luase ceva de la cineva?', '[{"text":"Un bou sau un măgar","correct":true},{"text":"O oaie sau o capră","correct":false},{"text":"Un cal sau o cămilă","correct":false}]'::jsonb, 12, 1, '1 Samuel', ARRAY['12:3']::text[], 'pending_review', 'Codex'),
  ('Ce au răspuns israeliții când Samuel i-a întrebat dacă îi apăsase ori îi năpăstuise?', '[{"text":"Că nu făcuse niciuna dintre acestea și nu primise nimic de la nimeni","correct":true},{"text":"Că îi apăsase, dar nu primise nimic","correct":false},{"text":"Că nu îi apăsase, dar luase mită","correct":false}]'::jsonb, 12, 2, '1 Samuel', ARRAY['12:4']::text[], 'pending_review', 'Codex'),
  ('Ce a răspuns poporul după ce Samuel a spus că Domnul și unsul Lui sunt martori?', '[{"text":"«Sunt martori!»","correct":true},{"text":"«Nu suntem martori!»","correct":false},{"text":"«Samuel este singurul martor!»","correct":false}]'::jsonb, 12, 1, '1 Samuel', ARRAY['12:5']::text[], 'pending_review', 'Codex'),
  ('Pentru ce le-a cerut Samuel israeliților să se înfățișeze înaintea Domnului?', '[{"text":"Ca să-i judece pentru binefacerile făcute lor și părinților lor","correct":true},{"text":"Ca să aleagă un alt împărat","correct":false},{"text":"Ca să numere oștirea lui Israel","correct":false}]'::jsonb, 12, 2, '1 Samuel', ARRAY['12:7']::text[], 'pending_review', 'Codex'),
  ('Pe cine a trimis Domnul după ce părinții poporului au strigat către El în Egipt?', '[{"text":"Pe Moise și pe Aaron","correct":true},{"text":"Pe Ierubaal și pe Barac","correct":false},{"text":"Pe Samuel și pe Iefta","correct":false}]'::jsonb, 12, 1, '1 Samuel', ARRAY['12:8']::text[], 'pending_review', 'Codex'),
  ('Cine era căpetenia oștii Hațorului în relatarea lui Samuel?', '[{"text":"Sisera","correct":true},{"text":"Nahaș","correct":false},{"text":"Ierubaal","correct":false}]'::jsonb, 12, 2, '1 Samuel', ARRAY['12:9']::text[], 'pending_review', 'Codex'),
  ('În mâinile cui, pe lângă Sisera, au fost vânduți israeliții?', '[{"text":"Ale filistenilor și ale împăratului Moabului","correct":true},{"text":"Ale egiptenilor și ale amaleciților","correct":false},{"text":"Ale lui Barac și ale lui Iefta","correct":false}]'::jsonb, 12, 2, '1 Samuel', ARRAY['12:9']::text[], 'pending_review', 'Codex'),
  ('Cărui grup de dumnezei au spus israeliții că slujiseră după ce Îl părăsiseră pe Domnul?', '[{"text":"Baalilor și astarteelor","correct":true},{"text":"Dagonului și lui Chemoș","correct":false},{"text":"Lui Baal și lui Moloh","correct":false}]'::jsonb, 12, 2, '1 Samuel', ARRAY['12:10']::text[], 'pending_review', 'Codex'),
  ('Cum spune Samuel că au locuit israeliții după ce Domnul i-a izbăvit de vrăjmași?', '[{"text":"În liniște","correct":true},{"text":"În Egipt","correct":false},{"text":"În pustie","correct":false}]'::jsonb, 12, 1, '1 Samuel', ARRAY['12:11']::text[], 'pending_review', 'Codex'),
  ('Cine era Nahaș, cel care mergea împotriva israeliților?', '[{"text":"Împăratul fiilor lui Amon","correct":true},{"text":"Căpetenia oștii Hațorului","correct":false},{"text":"Împăratul Moabului","correct":false}]'::jsonb, 12, 1, '1 Samuel', ARRAY['12:12']::text[], 'pending_review', 'Codex'),
  ('Cine a pus peste Israel împăratul pe care poporul îl alesese și îl ceruse?', '[{"text":"Domnul","correct":true},{"text":"Samuel","correct":false},{"text":"Nahaș","correct":false}]'::jsonb, 12, 1, '1 Samuel', ARRAY['12:13']::text[], 'pending_review', 'Codex'),
  ('Potrivit lui Samuel, cine urma să se alipească de Domnul dacă poporul Îl asculta și nu I se împotrivea?', '[{"text":"Poporul și împăratul care domnea peste el","correct":true},{"text":"Numai împăratul","correct":false},{"text":"Numai bătrânii poporului","correct":false}]'::jsonb, 12, 2, '1 Samuel', ARRAY['12:14']::text[], 'pending_review', 'Codex'),
  ('Ce urma să fie împotriva poporului dacă nu asculta de glasul Domnului și se împotrivea Cuvântului Lui?', '[{"text":"Mâna Domnului","correct":true},{"text":"Oștirea filistenilor","correct":false},{"text":"Mâna împăratului Moabului","correct":false}]'::jsonb, 12, 2, '1 Samuel', ARRAY['12:15']::text[], 'pending_review', 'Codex'),
  ('Ce le-a spus Samuel să aștepte ca să vadă sub ochii lor?', '[{"text":"Minunea pe care o va face Domnul","correct":true},{"text":"Venirea lui Nahaș","correct":false},{"text":"Alegerea unui alt judecător","correct":false}]'::jsonb, 12, 1, '1 Samuel', ARRAY['12:16']::text[], 'pending_review', 'Codex'),
  ('În ce perioadă a anului a spus Samuel că va striga către Domnul?', '[{"text":"La seceratul grânelor","correct":true},{"text":"La culesul măslinilor","correct":false},{"text":"La semănatul grâului","correct":false}]'::jsonb, 12, 2, '1 Samuel', ARRAY['12:17']::text[], 'pending_review', 'Codex'),
  ('De ce i-a cerut tot poporul lui Samuel să se roage Domnului pentru ei?', '[{"text":"Ca să nu moară","correct":true},{"text":"Ca să nu vină ploaia","correct":false},{"text":"Ca să li se dea un alt împărat","correct":false}]'::jsonb, 12, 1, '1 Samuel', ARRAY['12:19']::text[], 'pending_review', 'Codex'),
  ('Cu ce le-a spus Samuel să-I slujească Domnului?', '[{"text":"Cu toată inima","correct":true},{"text":"Numai prin jertfe","correct":false},{"text":"Doar când erau în primejdie","correct":false}]'::jsonb, 12, 1, '1 Samuel', ARRAY['12:20']::text[], 'pending_review', 'Codex'),
  ('Din ce pricină a spus Samuel că Domnul nu-Și va părăsi poporul?', '[{"text":"Din pricina Numelui Lui celui mare","correct":true},{"text":"Pentru că poporul nu păcătuise","correct":false},{"text":"Pentru că împăratul Îi poruncise","correct":false}]'::jsonb, 12, 2, '1 Samuel', ARRAY['12:22']::text[], 'pending_review', 'Codex'),
  ('Cum le-a cerut Samuel să-I slujească Domnului?', '[{"text":"Cu credincioșie și din toată inima","correct":true},{"text":"Numai când veneau tunete și ploaie","correct":false},{"text":"Prin împotrivirea față de Cuvântul Lui","correct":false}]'::jsonb, 12, 2, '1 Samuel', ARRAY['12:24']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 12, ARRAY['12:3']::text[], 'pending_review', 'Despre care fapte îl întreabă Samuel pe popor dacă le-a făcut?'),
  ('1 Samuel', 12, ARRAY['12:9']::text[], 'pending_review', 'Cine, pe lângă Sisera, este menționat printre cei în ale căror mâini Domnul i-a vândut pe israeliți?'),
  ('1 Samuel', 12, ARRAY['12:14']::text[], 'pending_review', 'Ce le cere Samuel să facă israeliților pentru a rămâne alipiți de Domnul, împreună cu împăratul lor?'),
  ('1 Samuel', 12, ARRAY['12:17']::text[], 'pending_review', 'Ce a spus Samuel că se va întâmpla când va striga către Domnul la seceratul grânelor?'),
  ('1 Samuel', 12, ARRAY['12:21']::text[], 'pending_review', 'Ce spune Samuel despre lucrurile de nimic după care poporul nu trebuia să umble?'),
  ('1 Samuel', 12, ARRAY['12:23']::text[], 'pending_review', 'Ce spune Samuel că va face pentru popor, chiar dacă a făcut rău cerând un împărat?')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_abc_multi (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Despre care fapte îl întreabă Samuel pe popor dacă le-a făcut?', '[{"text":"Dacă luase boul sau măgarul cuiva, ori apăsase și năpăstuit pe cineva","correct":true},{"text":"Dacă luase mită ca să închidă ochii asupra cuiva","correct":true},{"text":"Dacă refuzase să mai judece poporul","correct":false}]'::jsonb, 12, 3, '1 Samuel', ARRAY['12:3']::text[], 'pending_review', 'Codex'),
  ('Cine, pe lângă Sisera, este menționat printre cei în ale căror mâini Domnul i-a vândut pe israeliți?', '[{"text":"Filistenii","correct":true},{"text":"Împăratul Moabului","correct":true},{"text":"Nahaș, împăratul fiilor lui Amon","correct":false}]'::jsonb, 12, 3, '1 Samuel', ARRAY['12:9']::text[], 'pending_review', 'Codex'),
  ('Ce le cere Samuel să facă israeliților pentru a rămâne alipiți de Domnul, împreună cu împăratul lor?', '[{"text":"Să se teamă de Domnul și să-I slujească","correct":true},{"text":"Să asculte de glasul Lui și să nu se împotrivească Cuvântului Lui","correct":true},{"text":"Să se alipească numai de împărat și să nu mai asculte de Domnul","correct":false}]'::jsonb, 12, 2, '1 Samuel', ARRAY['12:14']::text[], 'pending_review', 'Codex'),
  ('Ce a spus Samuel că se va întâmpla când va striga către Domnul la seceratul grânelor?', '[{"text":"Domnul va trimite tunete și ploaie","correct":true},{"text":"Poporul va vedea cât de rău a făcut înaintea Domnului cerând un împărat","correct":true},{"text":"Domnul va trimite zăpadă, dovedind că cererea poporului fusese bună","correct":false}]'::jsonb, 12, 3, '1 Samuel', ARRAY['12:17']::text[], 'pending_review', 'Codex'),
  ('Ce spune Samuel despre lucrurile de nimic după care poporul nu trebuia să umble?', '[{"text":"Nu aduc niciun folos","correct":true},{"text":"Nu aduc izbăvire","correct":true},{"text":"Aduc izbăvire și folos celor care le urmează","correct":false}]'::jsonb, 12, 2, '1 Samuel', ARRAY['12:21']::text[], 'pending_review', 'Codex'),
  ('Ce spune Samuel că va face pentru popor, chiar dacă a făcut rău cerând un împărat?', '[{"text":"Nu va înceta să se roage pentru popor","correct":true},{"text":"Îl va învăța calea cea bună și dreaptă","correct":true},{"text":"Va înceta să se roage și îl va lăsa fără îndrumare","correct":false}]'::jsonb, 12, 2, '1 Samuel', ARRAY['12:23']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 12, ARRAY['12:8', '12:9', '12:11']::text[], 'pending_review', '[{"left":"Iacov","right":"A venit în Egipt"},{"left":"Moise și Aaron","right":"Au scos părinții poporului din Egipt"},{"left":"Sisera","right":"Era căpetenia oștii Hațorului"},{"left":"Nahaș","right":"Era împăratul fiilor lui Amon"},{"left":"Samuel","right":"A fost numit printre cei trimiși să izbăvească poporul"}]'::jsonb),
  ('1 Samuel', 12, ARRAY['12:23', '12:24', '12:25']::text[], 'pending_review', '[{"left":"Rugăciunea lui Samuel","right":"Nu va înceta să se roage pentru popor"},{"left":"Învățătura promisă de Samuel","right":"Îi va învăța calea bună și dreaptă"},{"left":"Domnul","right":"Își desfășoară puterea printre popor"},{"left":"Poporul","right":"Trebuie să se teamă numai de Domnul și să-I slujească cu credincioșie"},{"left":"Poporul și împăratul","right":"Vor pieri dacă vor face răul"}]'::jsonb)
) as incoming (book, chapter, source_references, status, pairs)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.pairs = incoming.pairs;

insert into public.questions_match (pairs, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.pairs, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('[{"left":"Iacov","right":"A venit în Egipt"},{"left":"Moise și Aaron","right":"Au scos părinții poporului din Egipt"},{"left":"Sisera","right":"Era căpetenia oștii Hațorului"},{"left":"Nahaș","right":"Era împăratul fiilor lui Amon"},{"left":"Samuel","right":"A fost numit printre cei trimiși să izbăvească poporul"}]'::jsonb, 12, 3, '1 Samuel', ARRAY['12:8', '12:9', '12:11']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Rugăciunea lui Samuel","right":"Nu va înceta să se roage pentru popor"},{"left":"Învățătura promisă de Samuel","right":"Îi va învăța calea bună și dreaptă"},{"left":"Domnul","right":"Își desfășoară puterea printre popor"},{"left":"Poporul","right":"Trebuie să se teamă numai de Domnul și să-I slujească cu credincioșie"},{"left":"Poporul și împăratul","right":"Vor pieri dacă vor face răul"}]'::jsonb, 12, 3, '1 Samuel', ARRAY['12:23', '12:24', '12:25']::text[], 'pending_review', 'Codex')
) as incoming (pairs, chapter, difficulty, book, source_references, status, added_by)
where not exists (
  select 1 from public.questions_match existing
  where existing.book = incoming.book
    and existing.chapter = incoming.chapter
    and existing.source_references = incoming.source_references
    and existing.pairs = incoming.pairs
);

commit;
