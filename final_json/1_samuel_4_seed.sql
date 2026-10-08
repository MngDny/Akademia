begin;

alter table public.questions_tf add column if not exists source_references text[] not null default '{}';

alter table public.questions_abc_one add column if not exists source_references text[] not null default '{}';

alter table public.questions_abc_multi add column if not exists source_references text[] not null default '{}';

alter table public.questions_match add column if not exists source_references text[] not null default '{}';

update public.questions_tf as existing
set status = incoming.status
from (values
  ('1 Samuel', 4, ARRAY['4:1']::text[], 'pending_review', 'Chemarea lui Samuel ajunsese la cunoștința întregului Israel.'),
  ('1 Samuel', 4, ARRAY['4:1']::text[], 'pending_review', 'Israel a tăbărât la Afec, iar filistenii lângă Eben-Ezer.'),
  ('1 Samuel', 4, ARRAY['4:2']::text[], 'pending_review', 'În prima luptă, filistenii au omorât pe câmpul de bătaie aproape patru mii de oameni din Israel.'),
  ('1 Samuel', 4, ARRAY['4:3']::text[], 'pending_review', 'După prima înfrângere, bătrânii lui Israel au propus să aducă chivotul de la Silo.'),
  ('1 Samuel', 4, ARRAY['4:3']::text[], 'pending_review', 'Bătrânii au spus că vor să aducă chivotul în tabără ca să-i izbăvească din mâna vrăjmașilor.'),
  ('1 Samuel', 4, ARRAY['4:4']::text[], 'pending_review', 'Hofni și Fineas erau la Silo împreună cu chivotul legământului lui Dumnezeu.'),
  ('1 Samuel', 4, ARRAY['4:5']::text[], 'pending_review', 'Când chivotul a intrat în tabără, tot Israelul a tăcut, iar pământul s-a cutremurat.'),
  ('1 Samuel', 4, ARRAY['4:6']::text[], 'pending_review', 'Filistenii au auzit strigătele din tabăra evreilor și au aflat că sosise chivotul Domnului.'),
  ('1 Samuel', 4, ARRAY['4:7']::text[], 'pending_review', 'Filistenii au spus că mai trecuseră printr-o asemenea situație înainte.'),
  ('1 Samuel', 4, ARRAY['4:8']::text[], 'pending_review', 'În vorbirea lor, filistenii au amintit că dumnezeii aceștia îi loviseră pe egipteni cu urgii în pustie.'),
  ('1 Samuel', 4, ARRAY['4:9']::text[], 'pending_review', 'Filistenii s-au îndemnat unii pe alții să lupte, ca să nu ajungă robi evreilor.'),
  ('1 Samuel', 4, ARRAY['4:10']::text[], 'pending_review', 'În a doua luptă, fiecare israelit a fugit în cortul lui.'),
  ('1 Samuel', 4, ARRAY['4:10']::text[], 'pending_review', 'În a doua înfrângere au căzut treizeci de mii de oameni pedeștri din Israel.'),
  ('1 Samuel', 4, ARRAY['4:11']::text[], 'pending_review', 'După luptă, chivotul lui Dumnezeu a fost luat, iar Hofni și Fineas au murit.'),
  ('1 Samuel', 4, ARRAY['4:12']::text[], 'pending_review', 'Omul care a adus vestea la Silo era din Beniamin și a ajuns în aceeași zi.'),
  ('1 Samuel', 4, ARRAY['4:13']::text[], 'pending_review', 'Eli aștepta la drum fără să fie neliniștit pentru chivotul lui Dumnezeu.'),
  ('1 Samuel', 4, ARRAY['4:15']::text[], 'pending_review', 'Eli avea nouăzeci și opt de ani și nu mai putea să vadă.'),
  ('1 Samuel', 4, ARRAY['4:16']::text[], 'pending_review', 'Omul i-a spus lui Eli că venea de pe câmpul de bătaie și fugise în acea zi.'),
  ('1 Samuel', 4, ARRAY['4:17', '4:18']::text[], 'pending_review', 'Eli a căzut de pe scaun în momentul în care a auzit că chivotul lui Dumnezeu fusese luat.'),
  ('1 Samuel', 4, ARRAY['4:18']::text[], 'pending_review', 'Eli a fost judecător în Israel timp de patruzeci de ani.'),
  ('1 Samuel', 4, ARRAY['4:19']::text[], 'pending_review', 'Nevasta lui Fineas era însărcinată și stătea să nască atunci când a auzit vestea.'),
  ('1 Samuel', 4, ARRAY['4:20']::text[], 'pending_review', 'Femeile i-au spus nurorii lui Eli să nu se teamă, pentru că născuse un fiu.'),
  ('1 Samuel', 4, ARRAY['4:21']::text[], 'pending_review', 'Femeia a pus copilului numele I-Cabod și a spus că slava plecase din Israel.'),
  ('1 Samuel', 4, ARRAY['4:22']::text[], 'pending_review', 'Ultimul verset spune că slava plecase din Israel deoarece chivotul lui Dumnezeu fusese luat.')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_tf (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Chemarea lui Samuel ajunsese la cunoștința întregului Israel.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 4, 1, '1 Samuel', ARRAY['4:1']::text[], 'pending_review', 'Codex'),
  ('Israel a tăbărât la Afec, iar filistenii lângă Eben-Ezer.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 4, 1, '1 Samuel', ARRAY['4:1']::text[], 'pending_review', 'Codex'),
  ('În prima luptă, filistenii au omorât pe câmpul de bătaie aproape patru mii de oameni din Israel.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 4, 1, '1 Samuel', ARRAY['4:2']::text[], 'pending_review', 'Codex'),
  ('După prima înfrângere, bătrânii lui Israel au propus să aducă chivotul de la Silo.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 4, 1, '1 Samuel', ARRAY['4:3']::text[], 'pending_review', 'Codex'),
  ('Bătrânii au spus că vor să aducă chivotul în tabără ca să-i izbăvească din mâna vrăjmașilor.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 4, 2, '1 Samuel', ARRAY['4:3']::text[], 'pending_review', 'Codex'),
  ('Hofni și Fineas erau la Silo împreună cu chivotul legământului lui Dumnezeu.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 4, 1, '1 Samuel', ARRAY['4:4']::text[], 'pending_review', 'Codex'),
  ('Când chivotul a intrat în tabără, tot Israelul a tăcut, iar pământul s-a cutremurat.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 4, 1, '1 Samuel', ARRAY['4:5']::text[], 'pending_review', 'Codex'),
  ('Filistenii au auzit strigătele din tabăra evreilor și au aflat că sosise chivotul Domnului.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 4, 1, '1 Samuel', ARRAY['4:6']::text[], 'pending_review', 'Codex'),
  ('Filistenii au spus că mai trecuseră printr-o asemenea situație înainte.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 4, 2, '1 Samuel', ARRAY['4:7']::text[], 'pending_review', 'Codex'),
  ('În vorbirea lor, filistenii au amintit că dumnezeii aceștia îi loviseră pe egipteni cu urgii în pustie.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 4, 2, '1 Samuel', ARRAY['4:8']::text[], 'pending_review', 'Codex'),
  ('Filistenii s-au îndemnat unii pe alții să lupte, ca să nu ajungă robi evreilor.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 4, 2, '1 Samuel', ARRAY['4:9']::text[], 'pending_review', 'Codex'),
  ('În a doua luptă, fiecare israelit a fugit în cortul lui.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 4, 1, '1 Samuel', ARRAY['4:10']::text[], 'pending_review', 'Codex'),
  ('În a doua înfrângere au căzut treizeci de mii de oameni pedeștri din Israel.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 4, 1, '1 Samuel', ARRAY['4:10']::text[], 'pending_review', 'Codex'),
  ('După luptă, chivotul lui Dumnezeu a fost luat, iar Hofni și Fineas au murit.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 4, 1, '1 Samuel', ARRAY['4:11']::text[], 'pending_review', 'Codex'),
  ('Omul care a adus vestea la Silo era din Beniamin și a ajuns în aceeași zi.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 4, 1, '1 Samuel', ARRAY['4:12']::text[], 'pending_review', 'Codex'),
  ('Eli aștepta la drum fără să fie neliniștit pentru chivotul lui Dumnezeu.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 4, 1, '1 Samuel', ARRAY['4:13']::text[], 'pending_review', 'Codex'),
  ('Eli avea nouăzeci și opt de ani și nu mai putea să vadă.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 4, 1, '1 Samuel', ARRAY['4:15']::text[], 'pending_review', 'Codex'),
  ('Omul i-a spus lui Eli că venea de pe câmpul de bătaie și fugise în acea zi.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 4, 2, '1 Samuel', ARRAY['4:16']::text[], 'pending_review', 'Codex'),
  ('Eli a căzut de pe scaun în momentul în care a auzit că chivotul lui Dumnezeu fusese luat.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 4, 2, '1 Samuel', ARRAY['4:17', '4:18']::text[], 'pending_review', 'Codex'),
  ('Eli a fost judecător în Israel timp de patruzeci de ani.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 4, 1, '1 Samuel', ARRAY['4:18']::text[], 'pending_review', 'Codex'),
  ('Nevasta lui Fineas era însărcinată și stătea să nască atunci când a auzit vestea.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 4, 1, '1 Samuel', ARRAY['4:19']::text[], 'pending_review', 'Codex'),
  ('Femeile i-au spus nurorii lui Eli să nu se teamă, pentru că născuse un fiu.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 4, 1, '1 Samuel', ARRAY['4:20']::text[], 'pending_review', 'Codex'),
  ('Femeia a pus copilului numele I-Cabod și a spus că slava plecase din Israel.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 4, 2, '1 Samuel', ARRAY['4:21']::text[], 'pending_review', 'Codex'),
  ('Ultimul verset spune că slava plecase din Israel deoarece chivotul lui Dumnezeu fusese luat.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 4, 1, '1 Samuel', ARRAY['4:22']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 4, ARRAY['4:1']::text[], 'pending_review', 'Lângă ce loc a tăbărât Israel înainte de lupta cu filistenii?'),
  ('1 Samuel', 4, ARRAY['4:1']::text[], 'pending_review', 'Unde tăbărâseră filistenii înainte de luptă?'),
  ('1 Samuel', 4, ARRAY['4:2']::text[], 'pending_review', 'Câți oameni au fost omorâți aproximativ în prima luptă?'),
  ('1 Samuel', 4, ARRAY['4:3', '4:4']::text[], 'pending_review', 'De unde au propus bătrânii să fie adus chivotul legământului?'),
  ('1 Samuel', 4, ARRAY['4:4']::text[], 'pending_review', 'Care doi fii ai lui Eli se aflau acolo împreună cu chivotul?'),
  ('1 Samuel', 4, ARRAY['4:5']::text[], 'pending_review', 'Ce s-a întâmplat cu pământul când tot Israelul a strigat la intrarea chivotului în tabără?'),
  ('1 Samuel', 4, ARRAY['4:6']::text[], 'pending_review', 'Ce au aflat filistenii după ce au auzit strigătele din tabăra evreilor?'),
  ('1 Samuel', 4, ARRAY['4:8']::text[], 'pending_review', 'Pe cine au spus filistenii că loviseră cu urgii dumnezeii aceștia?'),
  ('1 Samuel', 4, ARRAY['4:9']::text[], 'pending_review', 'Ce îndemn le-au adresat filistenii tovarășilor lor înainte de luptă?'),
  ('1 Samuel', 4, ARRAY['4:10']::text[], 'pending_review', 'Câți oameni pedeștri au căzut din Israel în a doua înfrângere?'),
  ('1 Samuel', 4, ARRAY['4:12']::text[], 'pending_review', 'Din ce seminție era omul care a alergat la Silo cu vestea?'),
  ('1 Samuel', 4, ARRAY['4:13']::text[], 'pending_review', 'Unde stătea Eli când aștepta vestea despre chivot?'),
  ('1 Samuel', 4, ARRAY['4:15']::text[], 'pending_review', 'Ce vârstă avea Eli când a primit vestea?'),
  ('1 Samuel', 4, ARRAY['4:16']::text[], 'pending_review', 'Ce l-a întrebat Eli pe omul venit de pe câmpul de bătaie?'),
  ('1 Samuel', 4, ARRAY['4:17', '4:18']::text[], 'pending_review', 'Ce i s-a întâmplat lui Eli lângă poartă după ce a auzit despre chivot?'),
  ('1 Samuel', 4, ARRAY['4:18']::text[], 'pending_review', 'Câți ani fusese Eli judecător în Israel?'),
  ('1 Samuel', 4, ARRAY['4:19']::text[], 'pending_review', 'Al cui era bărbatul femeii care a născut după ce a auzit vestea?'),
  ('1 Samuel', 4, ARRAY['4:20']::text[], 'pending_review', 'Cine i-a spus femeii, când era pe moarte, să nu se teamă și că născuse un fiu?'),
  ('1 Samuel', 4, ARRAY['4:21']::text[], 'pending_review', 'Ce nume a pus femeia copilului?')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_abc_one (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Lângă ce loc a tăbărât Israel înainte de lupta cu filistenii?', '[{"text":"Afec","correct":false},{"text":"Eben-Ezer","correct":true},{"text":"Silo","correct":false}]'::jsonb, 4, 1, '1 Samuel', ARRAY['4:1']::text[], 'pending_review', 'Codex'),
  ('Unde tăbărâseră filistenii înainte de luptă?', '[{"text":"La Afec","correct":true},{"text":"La Silo","correct":false},{"text":"La Eben-Ezer","correct":false}]'::jsonb, 4, 1, '1 Samuel', ARRAY['4:1']::text[], 'pending_review', 'Codex'),
  ('Câți oameni au fost omorâți aproximativ în prima luptă?', '[{"text":"Aproape patru mii","correct":true},{"text":"Treizeci de mii","correct":false},{"text":"Patruzeci de mii","correct":false}]'::jsonb, 4, 1, '1 Samuel', ARRAY['4:2']::text[], 'pending_review', 'Codex'),
  ('De unde au propus bătrânii să fie adus chivotul legământului?', '[{"text":"De la Afec","correct":false},{"text":"De la Silo","correct":true},{"text":"De la Eben-Ezer","correct":false}]'::jsonb, 4, 1, '1 Samuel', ARRAY['4:3', '4:4']::text[], 'pending_review', 'Codex'),
  ('Care doi fii ai lui Eli se aflau acolo împreună cu chivotul?', '[{"text":"Hofni și Fineas","correct":true},{"text":"Samuel și Hofni","correct":false},{"text":"Fineas și Eli","correct":false}]'::jsonb, 4, 1, '1 Samuel', ARRAY['4:4']::text[], 'pending_review', 'Codex'),
  ('Ce s-a întâmplat cu pământul când tot Israelul a strigat la intrarea chivotului în tabără?', '[{"text":"S-a cutremurat","correct":true},{"text":"S-a acoperit cu țărână","correct":false},{"text":"S-a despicat","correct":false}]'::jsonb, 4, 1, '1 Samuel', ARRAY['4:5']::text[], 'pending_review', 'Codex'),
  ('Ce au aflat filistenii după ce au auzit strigătele din tabăra evreilor?', '[{"text":"Că sosise chivotul Domnului în tabără","correct":true},{"text":"Că Eli venise la Afec","correct":false},{"text":"Că Samuel preluase conducerea luptei","correct":false}]'::jsonb, 4, 2, '1 Samuel', ARRAY['4:6']::text[], 'pending_review', 'Codex'),
  ('Pe cine au spus filistenii că loviseră cu urgii dumnezeii aceștia?', '[{"text":"Pe egipteni","correct":true},{"text":"Pe evrei","correct":false},{"text":"Pe beniaminiți","correct":false}]'::jsonb, 4, 2, '1 Samuel', ARRAY['4:8']::text[], 'pending_review', 'Codex'),
  ('Ce îndemn le-au adresat filistenii tovarășilor lor înainte de luptă?', '[{"text":"Să se întărească, să fie oameni și să lupte","correct":true},{"text":"Să se întoarcă la Afec și să aștepte","correct":false},{"text":"Să ceară pace de la bătrânii lui Israel","correct":false}]'::jsonb, 4, 2, '1 Samuel', ARRAY['4:9']::text[], 'pending_review', 'Codex'),
  ('Câți oameni pedeștri au căzut din Israel în a doua înfrângere?', '[{"text":"Aproape patru mii","correct":false},{"text":"Treizeci de mii","correct":true},{"text":"Nouăzeci și opt","correct":false}]'::jsonb, 4, 1, '1 Samuel', ARRAY['4:10']::text[], 'pending_review', 'Codex'),
  ('Din ce seminție era omul care a alergat la Silo cu vestea?', '[{"text":"Beniamin","correct":true},{"text":"Efraim","correct":false},{"text":"Levi","correct":false}]'::jsonb, 4, 1, '1 Samuel', ARRAY['4:12']::text[], 'pending_review', 'Codex'),
  ('Unde stătea Eli când aștepta vestea despre chivot?', '[{"text":"Pe un scaun lângă drum","correct":true},{"text":"La poarta taberei din Afec","correct":false},{"text":"În cortul lui Samuel","correct":false}]'::jsonb, 4, 1, '1 Samuel', ARRAY['4:13']::text[], 'pending_review', 'Codex'),
  ('Ce vârstă avea Eli când a primit vestea?', '[{"text":"Nouăzeci și opt de ani","correct":true},{"text":"Patruzeci de ani","correct":false},{"text":"O sută de ani","correct":false}]'::jsonb, 4, 1, '1 Samuel', ARRAY['4:15']::text[], 'pending_review', 'Codex'),
  ('Ce l-a întrebat Eli pe omul venit de pe câmpul de bătaie?', '[{"text":"„Ce s-a întâmplat, fiule?”","correct":true},{"text":"„Unde este Samuel?”","correct":false},{"text":"„Cine a luat chivotul?”","correct":false}]'::jsonb, 4, 2, '1 Samuel', ARRAY['4:16']::text[], 'pending_review', 'Codex'),
  ('Ce i s-a întâmplat lui Eli lângă poartă după ce a auzit despre chivot?', '[{"text":"A căzut pe spate, și-a rupt ceafa și a murit","correct":true},{"text":"A fugit spre câmpul de bătaie","correct":false},{"text":"A plecat la Silo să caute chivotul","correct":false}]'::jsonb, 4, 2, '1 Samuel', ARRAY['4:17', '4:18']::text[], 'pending_review', 'Codex'),
  ('Câți ani fusese Eli judecător în Israel?', '[{"text":"Patruzeci de ani","correct":true},{"text":"Treizeci de ani","correct":false},{"text":"Nouăzeci și opt de ani","correct":false}]'::jsonb, 4, 1, '1 Samuel', ARRAY['4:18']::text[], 'pending_review', 'Codex'),
  ('Al cui era bărbatul femeii care a născut după ce a auzit vestea?', '[{"text":"Al lui Fineas","correct":true},{"text":"Al lui Hofni","correct":false},{"text":"Al lui Samuel","correct":false}]'::jsonb, 4, 1, '1 Samuel', ARRAY['4:19']::text[], 'pending_review', 'Codex'),
  ('Cine i-a spus femeii, când era pe moarte, să nu se teamă și că născuse un fiu?', '[{"text":"Femeile care erau lângă ea","correct":true},{"text":"Bătrânii lui Israel","correct":false},{"text":"Omul din Beniamin","correct":false}]'::jsonb, 4, 1, '1 Samuel', ARRAY['4:20']::text[], 'pending_review', 'Codex'),
  ('Ce nume a pus femeia copilului?', '[{"text":"I-Cabod","correct":true},{"text":"Hofni","correct":false},{"text":"Eben-Ezer","correct":false}]'::jsonb, 4, 1, '1 Samuel', ARRAY['4:21']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 4, ARRAY['4:1']::text[], 'pending_review', 'Ce detalii despre așezarea celor două tabere sunt precizate înaintea luptei?'),
  ('1 Samuel', 4, ARRAY['4:2']::text[], 'pending_review', 'Ce se spune despre prima luptă dintre Israel și filisteni?'),
  ('1 Samuel', 4, ARRAY['4:3']::text[], 'pending_review', 'Ce au făcut și ce au spus bătrânii lui Israel după ce poporul s-a întors în tabără?'),
  ('1 Samuel', 4, ARRAY['4:3', '4:4']::text[], 'pending_review', 'Potrivit planului bătrânilor, ce sperau ei să facă prezența chivotului în tabără?'),
  ('1 Samuel', 4, ARRAY['4:4', '4:5']::text[], 'pending_review', 'Ce detalii sunt date despre sosirea chivotului în tabăra lui Israel?'),
  ('1 Samuel', 4, ARRAY['4:6']::text[], 'pending_review', 'Ce au făcut filistenii după ce au auzit strigătele din tabăra evreilor?'),
  ('1 Samuel', 4, ARRAY['4:7']::text[], 'pending_review', 'Cum au reacționat filistenii când au auzit că sosise chivotul?'),
  ('1 Samuel', 4, ARRAY['4:8']::text[], 'pending_review', 'Ce au afirmat filistenii în vorbirea lor despre dumnezeii de care se temeau?'),
  ('1 Samuel', 4, ARRAY['4:9']::text[], 'pending_review', 'Cu ce îndemnuri s-au încurajat filistenii înaintea luptei?'),
  ('1 Samuel', 4, ARRAY['4:10']::text[], 'pending_review', 'Ce rezultate ale celei de-a doua lupte sunt menționate?'),
  ('1 Samuel', 4, ARRAY['4:11']::text[], 'pending_review', 'Ce s-a întâmplat după luptă cu chivotul și cu fiii lui Eli?'),
  ('1 Samuel', 4, ARRAY['4:12']::text[], 'pending_review', 'Cum este descris omul din Beniamin care a venit la Silo?'),
  ('1 Samuel', 4, ARRAY['4:13']::text[], 'pending_review', 'Unde aștepta Eli și pentru ce era neliniștit?'),
  ('1 Samuel', 4, ARRAY['4:16', '4:17']::text[], 'pending_review', 'Ce i-a relatat mesagerul lui Eli despre rezultatul luptei?'),
  ('1 Samuel', 4, ARRAY['4:17', '4:18']::text[], 'pending_review', 'Ce detalii despre moartea lui Eli sunt precizate?'),
  ('1 Samuel', 4, ARRAY['4:19']::text[], 'pending_review', 'Ce împrejurări legate de naștere sunt consemnate despre nevasta lui Fineas?'),
  ('1 Samuel', 4, ARRAY['4:20']::text[], 'pending_review', 'Ce i-au spus femeile femeii care trăgea să moară și cum a reacționat ea?'),
  ('1 Samuel', 4, ARRAY['4:21']::text[], 'pending_review', 'Ce două împrejurări sunt menționate ca pricină pentru cuvintele femeii despre slava lui Israel?'),
  ('1 Samuel', 4, ARRAY['4:21', '4:22']::text[], 'pending_review', 'Ce spune femeia în legătură cu slava lui Israel și chivotul?'),
  ('1 Samuel', 4, ARRAY['4:18']::text[], 'pending_review', 'Care afirmații despre Eli sunt susținute de relatare?')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_abc_multi (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Ce detalii despre așezarea celor două tabere sunt precizate înaintea luptei?', '[{"text":"Israel a tăbărât lângă Eben-Ezer.","correct":true},{"text":"Filistenii au tăbărât la Afec.","correct":true},{"text":"Israel a tăbărât la Afec.","correct":false}]'::jsonb, 4, 2, '1 Samuel', ARRAY['4:1']::text[], 'pending_review', 'Codex'),
  ('Ce se spune despre prima luptă dintre Israel și filisteni?', '[{"text":"Filistenii s-au așezat în linie de bătaie împotriva lui Israel.","correct":true},{"text":"Israel a fost bătut.","correct":true},{"text":"Aproape patru mii de oameni au fugit în corturile lor.","correct":false}]'::jsonb, 4, 2, '1 Samuel', ARRAY['4:2']::text[], 'pending_review', 'Codex'),
  ('Ce au făcut și ce au spus bătrânii lui Israel după ce poporul s-a întors în tabără?', '[{"text":"Au întrebat de ce Domnul îi lăsase să fie bătuți de filisteni.","correct":true},{"text":"Au propus să trimită după chivotul legământului la Silo.","correct":true},{"text":"Au propus să-l trimită pe Eli singur în tabăra filistenilor.","correct":false}]'::jsonb, 4, 3, '1 Samuel', ARRAY['4:3']::text[], 'pending_review', 'Codex'),
  ('Potrivit planului bătrânilor, ce sperau ei să facă prezența chivotului în tabără?', '[{"text":"Să fie adus de la Silo și să vină în mijlocul poporului.","correct":true},{"text":"Să-i izbăvească din mâna vrăjmașilor.","correct":true},{"text":"Să-i ajute să-i învingă pe egipteni.","correct":false}]'::jsonb, 4, 3, '1 Samuel', ARRAY['4:3', '4:4']::text[], 'pending_review', 'Codex'),
  ('Ce detalii sunt date despre sosirea chivotului în tabăra lui Israel?', '[{"text":"A fost trimis după el la Silo.","correct":true},{"text":"Hofni și Fineas erau acolo împreună cu chivotul.","correct":true},{"text":"Tot Israelul a tăcut când chivotul a intrat în tabără.","correct":false}]'::jsonb, 4, 2, '1 Samuel', ARRAY['4:4', '4:5']::text[], 'pending_review', 'Codex'),
  ('Ce au făcut filistenii după ce au auzit strigătele din tabăra evreilor?', '[{"text":"Au întrebat ce înseamnă strigătele.","correct":true},{"text":"Au aflat că sosise chivotul Domnului în tabără.","correct":true},{"text":"Au plecat la Silo ca să aducă ei chivotul.","correct":false}]'::jsonb, 4, 2, '1 Samuel', ARRAY['4:6']::text[], 'pending_review', 'Codex'),
  ('Cum au reacționat filistenii când au auzit că sosise chivotul?', '[{"text":"S-au temut.","correct":true},{"text":"Au crezut că Dumnezeu venise în tabără.","correct":true},{"text":"Au spus că trecuseră de multe ori printr-o asemenea situație.","correct":false}]'::jsonb, 4, 2, '1 Samuel', ARRAY['4:7']::text[], 'pending_review', 'Codex'),
  ('Ce au afirmat filistenii în vorbirea lor despre dumnezeii de care se temeau?', '[{"text":"I-au numit dumnezei puternici.","correct":true},{"text":"Au spus că loviseră Egiptul cu tot felul de urgii în pustie.","correct":true},{"text":"Au spus că îi loviseră pe filisteni la Afec.","correct":false}]'::jsonb, 4, 3, '1 Samuel', ARRAY['4:8']::text[], 'pending_review', 'Codex'),
  ('Cu ce îndemnuri s-au încurajat filistenii înaintea luptei?', '[{"text":"Să se întărească și să fie oameni.","correct":true},{"text":"Să lupte.","correct":true},{"text":"Să se predea evreilor.","correct":false}]'::jsonb, 4, 2, '1 Samuel', ARRAY['4:9']::text[], 'pending_review', 'Codex'),
  ('Ce rezultate ale celei de-a doua lupte sunt menționate?', '[{"text":"Israel a fost bătut.","correct":true},{"text":"Fiecare israelit a fugit în cortul lui.","correct":true},{"text":"Din Israel au căzut aproape patru mii de oameni pedeștri.","correct":false}]'::jsonb, 4, 2, '1 Samuel', ARRAY['4:10']::text[], 'pending_review', 'Codex'),
  ('Ce s-a întâmplat după luptă cu chivotul și cu fiii lui Eli?', '[{"text":"Chivotul lui Dumnezeu a fost luat.","correct":true},{"text":"Hofni și Fineas au murit.","correct":true},{"text":"Chivotul a fost dus înapoi la Silo în aceeași zi.","correct":false}]'::jsonb, 4, 2, '1 Samuel', ARRAY['4:11']::text[], 'pending_review', 'Codex'),
  ('Cum este descris omul din Beniamin care a venit la Silo?', '[{"text":"A alergat din tabăra de bătaie.","correct":true},{"text":"A ajuns în aceeași zi.","correct":true},{"text":"Avea haine curate și nu avea țărână pe cap.","correct":false}]'::jsonb, 4, 2, '1 Samuel', ARRAY['4:12']::text[], 'pending_review', 'Codex'),
  ('Unde aștepta Eli și pentru ce era neliniștit?', '[{"text":"Aștepta pe un scaun lângă drum.","correct":true},{"text":"Inima îi era neliniștită pentru chivotul lui Dumnezeu.","correct":true},{"text":"Aștepta la Afec și se pregătea să-și întâmpine fiii.","correct":false}]'::jsonb, 4, 3, '1 Samuel', ARRAY['4:13']::text[], 'pending_review', 'Codex'),
  ('Ce i-a relatat mesagerul lui Eli despre rezultatul luptei?', '[{"text":"Israel fugise dinaintea filistenilor și poporul suferise o mare înfrângere.","correct":true},{"text":"Hofni și Fineas muriseră, iar chivotul Domnului fusese luat.","correct":true},{"text":"Israel îi învinsese pe filisteni și adusese prada la Silo.","correct":false}]'::jsonb, 4, 3, '1 Samuel', ARRAY['4:16', '4:17']::text[], 'pending_review', 'Codex'),
  ('Ce detalii despre moartea lui Eli sunt precizate?', '[{"text":"A căzut pe spate de pe scaun, lângă poartă.","correct":true},{"text":"Și-a rupt ceafa și a murit.","correct":true},{"text":"A murit pe câmpul de bătaie, lângă Afec.","correct":false}]'::jsonb, 4, 3, '1 Samuel', ARRAY['4:17', '4:18']::text[], 'pending_review', 'Codex'),
  ('Ce împrejurări legate de naștere sunt consemnate despre nevasta lui Fineas?', '[{"text":"Era însărcinată și stătea să nască.","correct":true},{"text":"A auzit vestea luării chivotului și a morții socrului și a bărbatului ei.","correct":true},{"text":"Născuse deja înainte să audă aceste vești.","correct":false}]'::jsonb, 4, 3, '1 Samuel', ARRAY['4:19']::text[], 'pending_review', 'Codex'),
  ('Ce i-au spus femeile femeii care trăgea să moară și cum a reacționat ea?', '[{"text":"I-au spus să nu se teamă.","correct":true},{"text":"I-au spus că născuse un fiu.","correct":true},{"text":"Ea le-a răspuns și a luat seama la ce i se spunea.","correct":false}]'::jsonb, 4, 2, '1 Samuel', ARRAY['4:20']::text[], 'pending_review', 'Codex'),
  ('Ce două împrejurări sunt menționate ca pricină pentru cuvintele femeii despre slava lui Israel?', '[{"text":"Luarea chivotului lui Dumnezeu.","correct":true},{"text":"Moartea socrului ei și a bărbatului ei.","correct":true},{"text":"Cei patruzeci de ani în care Eli fusese judecător.","correct":false}]'::jsonb, 4, 3, '1 Samuel', ARRAY['4:21']::text[], 'pending_review', 'Codex'),
  ('Ce spune femeia în legătură cu slava lui Israel și chivotul?', '[{"text":"Slava s-a dus din Israel.","correct":true},{"text":"Chivotul lui Dumnezeu a fost luat.","correct":true},{"text":"Chivotul s-a întors la Silo.","correct":false}]'::jsonb, 4, 2, '1 Samuel', ARRAY['4:21', '4:22']::text[], 'pending_review', 'Codex'),
  ('Care afirmații despre Eli sunt susținute de relatare?', '[{"text":"Era bătrân și greu.","correct":true},{"text":"A fost judecător în Israel patruzeci de ani.","correct":true},{"text":"A murit pe câmpul de bătaie.","correct":false}]'::jsonb, 4, 3, '1 Samuel', ARRAY['4:18']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 4, ARRAY['4:1', '4:4', '4:12', '4:13']::text[], 'pending_review', '[{"left":"Tabăra lui Israel înaintea luptei","right":"Lângă Eben-Ezer"},{"left":"Tabăra filistenilor înaintea luptei","right":"La Afec"},{"left":"Locul de unde a fost adus chivotul","right":"Silo"},{"left":"Locul unde aștepta Eli","right":"Pe un scaun lângă drum"},{"left":"Timpul sosirii mesagerului la Silo","right":"În aceeași zi"}]'::jsonb),
  ('1 Samuel', 4, ARRAY['4:2', '4:3', '4:10']::text[], 'pending_review', '[{"left":"Prima luptă","right":"Israel este bătut de filisteni"},{"left":"Pierderile din prima luptă","right":"Aproape patru mii de oameni"},{"left":"După prima înfrângere","right":"Poporul se întoarce în tabără"},{"left":"A doua luptă","right":"Israel este din nou bătut"},{"left":"Pierderile din a doua înfrângere","right":"Treizeci de mii de oameni pedeștri"}]'::jsonb),
  ('1 Samuel', 4, ARRAY['4:3', '4:4']::text[], 'pending_review', '[{"left":"Întrebarea bătrânilor după prima înfrângere","right":"De ce i-a lăsat Domnul să fie bătuți?"},{"left":"Locul de unde propun bătrânii să aducă chivotul","right":"Silo"},{"left":"Ce urma să facă chivotul în tabără","right":"Să vină în mijlocul poporului"},{"left":"Izbăvirea pe care o așteptau bătrânii","right":"Din mâna vrăjmașilor"},{"left":"Fiii lui Eli aflați împreună cu chivotul","right":"Hofni și Fineas"}]'::jsonb),
  ('1 Samuel', 4, ARRAY['4:5', '4:6', '4:7', '4:9']::text[], 'pending_review', '[{"left":"Ce aud filistenii din tabăra evreilor","right":"Strigăte de bucurie care cutremură pământul"},{"left":"Ce întreabă după ce aud strigătele","right":"Ce înseamnă zarva?"},{"left":"Ce află despre tabăra lui Israel","right":"A sosit chivotul Domnului"},{"left":"Cum reacționează la veste","right":"Se tem"},{"left":"Ce îndemn își dau înaintea luptei","right":"Să se întărească, să fie oameni și să lupte"}]'::jsonb),
  ('1 Samuel', 4, ARRAY['4:7', '4:8', '4:9']::text[], 'pending_review', '[{"left":"Ce au crezut filistenii despre Dumnezeu","right":"Că venise în tabără"},{"left":"Pe cine spun că loviseră dumnezeii aceștia","right":"Pe egipteni"},{"left":"Cu ce au fost loviți egiptenii","right":"Cu tot felul de urgii"},{"left":"Unde au fost loviți egiptenii, potrivit cuvintelor lor","right":"În pustie"},{"left":"De ce se îndeamnă filistenii să lupte","right":"Ca să nu fie robi evreilor"}]'::jsonb),
  ('1 Samuel', 4, ARRAY['4:12', '4:16']::text[], 'pending_review', '[{"left":"Tribul mesagerului","right":"Beniamin"},{"left":"De unde a alergat","right":"Din tabăra de bătaie"},{"left":"Când a ajuns la Silo","right":"În aceeași zi"},{"left":"Starea hainelor","right":"Sfâșiate"},{"left":"Întrebarea lui Eli către mesager","right":"„Ce s-a întâmplat, fiule?”"}]'::jsonb),
  ('1 Samuel', 4, ARRAY['4:13', '4:14', '4:15', '4:18']::text[], 'pending_review', '[{"left":"Ce neliniștea inima lui Eli","right":"Chivotul lui Dumnezeu"},{"left":"Ce întreabă Eli auzind strigătele cetății","right":"Ce înseamnă zarva?"},{"left":"Vârsta lui Eli","right":"Nouăzeci și opt de ani"},{"left":"Vederea lui Eli","right":"Nu mai putea să vadă"},{"left":"Câți ani fusese judecător","right":"Patruzeci de ani"}]'::jsonb),
  ('1 Samuel', 4, ARRAY['4:17', '4:18']::text[], 'pending_review', '[{"left":"Vestea despre Israel","right":"A fugit dinaintea filistenilor"},{"left":"Vestea despre popor","right":"A suferit o mare înfrângere"},{"left":"Vestea despre Hofni și Fineas","right":"Au murit"},{"left":"Vestea despre chivot","right":"A fost luat"},{"left":"Reacția lui Eli la pomenirea chivotului","right":"A căzut de pe scaun și a murit"}]'::jsonb),
  ('1 Samuel', 4, ARRAY['4:19', '4:20']::text[], 'pending_review', '[{"left":"Starea nevestei lui Fineas","right":"Însărcinată și stând să nască"},{"left":"Vestea care o face să se încovoaie","right":"Luarea chivotului și moartea socrului și a bărbatului"},{"left":"Ce o apucă după ce se încovoaie","right":"Durerile nașterii"},{"left":"Ce îi spun femeile","right":"Să nu se teamă, fiindcă a născut un fiu"},{"left":"Reacția ei la ce i se spune","right":"Nu răspunde și nu ia seama"}]'::jsonb),
  ('1 Samuel', 4, ARRAY['4:21', '4:22']::text[], 'pending_review', '[{"left":"Numele pus copilului","right":"I-Cabod"},{"left":"Ce spune numele între paranteze în relatare","right":"Nu mai e slavă"},{"left":"Ce spune femeia despre slava lui Israel","right":"S-a dus"},{"left":"Ce s-a întâmplat cu chivotul","right":"A fost luat"},{"left":"De ce spune femeia că slava s-a dus","right":"Pentru că chivotul lui Dumnezeu este luat"}]'::jsonb)
) as incoming (book, chapter, source_references, status, pairs)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.pairs = incoming.pairs;

insert into public.questions_match (pairs, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.pairs, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('[{"left":"Tabăra lui Israel înaintea luptei","right":"Lângă Eben-Ezer"},{"left":"Tabăra filistenilor înaintea luptei","right":"La Afec"},{"left":"Locul de unde a fost adus chivotul","right":"Silo"},{"left":"Locul unde aștepta Eli","right":"Pe un scaun lângă drum"},{"left":"Timpul sosirii mesagerului la Silo","right":"În aceeași zi"}]'::jsonb, 4, 2, '1 Samuel', ARRAY['4:1', '4:4', '4:12', '4:13']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Prima luptă","right":"Israel este bătut de filisteni"},{"left":"Pierderile din prima luptă","right":"Aproape patru mii de oameni"},{"left":"După prima înfrângere","right":"Poporul se întoarce în tabără"},{"left":"A doua luptă","right":"Israel este din nou bătut"},{"left":"Pierderile din a doua înfrângere","right":"Treizeci de mii de oameni pedeștri"}]'::jsonb, 4, 3, '1 Samuel', ARRAY['4:2', '4:3', '4:10']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Întrebarea bătrânilor după prima înfrângere","right":"De ce i-a lăsat Domnul să fie bătuți?"},{"left":"Locul de unde propun bătrânii să aducă chivotul","right":"Silo"},{"left":"Ce urma să facă chivotul în tabără","right":"Să vină în mijlocul poporului"},{"left":"Izbăvirea pe care o așteptau bătrânii","right":"Din mâna vrăjmașilor"},{"left":"Fiii lui Eli aflați împreună cu chivotul","right":"Hofni și Fineas"}]'::jsonb, 4, 3, '1 Samuel', ARRAY['4:3', '4:4']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Ce aud filistenii din tabăra evreilor","right":"Strigăte de bucurie care cutremură pământul"},{"left":"Ce întreabă după ce aud strigătele","right":"Ce înseamnă zarva?"},{"left":"Ce află despre tabăra lui Israel","right":"A sosit chivotul Domnului"},{"left":"Cum reacționează la veste","right":"Se tem"},{"left":"Ce îndemn își dau înaintea luptei","right":"Să se întărească, să fie oameni și să lupte"}]'::jsonb, 4, 3, '1 Samuel', ARRAY['4:5', '4:6', '4:7', '4:9']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Ce au crezut filistenii despre Dumnezeu","right":"Că venise în tabără"},{"left":"Pe cine spun că loviseră dumnezeii aceștia","right":"Pe egipteni"},{"left":"Cu ce au fost loviți egiptenii","right":"Cu tot felul de urgii"},{"left":"Unde au fost loviți egiptenii, potrivit cuvintelor lor","right":"În pustie"},{"left":"De ce se îndeamnă filistenii să lupte","right":"Ca să nu fie robi evreilor"}]'::jsonb, 4, 4, '1 Samuel', ARRAY['4:7', '4:8', '4:9']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Tribul mesagerului","right":"Beniamin"},{"left":"De unde a alergat","right":"Din tabăra de bătaie"},{"left":"Când a ajuns la Silo","right":"În aceeași zi"},{"left":"Starea hainelor","right":"Sfâșiate"},{"left":"Întrebarea lui Eli către mesager","right":"„Ce s-a întâmplat, fiule?”"}]'::jsonb, 4, 2, '1 Samuel', ARRAY['4:12', '4:16']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Ce neliniștea inima lui Eli","right":"Chivotul lui Dumnezeu"},{"left":"Ce întreabă Eli auzind strigătele cetății","right":"Ce înseamnă zarva?"},{"left":"Vârsta lui Eli","right":"Nouăzeci și opt de ani"},{"left":"Vederea lui Eli","right":"Nu mai putea să vadă"},{"left":"Câți ani fusese judecător","right":"Patruzeci de ani"}]'::jsonb, 4, 3, '1 Samuel', ARRAY['4:13', '4:14', '4:15', '4:18']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Vestea despre Israel","right":"A fugit dinaintea filistenilor"},{"left":"Vestea despre popor","right":"A suferit o mare înfrângere"},{"left":"Vestea despre Hofni și Fineas","right":"Au murit"},{"left":"Vestea despre chivot","right":"A fost luat"},{"left":"Reacția lui Eli la pomenirea chivotului","right":"A căzut de pe scaun și a murit"}]'::jsonb, 4, 3, '1 Samuel', ARRAY['4:17', '4:18']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Starea nevestei lui Fineas","right":"Însărcinată și stând să nască"},{"left":"Vestea care o face să se încovoaie","right":"Luarea chivotului și moartea socrului și a bărbatului"},{"left":"Ce o apucă după ce se încovoaie","right":"Durerile nașterii"},{"left":"Ce îi spun femeile","right":"Să nu se teamă, fiindcă a născut un fiu"},{"left":"Reacția ei la ce i se spune","right":"Nu răspunde și nu ia seama"}]'::jsonb, 4, 3, '1 Samuel', ARRAY['4:19', '4:20']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Numele pus copilului","right":"I-Cabod"},{"left":"Ce spune numele între paranteze în relatare","right":"Nu mai e slavă"},{"left":"Ce spune femeia despre slava lui Israel","right":"S-a dus"},{"left":"Ce s-a întâmplat cu chivotul","right":"A fost luat"},{"left":"De ce spune femeia că slava s-a dus","right":"Pentru că chivotul lui Dumnezeu este luat"}]'::jsonb, 4, 4, '1 Samuel', ARRAY['4:21', '4:22']::text[], 'pending_review', 'Codex')
) as incoming (pairs, chapter, difficulty, book, source_references, status, added_by)
where not exists (
  select 1 from public.questions_match existing
  where existing.book = incoming.book
    and existing.chapter = incoming.chapter
    and existing.source_references = incoming.source_references
    and existing.pairs = incoming.pairs
);

commit;
