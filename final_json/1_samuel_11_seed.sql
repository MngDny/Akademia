begin;

alter table public.questions_tf add column if not exists source_references text[] not null default '{}';

alter table public.questions_abc_one add column if not exists source_references text[] not null default '{}';

alter table public.questions_abc_multi add column if not exists source_references text[] not null default '{}';

alter table public.questions_match add column if not exists source_references text[] not null default '{}';

update public.questions_tf as existing
set status = incoming.status
from (values
  ('1 Samuel', 11, ARRAY['11:1']::text[], 'pending_review', 'Nahaș, Amonitul, a împresurat Iabesul din Galaad.'),
  ('1 Samuel', 11, ARRAY['11:1']::text[], 'pending_review', 'Locuitorii din Iabes i-au cerut lui Nahaș să facă legământ cu ei și i-au spus că îi vor fi supuși.'),
  ('1 Samuel', 11, ARRAY['11:2']::text[], 'pending_review', 'Nahaș a spus că va face legământ dacă îi va lăsa pe locuitorii din Iabes să-și păstreze ochiul drept.'),
  ('1 Samuel', 11, ARRAY['11:2']::text[], 'pending_review', 'Nahaș a cerut să scoată tuturor ochiul drept și a spus că astfel va arunca o ocară asupra întregului Israel.'),
  ('1 Samuel', 11, ARRAY['11:3']::text[], 'pending_review', 'Bătrânii din Iabes au cerut un răgaz de șapte zile pentru a trimite soli prin tot ținutul lui Israel.'),
  ('1 Samuel', 11, ARRAY['11:3']::text[], 'pending_review', 'Bătrânii din Iabes au spus că se vor supune lui Nahaș chiar dacă va veni ajutor din Israel.'),
  ('1 Samuel', 11, ARRAY['11:4']::text[], 'pending_review', 'Solii din Iabes au ajuns la Ghibea, cetatea lui Saul, și au spus cele întâmplate în auzul poporului.'),
  ('1 Samuel', 11, ARRAY['11:4']::text[], 'pending_review', 'După ce a auzit vestea, tot poporul din Ghibea și-a ridicat glasul și a plâns.'),
  ('1 Samuel', 11, ARRAY['11:5']::text[], 'pending_review', 'Saul tocmai se întorcea de la câmp, venind în urma boilor.'),
  ('1 Samuel', 11, ARRAY['11:5']::text[], 'pending_review', 'Saul a întrebat de ce plânge poporul, iar oamenii i-au istorisit ce spuseseră cei din Iabes.'),
  ('1 Samuel', 11, ARRAY['11:6']::text[], 'pending_review', 'După ce a auzit vestea, Saul s-a temut și a fugit din Ghibea.'),
  ('1 Samuel', 11, ARRAY['11:6']::text[], 'pending_review', 'Duhul lui Dumnezeu a venit peste Saul când a auzit aceste lucruri, iar Saul s-a mâniat foarte tare.'),
  ('1 Samuel', 11, ARRAY['11:7']::text[], 'pending_review', 'Saul a luat o pereche de boi, i-a tăiat în bucăți și a trimis bucățile prin soli în tot ținutul lui Israel.'),
  ('1 Samuel', 11, ARRAY['11:7']::text[], 'pending_review', 'Saul a trimis în tot Israelul solia să-l urmeze doar pe Samuel.'),
  ('1 Samuel', 11, ARRAY['11:7']::text[], 'pending_review', 'Saul a spus că oricine nu va merge după el și Samuel își va vedea boii tăiați la fel.'),
  ('1 Samuel', 11, ARRAY['11:7']::text[], 'pending_review', 'Groaza Domnului a apucat poporul, iar oamenii au pornit ca un singur om.'),
  ('1 Samuel', 11, ARRAY['11:8']::text[], 'pending_review', 'Numărătoarea făcută de Saul la Bezec a dat trei sute de mii de oameni din Israel și treizeci de mii de bărbați din Iuda.'),
  ('1 Samuel', 11, ARRAY['11:8']::text[], 'pending_review', 'La Bezec au fost numărați treizeci de mii de oameni din Israel și trei sute de mii din Iuda.'),
  ('1 Samuel', 11, ARRAY['11:9']::text[], 'pending_review', 'Solii au vestit locuitorilor din Iabes că vor avea ajutor a doua zi, când va dogori soarele.'),
  ('1 Samuel', 11, ARRAY['11:9']::text[], 'pending_review', 'Locuitorii din Iabes s-au umplut de bucurie când au primit vestea ajutorului.'),
  ('1 Samuel', 11, ARRAY['11:10']::text[], 'pending_review', 'Locuitorii din Iabes le-au spus amoniților că a doua zi li se vor supune și că amoniții le pot face ce le va plăcea.'),
  ('1 Samuel', 11, ARRAY['11:11']::text[], 'pending_review', 'A doua zi, Saul a împărțit poporul în trei cete.'),
  ('1 Samuel', 11, ARRAY['11:11']::text[], 'pending_review', 'Cetele au pătruns în tabăra amoniților în straja dimineții și i-au bătut până la căldura zilei.'),
  ('1 Samuel', 11, ARRAY['11:11']::text[], 'pending_review', 'După luptă, cei ce scăpaseră dintre amoniți au rămas împreună în aceeași tabără.'),
  ('1 Samuel', 11, ARRAY['11:12']::text[], 'pending_review', 'După izbândă, poporul i-a cerut lui Samuel să-i dea încoace pe oamenii aceia ca să-i omoare.'),
  ('1 Samuel', 11, ARRAY['11:13']::text[], 'pending_review', 'Saul a spus că nimeni nu va fi omorât în ziua aceea, fiindcă Domnul dăduse o izbăvire lui Israel.'),
  ('1 Samuel', 11, ARRAY['11:14']::text[], 'pending_review', 'Samuel i-a chemat pe oameni să meargă la Ghilgal pentru a întări acolo împărăția.'),
  ('1 Samuel', 11, ARRAY['11:15']::text[], 'pending_review', 'La Ghilgal, tot poporul l-a pus pe Saul împărat înaintea Domnului și a adus jertfe de mulțumire.'),
  ('1 Samuel', 11, ARRAY['11:15']::text[], 'pending_review', 'Saul și toți oamenii lui Israel s-au întristat foarte mult la Ghilgal.')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_tf (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Nahaș, Amonitul, a împresurat Iabesul din Galaad.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 11, 1, '1 Samuel', ARRAY['11:1']::text[], 'pending_review', 'Codex'),
  ('Locuitorii din Iabes i-au cerut lui Nahaș să facă legământ cu ei și i-au spus că îi vor fi supuși.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:1']::text[], 'pending_review', 'Codex'),
  ('Nahaș a spus că va face legământ dacă îi va lăsa pe locuitorii din Iabes să-și păstreze ochiul drept.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:2']::text[], 'pending_review', 'Codex'),
  ('Nahaș a cerut să scoată tuturor ochiul drept și a spus că astfel va arunca o ocară asupra întregului Israel.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:2']::text[], 'pending_review', 'Codex'),
  ('Bătrânii din Iabes au cerut un răgaz de șapte zile pentru a trimite soli prin tot ținutul lui Israel.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:3']::text[], 'pending_review', 'Codex'),
  ('Bătrânii din Iabes au spus că se vor supune lui Nahaș chiar dacă va veni ajutor din Israel.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:3']::text[], 'pending_review', 'Codex'),
  ('Solii din Iabes au ajuns la Ghibea, cetatea lui Saul, și au spus cele întâmplate în auzul poporului.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:4']::text[], 'pending_review', 'Codex'),
  ('După ce a auzit vestea, tot poporul din Ghibea și-a ridicat glasul și a plâns.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 11, 1, '1 Samuel', ARRAY['11:4']::text[], 'pending_review', 'Codex'),
  ('Saul tocmai se întorcea de la câmp, venind în urma boilor.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 11, 1, '1 Samuel', ARRAY['11:5']::text[], 'pending_review', 'Codex'),
  ('Saul a întrebat de ce plânge poporul, iar oamenii i-au istorisit ce spuseseră cei din Iabes.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:5']::text[], 'pending_review', 'Codex'),
  ('După ce a auzit vestea, Saul s-a temut și a fugit din Ghibea.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:6']::text[], 'pending_review', 'Codex'),
  ('Duhul lui Dumnezeu a venit peste Saul când a auzit aceste lucruri, iar Saul s-a mâniat foarte tare.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:6']::text[], 'pending_review', 'Codex'),
  ('Saul a luat o pereche de boi, i-a tăiat în bucăți și a trimis bucățile prin soli în tot ținutul lui Israel.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 11, 1, '1 Samuel', ARRAY['11:7']::text[], 'pending_review', 'Codex'),
  ('Saul a trimis în tot Israelul solia să-l urmeze doar pe Samuel.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 11, 1, '1 Samuel', ARRAY['11:7']::text[], 'pending_review', 'Codex'),
  ('Saul a spus că oricine nu va merge după el și Samuel își va vedea boii tăiați la fel.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:7']::text[], 'pending_review', 'Codex'),
  ('Groaza Domnului a apucat poporul, iar oamenii au pornit ca un singur om.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:7']::text[], 'pending_review', 'Codex'),
  ('Numărătoarea făcută de Saul la Bezec a dat trei sute de mii de oameni din Israel și treizeci de mii de bărbați din Iuda.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 11, 1, '1 Samuel', ARRAY['11:8']::text[], 'pending_review', 'Codex'),
  ('La Bezec au fost numărați treizeci de mii de oameni din Israel și trei sute de mii din Iuda.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:8']::text[], 'pending_review', 'Codex'),
  ('Solii au vestit locuitorilor din Iabes că vor avea ajutor a doua zi, când va dogori soarele.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:9']::text[], 'pending_review', 'Codex'),
  ('Locuitorii din Iabes s-au umplut de bucurie când au primit vestea ajutorului.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 11, 1, '1 Samuel', ARRAY['11:9']::text[], 'pending_review', 'Codex'),
  ('Locuitorii din Iabes le-au spus amoniților că a doua zi li se vor supune și că amoniții le pot face ce le va plăcea.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:10']::text[], 'pending_review', 'Codex'),
  ('A doua zi, Saul a împărțit poporul în trei cete.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 11, 1, '1 Samuel', ARRAY['11:11']::text[], 'pending_review', 'Codex'),
  ('Cetele au pătruns în tabăra amoniților în straja dimineții și i-au bătut până la căldura zilei.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:11']::text[], 'pending_review', 'Codex'),
  ('După luptă, cei ce scăpaseră dintre amoniți au rămas împreună în aceeași tabără.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:11']::text[], 'pending_review', 'Codex'),
  ('După izbândă, poporul i-a cerut lui Samuel să-i dea încoace pe oamenii aceia ca să-i omoare.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:12']::text[], 'pending_review', 'Codex'),
  ('Saul a spus că nimeni nu va fi omorât în ziua aceea, fiindcă Domnul dăduse o izbăvire lui Israel.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 11, 1, '1 Samuel', ARRAY['11:13']::text[], 'pending_review', 'Codex'),
  ('Samuel i-a chemat pe oameni să meargă la Ghilgal pentru a întări acolo împărăția.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 11, 1, '1 Samuel', ARRAY['11:14']::text[], 'pending_review', 'Codex'),
  ('La Ghilgal, tot poporul l-a pus pe Saul împărat înaintea Domnului și a adus jertfe de mulțumire.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:15']::text[], 'pending_review', 'Codex'),
  ('Saul și toți oamenii lui Israel s-au întristat foarte mult la Ghilgal.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 11, 1, '1 Samuel', ARRAY['11:15']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 11, ARRAY['11:1']::text[], 'pending_review', 'Cine a împresurat Iabesul din Galaad?'),
  ('1 Samuel', 11, ARRAY['11:1']::text[], 'pending_review', 'Unde se afla cetatea pe care a împresurat-o Nahaș?'),
  ('1 Samuel', 11, ARRAY['11:1']::text[], 'pending_review', 'Ce le-au cerut locuitorii din Iabes lui Nahaș când au fost împresurați?'),
  ('1 Samuel', 11, ARRAY['11:2']::text[], 'pending_review', 'Ce condiție a pus Nahaș pentru a face legământ cu locuitorii din Iabes?'),
  ('1 Samuel', 11, ARRAY['11:2']::text[], 'pending_review', 'Asupra cui a spus Nahaș că va arunca ocară prin condiția pusă locuitorilor din Iabes?'),
  ('1 Samuel', 11, ARRAY['11:3']::text[], 'pending_review', 'Câte zile de răgaz au cerut bătrânii din Iabes?'),
  ('1 Samuel', 11, ARRAY['11:3']::text[], 'pending_review', 'Ce voiau bătrânii din Iabes să facă în răgazul cerut de la Nahaș?'),
  ('1 Samuel', 11, ARRAY['11:3']::text[], 'pending_review', 'Ce au spus bătrânii că vor face dacă nu va fi nimeni să-i ajute?'),
  ('1 Samuel', 11, ARRAY['11:4']::text[], 'pending_review', 'În ce cetate au ajuns solii trimiși de locuitorii din Iabes?'),
  ('1 Samuel', 11, ARRAY['11:4']::text[], 'pending_review', 'Cum a reacționat poporul din Ghibea când a auzit vestea solilor?'),
  ('1 Samuel', 11, ARRAY['11:5']::text[], 'pending_review', 'De unde se întorcea Saul când a auzit că poporul plânge?'),
  ('1 Samuel', 11, ARRAY['11:5']::text[], 'pending_review', 'Ce i-a întrebat Saul pe oamenii care plângeau în Ghibea?'),
  ('1 Samuel', 11, ARRAY['11:5']::text[], 'pending_review', 'Ce i-au istorisit oamenii lui Saul când acesta a întrebat de ce plânge poporul?'),
  ('1 Samuel', 11, ARRAY['11:6']::text[], 'pending_review', 'Ce s-a întâmplat cu Saul după ce a auzit vestea din Iabes?'),
  ('1 Samuel', 11, ARRAY['11:7']::text[], 'pending_review', 'Ce a luat Saul și a tăiat în bucăți pentru a trimite soli prin Israel?'),
  ('1 Samuel', 11, ARRAY['11:7']::text[], 'pending_review', 'Ce urma să li se întâmple boilor celor care nu mergeau după Saul și Samuel?'),
  ('1 Samuel', 11, ARRAY['11:7']::text[], 'pending_review', 'Cum a pornit poporul după ce groaza Domnului l-a apucat?'),
  ('1 Samuel', 11, ARRAY['11:8']::text[], 'pending_review', 'Unde a făcut Saul numărătoarea poporului?'),
  ('1 Samuel', 11, ARRAY['11:8']::text[], 'pending_review', 'Câți oameni din Israel au fost numărați la Bezec?'),
  ('1 Samuel', 11, ARRAY['11:8']::text[], 'pending_review', 'Câți bărbați din Iuda au fost numărați la Bezec?'),
  ('1 Samuel', 11, ARRAY['11:9']::text[], 'pending_review', 'Când urma să primească Iabesul ajutorul anunțat de soli?'),
  ('1 Samuel', 11, ARRAY['11:9']::text[], 'pending_review', 'Cum au reacționat locuitorii din Iabes după ce solii le-au dus vestea?'),
  ('1 Samuel', 11, ARRAY['11:10']::text[], 'pending_review', 'Ce le-au spus locuitorii din Iabes amoniților despre ziua următoare?'),
  ('1 Samuel', 11, ARRAY['11:11']::text[], 'pending_review', 'În câte cete a împărțit Saul poporul înainte de atac?'),
  ('1 Samuel', 11, ARRAY['11:11']::text[], 'pending_review', 'Când au pătruns cetele în tabăra amoniților?'),
  ('1 Samuel', 11, ARRAY['11:11']::text[], 'pending_review', 'Până când i-au bătut israeliții pe amoniți?'),
  ('1 Samuel', 11, ARRAY['11:11']::text[], 'pending_review', 'Ce s-a întâmplat cu amoniții care au scăpat?'),
  ('1 Samuel', 11, ARRAY['11:12']::text[], 'pending_review', 'Ce a cerut poporul lui Samuel după izbânda asupra amoniților?'),
  ('1 Samuel', 11, ARRAY['11:13']::text[], 'pending_review', 'Ce a spus Saul despre oamenii pe care poporul voia să-i omoare și de ce?')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_abc_one (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Cine a împresurat Iabesul din Galaad?', '[{"text":"Nahaș, Amonitul","correct":true},{"text":"Saul, fiul lui Chis","correct":false},{"text":"Samuel din Rama","correct":false}]'::jsonb, 11, 1, '1 Samuel', ARRAY['11:1']::text[], 'pending_review', 'Codex'),
  ('Unde se afla cetatea pe care a împresurat-o Nahaș?', '[{"text":"În ținutul lui Iuda","correct":false},{"text":"În țara filistenilor","correct":false},{"text":"În Galaad","correct":true}]'::jsonb, 11, 1, '1 Samuel', ARRAY['11:1']::text[], 'pending_review', 'Codex'),
  ('Ce le-au cerut locuitorii din Iabes lui Nahaș când au fost împresurați?', '[{"text":"Să-i ducă la Ghibea","correct":false},{"text":"Să facă legământ cu ei, iar ei să-i fie supuși","correct":true},{"text":"Să plece și să le lase cetatea","correct":false}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:1']::text[], 'pending_review', 'Codex'),
  ('Ce condiție a pus Nahaș pentru a face legământ cu locuitorii din Iabes?', '[{"text":"Să li se scoată tuturor ochiul drept","correct":true},{"text":"Să-i lase să plece în Ghilgal","correct":false},{"text":"Să trimită o pereche de boi","correct":false}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:2']::text[], 'pending_review', 'Codex'),
  ('Asupra cui a spus Nahaș că va arunca ocară prin condiția pusă locuitorilor din Iabes?', '[{"text":"Numai asupra bătrânilor din Iabes","correct":false},{"text":"Asupra cetății Ghibea","correct":false},{"text":"Asupra întregului Israel","correct":true}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:2']::text[], 'pending_review', 'Codex'),
  ('Câte zile de răgaz au cerut bătrânii din Iabes?', '[{"text":"Treizeci de zile","correct":false},{"text":"Șapte zile","correct":true},{"text":"Trei zile","correct":false}]'::jsonb, 11, 1, '1 Samuel', ARRAY['11:3']::text[], 'pending_review', 'Codex'),
  ('Ce voiau bătrânii din Iabes să facă în răgazul cerut de la Nahaș?', '[{"text":"Să trimită soli în tot ținutul lui Israel","correct":true},{"text":"Să se mute la Bezec","correct":false},{"text":"Să adune jertfe la Ghilgal","correct":false}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:3']::text[], 'pending_review', 'Codex'),
  ('Ce au spus bătrânii că vor face dacă nu va fi nimeni să-i ajute?', '[{"text":"Îl vor pune pe Saul împărat la Ghibea","correct":false},{"text":"Vor ataca tabăra amoniților","correct":false},{"text":"Se vor supune lui Nahaș","correct":true}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:3']::text[], 'pending_review', 'Codex'),
  ('În ce cetate au ajuns solii trimiși de locuitorii din Iabes?', '[{"text":"La Bezec, cetatea lui Nahaș","correct":false},{"text":"La Ghibea, cetatea lui Saul","correct":true},{"text":"La Ghilgal, cetatea lui Samuel","correct":false}]'::jsonb, 11, 1, '1 Samuel', ARRAY['11:4']::text[], 'pending_review', 'Codex'),
  ('Cum a reacționat poporul din Ghibea când a auzit vestea solilor?', '[{"text":"Și-a ridicat glasul și a plâns","correct":true},{"text":"A plecat imediat la Ghilgal","correct":false},{"text":"A cerut să fie omorât Saul","correct":false}]'::jsonb, 11, 1, '1 Samuel', ARRAY['11:4']::text[], 'pending_review', 'Codex'),
  ('De unde se întorcea Saul când a auzit că poporul plânge?', '[{"text":"Din tabăra amoniților","correct":false},{"text":"De la Ghilgal, după jertfe","correct":false},{"text":"De la câmp, în urma boilor","correct":true}]'::jsonb, 11, 1, '1 Samuel', ARRAY['11:5']::text[], 'pending_review', 'Codex'),
  ('Ce i-a întrebat Saul pe oamenii care plângeau în Ghibea?', '[{"text":"Unde sunt solii din Iabes?","correct":false},{"text":"Ce are poporul de plânge?","correct":true},{"text":"Cine a spus că el nu va domni?","correct":false}]'::jsonb, 11, 1, '1 Samuel', ARRAY['11:5']::text[], 'pending_review', 'Codex'),
  ('Ce i-au istorisit oamenii lui Saul când acesta a întrebat de ce plânge poporul?', '[{"text":"Ce spuseseră cei din Iabes","correct":true},{"text":"Ce hotărâse Samuel la Ghilgal","correct":false},{"text":"Ce răspuns dăduse Nahaș solilor din Israel","correct":false}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:5']::text[], 'pending_review', 'Codex'),
  ('Ce s-a întâmplat cu Saul după ce a auzit vestea din Iabes?', '[{"text":"A fugit din cetate și s-a ascuns","correct":false},{"text":"A trimis solii să ceară răgaz","correct":false},{"text":"Duhul lui Dumnezeu a venit peste el și s-a mâniat foarte tare","correct":true}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:6']::text[], 'pending_review', 'Codex'),
  ('Ce a luat Saul și a tăiat în bucăți pentru a trimite soli prin Israel?', '[{"text":"Două pâini","correct":false},{"text":"O pereche de boi","correct":true},{"text":"Trei cete de oameni","correct":false}]'::jsonb, 11, 1, '1 Samuel', ARRAY['11:7']::text[], 'pending_review', 'Codex'),
  ('Ce urma să li se întâmple boilor celor care nu mergeau după Saul și Samuel?', '[{"text":"Să fie tăiați la fel","correct":true},{"text":"Să fie duși la Ghilgal","correct":false},{"text":"Să fie dați bătrânilor din Iabes","correct":false}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:7']::text[], 'pending_review', 'Codex'),
  ('Cum a pornit poporul după ce groaza Domnului l-a apucat?', '[{"text":"În grupuri care se întorceau la case","correct":false},{"text":"Numai după ce a ajuns la Ghilgal","correct":false},{"text":"Ca un singur om","correct":true}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:7']::text[], 'pending_review', 'Codex'),
  ('Unde a făcut Saul numărătoarea poporului?', '[{"text":"La Iabes","correct":false},{"text":"La Bezec","correct":true},{"text":"La Ghibea","correct":false}]'::jsonb, 11, 1, '1 Samuel', ARRAY['11:8']::text[], 'pending_review', 'Codex'),
  ('Câți oameni din Israel au fost numărați la Bezec?', '[{"text":"Trei sute de mii","correct":true},{"text":"Treizeci de mii","correct":false},{"text":"Trei sute de oameni","correct":false}]'::jsonb, 11, 1, '1 Samuel', ARRAY['11:8']::text[], 'pending_review', 'Codex'),
  ('Câți bărbați din Iuda au fost numărați la Bezec?', '[{"text":"Trei sute de mii","correct":false},{"text":"Șapte mii","correct":false},{"text":"Treizeci de mii","correct":true}]'::jsonb, 11, 1, '1 Samuel', ARRAY['11:8']::text[], 'pending_review', 'Codex'),
  ('Când urma să primească Iabesul ajutorul anunțat de soli?', '[{"text":"În aceeași zi, în straja dimineții","correct":false},{"text":"A doua zi, când dogorea soarele","correct":true},{"text":"După șapte zile, la apus","correct":false}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:9']::text[], 'pending_review', 'Codex'),
  ('Cum au reacționat locuitorii din Iabes după ce solii le-au dus vestea?', '[{"text":"S-au umplut de bucurie","correct":true},{"text":"Au plâns și mai mult","correct":false},{"text":"Au pornit singuri spre Bezec","correct":false}]'::jsonb, 11, 1, '1 Samuel', ARRAY['11:9']::text[], 'pending_review', 'Codex'),
  ('Ce le-au spus locuitorii din Iabes amoniților despre ziua următoare?', '[{"text":"Că vor veni cu oastea la Ghibea","correct":false},{"text":"Că Nahaș trebuie să meargă la Samuel","correct":false},{"text":"Că li se vor supune și amoniții le vor putea face ce le place","correct":true}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:10']::text[], 'pending_review', 'Codex'),
  ('În câte cete a împărțit Saul poporul înainte de atac?', '[{"text":"Șapte","correct":false},{"text":"Trei","correct":true},{"text":"Două","correct":false}]'::jsonb, 11, 1, '1 Samuel', ARRAY['11:11']::text[], 'pending_review', 'Codex'),
  ('Când au pătruns cetele în tabăra amoniților?', '[{"text":"În straja dimineții","correct":true},{"text":"La apusul soarelui","correct":false},{"text":"După căldura zilei","correct":false}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:11']::text[], 'pending_review', 'Codex'),
  ('Până când i-au bătut israeliții pe amoniți?', '[{"text":"Până la miezul nopții","correct":false},{"text":"Până la apusul soarelui din ziua următoare","correct":false},{"text":"Până la căldura zilei","correct":true}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:11']::text[], 'pending_review', 'Codex'),
  ('Ce s-a întâmplat cu amoniții care au scăpat?', '[{"text":"Au fost numărați la Bezec","correct":false},{"text":"Au fost risipiți și n-au mai rămas doi laolaltă","correct":true},{"text":"Au rămas împreună în tabără","correct":false}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:11']::text[], 'pending_review', 'Codex'),
  ('Ce a cerut poporul lui Samuel după izbânda asupra amoniților?', '[{"text":"Să le dea încoace pe oamenii despre care întreba: «Cine zicea: Saul să domnească peste noi?», ca să-i omoare.","correct":true},{"text":"Să-l îndepărteze pe Saul și să-l pună pe Nahaș împărat","correct":false},{"text":"Să-i trimită pe solii din Iabes la Bezec","correct":false}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:12']::text[], 'pending_review', 'Codex'),
  ('Ce a spus Saul despre oamenii pe care poporul voia să-i omoare și de ce?', '[{"text":"Toți trebuie omorâți înainte de apus, pentru că Saul a poruncit","correct":false},{"text":"Vor fi trimiși la Nahaș, pentru că au ajutat amoniții","correct":false},{"text":"Nimeni nu va fi omorât în ziua aceea, pentru că Domnul a dat o izbăvire lui Israel","correct":true}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:13']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 11, ARRAY['11:1']::text[], 'pending_review', 'Ce afirmații sunt consemnate despre începutul crizei de la Iabes?'),
  ('1 Samuel', 11, ARRAY['11:2']::text[], 'pending_review', 'Ce cuprinde condiția pe care Nahaș a pus-o pentru legământ?'),
  ('1 Samuel', 11, ARRAY['11:3']::text[], 'pending_review', 'Ce au cerut bătrânii din Iabes în răgazul de șapte zile?'),
  ('1 Samuel', 11, ARRAY['11:4', '11:5']::text[], 'pending_review', 'Ce este relatat despre sosirea solilor și reacția din Ghibea?'),
  ('1 Samuel', 11, ARRAY['11:5']::text[], 'pending_review', 'Ce este spus despre Saul înainte ca el să afle motivul plânsului?'),
  ('1 Samuel', 11, ARRAY['11:5']::text[], 'pending_review', 'Ce au făcut Saul și poporul în dialogul despre plânsul din Ghibea?'),
  ('1 Samuel', 11, ARRAY['11:6']::text[], 'pending_review', 'Ce s-a întâmplat cu Saul după ce a auzit cuvintele celor din Iabes?'),
  ('1 Samuel', 11, ARRAY['11:7']::text[], 'pending_review', 'Cum a răspândit Saul chemarea prin ținutul lui Israel?'),
  ('1 Samuel', 11, ARRAY['11:7']::text[], 'pending_review', 'Ce cuprindea mesajul trimis în Israel împreună cu bucățile de boi?'),
  ('1 Samuel', 11, ARRAY['11:7']::text[], 'pending_review', 'Ce două lucruri sunt consemnate despre reacția poporului la chemarea lui Saul?'),
  ('1 Samuel', 11, ARRAY['11:8']::text[], 'pending_review', 'Ce cifre sunt date pentru numărătoarea făcută la Bezec?'),
  ('1 Samuel', 11, ARRAY['11:9']::text[], 'pending_review', 'Ce mesaj au transmis solii locuitorilor din Iabes?'),
  ('1 Samuel', 11, ARRAY['11:9', '11:10']::text[], 'pending_review', 'Ce au făcut locuitorii din Iabes după ce au primit vestea ajutorului?'),
  ('1 Samuel', 11, ARRAY['11:10']::text[], 'pending_review', 'Ce afirmații redau cuvintele locuitorilor din Iabes adresate amoniților?'),
  ('1 Samuel', 11, ARRAY['11:11']::text[], 'pending_review', 'Ce este consemnat despre pregătirea și începutul atacului lui Saul?'),
  ('1 Samuel', 11, ARRAY['11:11']::text[], 'pending_review', 'Ce rezultat al luptei este relatat pentru ziua atacului?'),
  ('1 Samuel', 11, ARRAY['11:11', '11:12']::text[], 'pending_review', 'Ce s-a întâmplat după înfrângerea amoniților?'),
  ('1 Samuel', 11, ARRAY['11:12']::text[], 'pending_review', 'Ce cuprinde cererea pe care poporul i-a adresat-o lui Samuel?'),
  ('1 Samuel', 11, ARRAY['11:13']::text[], 'pending_review', 'Ce a spus Saul când poporul a cerut: «Dați încoace pe oamenii aceia, ca să-i omorâm»?'),
  ('1 Samuel', 11, ARRAY['11:14']::text[], 'pending_review', 'Ce le-a propus Samuel israeliților după cuvintele lui Saul?'),
  ('1 Samuel', 11, ARRAY['11:15']::text[], 'pending_review', 'Ce s-a întâmplat la Ghilgal înaintea Domnului?'),
  ('1 Samuel', 11, ARRAY['11:15']::text[], 'pending_review', 'Cum este descrisă încheierea capitolului la Ghilgal?'),
  ('1 Samuel', 11, ARRAY['11:7', '11:8', '11:9', '11:11']::text[], 'pending_review', 'Ce fapte sunt relatate despre mobilizarea și atacul armatei lui Saul?'),
  ('1 Samuel', 11, ARRAY['11:12', '11:13', '11:14', '11:15']::text[], 'pending_review', 'Ce hotărâri și acțiuni sunt consemnate după izbăvirea lui Israel?')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_abc_multi (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Ce afirmații sunt consemnate despre începutul crizei de la Iabes?', '[{"text":"Nahaș era Amonit și a împresurat Iabesul din Galaad.","correct":true},{"text":"Locuitorii din Iabes i-au cerut să facă legământ cu ei și au spus că îi vor fi supuși.","correct":true},{"text":"Nahaș a venit din țara filistenilor și a împresurat Ghibea.","correct":false}]'::jsonb, 11, 1, '1 Samuel', ARRAY['11:1']::text[], 'pending_review', 'Codex'),
  ('Ce cuprinde condiția pe care Nahaș a pus-o pentru legământ?', '[{"text":"Să arunce o ocară asupra întregului Israel.","correct":true},{"text":"Să le lase ochiul drept și să-i ducă la Ghilgal.","correct":false},{"text":"Să li se scoată tuturor locuitorilor ochiul drept.","correct":true}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:2']::text[], 'pending_review', 'Codex'),
  ('Ce au cerut bătrânii din Iabes în răgazul de șapte zile?', '[{"text":"Să poată pleca la Ghilgal și să-l încoroneze pe Saul.","correct":false},{"text":"Să poată trimite soli în tot ținutul lui Israel.","correct":true},{"text":"Dacă nimeni nu îi ajută, se vor supune lui Nahaș.","correct":true}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:3']::text[], 'pending_review', 'Codex'),
  ('Ce este relatat despre sosirea solilor și reacția din Ghibea?', '[{"text":"Solii au ajuns în cetatea lui Saul.","correct":true},{"text":"Ei au spus lucrurile în auzul poporului, iar poporul a ridicat glasul și a plâns.","correct":true},{"text":"Poporul i-a trimis pe soli înapoi fără să-i asculte.","correct":false}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:4', '11:5']::text[], 'pending_review', 'Codex'),
  ('Ce este spus despre Saul înainte ca el să afle motivul plânsului?', '[{"text":"Mergea în urma boilor.","correct":true},{"text":"Se întorcea de la lupta cu amoniții.","correct":false},{"text":"Se întorcea de la câmp.","correct":true}]'::jsonb, 11, 1, '1 Samuel', ARRAY['11:5']::text[], 'pending_review', 'Codex'),
  ('Ce au făcut Saul și poporul în dialogul despre plânsul din Ghibea?', '[{"text":"Saul i-a întrebat cine a fost ales la sorți.","correct":false},{"text":"Saul a întrebat ce are poporul de plânge.","correct":true},{"text":"Oamenii i-au istorisit ce spuseseră cei din Iabes.","correct":true}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:5']::text[], 'pending_review', 'Codex'),
  ('Ce s-a întâmplat cu Saul după ce a auzit cuvintele celor din Iabes?', '[{"text":"Duhul lui Dumnezeu a venit peste el.","correct":true},{"text":"Saul s-a mâniat foarte tare.","correct":true},{"text":"Saul s-a ascuns între vase.","correct":false}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:6']::text[], 'pending_review', 'Codex'),
  ('Cum a răspândit Saul chemarea prin ținutul lui Israel?', '[{"text":"A trimis bucățile prin soli în tot ținutul lui Israel.","correct":true},{"text":"A trimis câte o pâine fiecărui bătrân din Israel.","correct":false},{"text":"A tăiat în bucăți o pereche de boi.","correct":true}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:7']::text[], 'pending_review', 'Codex'),
  ('Ce cuprindea mesajul trimis în Israel împreună cu bucățile de boi?', '[{"text":"Să se supună lui Nahaș după șapte zile.","correct":false},{"text":"Să meargă după Saul și Samuel.","correct":true},{"text":"Cine nu merge după Saul și Samuel își va vedea boii tăiați la fel.","correct":true}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:7']::text[], 'pending_review', 'Codex'),
  ('Ce două lucruri sunt consemnate despre reacția poporului la chemarea lui Saul?', '[{"text":"Poporul a pornit ca un singur om.","correct":true},{"text":"Groaza Domnului a apucat poporul.","correct":true},{"text":"Poporul s-a întors fiecare la casa lui.","correct":false}]'::jsonb, 11, 1, '1 Samuel', ARRAY['11:7']::text[], 'pending_review', 'Codex'),
  ('Ce cifre sunt date pentru numărătoarea făcută la Bezec?', '[{"text":"Bărbații lui Iuda erau treizeci de mii.","correct":true},{"text":"Bărbații lui Iuda erau trei sute de mii.","correct":false},{"text":"Copiii lui Israel erau trei sute de mii.","correct":true}]'::jsonb, 11, 1, '1 Samuel', ARRAY['11:8']::text[], 'pending_review', 'Codex'),
  ('Ce mesaj au transmis solii locuitorilor din Iabes?', '[{"text":"Ajutorul va veni după răgazul unei luni.","correct":false},{"text":"A doua zi vor avea ajutor.","correct":true},{"text":"Ajutorul va veni când va dogori soarele.","correct":true}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:9']::text[], 'pending_review', 'Codex'),
  ('Ce au făcut locuitorii din Iabes după ce au primit vestea ajutorului?', '[{"text":"S-au umplut de bucurie.","correct":true},{"text":"Le-au spus amoniților că a doua zi li se vor supune.","correct":true},{"text":"Au fugit din cetate înainte de sosirea solilor.","correct":false}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:9', '11:10']::text[], 'pending_review', 'Codex'),
  ('Ce afirmații redau cuvintele locuitorilor din Iabes adresate amoniților?', '[{"text":"Au spus că amoniții le vor putea face ce le va plăcea.","correct":true},{"text":"Au cerut să le fie cruțat ochiul drept.","correct":false},{"text":"Au spus că a doua zi li se vor supune.","correct":true}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:10']::text[], 'pending_review', 'Codex'),
  ('Ce este consemnat despre pregătirea și începutul atacului lui Saul?', '[{"text":"Saul a împărțit poporul în șapte cete care au intrat la apus.","correct":false},{"text":"Saul a împărțit poporul în trei cete.","correct":true},{"text":"Cetele au pătruns în tabăra amoniților în straja dimineții.","correct":true}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:11']::text[], 'pending_review', 'Codex'),
  ('Ce rezultat al luptei este relatat pentru ziua atacului?', '[{"text":"Amoniții au fost bătuți până la căldura zilei.","correct":true},{"text":"Cei care au scăpat au fost risipiți.","correct":true},{"text":"Amoniții au fost lăsați să rămână împreună în tabără.","correct":false}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:11']::text[], 'pending_review', 'Codex'),
  ('Ce s-a întâmplat după înfrângerea amoniților?', '[{"text":"Poporul i-a cerut lui Samuel să-i dea pe oamenii despre care întreba: «Cine zicea: Saul să domnească peste noi?», ca să-i omoare.","correct":true},{"text":"Poporul a cerut să-l omoare pe Samuel.","correct":false},{"text":"Nu au mai rămas doi laolaltă dintre cei care scăpaseră.","correct":true}]'::jsonb, 11, 3, '1 Samuel', ARRAY['11:11', '11:12']::text[], 'pending_review', 'Codex'),
  ('Ce cuprinde cererea pe care poporul i-a adresat-o lui Samuel?', '[{"text":"A cerut ca Saul să fie trimis înapoi la câmp.","correct":false},{"text":"A întrebat cine spusese «Saul să domnească peste noi?»","correct":true},{"text":"A cerut să fie aduși oamenii aceia pentru a fi omorâți.","correct":true}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:12']::text[], 'pending_review', 'Codex'),
  ('Ce a spus Saul când poporul a cerut: «Dați încoace pe oamenii aceia, ca să-i omorâm»?', '[{"text":"Nimeni nu va fi omorât în ziua aceea.","correct":true},{"text":"Domnul a dat în ziua aceea o izbăvire lui Israel.","correct":true},{"text":"Oamenii aceia trebuie omorâți înainte de a merge la Ghilgal.","correct":false}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:13']::text[], 'pending_review', 'Codex'),
  ('Ce le-a propus Samuel israeliților după cuvintele lui Saul?', '[{"text":"Să întărească acolo împărăția.","correct":true},{"text":"Să se întoarcă la Bezec pentru o nouă numărătoare.","correct":false},{"text":"Să meargă la Ghilgal.","correct":true}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:14']::text[], 'pending_review', 'Codex'),
  ('Ce s-a întâmplat la Ghilgal înaintea Domnului?', '[{"text":"Au cerut lui Nahaș să încheie un legământ.","correct":false},{"text":"Tot poporul a mers la Ghilgal și l-a pus pe Saul împărat.","correct":true},{"text":"Au adus jertfe de mulțumire înaintea Domnului.","correct":true}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:15']::text[], 'pending_review', 'Codex'),
  ('Cum este descrisă încheierea capitolului la Ghilgal?', '[{"text":"Saul și toți oamenii lui Israel s-au veselit foarte mult.","correct":true},{"text":"Jertfele au fost aduse înaintea Domnului.","correct":true},{"text":"Poporul s-a întors acasă plângând.","correct":false}]'::jsonb, 11, 1, '1 Samuel', ARRAY['11:15']::text[], 'pending_review', 'Codex'),
  ('Ce fapte sunt relatate despre mobilizarea și atacul armatei lui Saul?', '[{"text":"După numărătoarea de la Bezec, cetele au atacat tabăra amoniților în straja dimineții.","correct":true},{"text":"Saul a atacat fără să numere poporul, în miezul nopții.","correct":false},{"text":"Saul a trimis în Israel bucăți dintr-o pereche de boi prin soli.","correct":true}]'::jsonb, 11, 3, '1 Samuel', ARRAY['11:7', '11:8', '11:9', '11:11']::text[], 'pending_review', 'Codex'),
  ('Ce hotărâri și acțiuni sunt consemnate după izbăvirea lui Israel?', '[{"text":"Poporul a ales să se întoarcă la Iabes și să-l lase pe Saul în Ghibea.","correct":false},{"text":"Saul a spus că nimeni nu va fi omorât în ziua aceea.","correct":true},{"text":"Samuel a chemat poporul să meargă la Ghilgal pentru a întări împărăția.","correct":true}]'::jsonb, 11, 3, '1 Samuel', ARRAY['11:12', '11:13', '11:14', '11:15']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 11, ARRAY['11:1', '11:2', '11:3']::text[], 'pending_review', '[{"left":"Cine a împresurat Iabesul","right":"Nahaș, Amonitul"},{"left":"Unde se afla Iabesul","right":"În Galaad"},{"left":"Ce i-au cerut locuitorii din Iabes lui Nahaș","right":"Să facă legământ"},{"left":"Ce au spus locuitorii că vor fi","right":"Supuși lui Nahaș"},{"left":"Câte zile au cerut bătrânii pentru a trimite soli","right":"Șapte zile"}]'::jsonb),
  ('1 Samuel', 11, ARRAY['11:1', '11:2']::text[], 'pending_review', '[{"left":"Cine a pus condiția legământului","right":"Nahaș"},{"left":"Ce trebuia scos tuturor locuitorilor","right":"Ochiul drept"},{"left":"Asupra cui urma să fie aruncată ocara","right":"Asupra întregului Israel"},{"left":"Ce au cerut locuitorii din Iabes","right":"Un legământ"},{"left":"Ce au spus că vor face față de Nahaș","right":"Îi vor fi supuși"}]'::jsonb),
  ('1 Samuel', 11, ARRAY['11:3', '11:4']::text[], 'pending_review', '[{"left":"Cine a cerut răgazul de șapte zile","right":"Bătrânii din Iabes"},{"left":"Unde urmau să trimită soli?","right":"În tot ținutul lui Israel"},{"left":"Ce aveau să facă dacă nu primeau ajutor","right":"Să se supună lui Nahaș"},{"left":"Unde au ajuns solii","right":"La Ghibea"},{"left":"A cui cetate era Ghibea","right":"A lui Saul"}]'::jsonb),
  ('1 Samuel', 11, ARRAY['11:4', '11:5']::text[], 'pending_review', '[{"left":"Unde au ajuns solii din Iabes","right":"La Ghibea"},{"left":"În auzul cui au spus ei lucrurile","right":"Al poporului"},{"left":"Ce a făcut poporul după ce a auzit","right":"A ridicat glasul și a plâns"},{"left":"De unde se întorcea Saul","right":"De la câmp"},{"left":"În urma cui venea Saul","right":"Boii"}]'::jsonb),
  ('1 Samuel', 11, ARRAY['11:5', '11:6']::text[], 'pending_review', '[{"left":"Ce a întrebat Saul despre popor","right":"De ce plângea"},{"left":"Ce i-au istorisit oamenii","right":"Ce spuseseră cei din Iabes"},{"left":"Cine a venit peste Saul după ce a auzit","right":"Duhul lui Dumnezeu"},{"left":"Cum s-a mâniat Saul","right":"Foarte tare"},{"left":"Ce eveniment a precedat mânia lui Saul","right":"A auzit vestea din Iabes"}]'::jsonb),
  ('1 Samuel', 11, ARRAY['11:6', '11:7']::text[], 'pending_review', '[{"left":"Peste cine a venit Duhul lui Dumnezeu","right":"Peste Saul"},{"left":"Ce a luat Saul pentru a trimite un semn prin Israel","right":"O pereche de boi"},{"left":"Ce a făcut Saul cu boii","right":"I-a tăiat în bucăți"},{"left":"Prin cine au fost trimise bucățile","right":"Prin soli"},{"left":"Unde au fost trimise bucățile","right":"În tot ținutul lui Israel"}]'::jsonb),
  ('1 Samuel', 11, ARRAY['11:7']::text[], 'pending_review', '[{"left":"Cui trebuia să-i urmeze poporul","right":"Lui Saul și lui Samuel"},{"left":"Ce pățeau boii celui care nu mergea","right":"Erau tăiați la fel"},{"left":"Ce a apucat poporul","right":"Groaza Domnului"},{"left":"Cum a pornit poporul","right":"Ca un singur om"},{"left":"Ce a făcut Saul cu perechea de boi","right":"A tăiat-o în bucăți"}]'::jsonb),
  ('1 Samuel', 11, ARRAY['11:8', '11:9']::text[], 'pending_review', '[{"left":"Unde a numărat Saul poporul","right":"La Bezec"},{"left":"Numărul copiilor lui Israel","right":"Trei sute de mii"},{"left":"Numărul bărbaților lui Iuda","right":"Treizeci de mii"},{"left":"Când urma Iabesul să aibă ajutor","right":"A doua zi"},{"left":"În ce moment al zilei urma ajutorul","right":"Când dogorea soarele"}]'::jsonb),
  ('1 Samuel', 11, ARRAY['11:9', '11:10']::text[], 'pending_review', '[{"left":"Ce le-au vestit solii locuitorilor din Iabes","right":"Vor avea ajutor"},{"left":"Când va veni ajutorul","right":"A doua zi, când va dogori soarele"},{"left":"Cum au primit locuitorii vestea","right":"S-au umplut de bucurie"},{"left":"Ce le-au spus amoniților despre ziua următoare","right":"Se vor supune"},{"left":"Ce au spus că le pot face amoniții","right":"Ce le va plăcea"}]'::jsonb),
  ('1 Samuel', 11, ARRAY['11:10', '11:11']::text[], 'pending_review', '[{"left":"Cine a împărțit poporul în cete","right":"Saul"},{"left":"În câte cete a fost împărțit poporul","right":"Trei"},{"left":"În ce tabără au pătruns cetele","right":"În tabăra amoniților"},{"left":"Când au pătruns în tabără","right":"În straja dimineții"},{"left":"Până când i-au bătut pe amoniți","right":"Până la căldura zilei"}]'::jsonb),
  ('1 Samuel', 11, ARRAY['11:11']::text[], 'pending_review', '[{"left":"Ce s-a întâmplat cu cei care au scăpat","right":"Au fost risipiți"},{"left":"Ce spune textul despre cei rămași doi laolaltă","right":"N-au mai rămas doi laolaltă"},{"left":"Cine a împărțit poporul","right":"Saul"},{"left":"Numărul cetelor","right":"Trei"},{"left":"Ținta atacului","right":"Tabăra amoniților"}]'::jsonb),
  ('1 Samuel', 11, ARRAY['11:11', '11:12']::text[], 'pending_review', '[{"left":"Până când i-au bătut pe amoniți","right":"Până la căldura zilei"},{"left":"Cum au fost împrăștiați cei care au scăpat","right":"Risipiți"},{"left":"Cui i-a vorbit poporul după izbândă","right":"Lui Samuel"},{"left":"Pe cine a cerut poporul să aducă","right":"Oamenii despre care poporul întreba: «Cine zicea: Saul să domnească peste noi?»"},{"left":"Ce voia poporul să li se întâmple acelor oameni","right":"Să fie omorâți"}]'::jsonb),
  ('1 Samuel', 11, ARRAY['11:12', '11:13']::text[], 'pending_review', '[{"left":"Cine a cerut să fie omorâți oamenii aceia","right":"Poporul"},{"left":"Cui i-a adresat poporul cererea","right":"Lui Samuel"},{"left":"Ce i-a cerut să facă cu oamenii aceia","right":"Să-i dea încoace"},{"left":"Ce a hotărât Saul pentru ziua aceea","right":"Nimeni nu va fi omorât"},{"left":"Cine dăduse o izbăvire lui Israel","right":"Domnul"}]'::jsonb),
  ('1 Samuel', 11, ARRAY['11:13', '11:14', '11:15']::text[], 'pending_review', '[{"left":"Ce a dat Domnul lui Israel în ziua aceea","right":"O izbăvire"},{"left":"Cine i-a chemat pe israeliți să meargă la Ghilgal","right":"Samuel"},{"left":"Ce urmau să întărească acolo","right":"Împărăția"},{"left":"Unde l-au pus pe Saul împărat","right":"La Ghilgal"},{"left":"Înaintea cui a fost pus Saul împărat","right":"Înaintea Domnului"}]'::jsonb),
  ('1 Samuel', 11, ARRAY['11:14', '11:15']::text[], 'pending_review', '[{"left":"Cine a chemat poporul să meargă la Ghilgal","right":"Samuel"},{"left":"Unde a fost întărită împărăția","right":"La Ghilgal"},{"left":"Cine a mers la Ghilgal","right":"Tot poporul"},{"left":"Ce jertfe au adus înaintea Domnului","right":"Jertfe de mulțumire"},{"left":"Cum s-au veselit Saul și Israel","right":"Foarte mult"}]'::jsonb),
  ('1 Samuel', 11, ARRAY['11:15']::text[], 'pending_review', '[{"left":"Unde s-a dus tot poporul","right":"La Ghilgal"},{"left":"Pe cine au pus împărat","right":"Pe Saul"},{"left":"Înaintea cui l-au pus împărat","right":"Înaintea Domnului"},{"left":"Ce au adus înaintea Domnului","right":"Jertfe de mulțumire"},{"left":"Cum s-au veselit Saul și oamenii lui Israel","right":"Foarte mult"}]'::jsonb),
  ('1 Samuel', 11, ARRAY['11:1', '11:2', '11:7', '11:8', '11:15']::text[], 'pending_review', '[{"left":"Cetatea împresurată la început","right":"Iabes din Galaad"},{"left":"Condiția pusă de Nahaș","right":"Să scoată ochiul drept"},{"left":"Animalul pe care Saul l-a tăiat în bucăți","right":"O pereche de boi"},{"left":"Locul unde a numărat Saul poporul","right":"Bezec"},{"left":"Locul unde l-au pus pe Saul împărat","right":"Ghilgal"}]'::jsonb),
  ('1 Samuel', 11, ARRAY['11:1', '11:3', '11:4', '11:8', '11:11', '11:14']::text[], 'pending_review', '[{"left":"Locul unde au ajuns solii din Iabes","right":"Ghibea"},{"left":"Locul unde a fost făcută numărătoarea","right":"Bezec"},{"left":"Unde a venit Nahaș și a împresurat cetatea","right":"Iabes din Galaad"},{"left":"Momentul intrării în tabăra amoniților","right":"Straja dimineții"},{"left":"Locul ales pentru întărirea împărăției","right":"Ghilgal"}]'::jsonb),
  ('1 Samuel', 11, ARRAY['11:5', '11:6', '11:9', '11:13', '11:15']::text[], 'pending_review', '[{"left":"Ce i-au istorisit oamenii lui Saul","right":"Ce spuseseră cei din Iabes"},{"left":"Ce a venit peste Saul după ce a auzit vestea","right":"Duhul lui Dumnezeu"},{"left":"Ce ajutor li s-a promis locuitorilor din Iabes?","right":"Ajutor a doua zi, când va dogori soarele"},{"left":"Ce a hotărât Saul pentru oamenii pe care poporul voia să-i omoare","right":"Nimeni nu va fi omorât în ziua aceea"},{"left":"Cum s-au veselit Saul și Israel după ce l-au pus împărat","right":"Foarte mult"}]'::jsonb)
) as incoming (book, chapter, source_references, status, pairs)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.pairs = incoming.pairs;

insert into public.questions_match (pairs, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.pairs, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('[{"left":"Cine a împresurat Iabesul","right":"Nahaș, Amonitul"},{"left":"Unde se afla Iabesul","right":"În Galaad"},{"left":"Ce i-au cerut locuitorii din Iabes lui Nahaș","right":"Să facă legământ"},{"left":"Ce au spus locuitorii că vor fi","right":"Supuși lui Nahaș"},{"left":"Câte zile au cerut bătrânii pentru a trimite soli","right":"Șapte zile"}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:1', '11:2', '11:3']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Cine a pus condiția legământului","right":"Nahaș"},{"left":"Ce trebuia scos tuturor locuitorilor","right":"Ochiul drept"},{"left":"Asupra cui urma să fie aruncată ocara","right":"Asupra întregului Israel"},{"left":"Ce au cerut locuitorii din Iabes","right":"Un legământ"},{"left":"Ce au spus că vor face față de Nahaș","right":"Îi vor fi supuși"}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:1', '11:2']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Cine a cerut răgazul de șapte zile","right":"Bătrânii din Iabes"},{"left":"Unde urmau să trimită soli?","right":"În tot ținutul lui Israel"},{"left":"Ce aveau să facă dacă nu primeau ajutor","right":"Să se supună lui Nahaș"},{"left":"Unde au ajuns solii","right":"La Ghibea"},{"left":"A cui cetate era Ghibea","right":"A lui Saul"}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:3', '11:4']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Unde au ajuns solii din Iabes","right":"La Ghibea"},{"left":"În auzul cui au spus ei lucrurile","right":"Al poporului"},{"left":"Ce a făcut poporul după ce a auzit","right":"A ridicat glasul și a plâns"},{"left":"De unde se întorcea Saul","right":"De la câmp"},{"left":"În urma cui venea Saul","right":"Boii"}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:4', '11:5']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Ce a întrebat Saul despre popor","right":"De ce plângea"},{"left":"Ce i-au istorisit oamenii","right":"Ce spuseseră cei din Iabes"},{"left":"Cine a venit peste Saul după ce a auzit","right":"Duhul lui Dumnezeu"},{"left":"Cum s-a mâniat Saul","right":"Foarte tare"},{"left":"Ce eveniment a precedat mânia lui Saul","right":"A auzit vestea din Iabes"}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:5', '11:6']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Peste cine a venit Duhul lui Dumnezeu","right":"Peste Saul"},{"left":"Ce a luat Saul pentru a trimite un semn prin Israel","right":"O pereche de boi"},{"left":"Ce a făcut Saul cu boii","right":"I-a tăiat în bucăți"},{"left":"Prin cine au fost trimise bucățile","right":"Prin soli"},{"left":"Unde au fost trimise bucățile","right":"În tot ținutul lui Israel"}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:6', '11:7']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Cui trebuia să-i urmeze poporul","right":"Lui Saul și lui Samuel"},{"left":"Ce pățeau boii celui care nu mergea","right":"Erau tăiați la fel"},{"left":"Ce a apucat poporul","right":"Groaza Domnului"},{"left":"Cum a pornit poporul","right":"Ca un singur om"},{"left":"Ce a făcut Saul cu perechea de boi","right":"A tăiat-o în bucăți"}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:7']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Unde a numărat Saul poporul","right":"La Bezec"},{"left":"Numărul copiilor lui Israel","right":"Trei sute de mii"},{"left":"Numărul bărbaților lui Iuda","right":"Treizeci de mii"},{"left":"Când urma Iabesul să aibă ajutor","right":"A doua zi"},{"left":"În ce moment al zilei urma ajutorul","right":"Când dogorea soarele"}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:8', '11:9']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Ce le-au vestit solii locuitorilor din Iabes","right":"Vor avea ajutor"},{"left":"Când va veni ajutorul","right":"A doua zi, când va dogori soarele"},{"left":"Cum au primit locuitorii vestea","right":"S-au umplut de bucurie"},{"left":"Ce le-au spus amoniților despre ziua următoare","right":"Se vor supune"},{"left":"Ce au spus că le pot face amoniții","right":"Ce le va plăcea"}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:9', '11:10']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Cine a împărțit poporul în cete","right":"Saul"},{"left":"În câte cete a fost împărțit poporul","right":"Trei"},{"left":"În ce tabără au pătruns cetele","right":"În tabăra amoniților"},{"left":"Când au pătruns în tabără","right":"În straja dimineții"},{"left":"Până când i-au bătut pe amoniți","right":"Până la căldura zilei"}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:10', '11:11']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Ce s-a întâmplat cu cei care au scăpat","right":"Au fost risipiți"},{"left":"Ce spune textul despre cei rămași doi laolaltă","right":"N-au mai rămas doi laolaltă"},{"left":"Cine a împărțit poporul","right":"Saul"},{"left":"Numărul cetelor","right":"Trei"},{"left":"Ținta atacului","right":"Tabăra amoniților"}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:11']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Până când i-au bătut pe amoniți","right":"Până la căldura zilei"},{"left":"Cum au fost împrăștiați cei care au scăpat","right":"Risipiți"},{"left":"Cui i-a vorbit poporul după izbândă","right":"Lui Samuel"},{"left":"Pe cine a cerut poporul să aducă","right":"Oamenii despre care poporul întreba: «Cine zicea: Saul să domnească peste noi?»"},{"left":"Ce voia poporul să li se întâmple acelor oameni","right":"Să fie omorâți"}]'::jsonb, 11, 3, '1 Samuel', ARRAY['11:11', '11:12']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Cine a cerut să fie omorâți oamenii aceia","right":"Poporul"},{"left":"Cui i-a adresat poporul cererea","right":"Lui Samuel"},{"left":"Ce i-a cerut să facă cu oamenii aceia","right":"Să-i dea încoace"},{"left":"Ce a hotărât Saul pentru ziua aceea","right":"Nimeni nu va fi omorât"},{"left":"Cine dăduse o izbăvire lui Israel","right":"Domnul"}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:12', '11:13']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Ce a dat Domnul lui Israel în ziua aceea","right":"O izbăvire"},{"left":"Cine i-a chemat pe israeliți să meargă la Ghilgal","right":"Samuel"},{"left":"Ce urmau să întărească acolo","right":"Împărăția"},{"left":"Unde l-au pus pe Saul împărat","right":"La Ghilgal"},{"left":"Înaintea cui a fost pus Saul împărat","right":"Înaintea Domnului"}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:13', '11:14', '11:15']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Cine a chemat poporul să meargă la Ghilgal","right":"Samuel"},{"left":"Unde a fost întărită împărăția","right":"La Ghilgal"},{"left":"Cine a mers la Ghilgal","right":"Tot poporul"},{"left":"Ce jertfe au adus înaintea Domnului","right":"Jertfe de mulțumire"},{"left":"Cum s-au veselit Saul și Israel","right":"Foarte mult"}]'::jsonb, 11, 2, '1 Samuel', ARRAY['11:14', '11:15']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Unde s-a dus tot poporul","right":"La Ghilgal"},{"left":"Pe cine au pus împărat","right":"Pe Saul"},{"left":"Înaintea cui l-au pus împărat","right":"Înaintea Domnului"},{"left":"Ce au adus înaintea Domnului","right":"Jertfe de mulțumire"},{"left":"Cum s-au veselit Saul și oamenii lui Israel","right":"Foarte mult"}]'::jsonb, 11, 1, '1 Samuel', ARRAY['11:15']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Cetatea împresurată la început","right":"Iabes din Galaad"},{"left":"Condiția pusă de Nahaș","right":"Să scoată ochiul drept"},{"left":"Animalul pe care Saul l-a tăiat în bucăți","right":"O pereche de boi"},{"left":"Locul unde a numărat Saul poporul","right":"Bezec"},{"left":"Locul unde l-au pus pe Saul împărat","right":"Ghilgal"}]'::jsonb, 11, 3, '1 Samuel', ARRAY['11:1', '11:2', '11:7', '11:8', '11:15']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Locul unde au ajuns solii din Iabes","right":"Ghibea"},{"left":"Locul unde a fost făcută numărătoarea","right":"Bezec"},{"left":"Unde a venit Nahaș și a împresurat cetatea","right":"Iabes din Galaad"},{"left":"Momentul intrării în tabăra amoniților","right":"Straja dimineții"},{"left":"Locul ales pentru întărirea împărăției","right":"Ghilgal"}]'::jsonb, 11, 3, '1 Samuel', ARRAY['11:1', '11:3', '11:4', '11:8', '11:11', '11:14']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Ce i-au istorisit oamenii lui Saul","right":"Ce spuseseră cei din Iabes"},{"left":"Ce a venit peste Saul după ce a auzit vestea","right":"Duhul lui Dumnezeu"},{"left":"Ce ajutor li s-a promis locuitorilor din Iabes?","right":"Ajutor a doua zi, când va dogori soarele"},{"left":"Ce a hotărât Saul pentru oamenii pe care poporul voia să-i omoare","right":"Nimeni nu va fi omorât în ziua aceea"},{"left":"Cum s-au veselit Saul și Israel după ce l-au pus împărat","right":"Foarte mult"}]'::jsonb, 11, 3, '1 Samuel', ARRAY['11:5', '11:6', '11:9', '11:13', '11:15']::text[], 'pending_review', 'Codex')
) as incoming (pairs, chapter, difficulty, book, source_references, status, added_by)
where not exists (
  select 1 from public.questions_match existing
  where existing.book = incoming.book
    and existing.chapter = incoming.chapter
    and existing.source_references = incoming.source_references
    and existing.pairs = incoming.pairs
);

commit;
