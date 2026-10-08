begin;

alter table public.questions_tf add column if not exists source_references text[] not null default '{}';

alter table public.questions_abc_one add column if not exists source_references text[] not null default '{}';

alter table public.questions_abc_multi add column if not exists source_references text[] not null default '{}';

alter table public.questions_match add column if not exists source_references text[] not null default '{}';

update public.questions_tf as existing
set status = incoming.status
from (values
  ('1 Samuel', 13, ARRAY['13:1']::text[], 'pending_review', 'Saul avea treizeci de ani când a ajuns împărat și a domnit doi ani peste Israel.'),
  ('1 Samuel', 13, ARRAY['13:2']::text[], 'pending_review', 'Saul și-a ales trei mii de bărbați: două mii au rămas cu el la Micmaș și pe muntele Betel, iar o mie a fost cu Ionatan la Ghibea lui Beniamin.'),
  ('1 Samuel', 13, ARRAY['13:3']::text[], 'pending_review', 'Ionatan a bătut tabăra filistenilor de la Gheba, iar Saul a pus să sune cu trâmbița prin toată țara ca să audă evreii.'),
  ('1 Samuel', 13, ARRAY['13:4']::text[], 'pending_review', 'Tot Israelul a auzit spunându-se că Saul bătuse tabăra filistenilor și că Israel se făcuse urât filistenilor, iar poporul s-a adunat la Saul în Ghilgal.'),
  ('1 Samuel', 13, ARRAY['13:5']::text[], 'pending_review', 'Filistenii au venit cu o mie de care și șase mii de călăreți și au tăbărât la Micmaș, la răsărit de Bet-Aven.'),
  ('1 Samuel', 13, ARRAY['13:6']::text[], 'pending_review', 'Bărbații lui Israel s-au ascuns, între altele, în peșteri, în tufişuri, în stânci, în turnuri și în gropi pentru apă.'),
  ('1 Samuel', 13, ARRAY['13:7']::text[], 'pending_review', 'Unii evrei au trecut Iordanul spre țara lui Gad și Galaad, în timp ce Saul a rămas la Ghilgal și poporul de lângă el tremura.'),
  ('1 Samuel', 13, ARRAY['13:8']::text[], 'pending_review', 'Saul a așteptat șapte zile, după timpul hotărât de Samuel, dar Samuel nu venea la Ghilgal și poporul se împrăștia de lângă Saul.'),
  ('1 Samuel', 13, ARRAY['13:9']::text[], 'pending_review', 'Saul a cerut să i se aducă arderea-de-tot și jertfele de mulțumire, apoi a jertfit arderea-de-tot.'),
  ('1 Samuel', 13, ARRAY['13:10']::text[], 'pending_review', 'Samuel a venit pe când Saul sfârșea de adus arderea-de-tot, iar Saul i-a ieșit înainte să-i ureze de bine.'),
  ('1 Samuel', 13, ARRAY['13:2']::text[], 'pending_review', 'Dintre cei trei mii de bărbați aleși de Saul, o mie era cu el la Micmaș, iar două mii erau cu Ionatan la Ghibea lui Beniamin.'),
  ('1 Samuel', 13, ARRAY['13:3']::text[], 'pending_review', 'Saul a bătut garnizoana filistenilor de la Gheba, iar Ionatan a sunat din trâmbiță prin toată țara.'),
  ('1 Samuel', 13, ARRAY['13:5']::text[], 'pending_review', 'Filistenii aveau șase mii de care și o mie de călăreți când s-au strâns să lupte cu Israel.'),
  ('1 Samuel', 13, ARRAY['13:6']::text[], 'pending_review', 'Bărbații lui Israel s-au ascuns numai în case și în corturi, nu și în peșteri, stânci ori gropi pentru apă.'),
  ('1 Samuel', 13, ARRAY['13:7']::text[], 'pending_review', 'Tot poporul a trecut Iordanul spre țara lui Gad și Galaad, iar Saul a plecat și el de la Ghilgal.'),
  ('1 Samuel', 13, ARRAY['13:8']::text[], 'pending_review', 'Samuel a venit la Ghilgal în timpul așteptat, înainte ca poporul să se împrăștie de lângă Saul.'),
  ('1 Samuel', 13, ARRAY['13:9']::text[], 'pending_review', 'Saul a jertfit jertfele de mulțumire, dar nu a adus arderea-de-tot.'),
  ('1 Samuel', 13, ARRAY['13:12']::text[], 'pending_review', 'Saul i-a spus lui Samuel că se rugase Domnului înainte de a aduce arderea-de-tot și că nu se temuse de venirea filistenilor.'),
  ('1 Samuel', 13, ARRAY['13:13']::text[], 'pending_review', 'Samuel i-a spus lui Saul că păzise porunca Domnului și că Domnul îi va întări pe vecie domnia peste Israel.'),
  ('1 Samuel', 13, ARRAY['13:22']::text[], 'pending_review', 'În ziua luptei, toți bărbații aflați cu Saul și Ionatan aveau săbii și sulițe.')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_tf (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Saul avea treizeci de ani când a ajuns împărat și a domnit doi ani peste Israel.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 13, 1, '1 Samuel', ARRAY['13:1']::text[], 'pending_review', 'Codex'),
  ('Saul și-a ales trei mii de bărbați: două mii au rămas cu el la Micmaș și pe muntele Betel, iar o mie a fost cu Ionatan la Ghibea lui Beniamin.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 13, 2, '1 Samuel', ARRAY['13:2']::text[], 'pending_review', 'Codex'),
  ('Ionatan a bătut tabăra filistenilor de la Gheba, iar Saul a pus să sune cu trâmbița prin toată țara ca să audă evreii.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 13, 2, '1 Samuel', ARRAY['13:3']::text[], 'pending_review', 'Codex'),
  ('Tot Israelul a auzit spunându-se că Saul bătuse tabăra filistenilor și că Israel se făcuse urât filistenilor, iar poporul s-a adunat la Saul în Ghilgal.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 13, 2, '1 Samuel', ARRAY['13:4']::text[], 'pending_review', 'Codex'),
  ('Filistenii au venit cu o mie de care și șase mii de călăreți și au tăbărât la Micmaș, la răsărit de Bet-Aven.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 13, 2, '1 Samuel', ARRAY['13:5']::text[], 'pending_review', 'Codex'),
  ('Bărbații lui Israel s-au ascuns, între altele, în peșteri, în tufişuri, în stânci, în turnuri și în gropi pentru apă.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 13, 2, '1 Samuel', ARRAY['13:6']::text[], 'pending_review', 'Codex'),
  ('Unii evrei au trecut Iordanul spre țara lui Gad și Galaad, în timp ce Saul a rămas la Ghilgal și poporul de lângă el tremura.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 13, 2, '1 Samuel', ARRAY['13:7']::text[], 'pending_review', 'Codex'),
  ('Saul a așteptat șapte zile, după timpul hotărât de Samuel, dar Samuel nu venea la Ghilgal și poporul se împrăștia de lângă Saul.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 13, 2, '1 Samuel', ARRAY['13:8']::text[], 'pending_review', 'Codex'),
  ('Saul a cerut să i se aducă arderea-de-tot și jertfele de mulțumire, apoi a jertfit arderea-de-tot.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 13, 2, '1 Samuel', ARRAY['13:9']::text[], 'pending_review', 'Codex'),
  ('Samuel a venit pe când Saul sfârșea de adus arderea-de-tot, iar Saul i-a ieșit înainte să-i ureze de bine.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 13, 2, '1 Samuel', ARRAY['13:10']::text[], 'pending_review', 'Codex'),
  ('Dintre cei trei mii de bărbați aleși de Saul, o mie era cu el la Micmaș, iar două mii erau cu Ionatan la Ghibea lui Beniamin.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 13, 2, '1 Samuel', ARRAY['13:2']::text[], 'pending_review', 'Codex'),
  ('Saul a bătut garnizoana filistenilor de la Gheba, iar Ionatan a sunat din trâmbiță prin toată țara.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 13, 2, '1 Samuel', ARRAY['13:3']::text[], 'pending_review', 'Codex'),
  ('Filistenii aveau șase mii de care și o mie de călăreți când s-au strâns să lupte cu Israel.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 13, 2, '1 Samuel', ARRAY['13:5']::text[], 'pending_review', 'Codex'),
  ('Bărbații lui Israel s-au ascuns numai în case și în corturi, nu și în peșteri, stânci ori gropi pentru apă.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 13, 3, '1 Samuel', ARRAY['13:6']::text[], 'pending_review', 'Codex'),
  ('Tot poporul a trecut Iordanul spre țara lui Gad și Galaad, iar Saul a plecat și el de la Ghilgal.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 13, 2, '1 Samuel', ARRAY['13:7']::text[], 'pending_review', 'Codex'),
  ('Samuel a venit la Ghilgal în timpul așteptat, înainte ca poporul să se împrăștie de lângă Saul.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 13, 2, '1 Samuel', ARRAY['13:8']::text[], 'pending_review', 'Codex'),
  ('Saul a jertfit jertfele de mulțumire, dar nu a adus arderea-de-tot.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 13, 2, '1 Samuel', ARRAY['13:9']::text[], 'pending_review', 'Codex'),
  ('Saul i-a spus lui Samuel că se rugase Domnului înainte de a aduce arderea-de-tot și că nu se temuse de venirea filistenilor.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 13, 3, '1 Samuel', ARRAY['13:12']::text[], 'pending_review', 'Codex'),
  ('Samuel i-a spus lui Saul că păzise porunca Domnului și că Domnul îi va întări pe vecie domnia peste Israel.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 13, 2, '1 Samuel', ARRAY['13:13']::text[], 'pending_review', 'Codex'),
  ('În ziua luptei, toți bărbații aflați cu Saul și Ionatan aveau săbii și sulițe.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 13, 2, '1 Samuel', ARRAY['13:22']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 13, ARRAY['13:1']::text[], 'pending_review', 'Câți ani avea Saul când a ajuns împărat, potrivit relatării?'),
  ('1 Samuel', 13, ARRAY['13:2']::text[], 'pending_review', 'Câți bărbați și-a ales Saul din Israel pentru a rămâne cu el și cu Ionatan?'),
  ('1 Samuel', 13, ARRAY['13:2']::text[], 'pending_review', 'Unde se aflau cei două mii de bărbați care erau cu Saul?'),
  ('1 Samuel', 13, ARRAY['13:2']::text[], 'pending_review', 'Unde se aflau cei o mie de bărbați care erau cu Ionatan?'),
  ('1 Samuel', 13, ARRAY['13:2']::text[], 'pending_review', 'Ce le-a făcut Saul celorlalți oameni din popor, care nu rămăseseră cu el sau cu Ionatan?'),
  ('1 Samuel', 13, ARRAY['13:3']::text[], 'pending_review', 'Ce a făcut Ionatan cu tabăra filistenilor care era la Gheba?'),
  ('1 Samuel', 13, ARRAY['13:3']::text[], 'pending_review', 'Ce a pus Saul să se facă prin toată țara după ce filistenii au auzit ce făcuse Ionatan?'),
  ('1 Samuel', 13, ARRAY['13:4']::text[], 'pending_review', 'Unde s-a adunat poporul la Saul după ce a auzit despre tabăra filistenilor?'),
  ('1 Samuel', 13, ARRAY['13:5']::text[], 'pending_review', 'Unde și-au așezat filistenii tabăra după ce s-au strâns să lupte cu Israel?'),
  ('1 Samuel', 13, ARRAY['13:6']::text[], 'pending_review', 'Care dintre aceste locuri este menționat ca ascunzătoare pentru bărbații lui Israel?'),
  ('1 Samuel', 13, ARRAY['13:7']::text[], 'pending_review', 'Înspre ce țări s-au dus unii evrei după ce au trecut Iordanul?'),
  ('1 Samuel', 13, ARRAY['13:8']::text[], 'pending_review', 'Câte zile a așteptat Saul la Ghilgal, după timpul hotărât de Samuel?'),
  ('1 Samuel', 13, ARRAY['13:9']::text[], 'pending_review', 'Ce a jertfit Saul după ce a cerut să i se aducă arderea-de-tot și jertfele de mulțumire?'),
  ('1 Samuel', 13, ARRAY['13:10']::text[], 'pending_review', 'Când a sosit Samuel la Ghilgal în raport cu jertfa lui Saul?'),
  ('1 Samuel', 13, ARRAY['13:12']::text[], 'pending_review', 'Ce se temea Saul că vor face filistenii, potrivit explicației date lui Samuel?'),
  ('1 Samuel', 13, ARRAY['13:13', '13:14']::text[], 'pending_review', 'Ce i-a spus Samuel lui Saul despre porunca neascultată și urmarea pentru domnia lui?'),
  ('1 Samuel', 13, ARRAY['13:13']::text[], 'pending_review', 'Ce ar fi făcut Domnul cu domnia lui Saul dacă Saul ar fi păzit porunca?'),
  ('1 Samuel', 13, ARRAY['13:15']::text[], 'pending_review', 'Câți oameni erau aproape cu Saul după ce a numărat poporul rămas cu el?'),
  ('1 Samuel', 13, ARRAY['13:20']::text[], 'pending_review', 'La cine se cobora fiecare om din Israel ca să-și ascută uneltele de fier?'),
  ('1 Samuel', 13, ARRAY['13:23']::text[], 'pending_review', 'Unde s-a așezat ceata de filisteni menționată la sfârșitul capitolului?')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_abc_one (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Câți ani avea Saul când a ajuns împărat, potrivit relatării?', '[{"text":"Treizeci de ani","correct":true},{"text":"Patruzeci de ani","correct":false},{"text":"Cincizeci de ani","correct":false}]'::jsonb, 13, 1, '1 Samuel', ARRAY['13:1']::text[], 'pending_review', 'Codex'),
  ('Câți bărbați și-a ales Saul din Israel pentru a rămâne cu el și cu Ionatan?', '[{"text":"Trei mii","correct":true},{"text":"Șase sute","correct":false},{"text":"Șase mii","correct":false}]'::jsonb, 13, 1, '1 Samuel', ARRAY['13:2']::text[], 'pending_review', 'Codex'),
  ('Unde se aflau cei două mii de bărbați care erau cu Saul?', '[{"text":"La Micmaș și pe muntele Betel","correct":true},{"text":"La Ghibea lui Beniamin și la Ghilgal","correct":false},{"text":"La Bet-Horon și la Ofra","correct":false}]'::jsonb, 13, 2, '1 Samuel', ARRAY['13:2']::text[], 'pending_review', 'Codex'),
  ('Unde se aflau cei o mie de bărbați care erau cu Ionatan?', '[{"text":"La Ghibea lui Beniamin","correct":true},{"text":"La Micmaș","correct":false},{"text":"La Ghilgal","correct":false}]'::jsonb, 13, 1, '1 Samuel', ARRAY['13:2']::text[], 'pending_review', 'Codex'),
  ('Ce le-a făcut Saul celorlalți oameni din popor, care nu rămăseseră cu el sau cu Ionatan?', '[{"text":"I-a trimis pe fiecare la cortul lui","correct":true},{"text":"I-a trimis la filisteni","correct":false},{"text":"I-a așezat cu Ionatan la Ghibea","correct":false}]'::jsonb, 13, 2, '1 Samuel', ARRAY['13:2']::text[], 'pending_review', 'Codex'),
  ('Ce a făcut Ionatan cu tabăra filistenilor care era la Gheba?', '[{"text":"A bătut-o","correct":true},{"text":"A cerut să se alieze cu ea","correct":false},{"text":"A trimis-o la Micmaș","correct":false}]'::jsonb, 13, 1, '1 Samuel', ARRAY['13:3']::text[], 'pending_review', 'Codex'),
  ('Ce a pus Saul să se facă prin toată țara după ce filistenii au auzit ce făcuse Ionatan?', '[{"text":"Să sune cu trâmbița și să se audă vestea printre evrei","correct":true},{"text":"Să se aprindă focuri pentru Samuel","correct":false},{"text":"Să se numere carele filistenilor","correct":false}]'::jsonb, 13, 2, '1 Samuel', ARRAY['13:3']::text[], 'pending_review', 'Codex'),
  ('Unde s-a adunat poporul la Saul după ce a auzit despre tabăra filistenilor?', '[{"text":"La Ghilgal","correct":true},{"text":"La Micmaș","correct":false},{"text":"La Ghibea lui Beniamin","correct":false}]'::jsonb, 13, 1, '1 Samuel', ARRAY['13:4']::text[], 'pending_review', 'Codex'),
  ('Unde și-au așezat filistenii tabăra după ce s-au strâns să lupte cu Israel?', '[{"text":"La Micmaș, la răsărit de Bet-Aven","correct":true},{"text":"La Gheba, la apus de Betel","correct":false},{"text":"La Ghilgal, lângă Iordan","correct":false}]'::jsonb, 13, 2, '1 Samuel', ARRAY['13:5']::text[], 'pending_review', 'Codex'),
  ('Care dintre aceste locuri este menționat ca ascunzătoare pentru bărbații lui Israel?', '[{"text":"Peșterile","correct":true},{"text":"Palatele","correct":false},{"text":"Sinagogile","correct":false}]'::jsonb, 13, 1, '1 Samuel', ARRAY['13:6']::text[], 'pending_review', 'Codex'),
  ('Înspre ce țări s-au dus unii evrei după ce au trecut Iordanul?', '[{"text":"Țara lui Gad și Galaad","correct":true},{"text":"Țara lui Moab și Amon","correct":false},{"text":"Țara filistenilor și Egipt","correct":false}]'::jsonb, 13, 1, '1 Samuel', ARRAY['13:7']::text[], 'pending_review', 'Codex'),
  ('Câte zile a așteptat Saul la Ghilgal, după timpul hotărât de Samuel?', '[{"text":"Șapte zile","correct":true},{"text":"Trei zile","correct":false},{"text":"Patruzeci de zile","correct":false}]'::jsonb, 13, 1, '1 Samuel', ARRAY['13:8']::text[], 'pending_review', 'Codex'),
  ('Ce a jertfit Saul după ce a cerut să i se aducă arderea-de-tot și jertfele de mulțumire?', '[{"text":"Arderea-de-tot","correct":true},{"text":"Jertfele de mulțumire, dar nu arderea-de-tot","correct":false},{"text":"Nicio jertfă","correct":false}]'::jsonb, 13, 1, '1 Samuel', ARRAY['13:9']::text[], 'pending_review', 'Codex'),
  ('Când a sosit Samuel la Ghilgal în raport cu jertfa lui Saul?', '[{"text":"Pe când Saul sfârșea de adus arderea-de-tot","correct":true},{"text":"Cu șapte zile înainte să înceapă jertfa","correct":false},{"text":"După ce poporul plecase cu totul","correct":false}]'::jsonb, 13, 2, '1 Samuel', ARRAY['13:10']::text[], 'pending_review', 'Codex'),
  ('Ce se temea Saul că vor face filistenii, potrivit explicației date lui Samuel?', '[{"text":"Se vor coborî împotriva lui la Ghilgal","correct":true},{"text":"Vor trece Iordanul spre Galaad","correct":false},{"text":"Vor ataca Ghibea lui Beniamin","correct":false}]'::jsonb, 13, 2, '1 Samuel', ARRAY['13:12']::text[], 'pending_review', 'Codex'),
  ('Ce i-a spus Samuel lui Saul despre porunca neascultată și urmarea pentru domnia lui?', '[{"text":"Că nu păzise porunca, iar domnia lui nu va dăinui","correct":true},{"text":"Că păzise porunca și domnia lui va fi întărită pe vecie","correct":false},{"text":"Că nu trebuia să asculte de Samuel, iar poporul îl va alege din nou","correct":false}]'::jsonb, 13, 2, '1 Samuel', ARRAY['13:13', '13:14']::text[], 'pending_review', 'Codex'),
  ('Ce ar fi făcut Domnul cu domnia lui Saul dacă Saul ar fi păzit porunca?', '[{"text":"Ar fi întărit-o pe vecie peste Israel","correct":true},{"text":"Ar fi mutat-o la Ionatan imediat","correct":false},{"text":"Ar fi dat-o filistenilor","correct":false}]'::jsonb, 13, 2, '1 Samuel', ARRAY['13:13']::text[], 'pending_review', 'Codex'),
  ('Câți oameni erau aproape cu Saul după ce a numărat poporul rămas cu el?', '[{"text":"Aproape șase sute","correct":true},{"text":"Trei mii","correct":false},{"text":"Șase mii","correct":false}]'::jsonb, 13, 1, '1 Samuel', ARRAY['13:15']::text[], 'pending_review', 'Codex'),
  ('La cine se cobora fiecare om din Israel ca să-și ascută uneltele de fier?', '[{"text":"La filisteni","correct":true},{"text":"La Samuel","correct":false},{"text":"La locuitorii din Ghilgal","correct":false}]'::jsonb, 13, 2, '1 Samuel', ARRAY['13:20']::text[], 'pending_review', 'Codex'),
  ('Unde s-a așezat ceata de filisteni menționată la sfârșitul capitolului?', '[{"text":"La trecătoarea Micmașului","correct":true},{"text":"La vadul Iordanului","correct":false},{"text":"La poarta Ghilgalului","correct":false}]'::jsonb, 13, 1, '1 Samuel', ARRAY['13:23']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 13, ARRAY['13:5']::text[], 'pending_review', 'Ce informații sunt date despre oastea filistenilor strânsă împotriva lui Israel?'),
  ('1 Samuel', 13, ARRAY['13:6', '13:7']::text[], 'pending_review', 'Care afirmații descriu ce au făcut israeliții când s-au văzut la strâmtoare?'),
  ('1 Samuel', 13, ARRAY['13:11', '13:12']::text[], 'pending_review', 'Ce motive a dat Saul când i-a explicat lui Samuel de ce adusese arderea-de-tot?'),
  ('1 Samuel', 13, ARRAY['13:13']::text[], 'pending_review', 'Ce i-a spus Samuel lui Saul după ce acesta a adus arderea-de-tot?'),
  ('1 Samuel', 13, ARRAY['13:17', '13:18']::text[], 'pending_review', 'Care afirmații redau drumurile luate de cetele filistenilor care au ieșit să pustiască țara?'),
  ('1 Samuel', 13, ARRAY['13:19', '13:20', '13:21', '13:22']::text[], 'pending_review', 'Ce afirmații sunt consemnate despre fierari, uneltele israeliților și armele din ziua luptei?')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_abc_multi (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Ce informații sunt date despre oastea filistenilor strânsă împotriva lui Israel?', '[{"text":"Avea o mie de care","correct":true},{"text":"Avea șase mii de călăreți","correct":true},{"text":"Număra exact șase sute de oameni","correct":false}]'::jsonb, 13, 2, '1 Samuel', ARRAY['13:5']::text[], 'pending_review', 'Codex'),
  ('Care afirmații descriu ce au făcut israeliții când s-au văzut la strâmtoare?', '[{"text":"Unii s-au ascuns în locuri precum peșteri, tufişuri, stânci, turnuri și gropi pentru apă","correct":true},{"text":"Unii evrei au trecut Iordanul spre țara lui Gad și Galaad","correct":true},{"text":"Tot poporul a trecut Iordanul, iar Saul a plecat din Ghilgal","correct":false}]'::jsonb, 13, 3, '1 Samuel', ARRAY['13:6', '13:7']::text[], 'pending_review', 'Codex'),
  ('Ce motive a dat Saul când i-a explicat lui Samuel de ce adusese arderea-de-tot?', '[{"text":"A văzut că poporul se împrăștia și că Samuel nu venise la timpul hotărât","correct":true},{"text":"Se temea că filistenii se vor coborî împotriva lui la Ghilgal și a spus că nu se rugase Domnului","correct":true},{"text":"Samuel îi poruncise înainte să aducă arderea-de-tot","correct":false}]'::jsonb, 13, 3, '1 Samuel', ARRAY['13:11', '13:12']::text[], 'pending_review', 'Codex'),
  ('Ce i-a spus Samuel lui Saul după ce acesta a adus arderea-de-tot?', '[{"text":"Că lucrase ca un nebun și nu păzise porunca Domnului","correct":true},{"text":"Că Domnul ar fi întărit pe vecie domnia lui dacă păzea porunca","correct":true},{"text":"Că Domnul îi va întări de acum înainte domnia pentru totdeauna","correct":false}]'::jsonb, 13, 3, '1 Samuel', ARRAY['13:13']::text[], 'pending_review', 'Codex'),
  ('Care afirmații redau drumurile luate de cetele filistenilor care au ieșit să pustiască țara?', '[{"text":"Una a luat drumul spre Ofra, spre țara Șual, iar alta spre Bet-Horon","correct":true},{"text":"A treia a mers spre hotarul văii Țeboim, înspre pustie","correct":true},{"text":"Toate trei au mers împreună pe drumul spre Ghilgal","correct":false}]'::jsonb, 13, 3, '1 Samuel', ARRAY['13:17', '13:18']::text[], 'pending_review', 'Codex'),
  ('Ce afirmații sunt consemnate despre fierari, uneltele israeliților și armele din ziua luptei?', '[{"text":"Filistenii au vrut să-i împiedice pe evrei să-și facă săbii sau sulițe, iar în țară nu se găsea niciun fierar","correct":true},{"text":"Israeliții mergeau la filisteni ca să-și ascută uneltele agricole și alte unelte de fier","correct":true},{"text":"În ziua luptei, toți oamenii lui Israel aveau săbii și sulițe, în afară de Saul și Ionatan","correct":false}]'::jsonb, 13, 3, '1 Samuel', ARRAY['13:19', '13:20', '13:21', '13:22']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 13, ARRAY['13:2', '13:7', '13:8', '13:16']::text[], 'pending_review', '[{"left":"Cei două mii de oameni aflați cu Saul","right":"Erau la Micmaș și pe muntele Betel"},{"left":"Cei o mie de oameni aflați cu Ionatan","right":"Erau la Ghibea lui Beniamin"},{"left":"Ceilalți oameni din popor","right":"Au fost trimiși fiecare la cortul lui"},{"left":"Timpul hotărât de Samuel","right":"Șapte zile de așteptare"},{"left":"Saul, Ionatan și poporul care era cu ei","right":"Se așezaseră la Gheba lui Beniamin"}]'::jsonb),
  ('1 Samuel', 13, ARRAY['13:17', '13:18', '13:20', '13:23']::text[], 'pending_review', '[{"left":"Prima ceată de filisteni","right":"A luat drumul spre Ofra și țara Șual"},{"left":"A doua ceată de filisteni","right":"A luat drumul spre Bet-Horon"},{"left":"A treia ceată de filisteni","right":"A mers spre hotarul văii Țeboim, înspre pustie"},{"left":"Uneltele de fier ale israeliților","right":"Erau duse la filisteni ca să fie ascuțite"},{"left":"Ceata filistenilor de la finalul capitolului","right":"S-a așezat la trecătoarea Micmașului"}]'::jsonb)
) as incoming (book, chapter, source_references, status, pairs)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.pairs = incoming.pairs;

insert into public.questions_match (pairs, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.pairs, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('[{"left":"Cei două mii de oameni aflați cu Saul","right":"Erau la Micmaș și pe muntele Betel"},{"left":"Cei o mie de oameni aflați cu Ionatan","right":"Erau la Ghibea lui Beniamin"},{"left":"Ceilalți oameni din popor","right":"Au fost trimiși fiecare la cortul lui"},{"left":"Timpul hotărât de Samuel","right":"Șapte zile de așteptare"},{"left":"Saul, Ionatan și poporul care era cu ei","right":"Se așezaseră la Gheba lui Beniamin"}]'::jsonb, 13, 3, '1 Samuel', ARRAY['13:2', '13:7', '13:8', '13:16']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Prima ceată de filisteni","right":"A luat drumul spre Ofra și țara Șual"},{"left":"A doua ceată de filisteni","right":"A luat drumul spre Bet-Horon"},{"left":"A treia ceată de filisteni","right":"A mers spre hotarul văii Țeboim, înspre pustie"},{"left":"Uneltele de fier ale israeliților","right":"Erau duse la filisteni ca să fie ascuțite"},{"left":"Ceata filistenilor de la finalul capitolului","right":"S-a așezat la trecătoarea Micmașului"}]'::jsonb, 13, 3, '1 Samuel', ARRAY['13:17', '13:18', '13:20', '13:23']::text[], 'pending_review', 'Codex')
) as incoming (pairs, chapter, difficulty, book, source_references, status, added_by)
where not exists (
  select 1 from public.questions_match existing
  where existing.book = incoming.book
    and existing.chapter = incoming.chapter
    and existing.source_references = incoming.source_references
    and existing.pairs = incoming.pairs
);

commit;
