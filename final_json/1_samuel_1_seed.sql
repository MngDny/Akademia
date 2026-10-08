begin;

alter table public.questions_tf add column if not exists source_references text[] not null default '{}';

alter table public.questions_abc_one add column if not exists source_references text[] not null default '{}';

alter table public.questions_abc_multi add column if not exists source_references text[] not null default '{}';

alter table public.questions_match add column if not exists source_references text[] not null default '{}';

update public.questions_tf as existing
set status = incoming.status
from (values
  ('1 Samuel', 1, ARRAY['1:1']::text[], 'pending_review', 'Elcana provenea din Ramataim-Țofim, din zona muntelui Efraim.'),
  ('1 Samuel', 1, ARRAY['1:1']::text[], 'pending_review', 'Elcana era numit efratit.'),
  ('1 Samuel', 1, ARRAY['1:2']::text[], 'pending_review', 'Ana avea copii.'),
  ('1 Samuel', 1, ARRAY['1:3']::text[], 'pending_review', 'Hofni și Fineas erau fiii lui Eli și preoți ai Domnului.'),
  ('1 Samuel', 1, ARRAY['1:2', '1:4']::text[], 'pending_review', 'Elcana dădea părți fiilor și fiicelor pe care îi avea cu Ana.'),
  ('1 Samuel', 1, ARRAY['1:5']::text[], 'pending_review', 'Elcana îi dădea Anei o parte îndoită.'),
  ('1 Samuel', 1, ARRAY['1:5']::text[], 'pending_review', 'Textul spune că Domnul o făcuse pe Ana stearpă.'),
  ('1 Samuel', 1, ARRAY['1:6']::text[], 'pending_review', 'Potrivnica o necăjea pe Ana ca s-o facă să se mânie.'),
  ('1 Samuel', 1, ARRAY['1:7']::text[], 'pending_review', 'Ana plângea și nu mânca.'),
  ('1 Samuel', 1, ARRAY['1:8']::text[], 'pending_review', 'Elcana a întrebat-o pe Ana dacă el nu prețuia pentru ea mai mult decât zece fii.'),
  ('1 Samuel', 1, ARRAY['1:9']::text[], 'pending_review', 'Ana s-a ridicat după ce au mâncat și au băut la Silo.'),
  ('1 Samuel', 1, ARRAY['1:9']::text[], 'pending_review', 'Eli ședea pe un scaun lângă unul dintre ușorii Templului Domnului.'),
  ('1 Samuel', 1, ARRAY['1:10']::text[], 'pending_review', 'Ana se ruga Domnului cu sufletul amărât și plângea.'),
  ('1 Samuel', 1, ARRAY['1:11']::text[], 'pending_review', 'Ana a promis că îl va închina Domnului pe copil pentru toate zilele vieții lui.'),
  ('1 Samuel', 1, ARRAY['1:11']::text[], 'pending_review', 'Ana a spus că un brici va trece peste capul copilului.'),
  ('1 Samuel', 1, ARRAY['1:12']::text[], 'pending_review', 'Ana a stat multă vreme în rugăciune înaintea Domnului.'),
  ('1 Samuel', 1, ARRAY['1:13']::text[], 'pending_review', 'Ana vorbea în inima ei, își mișca buzele, dar nu i se auzea glasul.'),
  ('1 Samuel', 1, ARRAY['1:14']::text[], 'pending_review', 'Eli a întrebat-o pe Ana până când va fi beată.'),
  ('1 Samuel', 1, ARRAY['1:15']::text[], 'pending_review', 'Ana a spus că nu băuse nici vin, nici băutură amețitoare.'),
  ('1 Samuel', 1, ARRAY['1:15']::text[], 'pending_review', 'Ana a spus că își vărsa sufletul înaintea Domnului.'),
  ('1 Samuel', 1, ARRAY['1:16']::text[], 'pending_review', 'Ana i-a cerut lui Eli să nu o socotească o femeie stricată.'),
  ('1 Samuel', 1, ARRAY['1:17']::text[], 'pending_review', 'Eli i-a spus Anei să meargă în pace.'),
  ('1 Samuel', 1, ARRAY['1:18']::text[], 'pending_review', 'După ce a plecat, Ana a mâncat.'),
  ('1 Samuel', 1, ARRAY['1:19']::text[], 'pending_review', 'S-au sculat devreme, s-au închinat înaintea Domnului și s-au întors acasă, la Rama.'),
  ('1 Samuel', 1, ARRAY['1:20']::text[], 'pending_review', 'Ana a rămas însărcinată și a născut un fiu.'),
  ('1 Samuel', 1, ARRAY['1:20']::text[], 'pending_review', 'Ana a spus că îl ceruse de la Domnul.'),
  ('1 Samuel', 1, ARRAY['1:21']::text[], 'pending_review', 'Elcana s-a dus cu toată casa lui să aducă jertfa de peste an și să-și împlinească juruința.'),
  ('1 Samuel', 1, ARRAY['1:22']::text[], 'pending_review', 'Ana nu s-a suit atunci și a spus că îl va duce pe copil înaintea Domnului după ce îl va înțărca.'),
  ('1 Samuel', 1, ARRAY['1:23']::text[], 'pending_review', 'Ana a rămas acasă și și-a alăptat fiul până l-a înțărcat.'),
  ('1 Samuel', 1, ARRAY['1:24']::text[], 'pending_review', 'Ana l-a dus pe copil la Casa Domnului, la Silo, când el era încă foarte mic.'),
  ('1 Samuel', 1, ARRAY['1:25']::text[], 'pending_review', 'După ce au înjunghiat taurii, au dus copilul la Eli.'),
  ('1 Samuel', 1, ARRAY['1:26']::text[], 'pending_review', 'Ana i-a spus lui Eli că ea era femeia care stătuse lângă el și se rugase Domnului.'),
  ('1 Samuel', 1, ARRAY['1:27']::text[], 'pending_review', 'Ana a spus că se rugase pentru copilul acesta și că Domnul îi ascultase rugăciunea.'),
  ('1 Samuel', 1, ARRAY['1:28']::text[], 'pending_review', 'Ana a spus că toată viața copilului va fi dată Domnului.')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_tf (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Elcana provenea din Ramataim-Țofim, din zona muntelui Efraim.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 1, 1, '1 Samuel', ARRAY['1:1']::text[], 'pending_review', 'Codex'),
  ('Elcana era numit efratit.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 1, 1, '1 Samuel', ARRAY['1:1']::text[], 'pending_review', 'Codex'),
  ('Ana avea copii.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 1, 1, '1 Samuel', ARRAY['1:2']::text[], 'pending_review', 'Codex'),
  ('Hofni și Fineas erau fiii lui Eli și preoți ai Domnului.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 1, 2, '1 Samuel', ARRAY['1:3']::text[], 'pending_review', 'Codex'),
  ('Elcana dădea părți fiilor și fiicelor pe care îi avea cu Ana.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 1, 2, '1 Samuel', ARRAY['1:2', '1:4']::text[], 'pending_review', 'Codex'),
  ('Elcana îi dădea Anei o parte îndoită.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 1, 1, '1 Samuel', ARRAY['1:5']::text[], 'pending_review', 'Codex'),
  ('Textul spune că Domnul o făcuse pe Ana stearpă.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 1, 1, '1 Samuel', ARRAY['1:5']::text[], 'pending_review', 'Codex'),
  ('Potrivnica o necăjea pe Ana ca s-o facă să se mânie.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 1, 2, '1 Samuel', ARRAY['1:6']::text[], 'pending_review', 'Codex'),
  ('Ana plângea și nu mânca.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 1, 1, '1 Samuel', ARRAY['1:7']::text[], 'pending_review', 'Codex'),
  ('Elcana a întrebat-o pe Ana dacă el nu prețuia pentru ea mai mult decât zece fii.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 1, 2, '1 Samuel', ARRAY['1:8']::text[], 'pending_review', 'Codex'),
  ('Ana s-a ridicat după ce au mâncat și au băut la Silo.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 1, 2, '1 Samuel', ARRAY['1:9']::text[], 'pending_review', 'Codex'),
  ('Eli ședea pe un scaun lângă unul dintre ușorii Templului Domnului.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 1, 2, '1 Samuel', ARRAY['1:9']::text[], 'pending_review', 'Codex'),
  ('Ana se ruga Domnului cu sufletul amărât și plângea.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 1, 1, '1 Samuel', ARRAY['1:10']::text[], 'pending_review', 'Codex'),
  ('Ana a promis că îl va închina Domnului pe copil pentru toate zilele vieții lui.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 1, 2, '1 Samuel', ARRAY['1:11']::text[], 'pending_review', 'Codex'),
  ('Ana a spus că un brici va trece peste capul copilului.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 1, 1, '1 Samuel', ARRAY['1:11']::text[], 'pending_review', 'Codex'),
  ('Ana a stat multă vreme în rugăciune înaintea Domnului.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 1, 1, '1 Samuel', ARRAY['1:12']::text[], 'pending_review', 'Codex'),
  ('Ana vorbea în inima ei, își mișca buzele, dar nu i se auzea glasul.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 1, 2, '1 Samuel', ARRAY['1:13']::text[], 'pending_review', 'Codex'),
  ('Eli a întrebat-o pe Ana până când va fi beată.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 1, 2, '1 Samuel', ARRAY['1:14']::text[], 'pending_review', 'Codex'),
  ('Ana a spus că nu băuse nici vin, nici băutură amețitoare.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 1, 2, '1 Samuel', ARRAY['1:15']::text[], 'pending_review', 'Codex'),
  ('Ana a spus că își vărsa sufletul înaintea Domnului.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 1, 2, '1 Samuel', ARRAY['1:15']::text[], 'pending_review', 'Codex'),
  ('Ana i-a cerut lui Eli să nu o socotească o femeie stricată.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 1, 2, '1 Samuel', ARRAY['1:16']::text[], 'pending_review', 'Codex'),
  ('Eli i-a spus Anei să meargă în pace.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 1, 1, '1 Samuel', ARRAY['1:17']::text[], 'pending_review', 'Codex'),
  ('După ce a plecat, Ana a mâncat.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 1, 1, '1 Samuel', ARRAY['1:18']::text[], 'pending_review', 'Codex'),
  ('S-au sculat devreme, s-au închinat înaintea Domnului și s-au întors acasă, la Rama.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 1, 3, '1 Samuel', ARRAY['1:19']::text[], 'pending_review', 'Codex'),
  ('Ana a rămas însărcinată și a născut un fiu.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 1, 2, '1 Samuel', ARRAY['1:20']::text[], 'pending_review', 'Codex'),
  ('Ana a spus că îl ceruse de la Domnul.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 1, 2, '1 Samuel', ARRAY['1:20']::text[], 'pending_review', 'Codex'),
  ('Elcana s-a dus cu toată casa lui să aducă jertfa de peste an și să-și împlinească juruința.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 1, 3, '1 Samuel', ARRAY['1:21']::text[], 'pending_review', 'Codex'),
  ('Ana nu s-a suit atunci și a spus că îl va duce pe copil înaintea Domnului după ce îl va înțărca.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 1, 2, '1 Samuel', ARRAY['1:22']::text[], 'pending_review', 'Codex'),
  ('Ana a rămas acasă și și-a alăptat fiul până l-a înțărcat.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 1, 2, '1 Samuel', ARRAY['1:23']::text[], 'pending_review', 'Codex'),
  ('Ana l-a dus pe copil la Casa Domnului, la Silo, când el era încă foarte mic.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 1, 2, '1 Samuel', ARRAY['1:24']::text[], 'pending_review', 'Codex'),
  ('După ce au înjunghiat taurii, au dus copilul la Eli.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 1, 2, '1 Samuel', ARRAY['1:25']::text[], 'pending_review', 'Codex'),
  ('Ana i-a spus lui Eli că ea era femeia care stătuse lângă el și se rugase Domnului.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 1, 2, '1 Samuel', ARRAY['1:26']::text[], 'pending_review', 'Codex'),
  ('Ana a spus că se rugase pentru copilul acesta și că Domnul îi ascultase rugăciunea.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 1, 2, '1 Samuel', ARRAY['1:27']::text[], 'pending_review', 'Codex'),
  ('Ana a spus că toată viața copilului va fi dată Domnului.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 1, 2, '1 Samuel', ARRAY['1:28']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 1, ARRAY['1:1']::text[], 'pending_review', 'Cine era tatăl lui Elcana?'),
  ('1 Samuel', 1, ARRAY['1:2']::text[], 'pending_review', 'Câte neveste avea Elcana?'),
  ('1 Samuel', 1, ARRAY['1:2']::text[], 'pending_review', 'Care dintre cele două neveste avea copii?'),
  ('1 Samuel', 1, ARRAY['1:3']::text[], 'pending_review', 'La ce loc se ducea Elcana în fiecare an?'),
  ('1 Samuel', 1, ARRAY['1:4']::text[], 'pending_review', 'Cui dădea Elcana părți când aducea jertfa?'),
  ('1 Samuel', 1, ARRAY['1:5']::text[], 'pending_review', 'De ce îi dădea Elcana Anei o parte îndoită?'),
  ('1 Samuel', 1, ARRAY['1:6']::text[], 'pending_review', 'Potrivit textului, de ce o înțepa potrivnica pe Ana?'),
  ('1 Samuel', 1, ARRAY['1:7']::text[], 'pending_review', 'Când o necăjea Penina pe Ana?'),
  ('1 Samuel', 1, ARRAY['1:8']::text[], 'pending_review', 'Ce relație avea Elcana cu Ana?'),
  ('1 Samuel', 1, ARRAY['1:8']::text[], 'pending_review', 'Cu câți fii și-a comparat Elcana valoarea pentru Ana?'),
  ('1 Samuel', 1, ARRAY['1:10']::text[], 'pending_review', 'Cui se ruga Ana?'),
  ('1 Samuel', 1, ARRAY['1:11']::text[], 'pending_review', 'Ce fel de copil i-a cerut Ana Domnului?'),
  ('1 Samuel', 1, ARRAY['1:12']::text[], 'pending_review', 'La ce se uita Eli cu băgare de seamă?'),
  ('1 Samuel', 1, ARRAY['1:13']::text[], 'pending_review', 'Ce credea Eli despre Ana?'),
  ('1 Samuel', 1, ARRAY['1:14']::text[], 'pending_review', 'Ce i-a spus Eli Anei să facă?'),
  ('1 Samuel', 1, ARRAY['1:15']::text[], 'pending_review', 'Cum s-a descris Ana?'),
  ('1 Samuel', 1, ARRAY['1:17']::text[], 'pending_review', 'Ce i-a spus Eli Anei?'),
  ('1 Samuel', 1, ARRAY['1:18']::text[], 'pending_review', 'Cum era fața Anei după ce a mâncat?'),
  ('1 Samuel', 1, ARRAY['1:19']::text[], 'pending_review', 'Unde au venit acasă Elcana și Ana?'),
  ('1 Samuel', 1, ARRAY['1:19']::text[], 'pending_review', 'De cine Și-a adus aminte Domnul?'),
  ('1 Samuel', 1, ARRAY['1:20']::text[], 'pending_review', 'Ce nume i-a pus Ana fiului ei?'),
  ('1 Samuel', 1, ARRAY['1:21']::text[], 'pending_review', 'Cu cine s-a suit Elcana?'),
  ('1 Samuel', 1, ARRAY['1:22']::text[], 'pending_review', 'Cât urma să rămână copilul acolo, potrivit spuselor Anei?'),
  ('1 Samuel', 1, ARRAY['1:23']::text[], 'pending_review', 'Până când i-a spus Elcana Anei să aștepte?'),
  ('1 Samuel', 1, ARRAY['1:23']::text[], 'pending_review', 'Ce a spus Elcana despre cuvântul Domnului?'),
  ('1 Samuel', 1, ARRAY['1:24']::text[], 'pending_review', 'Câți tauri a luat Ana când l-a dus pe copil la Silo?'),
  ('1 Samuel', 1, ARRAY['1:25']::text[], 'pending_review', 'La cine au dus copilul?'),
  ('1 Samuel', 1, ARRAY['1:26']::text[], 'pending_review', 'Ce făcea Ana când stătea lângă Eli?'),
  ('1 Samuel', 1, ARRAY['1:27']::text[], 'pending_review', 'Ce a făcut Domnul cu rugăciunea Anei?'),
  ('1 Samuel', 1, ARRAY['1:28']::text[], 'pending_review', 'Ce au făcut acolo înaintea Domnului?')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_abc_one (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Cine era tatăl lui Elcana?', '[{"text":"Elihu","correct":false},{"text":"Ieroham","correct":true},{"text":"Tohu","correct":false}]'::jsonb, 1, 1, '1 Samuel', ARRAY['1:1']::text[], 'pending_review', 'Codex'),
  ('Câte neveste avea Elcana?', '[{"text":"Una","correct":false},{"text":"Două","correct":true},{"text":"Trei","correct":false}]'::jsonb, 1, 1, '1 Samuel', ARRAY['1:2']::text[], 'pending_review', 'Codex'),
  ('Care dintre cele două neveste avea copii?', '[{"text":"Ana","correct":false},{"text":"Penina","correct":true},{"text":"Amândouă","correct":false}]'::jsonb, 1, 1, '1 Samuel', ARRAY['1:2']::text[], 'pending_review', 'Codex'),
  ('La ce loc se ducea Elcana în fiecare an?', '[{"text":"Silo","correct":true},{"text":"Rama","correct":false},{"text":"Ramataim-Țofim","correct":false}]'::jsonb, 1, 1, '1 Samuel', ARRAY['1:3']::text[], 'pending_review', 'Codex'),
  ('Cui dădea Elcana părți când aducea jertfa?', '[{"text":"Peninei și copiilor ei","correct":true},{"text":"Anei și copiilor ei","correct":false},{"text":"Lui Eli și fiilor lui","correct":false}]'::jsonb, 1, 2, '1 Samuel', ARRAY['1:4']::text[], 'pending_review', 'Codex'),
  ('De ce îi dădea Elcana Anei o parte îndoită?', '[{"text":"Pentru că o iubea","correct":true},{"text":"Pentru că ea avea copii","correct":false},{"text":"Pentru că Penina i-o cerea","correct":false}]'::jsonb, 1, 2, '1 Samuel', ARRAY['1:5']::text[], 'pending_review', 'Codex'),
  ('Potrivit textului, de ce o înțepa potrivnica pe Ana?', '[{"text":"Pentru că Domnul o făcuse stearpă","correct":true},{"text":"Pentru că Ana pleca la Rama","correct":false},{"text":"Pentru că Ana avea copii","correct":false}]'::jsonb, 1, 2, '1 Samuel', ARRAY['1:6']::text[], 'pending_review', 'Codex'),
  ('Când o necăjea Penina pe Ana?', '[{"text":"Când Ana se suia la Casa Domnului","correct":true},{"text":"Când Ana rămânea acasă","correct":false},{"text":"Când Elcana mergea la Rama","correct":false}]'::jsonb, 1, 2, '1 Samuel', ARRAY['1:7']::text[], 'pending_review', 'Codex'),
  ('Ce relație avea Elcana cu Ana?', '[{"text":"Era soțul ei","correct":true},{"text":"Era tatăl ei","correct":false},{"text":"Era fratele ei","correct":false}]'::jsonb, 1, 1, '1 Samuel', ARRAY['1:8']::text[], 'pending_review', 'Codex'),
  ('Cu câți fii și-a comparat Elcana valoarea pentru Ana?', '[{"text":"Cinci","correct":false},{"text":"Zece","correct":true},{"text":"Doisprezece","correct":false}]'::jsonb, 1, 1, '1 Samuel', ARRAY['1:8']::text[], 'pending_review', 'Codex'),
  ('Cui se ruga Ana?', '[{"text":"Domnului","correct":true},{"text":"Lui Eli","correct":false},{"text":"Lui Elcana","correct":false}]'::jsonb, 1, 1, '1 Samuel', ARRAY['1:10']::text[], 'pending_review', 'Codex'),
  ('Ce fel de copil i-a cerut Ana Domnului?', '[{"text":"Un copil de parte bărbătească","correct":true},{"text":"Un copil de parte femeiască","correct":false},{"text":"Doi copii","correct":false}]'::jsonb, 1, 1, '1 Samuel', ARRAY['1:11']::text[], 'pending_review', 'Codex'),
  ('La ce se uita Eli cu băgare de seamă?', '[{"text":"La gura Anei","correct":true},{"text":"La mâinile Anei","correct":false},{"text":"La ușa Templului","correct":false}]'::jsonb, 1, 1, '1 Samuel', ARRAY['1:12']::text[], 'pending_review', 'Codex'),
  ('Ce credea Eli despre Ana?', '[{"text":"Că era beată","correct":true},{"text":"Că dormea","correct":false},{"text":"Că nu auzea","correct":false}]'::jsonb, 1, 1, '1 Samuel', ARRAY['1:13']::text[], 'pending_review', 'Codex'),
  ('Ce i-a spus Eli Anei să facă?', '[{"text":"Să se trezească","correct":true},{"text":"Să mănânce","correct":false},{"text":"Să se întoarcă la Rama","correct":false}]'::jsonb, 1, 2, '1 Samuel', ARRAY['1:14']::text[], 'pending_review', 'Codex'),
  ('Cum s-a descris Ana?', '[{"text":"Ca o femeie care suferea în inima ei","correct":true},{"text":"Ca o femeie bolnavă","correct":false},{"text":"Ca o femeie care nu putea auzi","correct":false}]'::jsonb, 1, 1, '1 Samuel', ARRAY['1:15']::text[], 'pending_review', 'Codex'),
  ('Ce i-a spus Eli Anei?', '[{"text":"Să meargă în pace și ca Dumnezeul lui Israel să-i asculte rugăciunea","correct":true},{"text":"Să se întoarcă la Rama","correct":false},{"text":"Să-l ducă imediat pe copil la Silo","correct":false}]'::jsonb, 1, 2, '1 Samuel', ARRAY['1:17']::text[], 'pending_review', 'Codex'),
  ('Cum era fața Anei după ce a mâncat?', '[{"text":"Nu mai era ca înainte","correct":true},{"text":"Era plină de lacrimi","correct":false},{"text":"Era acoperită","correct":false}]'::jsonb, 1, 1, '1 Samuel', ARRAY['1:18']::text[], 'pending_review', 'Codex'),
  ('Unde au venit acasă Elcana și Ana?', '[{"text":"La Rama","correct":true},{"text":"La Silo","correct":false},{"text":"La Ramataim-Țofim","correct":false}]'::jsonb, 1, 1, '1 Samuel', ARRAY['1:19']::text[], 'pending_review', 'Codex'),
  ('De cine Și-a adus aminte Domnul?', '[{"text":"De Ana","correct":true},{"text":"De Penina","correct":false},{"text":"De Eli","correct":false}]'::jsonb, 1, 1, '1 Samuel', ARRAY['1:19']::text[], 'pending_review', 'Codex'),
  ('Ce nume i-a pus Ana fiului ei?', '[{"text":"Samuel","correct":true},{"text":"Elcana","correct":false},{"text":"Fineas","correct":false}]'::jsonb, 1, 1, '1 Samuel', ARRAY['1:20']::text[], 'pending_review', 'Codex'),
  ('Cu cine s-a suit Elcana?', '[{"text":"Cu toată casa lui","correct":true},{"text":"Numai cu Ana","correct":false},{"text":"Numai cu Eli","correct":false}]'::jsonb, 1, 1, '1 Samuel', ARRAY['1:21']::text[], 'pending_review', 'Codex'),
  ('Cât urma să rămână copilul acolo, potrivit spuselor Anei?', '[{"text":"Pentru totdeauna","correct":true},{"text":"Până la următoarea jertfă","correct":false},{"text":"Până la un an","correct":false}]'::jsonb, 1, 2, '1 Samuel', ARRAY['1:22']::text[], 'pending_review', 'Codex'),
  ('Până când i-a spus Elcana Anei să aștepte?', '[{"text":"Până la înțărcarea copilului","correct":true},{"text":"Până la întoarcerea lui Eli","correct":false},{"text":"Până la jertfa următoare","correct":false}]'::jsonb, 1, 1, '1 Samuel', ARRAY['1:23']::text[], 'pending_review', 'Codex'),
  ('Ce a spus Elcana despre cuvântul Domnului?', '[{"text":"Să-Și împlinească Domnul cuvântul","correct":true},{"text":"Să-l schimbe Domnul","correct":false},{"text":"Să-l uite Domnul","correct":false}]'::jsonb, 1, 2, '1 Samuel', ARRAY['1:23']::text[], 'pending_review', 'Codex'),
  ('Câți tauri a luat Ana când l-a dus pe copil la Silo?', '[{"text":"Doi","correct":false},{"text":"Trei","correct":true},{"text":"Cinci","correct":false}]'::jsonb, 1, 1, '1 Samuel', ARRAY['1:24']::text[], 'pending_review', 'Codex'),
  ('La cine au dus copilul?', '[{"text":"La Eli","correct":true},{"text":"La Fineas","correct":false},{"text":"La Elcana","correct":false}]'::jsonb, 1, 1, '1 Samuel', ARRAY['1:25']::text[], 'pending_review', 'Codex'),
  ('Ce făcea Ana când stătea lângă Eli?', '[{"text":"Se ruga Domnului","correct":true},{"text":"Îi vorbea lui Penina","correct":false},{"text":"Îi aducea jertfe lui Elcana","correct":false}]'::jsonb, 1, 1, '1 Samuel', ARRAY['1:26']::text[], 'pending_review', 'Codex'),
  ('Ce a făcut Domnul cu rugăciunea Anei?', '[{"text":"A ascultat-o","correct":true},{"text":"A uitat-o","correct":false},{"text":"A amânat-o","correct":false}]'::jsonb, 1, 1, '1 Samuel', ARRAY['1:27']::text[], 'pending_review', 'Codex'),
  ('Ce au făcut acolo înaintea Domnului?', '[{"text":"S-au închinat","correct":true},{"text":"Au mâncat","correct":false},{"text":"S-au întors acasă","correct":false}]'::jsonb, 1, 1, '1 Samuel', ARRAY['1:28']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 1, ARRAY['1:3']::text[], 'pending_review', 'Ce făcea Elcana la Silo?'),
  ('1 Samuel', 1, ARRAY['1:11', '1:22', '1:24', '1:25']::text[], 'pending_review', 'Care două angajamente apar în juruința Anei?'),
  ('1 Samuel', 1, ARRAY['1:15', '1:16']::text[], 'pending_review', 'Ce motive a dat Ana pentru felul în care vorbise?'),
  ('1 Samuel', 1, ARRAY['1:24']::text[], 'pending_review', 'Care dintre aceste lucruri se numără printre cele luate de Ana?')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_abc_multi (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Ce făcea Elcana la Silo?', '[{"text":"Se închina înaintea Domnului oştirilor","correct":true},{"text":"Aducea jertfe","correct":true},{"text":"Mergea să vorbească cu Fineas","correct":false}]'::jsonb, 1, 3, '1 Samuel', ARRAY['1:3']::text[], 'pending_review', 'Codex'),
  ('Care două angajamente apar în juruința Anei?', '[{"text":"Să-l închine Domnului toată viața lui","correct":true},{"text":"Să nu treacă briciul peste capul lui","correct":true},{"text":"Să-l ducă la Eli după înțărcare","correct":false}]'::jsonb, 1, 4, '1 Samuel', ARRAY['1:11', '1:22', '1:24', '1:25']::text[], 'pending_review', 'Codex'),
  ('Ce motive a dat Ana pentru felul în care vorbise?', '[{"text":"Durerea ei mare","correct":true},{"text":"Supărarea ei","correct":true},{"text":"Vinul pe care îl băuse","correct":false}]'::jsonb, 1, 3, '1 Samuel', ARRAY['1:15', '1:16']::text[], 'pending_review', 'Codex'),
  ('Care dintre aceste lucruri se numără printre cele luate de Ana?', '[{"text":"Trei tauri","correct":true},{"text":"O efă de făină","correct":true},{"text":"Două burdufuri cu vin","correct":false}]'::jsonb, 1, 3, '1 Samuel', ARRAY['1:24']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 1, ARRAY['1:1', '1:3', '1:19', '1:20', '1:25']::text[], 'pending_review', '[{"left":"Ramataim-Țofim","right":"Locul de proveniență al lui Elcana"},{"left":"Silo","right":"Locul unde Elcana se ducea să se închine și să aducă jertfe"},{"left":"Rama","right":"Locul unde s-au întors acasă"},{"left":"Samuel","right":"Numele dat fiului Anei"},{"left":"Eli","right":"Persoana la care au dus copilul"}]'::jsonb)
) as incoming (book, chapter, source_references, status, pairs)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.pairs = incoming.pairs;

insert into public.questions_match (pairs, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.pairs, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('[{"left":"Ramataim-Țofim","right":"Locul de proveniență al lui Elcana"},{"left":"Silo","right":"Locul unde Elcana se ducea să se închine și să aducă jertfe"},{"left":"Rama","right":"Locul unde s-au întors acasă"},{"left":"Samuel","right":"Numele dat fiului Anei"},{"left":"Eli","right":"Persoana la care au dus copilul"}]'::jsonb, 1, 5, '1 Samuel', ARRAY['1:1', '1:3', '1:19', '1:20', '1:25']::text[], 'pending_review', 'Codex')
) as incoming (pairs, chapter, difficulty, book, source_references, status, added_by)
where not exists (
  select 1 from public.questions_match existing
  where existing.book = incoming.book
    and existing.chapter = incoming.chapter
    and existing.source_references = incoming.source_references
    and existing.pairs = incoming.pairs
);

commit;

