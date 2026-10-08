begin;

alter table public.questions_tf add column if not exists source_references text[] not null default '{}';

alter table public.questions_abc_one add column if not exists source_references text[] not null default '{}';

alter table public.questions_abc_multi add column if not exists source_references text[] not null default '{}';

alter table public.questions_match add column if not exists source_references text[] not null default '{}';

update public.questions_tf as existing
set status = incoming.status
from (values
  ('1 Samuel', 2, ARRAY['2:1']::text[], 'pending_review', 'În cântarea ei, Ana spune că inima i se bucură în Domnul și că puterea i-a fost înălțată de El.'),
  ('1 Samuel', 2, ARRAY['2:2']::text[], 'pending_review', 'Ana spune că există un alt Dumnezeu în afară de Domnul.'),
  ('1 Samuel', 2, ARRAY['2:3']::text[], 'pending_review', 'În cântarea Anei, Domnul nu cunoaște faptele oamenilor.'),
  ('1 Samuel', 2, ARRAY['2:4']::text[], 'pending_review', 'Ana spune că arcul celor puternici s-a întărit, iar cei slabi au rămas fără putere.'),
  ('1 Samuel', 2, ARRAY['2:5']::text[], 'pending_review', 'În cântarea Anei, cei flămânzi se închiriază pentru pâine, iar cei sătui se odihnesc.'),
  ('1 Samuel', 2, ARRAY['2:5']::text[], 'pending_review', 'Ana spune că femeia stearpă naște de șapte ori, iar femeia care avea mulți copii stă lâncezită.'),
  ('1 Samuel', 2, ARRAY['2:6']::text[], 'pending_review', 'Ana spune despre Domnul că omoară, dar nu înviază.'),
  ('1 Samuel', 2, ARRAY['2:7']::text[], 'pending_review', 'În cântarea Anei, Domnul sărăcește și îmbogățește, smerește și înalță.'),
  ('1 Samuel', 2, ARRAY['2:8']::text[], 'pending_review', 'Domnul ridică din pulbere pe cel sărac și din gunoi pe cel lipsit.'),
  ('1 Samuel', 2, ARRAY['2:9']::text[], 'pending_review', 'Cântarea spune că omul va birui prin puterea sa.'),
  ('1 Samuel', 2, ARRAY['2:10']::text[], 'pending_review', 'Cântarea spune că Domnul va judeca numai poporul Israel.'),
  ('1 Samuel', 2, ARRAY['2:11']::text[], 'pending_review', 'Elcana s-a dus acasă la Rama, iar Samuel a rămas în slujba Domnului înaintea preotului Eli.'),
  ('1 Samuel', 2, ARRAY['2:12']::text[], 'pending_review', 'Textul spune că fiii lui Eli Îl cunoșteau pe Domnul.'),
  ('1 Samuel', 2, ARRAY['2:13']::text[], 'pending_review', 'Slujitorul preotului venea când se fierbea carnea și ținea în mână o furculiță cu trei coarne.'),
  ('1 Samuel', 2, ARRAY['2:14']::text[], 'pending_review', 'Preotul lua doar grăsimea și lăsa carnea prinsă de furculiță.'),
  ('1 Samuel', 2, ARRAY['2:15']::text[], 'pending_review', 'Înainte de arderea grăsimii, sluga preotului cerea carne fiartă, nu carne crudă.'),
  ('1 Samuel', 2, ARRAY['2:16']::text[], 'pending_review', 'Când omul spunea să ia ce-i place după arderea grăsimii, sluga cerea să i se dea atunci și amenința că altfel ia cu sila.'),
  ('1 Samuel', 2, ARRAY['2:17']::text[], 'pending_review', 'Tinerii se făceau vinovați înaintea Domnului deoarece nesocoteau darurile Lui.'),
  ('1 Samuel', 2, ARRAY['2:18']::text[], 'pending_review', 'Samuel slujea înaintea Domnului și purta un efod de lână.'),
  ('1 Samuel', 2, ARRAY['2:19']::text[], 'pending_review', 'Mama lui Samuel îi făcea în fiecare an o mantie mică.'),
  ('1 Samuel', 2, ARRAY['2:19']::text[], 'pending_review', 'Mama îi aducea mantia lui Samuel când urca singură la jertfă, fără soțul ei.'),
  ('1 Samuel', 2, ARRAY['2:20']::text[], 'pending_review', 'Eli i-a binecuvântat pe Elcana și pe soția lui, cerând Domnului să le dea copii din femeia aceasta.'),
  ('1 Samuel', 2, ARRAY['2:21']::text[], 'pending_review', 'După ce Domnul a cercetat-o pe Ana, ea a născut doi fii și trei fiice.'),
  ('1 Samuel', 2, ARRAY['2:22']::text[], 'pending_review', 'Eli a aflat că fiii lui se culcau cu femeile care slujeau la ușa cortului întâlnirii.'),
  ('1 Samuel', 2, ARRAY['2:24']::text[], 'pending_review', 'Eli le-a spus fiilor că faptele lor îi făceau pe slujitorii cortului să păcătuiască.'),
  ('1 Samuel', 2, ARRAY['2:25']::text[], 'pending_review', 'Fiii lui Eli au ascultat de glasul tatălui lor.'),
  ('1 Samuel', 2, ARRAY['2:26']::text[], 'pending_review', 'Tânărul Samuel creștea mereu și era plăcut Domnului și oamenilor.'),
  ('1 Samuel', 2, ARRAY['2:27']::text[], 'pending_review', 'Omul lui Dumnezeu i-a spus lui Eli că Domnul Se descoperise casei tatălui său în Egipt, în casa lui Faraon.'),
  ('1 Samuel', 2, ARRAY['2:28']::text[], 'pending_review', 'Mesajul spune că Domnul îl alesese pe preot dintre toate semințiile lui Israel pentru slujba Sa.'),
  ('1 Samuel', 2, ARRAY['2:28']::text[], 'pending_review', 'Domnul spune că dăduse casei tatălui lui Eli toate jertfele mistuite de foc aduse de copiii lui Israel.'),
  ('1 Samuel', 2, ARRAY['2:29']::text[], 'pending_review', 'Domnul l-a întrebat pe Eli de ce Îl cinstește pe El mai mult decât pe fiii săi.'),
  ('1 Samuel', 2, ARRAY['2:30']::text[], 'pending_review', 'Domnul spune că îi va cinsti pe cei care Îl cinstesc, iar cei care Îl disprețuiesc vor fi disprețuiți.'),
  ('1 Samuel', 2, ARRAY['2:31']::text[], 'pending_review', 'Mesajul anunță că în casa lui Eli nu va mai fi niciun bătrân.'),
  ('1 Samuel', 2, ARRAY['2:32']::text[], 'pending_review', 'Domnul a spus că Eli va vedea un potrivnic în locașul Domnului, în timp ce Israel va fi copleșit de bunătăți.'),
  ('1 Samuel', 2, ARRAY['2:33']::text[], 'pending_review', 'Domnul va lăsa să rămână la altar numai unul din casa lui Eli, iar ceilalți vor muri în floarea vârstei.'),
  ('1 Samuel', 2, ARRAY['2:34']::text[], 'pending_review', 'Semnul anunțat pentru Hofni și Fineas era că amândoi vor muri într-o zi.'),
  ('1 Samuel', 2, ARRAY['2:35']::text[], 'pending_review', 'Domnul va pune un preot credincios care va lucra după inima și sufletul Lui.'),
  ('1 Samuel', 2, ARRAY['2:36']::text[], 'pending_review', 'Cine va rămâne din casa lui Eli va cere o slujbă împărătească pentru a avea pâine de mâncat.')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_tf (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('În cântarea ei, Ana spune că inima i se bucură în Domnul și că puterea i-a fost înălțată de El.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 2, 1, '1 Samuel', ARRAY['2:1']::text[], 'pending_review', 'Codex'),
  ('Ana spune că există un alt Dumnezeu în afară de Domnul.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 2, 1, '1 Samuel', ARRAY['2:2']::text[], 'pending_review', 'Codex'),
  ('În cântarea Anei, Domnul nu cunoaște faptele oamenilor.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 2, 2, '1 Samuel', ARRAY['2:3']::text[], 'pending_review', 'Codex'),
  ('Ana spune că arcul celor puternici s-a întărit, iar cei slabi au rămas fără putere.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 2, 2, '1 Samuel', ARRAY['2:4']::text[], 'pending_review', 'Codex'),
  ('În cântarea Anei, cei flămânzi se închiriază pentru pâine, iar cei sătui se odihnesc.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 2, 2, '1 Samuel', ARRAY['2:5']::text[], 'pending_review', 'Codex'),
  ('Ana spune că femeia stearpă naște de șapte ori, iar femeia care avea mulți copii stă lâncezită.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 2, 2, '1 Samuel', ARRAY['2:5']::text[], 'pending_review', 'Codex'),
  ('Ana spune despre Domnul că omoară, dar nu înviază.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 2, 1, '1 Samuel', ARRAY['2:6']::text[], 'pending_review', 'Codex'),
  ('În cântarea Anei, Domnul sărăcește și îmbogățește, smerește și înalță.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 2, 2, '1 Samuel', ARRAY['2:7']::text[], 'pending_review', 'Codex'),
  ('Domnul ridică din pulbere pe cel sărac și din gunoi pe cel lipsit.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 2, 1, '1 Samuel', ARRAY['2:8']::text[], 'pending_review', 'Codex'),
  ('Cântarea spune că omul va birui prin puterea sa.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 2, 1, '1 Samuel', ARRAY['2:9']::text[], 'pending_review', 'Codex'),
  ('Cântarea spune că Domnul va judeca numai poporul Israel.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 2, 2, '1 Samuel', ARRAY['2:10']::text[], 'pending_review', 'Codex'),
  ('Elcana s-a dus acasă la Rama, iar Samuel a rămas în slujba Domnului înaintea preotului Eli.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 2, 2, '1 Samuel', ARRAY['2:11']::text[], 'pending_review', 'Codex'),
  ('Textul spune că fiii lui Eli Îl cunoșteau pe Domnul.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 2, 1, '1 Samuel', ARRAY['2:12']::text[], 'pending_review', 'Codex'),
  ('Slujitorul preotului venea când se fierbea carnea și ținea în mână o furculiță cu trei coarne.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 2, 2, '1 Samuel', ARRAY['2:13']::text[], 'pending_review', 'Codex'),
  ('Preotul lua doar grăsimea și lăsa carnea prinsă de furculiță.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 2, 1, '1 Samuel', ARRAY['2:14']::text[], 'pending_review', 'Codex'),
  ('Înainte de arderea grăsimii, sluga preotului cerea carne fiartă, nu carne crudă.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 2, 2, '1 Samuel', ARRAY['2:15']::text[], 'pending_review', 'Codex'),
  ('Când omul spunea să ia ce-i place după arderea grăsimii, sluga cerea să i se dea atunci și amenința că altfel ia cu sila.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 2, 3, '1 Samuel', ARRAY['2:16']::text[], 'pending_review', 'Codex'),
  ('Tinerii se făceau vinovați înaintea Domnului deoarece nesocoteau darurile Lui.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 2, 2, '1 Samuel', ARRAY['2:17']::text[], 'pending_review', 'Codex'),
  ('Samuel slujea înaintea Domnului și purta un efod de lână.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 2, 1, '1 Samuel', ARRAY['2:18']::text[], 'pending_review', 'Codex'),
  ('Mama lui Samuel îi făcea în fiecare an o mantie mică.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 2, 1, '1 Samuel', ARRAY['2:19']::text[], 'pending_review', 'Codex'),
  ('Mama îi aducea mantia lui Samuel când urca singură la jertfă, fără soțul ei.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 2, 2, '1 Samuel', ARRAY['2:19']::text[], 'pending_review', 'Codex'),
  ('Eli i-a binecuvântat pe Elcana și pe soția lui, cerând Domnului să le dea copii din femeia aceasta.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 2, 2, '1 Samuel', ARRAY['2:20']::text[], 'pending_review', 'Codex'),
  ('După ce Domnul a cercetat-o pe Ana, ea a născut doi fii și trei fiice.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 2, 1, '1 Samuel', ARRAY['2:21']::text[], 'pending_review', 'Codex'),
  ('Eli a aflat că fiii lui se culcau cu femeile care slujeau la ușa cortului întâlnirii.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 2, 2, '1 Samuel', ARRAY['2:22']::text[], 'pending_review', 'Codex'),
  ('Eli le-a spus fiilor că faptele lor îi făceau pe slujitorii cortului să păcătuiască.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 2, 2, '1 Samuel', ARRAY['2:24']::text[], 'pending_review', 'Codex'),
  ('Fiii lui Eli au ascultat de glasul tatălui lor.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 2, 1, '1 Samuel', ARRAY['2:25']::text[], 'pending_review', 'Codex'),
  ('Tânărul Samuel creștea mereu și era plăcut Domnului și oamenilor.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 2, 1, '1 Samuel', ARRAY['2:26']::text[], 'pending_review', 'Codex'),
  ('Omul lui Dumnezeu i-a spus lui Eli că Domnul Se descoperise casei tatălui său în Egipt, în casa lui Faraon.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 2, 2, '1 Samuel', ARRAY['2:27']::text[], 'pending_review', 'Codex'),
  ('Mesajul spune că Domnul îl alesese pe preot dintre toate semințiile lui Israel pentru slujba Sa.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 2, 2, '1 Samuel', ARRAY['2:28']::text[], 'pending_review', 'Codex'),
  ('Domnul spune că dăduse casei tatălui lui Eli toate jertfele mistuite de foc aduse de copiii lui Israel.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 2, 3, '1 Samuel', ARRAY['2:28']::text[], 'pending_review', 'Codex'),
  ('Domnul l-a întrebat pe Eli de ce Îl cinstește pe El mai mult decât pe fiii săi.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 2, 2, '1 Samuel', ARRAY['2:29']::text[], 'pending_review', 'Codex'),
  ('Domnul spune că îi va cinsti pe cei care Îl cinstesc, iar cei care Îl disprețuiesc vor fi disprețuiți.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 2, 2, '1 Samuel', ARRAY['2:30']::text[], 'pending_review', 'Codex'),
  ('Mesajul anunță că în casa lui Eli nu va mai fi niciun bătrân.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 2, 2, '1 Samuel', ARRAY['2:31']::text[], 'pending_review', 'Codex'),
  ('Domnul a spus că Eli va vedea un potrivnic în locașul Domnului, în timp ce Israel va fi copleșit de bunătăți.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 2, 3, '1 Samuel', ARRAY['2:32']::text[], 'pending_review', 'Codex'),
  ('Domnul va lăsa să rămână la altar numai unul din casa lui Eli, iar ceilalți vor muri în floarea vârstei.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 2, 3, '1 Samuel', ARRAY['2:33']::text[], 'pending_review', 'Codex'),
  ('Semnul anunțat pentru Hofni și Fineas era că amândoi vor muri într-o zi.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 2, 1, '1 Samuel', ARRAY['2:34']::text[], 'pending_review', 'Codex'),
  ('Domnul va pune un preot credincios care va lucra după inima și sufletul Lui.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 2, 2, '1 Samuel', ARRAY['2:35']::text[], 'pending_review', 'Codex'),
  ('Cine va rămâne din casa lui Eli va cere o slujbă împărătească pentru a avea pâine de mâncat.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 2, 2, '1 Samuel', ARRAY['2:36']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 2, ARRAY['2:1']::text[], 'pending_review', 'În cântarea ei, Ana spune că ce anume se bucură în Domnul?'),
  ('1 Samuel', 2, ARRAY['2:1']::text[], 'pending_review', 'Ce spune Ana că i-a fost înălțată de Domnul?'),
  ('1 Samuel', 2, ARRAY['2:2']::text[], 'pending_review', 'Cum formulează Ana comparația cu stânca în cântarea ei?'),
  ('1 Samuel', 2, ARRAY['2:3']::text[], 'pending_review', 'Ce spune Ana că face Domnul cu toate faptele?'),
  ('1 Samuel', 2, ARRAY['2:4']::text[], 'pending_review', 'Ce se întâmplă cu arcul celor puternici în cântarea Anei?'),
  ('1 Samuel', 2, ARRAY['2:5']::text[], 'pending_review', 'Ce se întâmplă cu cei flămânzi în versul despre cei sătui și flămânzi?'),
  ('1 Samuel', 2, ARRAY['2:6']::text[], 'pending_review', 'Ce face Domnul după ce coboară în Locuința morților, potrivit cântării?'),
  ('1 Samuel', 2, ARRAY['2:9']::text[], 'pending_review', 'Pe ai cui pași spune cântarea că îi păzește Domnul?'),
  ('1 Samuel', 2, ARRAY['2:10']::text[], 'pending_review', 'Ce va arunca Domnul asupra vrăjmașilor Săi din înălțimea cerului?'),
  ('1 Samuel', 2, ARRAY['2:10']::text[], 'pending_review', 'Cui spune cântarea că îi va da Domnul putere?'),
  ('1 Samuel', 2, ARRAY['2:11']::text[], 'pending_review', 'Unde s-a dus Elcana după ce copilul a rămas în slujba Domnului?'),
  ('1 Samuel', 2, ARRAY['2:11']::text[], 'pending_review', 'După ce Elcana s-a întors la Rama, înaintea cui a rămas Samuel în slujba Domnului?'),
  ('1 Samuel', 2, ARRAY['2:13']::text[], 'pending_review', 'Ce ținea în mână slujitorul preotului când venea, în timp ce carnea jertfei fierbea?'),
  ('1 Samuel', 2, ARRAY['2:14']::text[], 'pending_review', 'Ce lua preotul pentru el din vasul în care slujitorul vârâse furculița?'),
  ('1 Samuel', 2, ARRAY['2:15']::text[], 'pending_review', 'Ce fel de carne cerea slujitorul pentru preot înainte să ardă grăsimea?'),
  ('1 Samuel', 2, ARRAY['2:17']::text[], 'pending_review', 'De ce spune textul că tinerii se făceau vinovați de un păcat foarte mare?'),
  ('1 Samuel', 2, ARRAY['2:18']::text[], 'pending_review', 'Ce purta Samuel când făcea slujba înaintea Domnului?'),
  ('1 Samuel', 2, ARRAY['2:19']::text[], 'pending_review', 'Ce îi aducea anual mama lui Samuel când urca împreună cu soțul ei pentru jertfă?'),
  ('1 Samuel', 2, ARRAY['2:20']::text[], 'pending_review', 'Ce i-a cerut Eli Domnului pentru Elcana și soția lui după ce i-a binecuvântat?'),
  ('1 Samuel', 2, ARRAY['2:21']::text[], 'pending_review', 'Câți copii a născut Ana după ce Domnul a cercetat-o?'),
  ('1 Samuel', 2, ARRAY['2:22']::text[], 'pending_review', 'Unde slujeau femeile despre care Eli a aflat că fiii lui se culcau cu ele?'),
  ('1 Samuel', 2, ARRAY['2:25']::text[], 'pending_review', 'Potrivit mustrării lui Eli, cine îl va judeca pe omul care păcătuiește împotriva altui om?'),
  ('1 Samuel', 2, ARRAY['2:11', '2:26']::text[], 'pending_review', 'După plecarea lui Elcana la Rama și în relatarea despre creșterea sa, ce se spune despre Samuel?'),
  ('1 Samuel', 2, ARRAY['2:30']::text[], 'pending_review', 'Ce a spus Domnul că va face pentru omul care Îl cinstește?'),
  ('1 Samuel', 2, ARRAY['2:34']::text[], 'pending_review', 'Ce semn a fost anunțat pentru Hofni și Fineas?')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_abc_one (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('În cântarea ei, Ana spune că ce anume se bucură în Domnul?', '[{"text":"Inima ei","correct":true},{"text":"Gura ei","correct":false},{"text":"Casa ei","correct":false}]'::jsonb, 2, 1, '1 Samuel', ARRAY['2:1']::text[], 'pending_review', 'Codex'),
  ('Ce spune Ana că i-a fost înălțată de Domnul?', '[{"text":"Puterea","correct":true},{"text":"Casa","correct":false},{"text":"Pâinea","correct":false}]'::jsonb, 2, 1, '1 Samuel', ARRAY['2:1']::text[], 'pending_review', 'Codex'),
  ('Cum formulează Ana comparația cu stânca în cântarea ei?', '[{"text":"Nu este stâncă asemenea Dumnezeului nostru.","correct":true},{"text":"Există multe stânci mai tari decât Dumnezeul nostru.","correct":false},{"text":"Dumnezeul nostru nu este numit stâncă.","correct":false}]'::jsonb, 2, 1, '1 Samuel', ARRAY['2:2']::text[], 'pending_review', 'Codex'),
  ('Ce spune Ana că face Domnul cu toate faptele?', '[{"text":"Le cântărește","correct":true},{"text":"Le uită","correct":false},{"text":"Le ascunde","correct":false}]'::jsonb, 2, 2, '1 Samuel', ARRAY['2:3']::text[], 'pending_review', 'Codex'),
  ('Ce se întâmplă cu arcul celor puternici în cântarea Anei?', '[{"text":"Se sfărâmă","correct":true},{"text":"Este înălțat","correct":false},{"text":"Este pus deoparte","correct":false}]'::jsonb, 2, 1, '1 Samuel', ARRAY['2:4']::text[], 'pending_review', 'Codex'),
  ('Ce se întâmplă cu cei flămânzi în versul despre cei sătui și flămânzi?', '[{"text":"Se odihnesc","correct":true},{"text":"Se închiriază pentru pâine","correct":false},{"text":"Sunt trimiși la Silo","correct":false}]'::jsonb, 2, 1, '1 Samuel', ARRAY['2:5']::text[], 'pending_review', 'Codex'),
  ('Ce face Domnul după ce coboară în Locuința morților, potrivit cântării?', '[{"text":"Scoate de acolo","correct":true},{"text":"Îi lasă acolo","correct":false},{"text":"Îi cheamă la altar","correct":false}]'::jsonb, 2, 2, '1 Samuel', ARRAY['2:6']::text[], 'pending_review', 'Codex'),
  ('Pe ai cui pași spune cântarea că îi păzește Domnul?', '[{"text":"Pe ai preaiubiților Lui","correct":true},{"text":"Pe ai celor mândri","correct":false},{"text":"Pe ai preoților lui Eli","correct":false}]'::jsonb, 2, 1, '1 Samuel', ARRAY['2:9']::text[], 'pending_review', 'Codex'),
  ('Ce va arunca Domnul asupra vrăjmașilor Săi din înălțimea cerului?', '[{"text":"Tunetul","correct":true},{"text":"Putere asupra lor","correct":false},{"text":"O furculiță","correct":false}]'::jsonb, 2, 1, '1 Samuel', ARRAY['2:10']::text[], 'pending_review', 'Codex'),
  ('Cui spune cântarea că îi va da Domnul putere?', '[{"text":"Împăratului Său","correct":true},{"text":"Preotului Eli","correct":false},{"text":"Fiului lui Elcana","correct":false}]'::jsonb, 2, 1, '1 Samuel', ARRAY['2:10']::text[], 'pending_review', 'Codex'),
  ('Unde s-a dus Elcana după ce copilul a rămas în slujba Domnului?', '[{"text":"Acasă, la Rama","correct":true},{"text":"S-a întors la Silo","correct":false},{"text":"La casa lui Eli","correct":false}]'::jsonb, 2, 1, '1 Samuel', ARRAY['2:11']::text[], 'pending_review', 'Codex'),
  ('După ce Elcana s-a întors la Rama, înaintea cui a rămas Samuel în slujba Domnului?', '[{"text":"Preotului Eli","correct":true},{"text":"Lui Hofni","correct":false},{"text":"Lui Fineas","correct":false}]'::jsonb, 2, 1, '1 Samuel', ARRAY['2:11']::text[], 'pending_review', 'Codex'),
  ('Ce ținea în mână slujitorul preotului când venea, în timp ce carnea jertfei fierbea?', '[{"text":"O furculiță cu trei coarne","correct":true},{"text":"Un cuțit cu două tăișuri","correct":false},{"text":"Un vas cu pâine","correct":false}]'::jsonb, 2, 1, '1 Samuel', ARRAY['2:13']::text[], 'pending_review', 'Codex'),
  ('Ce lua preotul pentru el din vasul în care slujitorul vârâse furculița?', '[{"text":"Tot ce apuca furculița","correct":true},{"text":"Numai grăsimea","correct":false},{"text":"Numai carnea fiartă","correct":false}]'::jsonb, 2, 2, '1 Samuel', ARRAY['2:14']::text[], 'pending_review', 'Codex'),
  ('Ce fel de carne cerea slujitorul pentru preot înainte să ardă grăsimea?', '[{"text":"Carne crudă pentru fript","correct":true},{"text":"Carne fiartă","correct":false},{"text":"Carne păstrată pentru a doua zi","correct":false}]'::jsonb, 2, 2, '1 Samuel', ARRAY['2:15']::text[], 'pending_review', 'Codex'),
  ('De ce spune textul că tinerii se făceau vinovați de un păcat foarte mare?', '[{"text":"Nesocoteau darurile Domnului","correct":true},{"text":"Nu aduceau furculițe","correct":false},{"text":"Nu se întorceau la Rama","correct":false}]'::jsonb, 2, 2, '1 Samuel', ARRAY['2:17']::text[], 'pending_review', 'Codex'),
  ('Ce purta Samuel când făcea slujba înaintea Domnului?', '[{"text":"Un efod de in","correct":true},{"text":"O mantie mică","correct":false},{"text":"O haină de lână","correct":false}]'::jsonb, 2, 1, '1 Samuel', ARRAY['2:18']::text[], 'pending_review', 'Codex'),
  ('Ce îi aducea anual mama lui Samuel când urca împreună cu soțul ei pentru jertfă?', '[{"text":"O mantie mică","correct":true},{"text":"O furculiță","correct":false},{"text":"Un vas pentru jertfă","correct":false}]'::jsonb, 2, 1, '1 Samuel', ARRAY['2:19']::text[], 'pending_review', 'Codex'),
  ('Ce i-a cerut Eli Domnului pentru Elcana și soția lui după ce i-a binecuvântat?', '[{"text":"Să aibă copii din femeia aceasta","correct":true},{"text":"Să se mute la Silo","correct":false},{"text":"Să-l ia pe Samuel înapoi","correct":false}]'::jsonb, 2, 2, '1 Samuel', ARRAY['2:20']::text[], 'pending_review', 'Codex'),
  ('Câți copii a născut Ana după ce Domnul a cercetat-o?', '[{"text":"Trei fii și două fiice","correct":true},{"text":"Doi fii și trei fiice","correct":false},{"text":"Șapte fii","correct":false}]'::jsonb, 2, 1, '1 Samuel', ARRAY['2:21']::text[], 'pending_review', 'Codex'),
  ('Unde slujeau femeile despre care Eli a aflat că fiii lui se culcau cu ele?', '[{"text":"Afară, la ușa cortului întâlnirii","correct":true},{"text":"În casa lui Elcana","correct":false},{"text":"La poarta cetății Rama","correct":false}]'::jsonb, 2, 2, '1 Samuel', ARRAY['2:22']::text[], 'pending_review', 'Codex'),
  ('Potrivit mustrării lui Eli, cine îl va judeca pe omul care păcătuiește împotriva altui om?', '[{"text":"Dumnezeu","correct":true},{"text":"Preotul","correct":false},{"text":"Împăratul","correct":false}]'::jsonb, 2, 2, '1 Samuel', ARRAY['2:25']::text[], 'pending_review', 'Codex'),
  ('După plecarea lui Elcana la Rama și în relatarea despre creșterea sa, ce se spune despre Samuel?', '[{"text":"A rămas în slujba Domnului înaintea lui Eli și creștea plăcut Domnului și oamenilor.","correct":true},{"text":"A plecat cu Elcana la Rama și a încetat slujirea.","correct":false},{"text":"A rămas la Silo, dar nu mai slujea înaintea Domnului.","correct":false}]'::jsonb, 2, 3, '1 Samuel', ARRAY['2:11', '2:26']::text[], 'pending_review', 'Codex'),
  ('Ce a spus Domnul că va face pentru omul care Îl cinstește?', '[{"text":"Îl va cinsti","correct":true},{"text":"Îl va disprețui","correct":false},{"text":"Îl va trimite departe de altar","correct":false}]'::jsonb, 2, 1, '1 Samuel', ARRAY['2:30']::text[], 'pending_review', 'Codex'),
  ('Ce semn a fost anunțat pentru Hofni și Fineas?', '[{"text":"Amândoi vor muri într-o zi","correct":true},{"text":"Vor sluji împreună toată viața","correct":false},{"text":"Vor pleca din Silo la Rama","correct":false}]'::jsonb, 2, 1, '1 Samuel', ARRAY['2:34']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 2, ARRAY['2:1', '2:2']::text[], 'pending_review', 'Care afirmații despre Domnul sunt rostite de Ana la începutul cântării?'),
  ('1 Samuel', 2, ARRAY['2:4', '2:5']::text[], 'pending_review', 'Ce contraste despre cei puternici, cei slabi, cei sătui și cei flămânzi apar în cântarea Anei?'),
  ('1 Samuel', 2, ARRAY['2:5']::text[], 'pending_review', 'Ce afirmații din versetul despre cei sătui, cei flămânzi și femeile cu copii sunt corecte?'),
  ('1 Samuel', 2, ARRAY['2:6', '2:7']::text[], 'pending_review', 'Ce acțiuni îi atribuie cântarea Domnului în versetele despre viață și starea oamenilor?'),
  ('1 Samuel', 2, ARRAY['2:8']::text[], 'pending_review', 'Ce descrieri din cântarea Anei arată ce face Domnul cu cel sărac și cu cel lipsit?'),
  ('1 Samuel', 2, ARRAY['2:9', '2:10']::text[], 'pending_review', 'Ce spune cântarea despre cei preaiubiți ai Domnului și despre cei răi?'),
  ('1 Samuel', 2, ARRAY['2:13', '2:14']::text[], 'pending_review', 'Care detalii sunt menționate despre slujitorul preotului când se fierbea carnea?'),
  ('1 Samuel', 2, ARRAY['2:15', '2:16']::text[], 'pending_review', 'Ce cereri și răspunsuri apar în discuția dintre slujitor și omul care aducea jertfa?'),
  ('1 Samuel', 2, ARRAY['2:12', '2:17']::text[], 'pending_review', 'Care afirmații despre fiii lui Eli și darurile Domnului sunt susținute de text?'),
  ('1 Samuel', 2, ARRAY['2:18', '2:19']::text[], 'pending_review', 'Care detalii despre Samuel și mama lui apar în capitol?'),
  ('1 Samuel', 2, ARRAY['2:23', '2:24', '2:25']::text[], 'pending_review', 'Care afirmații din relatarea despre mustrarea lui Eli și răspunsul fiilor sunt corecte?'),
  ('1 Samuel', 2, ARRAY['2:28']::text[], 'pending_review', 'Ce slujiri ale preotului sunt amintite în mesajul omului lui Dumnezeu?'),
  ('1 Samuel', 2, ARRAY['2:31', '2:34', '2:36']::text[], 'pending_review', 'Ce anunțuri despre casa lui Eli apar în mesajul Domnului?'),
  ('1 Samuel', 2, ARRAY['2:35']::text[], 'pending_review', 'Ce i se promite preotului credincios în mesajul Domnului?')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_abc_multi (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Care afirmații despre Domnul sunt rostite de Ana la începutul cântării?', '[{"text":"Nimeni nu este sfânt ca Domnul.","correct":true},{"text":"Nu este alt Dumnezeu decât El.","correct":true},{"text":"Nu este stâncă asemenea Dumnezeului nostru.","correct":true}]'::jsonb, 2, 3, '1 Samuel', ARRAY['2:1', '2:2']::text[], 'pending_review', 'Codex'),
  ('Ce contraste despre cei puternici, cei slabi, cei sătui și cei flămânzi apar în cântarea Anei?', '[{"text":"Arcul celor puternici s-a sfărâmat.","correct":true},{"text":"Cei slabi sunt încinși cu putere.","correct":true},{"text":"Cei flămânzi se închiriază pentru pâine.","correct":false}]'::jsonb, 2, 3, '1 Samuel', ARRAY['2:4', '2:5']::text[], 'pending_review', 'Codex'),
  ('Ce afirmații din versetul despre cei sătui, cei flămânzi și femeile cu copii sunt corecte?', '[{"text":"Cei sătui se închiriază pentru pâine.","correct":true},{"text":"Cei flămânzi se odihnesc.","correct":true},{"text":"Femeia care avea mulți copii naște de șapte ori.","correct":false}]'::jsonb, 2, 3, '1 Samuel', ARRAY['2:5']::text[], 'pending_review', 'Codex'),
  ('Ce acțiuni îi atribuie cântarea Domnului în versetele despre viață și starea oamenilor?', '[{"text":"Omoară și înviază.","correct":true},{"text":"Coboară în Locuința morților și scoate de acolo.","correct":true},{"text":"Sărăcește și îmbogățește.","correct":true}]'::jsonb, 2, 3, '1 Samuel', ARRAY['2:6', '2:7']::text[], 'pending_review', 'Codex'),
  ('Ce descrieri din cântarea Anei arată ce face Domnul cu cel sărac și cu cel lipsit?', '[{"text":"Cel sărac este ridicat din pulbere.","correct":true},{"text":"Cel lipsit este ridicat din gunoi.","correct":true},{"text":"Sunt așezați alături de cei mari.","correct":true}]'::jsonb, 2, 3, '1 Samuel', ARRAY['2:8']::text[], 'pending_review', 'Codex'),
  ('Ce spune cântarea despre cei preaiubiți ai Domnului și despre cei răi?', '[{"text":"Domnul va păzi pașii preaiubiților Lui.","correct":true},{"text":"Cei răi vor fi nimiciți în întuneric.","correct":true},{"text":"Omul va birui prin putere.","correct":false}]'::jsonb, 2, 3, '1 Samuel', ARRAY['2:9', '2:10']::text[], 'pending_review', 'Codex'),
  ('Care detalii sunt menționate despre slujitorul preotului când se fierbea carnea?', '[{"text":"Venea în clipa când se fierbea carnea.","correct":true},{"text":"Ținea în mână o furculiță cu trei coarne.","correct":true},{"text":"Vârâa furculița în vasele folosite pentru gătit.","correct":true}]'::jsonb, 2, 3, '1 Samuel', ARRAY['2:13', '2:14']::text[], 'pending_review', 'Codex'),
  ('Ce cereri și răspunsuri apar în discuția dintre slujitor și omul care aducea jertfa?', '[{"text":"Slujitorul cere carne de fript și spune că preotul nu va lua carne fiartă.","correct":true},{"text":"Omul spune că slujitorul poate lua ce-i place după ce se arde grăsimea.","correct":true},{"text":"Slujitorul acceptă să aștepte până se arde grăsimea.","correct":false}]'::jsonb, 2, 3, '1 Samuel', ARRAY['2:15', '2:16']::text[], 'pending_review', 'Codex'),
  ('Care afirmații despre fiii lui Eli și darurile Domnului sunt susținute de text?', '[{"text":"Fiii lui Eli erau oameni răi.","correct":true},{"text":"Ei nu-L cunoșteau pe Domnul.","correct":true},{"text":"Tinerii nesocoteau darurile Domnului.","correct":true}]'::jsonb, 2, 3, '1 Samuel', ARRAY['2:12', '2:17']::text[], 'pending_review', 'Codex'),
  ('Care detalii despre Samuel și mama lui apar în capitol?', '[{"text":"Samuel făcea slujba înaintea Domnului.","correct":true},{"text":"Samuel purta un efod de in.","correct":true},{"text":"Mama lui îi făcea în fiecare an o mantie mică.","correct":true}]'::jsonb, 2, 3, '1 Samuel', ARRAY['2:18', '2:19']::text[], 'pending_review', 'Codex'),
  ('Care afirmații din relatarea despre mustrarea lui Eli și răspunsul fiilor sunt corecte?', '[{"text":"Aflase de la popor despre faptele lor rele.","correct":true},{"text":"Faptele lor făceau poporul Domnului să păcătuiască.","correct":true},{"text":"Ei ascultaseră de glasul tatălui lor.","correct":false}]'::jsonb, 2, 4, '1 Samuel', ARRAY['2:23', '2:24', '2:25']::text[], 'pending_review', 'Codex'),
  ('Ce slujiri ale preotului sunt amintite în mesajul omului lui Dumnezeu?', '[{"text":"Să se suie la altarul Domnului.","correct":true},{"text":"Să ardă tămâia.","correct":true},{"text":"Să poarte efodul înaintea Domnului.","correct":true}]'::jsonb, 2, 4, '1 Samuel', ARRAY['2:28']::text[], 'pending_review', 'Codex'),
  ('Ce anunțuri despre casa lui Eli apar în mesajul Domnului?', '[{"text":"Nu va mai fi niciun bătrân în casa lui.","correct":true},{"text":"Hofni și Fineas vor muri amândoi într-o zi.","correct":true},{"text":"Cei rămași vor cere o slujbă preoțească pentru o bucată de pâine.","correct":true}]'::jsonb, 2, 4, '1 Samuel', ARRAY['2:31', '2:34', '2:36']::text[], 'pending_review', 'Codex'),
  ('Ce i se promite preotului credincios în mesajul Domnului?', '[{"text":"Va lucra după inima și sufletul Domnului.","correct":true},{"text":"Domnul îi va zidi o casă stătătoare.","correct":true},{"text":"Va umbla totdeauna înaintea Unsului Domnului.","correct":true}]'::jsonb, 2, 4, '1 Samuel', ARRAY['2:35']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 2, ARRAY['2:4', '2:5']::text[], 'pending_review', '[{"left":"Arcul celor puternici","right":"S-a sfărâmat"},{"left":"Cei slabi","right":"Sunt încinși cu putere"},{"left":"Cei sătui","right":"Se închiriază pentru pâine"},{"left":"Cei flămânzi","right":"Se odihnesc"},{"left":"Femeia stearpă","right":"Naște de șapte ori"}]'::jsonb),
  ('1 Samuel', 2, ARRAY['2:6', '2:7', '2:9']::text[], 'pending_review', '[{"left":"Domnul omoară","right":"Și înviază"},{"left":"Domnul coboară în Locuința morților","right":"Scoate de acolo"},{"left":"Domnul sărăcește","right":"Și îmbogățește"},{"left":"Domnul smerește","right":"Și înalță"},{"left":"Pașii preaiubiților Lui","right":"Domnul îi păzește"}]'::jsonb),
  ('1 Samuel', 2, ARRAY['2:8']::text[], 'pending_review', '[{"left":"Cel sărac","right":"Este ridicat din pulbere"},{"left":"Cel lipsit","right":"Este ridicat din gunoi"},{"left":"Cei mari","right":"Alături de ei sunt așezați cei ridicați"},{"left":"Moștenirea dată","right":"Un scaun de domnie îmbrăcat cu slavă"},{"left":"Stâlpii pământului","right":"Ai Domnului sunt"}]'::jsonb),
  ('1 Samuel', 2, ARRAY['2:13', '2:14', '2:15', '2:16']::text[], 'pending_review', '[{"left":"Slujitorul preotului","right":"Venea când se fierbea carnea"},{"left":"Furculița din mâna slujitorului","right":"Avea trei coarne"},{"left":"Preotul","right":"Lua pentru el tot ce apuca furculița"},{"left":"Înainte de arderea grăsimii","right":"Slujitorul cerea carne de fript"},{"left":"„Dă-mi acum”, spunea slujitorul","right":"Altfel amenința că ia cu sila"}]'::jsonb),
  ('1 Samuel', 2, ARRAY['2:11', '2:19', '2:20', '2:21']::text[], 'pending_review', '[{"left":"Elcana","right":"S-a dus acasă, la Rama"},{"left":"Samuel","right":"A rămas în slujba Domnului înaintea lui Eli"},{"left":"Mama lui Samuel","right":"Îi făcea în fiecare an o mantie mică"},{"left":"Eli","right":"I-a binecuvântat pe Elcana și pe soția lui"},{"left":"Ana","right":"A născut trei fii și două fiice după ce Domnul a cercetat-o"}]'::jsonb),
  ('1 Samuel', 2, ARRAY['2:12', '2:17', '2:22', '2:26', '2:34']::text[], 'pending_review', '[{"left":"Fiii lui Eli","right":"Erau oameni răi și nu-L cunoșteau pe Domnul"},{"left":"Hofni și Fineas","right":"Amândoi urmau să moară într-o zi"},{"left":"Femeile de la ușa cortului","right":"Fiii lui Eli se culcau cu ele"},{"left":"Darurile Domnului","right":"Erau nesocotite de tineri"},{"left":"Tânărul Samuel","right":"Era plăcut Domnului și oamenilor"}]'::jsonb),
  ('1 Samuel', 2, ARRAY['2:28']::text[], 'pending_review', '[{"left":"Alesul Domnului","right":"Este ales dintre toate semințiile lui Israel"},{"left":"Slujirea amintită","right":"Să fie preot în slujba Domnului"},{"left":"Altarul Domnului","right":"La el se suie preotul ales"},{"left":"Tămâia","right":"Este arsă înaintea Domnului"},{"left":"Efodul","right":"Este purtat înaintea Domnului"}]'::jsonb),
  ('1 Samuel', 2, ARRAY['2:31', '2:33', '2:35', '2:36']::text[], 'pending_review', '[{"left":"Casa lui Eli","right":"Nu va mai avea niciun bătrân"},{"left":"Unul dintre cei rămași","right":"Va rămâne la altar"},{"left":"Ceilalți din casa lui","right":"Vor muri în floarea vârstei"},{"left":"Preotul credincios","right":"Va lucra după inima și sufletul Domnului"},{"left":"Cei rămași din casa lui Eli","right":"Vor cere o slujbă preoțească și o bucată de pâine"}]'::jsonb)
) as incoming (book, chapter, source_references, status, pairs)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.pairs = incoming.pairs;

insert into public.questions_match (pairs, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.pairs, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('[{"left":"Arcul celor puternici","right":"S-a sfărâmat"},{"left":"Cei slabi","right":"Sunt încinși cu putere"},{"left":"Cei sătui","right":"Se închiriază pentru pâine"},{"left":"Cei flămânzi","right":"Se odihnesc"},{"left":"Femeia stearpă","right":"Naște de șapte ori"}]'::jsonb, 2, 4, '1 Samuel', ARRAY['2:4', '2:5']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Domnul omoară","right":"Și înviază"},{"left":"Domnul coboară în Locuința morților","right":"Scoate de acolo"},{"left":"Domnul sărăcește","right":"Și îmbogățește"},{"left":"Domnul smerește","right":"Și înalță"},{"left":"Pașii preaiubiților Lui","right":"Domnul îi păzește"}]'::jsonb, 2, 4, '1 Samuel', ARRAY['2:6', '2:7', '2:9']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Cel sărac","right":"Este ridicat din pulbere"},{"left":"Cel lipsit","right":"Este ridicat din gunoi"},{"left":"Cei mari","right":"Alături de ei sunt așezați cei ridicați"},{"left":"Moștenirea dată","right":"Un scaun de domnie îmbrăcat cu slavă"},{"left":"Stâlpii pământului","right":"Ai Domnului sunt"}]'::jsonb, 2, 4, '1 Samuel', ARRAY['2:8']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Slujitorul preotului","right":"Venea când se fierbea carnea"},{"left":"Furculița din mâna slujitorului","right":"Avea trei coarne"},{"left":"Preotul","right":"Lua pentru el tot ce apuca furculița"},{"left":"Înainte de arderea grăsimii","right":"Slujitorul cerea carne de fript"},{"left":"„Dă-mi acum”, spunea slujitorul","right":"Altfel amenința că ia cu sila"}]'::jsonb, 2, 4, '1 Samuel', ARRAY['2:13', '2:14', '2:15', '2:16']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Elcana","right":"S-a dus acasă, la Rama"},{"left":"Samuel","right":"A rămas în slujba Domnului înaintea lui Eli"},{"left":"Mama lui Samuel","right":"Îi făcea în fiecare an o mantie mică"},{"left":"Eli","right":"I-a binecuvântat pe Elcana și pe soția lui"},{"left":"Ana","right":"A născut trei fii și două fiice după ce Domnul a cercetat-o"}]'::jsonb, 2, 4, '1 Samuel', ARRAY['2:11', '2:19', '2:20', '2:21']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Fiii lui Eli","right":"Erau oameni răi și nu-L cunoșteau pe Domnul"},{"left":"Hofni și Fineas","right":"Amândoi urmau să moară într-o zi"},{"left":"Femeile de la ușa cortului","right":"Fiii lui Eli se culcau cu ele"},{"left":"Darurile Domnului","right":"Erau nesocotite de tineri"},{"left":"Tânărul Samuel","right":"Era plăcut Domnului și oamenilor"}]'::jsonb, 2, 5, '1 Samuel', ARRAY['2:12', '2:17', '2:22', '2:26', '2:34']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Alesul Domnului","right":"Este ales dintre toate semințiile lui Israel"},{"left":"Slujirea amintită","right":"Să fie preot în slujba Domnului"},{"left":"Altarul Domnului","right":"La el se suie preotul ales"},{"left":"Tămâia","right":"Este arsă înaintea Domnului"},{"left":"Efodul","right":"Este purtat înaintea Domnului"}]'::jsonb, 2, 5, '1 Samuel', ARRAY['2:28']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Casa lui Eli","right":"Nu va mai avea niciun bătrân"},{"left":"Unul dintre cei rămași","right":"Va rămâne la altar"},{"left":"Ceilalți din casa lui","right":"Vor muri în floarea vârstei"},{"left":"Preotul credincios","right":"Va lucra după inima și sufletul Domnului"},{"left":"Cei rămași din casa lui Eli","right":"Vor cere o slujbă preoțească și o bucată de pâine"}]'::jsonb, 2, 5, '1 Samuel', ARRAY['2:31', '2:33', '2:35', '2:36']::text[], 'pending_review', 'Codex')
) as incoming (pairs, chapter, difficulty, book, source_references, status, added_by)
where not exists (
  select 1 from public.questions_match existing
  where existing.book = incoming.book
    and existing.chapter = incoming.chapter
    and existing.source_references = incoming.source_references
    and existing.pairs = incoming.pairs
);

commit;

