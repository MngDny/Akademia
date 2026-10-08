begin;

alter table public.questions_tf add column if not exists source_references text[] not null default '{}';

alter table public.questions_abc_one add column if not exists source_references text[] not null default '{}';

alter table public.questions_abc_multi add column if not exists source_references text[] not null default '{}';

alter table public.questions_match add column if not exists source_references text[] not null default '{}';

update public.questions_tf as existing
set status = incoming.status
from (values
  ('1 Samuel', 3, ARRAY['3:1']::text[], 'pending_review', 'În vremea când Samuel slujea Domnului înaintea lui Eli, Cuvântul Domnului era rar, iar vedeniile nu erau dese.'),
  ('1 Samuel', 3, ARRAY['3:2']::text[], 'pending_review', 'Eli vedea limpede și nu avea probleme cu ochii.'),
  ('1 Samuel', 3, ARRAY['3:3']::text[], 'pending_review', 'Când Samuel era culcat în Templu, candela lui Dumnezeu se stinsese deja.'),
  ('1 Samuel', 3, ARRAY['3:3']::text[], 'pending_review', 'Samuel era culcat în Templul Domnului, în locul unde se afla chivotul lui Dumnezeu.'),
  ('1 Samuel', 3, ARRAY['3:4']::text[], 'pending_review', 'La prima chemare a Domnului, Samuel a răspuns: „Iată-mă!”'),
  ('1 Samuel', 3, ARRAY['3:5']::text[], 'pending_review', 'După ce a auzit chemarea, Samuel a alergat la Eli, crezând că Eli îl chemase.'),
  ('1 Samuel', 3, ARRAY['3:5']::text[], 'pending_review', 'Când Samuel a venit prima oară la Eli, Eli i-a spus că îl chemase și i-a cerut să rămână acolo.'),
  ('1 Samuel', 3, ARRAY['3:6']::text[], 'pending_review', 'La a doua chemare, Samuel s-a sculat și s-a dus la Eli, iar Eli i-a spus să se întoarcă și să se culce.'),
  ('1 Samuel', 3, ARRAY['3:7']::text[], 'pending_review', 'Textul spune că Samuel Îl cunoștea deja pe Domnul și că primise Cuvântul Lui.'),
  ('1 Samuel', 3, ARRAY['3:8']::text[], 'pending_review', 'După a treia chemare, Eli a înțeles că Domnul chema copilul.'),
  ('1 Samuel', 3, ARRAY['3:9']::text[], 'pending_review', 'Eli l-a învățat pe Samuel să răspundă la următoarea chemare: „Vorbește, Doamne, căci robul Tău ascultă.”'),
  ('1 Samuel', 3, ARRAY['3:9']::text[], 'pending_review', 'După ce a primit îndrumarea lui Eli, Samuel s-a dus să se culce la locul lui.'),
  ('1 Samuel', 3, ARRAY['3:10']::text[], 'pending_review', 'Domnul l-a chemat pe Samuel rostindu-i numele o singură dată.'),
  ('1 Samuel', 3, ARRAY['3:10']::text[], 'pending_review', 'Când Domnul a venit și S-a înfățișat, Samuel a răspuns că robul Domnului ascultă.'),
  ('1 Samuel', 3, ARRAY['3:11']::text[], 'pending_review', 'Domnul i-a spus lui Samuel că va face în Israel un lucru care va asurzi urechile celor care îl vor auzi.'),
  ('1 Samuel', 3, ARRAY['3:12']::text[], 'pending_review', 'Domnul a spus că va împlini asupra casei lui Eli doar o parte din ceea ce rostise.'),
  ('1 Samuel', 3, ARRAY['3:12']::text[], 'pending_review', 'Domnul a spus că va începe și va isprăvi împlinirea celor rostite împotriva casei lui Eli.'),
  ('1 Samuel', 3, ARRAY['3:13']::text[], 'pending_review', 'Eli nu știa despre fărădelegea pentru care fiii lui s-au făcut vrednici de lepădat.'),
  ('1 Samuel', 3, ARRAY['3:13']::text[], 'pending_review', 'Pedepsirea casei lui Eli era legată de fărădelegea cunoscută de el și de faptul că nu și-a oprit fiii.'),
  ('1 Samuel', 3, ARRAY['3:14']::text[], 'pending_review', 'Domnul a jurat că fărădelegea casei lui Eli va fi ispășită prin jertfe și daruri de mâncare.'),
  ('1 Samuel', 3, ARRAY['3:15']::text[], 'pending_review', 'Samuel a rămas culcat până dimineața, apoi a deschis ușile Casei Domnului.'),
  ('1 Samuel', 3, ARRAY['3:15']::text[], 'pending_review', 'Samuel nu s-a temut să-i istorisească lui Eli vedenia.'),
  ('1 Samuel', 3, ARRAY['3:16']::text[], 'pending_review', 'Eli l-a chemat pe Samuel cu apelativul „fiule”, iar Samuel a răspuns: „Iată-mă!”'),
  ('1 Samuel', 3, ARRAY['3:17']::text[], 'pending_review', 'Eli i-a cerut lui Samuel să-i spună cuvântul rostit de Domnul și să nu-i ascundă nimic.'),
  ('1 Samuel', 3, ARRAY['3:18']::text[], 'pending_review', 'Samuel i-a ascuns lui Eli o parte din ceea ce îi vorbise Domnul.'),
  ('1 Samuel', 3, ARRAY['3:17', '3:18']::text[], 'pending_review', 'După ce Samuel i-a istorisit totul, Eli a spus: „Domnul este Acesta, să facă ce va crede!”'),
  ('1 Samuel', 3, ARRAY['3:19']::text[], 'pending_review', 'Pe măsură ce Samuel creștea, Domnul era cu el și nu lăsa să cadă la pământ niciunul dintre cuvintele lui.'),
  ('1 Samuel', 3, ARRAY['3:20']::text[], 'pending_review', 'Tot Israelul, de la Dan până la Beer-Șeba, a cunoscut că Domnul îl pusese pe Samuel proroc al Domnului.'),
  ('1 Samuel', 3, ARRAY['3:20', '3:21']::text[], 'pending_review', 'Domnul Se arăta lui Samuel la Betel și îl pusese preot al Domnului.'),
  ('1 Samuel', 3, ARRAY['3:21']::text[], 'pending_review', 'La Silo, Domnul Se descoperea lui Samuel prin Cuvântul Domnului.')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_tf (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('În vremea când Samuel slujea Domnului înaintea lui Eli, Cuvântul Domnului era rar, iar vedeniile nu erau dese.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 3, 1, '1 Samuel', ARRAY['3:1']::text[], 'pending_review', 'Codex'),
  ('Eli vedea limpede și nu avea probleme cu ochii.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 3, 1, '1 Samuel', ARRAY['3:2']::text[], 'pending_review', 'Codex'),
  ('Când Samuel era culcat în Templu, candela lui Dumnezeu se stinsese deja.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 3, 1, '1 Samuel', ARRAY['3:3']::text[], 'pending_review', 'Codex'),
  ('Samuel era culcat în Templul Domnului, în locul unde se afla chivotul lui Dumnezeu.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 3, 1, '1 Samuel', ARRAY['3:3']::text[], 'pending_review', 'Codex'),
  ('La prima chemare a Domnului, Samuel a răspuns: „Iată-mă!”', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 3, 1, '1 Samuel', ARRAY['3:4']::text[], 'pending_review', 'Codex'),
  ('După ce a auzit chemarea, Samuel a alergat la Eli, crezând că Eli îl chemase.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 3, 1, '1 Samuel', ARRAY['3:5']::text[], 'pending_review', 'Codex'),
  ('Când Samuel a venit prima oară la Eli, Eli i-a spus că îl chemase și i-a cerut să rămână acolo.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:5']::text[], 'pending_review', 'Codex'),
  ('La a doua chemare, Samuel s-a sculat și s-a dus la Eli, iar Eli i-a spus să se întoarcă și să se culce.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:6']::text[], 'pending_review', 'Codex'),
  ('Textul spune că Samuel Îl cunoștea deja pe Domnul și că primise Cuvântul Lui.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:7']::text[], 'pending_review', 'Codex'),
  ('După a treia chemare, Eli a înțeles că Domnul chema copilul.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:8']::text[], 'pending_review', 'Codex'),
  ('Eli l-a învățat pe Samuel să răspundă la următoarea chemare: „Vorbește, Doamne, căci robul Tău ascultă.”', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:9']::text[], 'pending_review', 'Codex'),
  ('După ce a primit îndrumarea lui Eli, Samuel s-a dus să se culce la locul lui.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 3, 1, '1 Samuel', ARRAY['3:9']::text[], 'pending_review', 'Codex'),
  ('Domnul l-a chemat pe Samuel rostindu-i numele o singură dată.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 3, 1, '1 Samuel', ARRAY['3:10']::text[], 'pending_review', 'Codex'),
  ('Când Domnul a venit și S-a înfățișat, Samuel a răspuns că robul Domnului ascultă.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:10']::text[], 'pending_review', 'Codex'),
  ('Domnul i-a spus lui Samuel că va face în Israel un lucru care va asurzi urechile celor care îl vor auzi.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:11']::text[], 'pending_review', 'Codex'),
  ('Domnul a spus că va împlini asupra casei lui Eli doar o parte din ceea ce rostise.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:12']::text[], 'pending_review', 'Codex'),
  ('Domnul a spus că va începe și va isprăvi împlinirea celor rostite împotriva casei lui Eli.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:12']::text[], 'pending_review', 'Codex'),
  ('Eli nu știa despre fărădelegea pentru care fiii lui s-au făcut vrednici de lepădat.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:13']::text[], 'pending_review', 'Codex'),
  ('Pedepsirea casei lui Eli era legată de fărădelegea cunoscută de el și de faptul că nu și-a oprit fiii.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 3, 3, '1 Samuel', ARRAY['3:13']::text[], 'pending_review', 'Codex'),
  ('Domnul a jurat că fărădelegea casei lui Eli va fi ispășită prin jertfe și daruri de mâncare.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:14']::text[], 'pending_review', 'Codex'),
  ('Samuel a rămas culcat până dimineața, apoi a deschis ușile Casei Domnului.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 3, 1, '1 Samuel', ARRAY['3:15']::text[], 'pending_review', 'Codex'),
  ('Samuel nu s-a temut să-i istorisească lui Eli vedenia.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 3, 1, '1 Samuel', ARRAY['3:15']::text[], 'pending_review', 'Codex'),
  ('Eli l-a chemat pe Samuel cu apelativul „fiule”, iar Samuel a răspuns: „Iată-mă!”', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 3, 1, '1 Samuel', ARRAY['3:16']::text[], 'pending_review', 'Codex'),
  ('Eli i-a cerut lui Samuel să-i spună cuvântul rostit de Domnul și să nu-i ascundă nimic.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:17']::text[], 'pending_review', 'Codex'),
  ('Samuel i-a ascuns lui Eli o parte din ceea ce îi vorbise Domnul.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 3, 1, '1 Samuel', ARRAY['3:18']::text[], 'pending_review', 'Codex'),
  ('După ce Samuel i-a istorisit totul, Eli a spus: „Domnul este Acesta, să facă ce va crede!”', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:17', '3:18']::text[], 'pending_review', 'Codex'),
  ('Pe măsură ce Samuel creștea, Domnul era cu el și nu lăsa să cadă la pământ niciunul dintre cuvintele lui.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:19']::text[], 'pending_review', 'Codex'),
  ('Tot Israelul, de la Dan până la Beer-Șeba, a cunoscut că Domnul îl pusese pe Samuel proroc al Domnului.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:20']::text[], 'pending_review', 'Codex'),
  ('Domnul Se arăta lui Samuel la Betel și îl pusese preot al Domnului.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:20', '3:21']::text[], 'pending_review', 'Codex'),
  ('La Silo, Domnul Se descoperea lui Samuel prin Cuvântul Domnului.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:21']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 3, ARRAY['3:1']::text[], 'pending_review', 'Ce era rar în vremea când tânărul Samuel slujea Domnului înaintea lui Eli?'),
  ('1 Samuel', 3, ARRAY['3:1']::text[], 'pending_review', 'Cum sunt descrise vedeniile în vremea aceea?'),
  ('1 Samuel', 3, ARRAY['3:2']::text[], 'pending_review', 'Ce problemă avea Eli în timp ce stătea culcat la locul lui?'),
  ('1 Samuel', 3, ARRAY['3:3']::text[], 'pending_review', 'Unde era culcat Samuel în timp ce candela lui Dumnezeu nu se stinsese încă?'),
  ('1 Samuel', 3, ARRAY['3:4', '3:10']::text[], 'pending_review', 'Cum diferă răspunsul lui Samuel la prima chemare de răspunsul dat după ce Domnul i S-a înfățișat?'),
  ('1 Samuel', 3, ARRAY['3:5']::text[], 'pending_review', 'La cine a alergat Samuel după ce a auzit prima chemare, crezând că acea persoană îl chemase?'),
  ('1 Samuel', 3, ARRAY['3:5']::text[], 'pending_review', 'Ce i-a spus Eli lui Samuel când acesta a venit prima dată la el?'),
  ('1 Samuel', 3, ARRAY['3:6']::text[], 'pending_review', 'Cum i-a răspuns Eli lui Samuel după a doua chemare?'),
  ('1 Samuel', 3, ARRAY['3:8']::text[], 'pending_review', 'Ce a înțeles Eli după ce Domnul l-a chemat pe Samuel a treia oară?'),
  ('1 Samuel', 3, ARRAY['3:8', '3:9']::text[], 'pending_review', 'Ce cuvinte i-a spus Eli să folosească dacă Domnul îl mai chema?'),
  ('1 Samuel', 3, ARRAY['3:10']::text[], 'pending_review', 'Cum l-a chemat Domnul pe Samuel când a venit și S-a înfățișat înaintea lui?'),
  ('1 Samuel', 3, ARRAY['3:11']::text[], 'pending_review', 'Ce efect urma să aibă asupra celor care îl auzeau lucrul pe care Domnul îl va face în Israel?'),
  ('1 Samuel', 3, ARRAY['3:11', '3:12']::text[], 'pending_review', 'Ce a spus Domnul că va împlini în ziua aceea asupra casei lui Eli?'),
  ('1 Samuel', 3, ARRAY['3:13']::text[], 'pending_review', 'Potrivit mesajului Domnului, de ce urma să fie pedepsită casa lui Eli?'),
  ('1 Samuel', 3, ARRAY['3:14']::text[], 'pending_review', 'Prin ce nu avea să fie ispășită fărădelegea casei lui Eli, potrivit jurământului Domnului?'),
  ('1 Samuel', 3, ARRAY['3:15']::text[], 'pending_review', 'Ce a făcut Samuel după ce a rămas culcat până dimineața?'),
  ('1 Samuel', 3, ARRAY['3:15']::text[], 'pending_review', 'De ce se temea Samuel în dimineața aceea?'),
  ('1 Samuel', 3, ARRAY['3:16', '3:17']::text[], 'pending_review', 'Ce i-a cerut Eli lui Samuel după ce l-a chemat și l-a întrebat despre cuvântul Domnului?'),
  ('1 Samuel', 3, ARRAY['3:17', '3:18']::text[], 'pending_review', 'Cum a reacționat Samuel când Eli i-a cerut să-i spună tot ce auzise?'),
  ('1 Samuel', 3, ARRAY['3:18']::text[], 'pending_review', 'Ce a spus Eli după ce Samuel i-a istorisit totul?'),
  ('1 Samuel', 3, ARRAY['3:19']::text[], 'pending_review', 'Ce nu a lăsat Domnul să se întâmple cu niciunul dintre cuvintele lui Samuel?'),
  ('1 Samuel', 3, ARRAY['3:19', '3:20']::text[], 'pending_review', 'Ce a ajuns să cunoască tot Israelul, de la Dan până la Beer-Șeba?'),
  ('1 Samuel', 3, ARRAY['3:20', '3:21']::text[], 'pending_review', 'Unde Se descoperea Domnul lui Samuel prin Cuvântul Domnului?')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_abc_one (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Ce era rar în vremea când tânărul Samuel slujea Domnului înaintea lui Eli?', '[{"text":"Cuvântul Domnului.","correct":true},{"text":"Candela lui Dumnezeu.","correct":false},{"text":"Chivotul lui Dumnezeu.","correct":false}]'::jsonb, 3, 1, '1 Samuel', ARRAY['3:1']::text[], 'pending_review', 'Codex'),
  ('Cum sunt descrise vedeniile în vremea aceea?', '[{"text":"Se arătau în fiecare noapte.","correct":false},{"text":"Erau auzite de tot Israelul în fiecare zi.","correct":false},{"text":"Nu erau dese.","correct":true}]'::jsonb, 3, 1, '1 Samuel', ARRAY['3:1']::text[], 'pending_review', 'Codex'),
  ('Ce problemă avea Eli în timp ce stătea culcat la locul lui?', '[{"text":"Avea ochii tulburi și nu mai putea să vadă.","correct":true},{"text":"Nu mai putea să vorbească.","correct":false},{"text":"Nu se putea ridica din locul lui.","correct":false}]'::jsonb, 3, 1, '1 Samuel', ARRAY['3:2']::text[], 'pending_review', 'Codex'),
  ('Unde era culcat Samuel în timp ce candela lui Dumnezeu nu se stinsese încă?', '[{"text":"În Templul Domnului, unde era chivotul lui Dumnezeu.","correct":true},{"text":"La poarta cetății Silo.","correct":false},{"text":"În casa lui Elcana, la Rama.","correct":false}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:3']::text[], 'pending_review', 'Codex'),
  ('Cum diferă răspunsul lui Samuel la prima chemare de răspunsul dat după ce Domnul i S-a înfățișat?', '[{"text":"A răspuns în ambele ocazii numai: „Iată-mă!”","correct":false},{"text":"La prima a spus „Iată-mă!”, iar apoi: „Vorbește, căci robul Tău ascultă.”","correct":true},{"text":"La prima a spus „Vorbește, căci robul Tău ascultă”, iar apoi: „Iată-mă!”","correct":false}]'::jsonb, 3, 1, '1 Samuel', ARRAY['3:4', '3:10']::text[], 'pending_review', 'Codex'),
  ('La cine a alergat Samuel după ce a auzit prima chemare, crezând că acea persoană îl chemase?', '[{"text":"La Elcana.","correct":false},{"text":"La bătrânii lui Israel.","correct":false},{"text":"La Eli.","correct":true}]'::jsonb, 3, 1, '1 Samuel', ARRAY['3:5']::text[], 'pending_review', 'Codex'),
  ('Ce i-a spus Eli lui Samuel când acesta a venit prima dată la el?', '[{"text":"„Vorbește, Doamne, căci robul Tău ascultă.”","correct":false},{"text":"„Nu te-am chemat; întoarce-te și te culcă.”","correct":true},{"text":"„Spune-mi tot ce ai auzit.”","correct":false}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:5']::text[], 'pending_review', 'Codex'),
  ('Cum i-a răspuns Eli lui Samuel după a doua chemare?', '[{"text":"I-a spus că nu îl chemase și i-a cerut să se întoarcă și să se culce.","correct":true},{"text":"I-a spus că îl chemase și i-a cerut să rămână cu el.","correct":false},{"text":"L-a trimis să vorbească cu bătrânii lui Israel.","correct":false}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:6']::text[], 'pending_review', 'Codex'),
  ('Ce a înțeles Eli după ce Domnul l-a chemat pe Samuel a treia oară?', '[{"text":"Că Samuel voia să plece la Rama.","correct":false},{"text":"Că fusese stinsă candela lui Dumnezeu.","correct":false},{"text":"Că Domnul chema copilul.","correct":true}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:8']::text[], 'pending_review', 'Codex'),
  ('Ce cuvinte i-a spus Eli să folosească dacă Domnul îl mai chema?', '[{"text":"„Iată-mă, căci m-ai chemat.”","correct":false},{"text":"„Vorbește, Doamne, căci robul Tău ascultă.”","correct":true},{"text":"„Samuele, fiule, nu-mi ascunde nimic.”","correct":false}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:8', '3:9']::text[], 'pending_review', 'Codex'),
  ('Cum l-a chemat Domnul pe Samuel când a venit și S-a înfățișat înaintea lui?', '[{"text":"„Samuele, Samuele!”","correct":true},{"text":"„Eli, Eli!”","correct":false},{"text":"„Samuel, vino la Silo!”","correct":false}]'::jsonb, 3, 1, '1 Samuel', ARRAY['3:10']::text[], 'pending_review', 'Codex'),
  ('Ce efect urma să aibă asupra celor care îl auzeau lucrul pe care Domnul îl va face în Israel?', '[{"text":"Le va asurzi urechile.","correct":true},{"text":"Le va întuneca ochii.","correct":false},{"text":"Îi va face să uite cuvintele lui Samuel.","correct":false}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:11']::text[], 'pending_review', 'Codex'),
  ('Ce a spus Domnul că va împlini în ziua aceea asupra casei lui Eli?', '[{"text":"Doar o parte din cuvintele rostite împotriva casei lui.","correct":false},{"text":"Numai cuvintele spuse de Eli împotriva lui Samuel.","correct":false},{"text":"Tot ce rostise împotriva casei lui; va începe și va isprăvi.","correct":true}]'::jsonb, 3, 3, '1 Samuel', ARRAY['3:11', '3:12']::text[], 'pending_review', 'Codex'),
  ('Potrivit mesajului Domnului, de ce urma să fie pedepsită casa lui Eli?', '[{"text":"Din pricina fărădelegii cunoscute de Eli și pentru că nu și-a oprit fiii.","correct":true},{"text":"Pentru că Samuel deschisese ușile Casei Domnului.","correct":false},{"text":"Pentru că Eli nu mai putea să vadă.","correct":false}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:13']::text[], 'pending_review', 'Codex'),
  ('Prin ce nu avea să fie ispășită fărădelegea casei lui Eli, potrivit jurământului Domnului?', '[{"text":"Prin deschiderea ușilor Casei Domnului.","correct":false},{"text":"Nici prin jertfe, nici prin daruri de mâncare.","correct":true},{"text":"Prin faptul că Samuel îi va vorbi lui Eli.","correct":false}]'::jsonb, 3, 3, '1 Samuel', ARRAY['3:14']::text[], 'pending_review', 'Codex'),
  ('Ce a făcut Samuel după ce a rămas culcat până dimineața?', '[{"text":"A deschis ușile Casei Domnului.","correct":true},{"text":"A plecat la Dan.","correct":false},{"text":"A adunat bătrânii lui Israel.","correct":false}]'::jsonb, 3, 1, '1 Samuel', ARRAY['3:15']::text[], 'pending_review', 'Codex'),
  ('De ce se temea Samuel în dimineața aceea?', '[{"text":"Să deschidă ușile Casei Domnului.","correct":false},{"text":"Să se culce din nou la locul lui.","correct":false},{"text":"Să-i istorisească lui Eli vedenia.","correct":true}]'::jsonb, 3, 1, '1 Samuel', ARRAY['3:15']::text[], 'pending_review', 'Codex'),
  ('Ce i-a cerut Eli lui Samuel după ce l-a chemat și l-a întrebat despre cuvântul Domnului?', '[{"text":"Să nu-i ascundă nimic din tot ce îi spusese Domnul.","correct":true},{"text":"Să plece imediat la Hebron.","correct":false},{"text":"Să-i răspundă doar cu „Iată-mă!”","correct":false}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:16', '3:17']::text[], 'pending_review', 'Codex'),
  ('Cum a reacționat Samuel când Eli i-a cerut să-i spună tot ce auzise?', '[{"text":"I-a spus numai prima parte a vedeniei.","correct":false},{"text":"A refuzat să-i răspundă.","correct":false},{"text":"I-a istorisit tot, fără să-i ascundă nimic.","correct":true}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:17', '3:18']::text[], 'pending_review', 'Codex'),
  ('Ce a spus Eli după ce Samuel i-a istorisit totul?', '[{"text":"„Vorbește, Doamne, căci robul Tău ascultă.”","correct":false},{"text":"„Domnul este Acesta, să facă ce va crede!”","correct":true},{"text":"„Nu te-am chemat, întoarce-te și te culcă.”","correct":false}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:18']::text[], 'pending_review', 'Codex'),
  ('Ce nu a lăsat Domnul să se întâmple cu niciunul dintre cuvintele lui Samuel?', '[{"text":"Să cadă la pământ.","correct":true},{"text":"Să fie auzit la Silo.","correct":false},{"text":"Să fie spus înaintea lui Eli.","correct":false}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:19']::text[], 'pending_review', 'Codex'),
  ('Ce a ajuns să cunoască tot Israelul, de la Dan până la Beer-Șeba?', '[{"text":"Că Eli nu mai putea să vadă.","correct":false},{"text":"Că Samuel deschisese ușile Casei Domnului.","correct":false},{"text":"Că Domnul îl pusese pe Samuel proroc al Domnului.","correct":true}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:19', '3:20']::text[], 'pending_review', 'Codex'),
  ('Unde Se descoperea Domnul lui Samuel prin Cuvântul Domnului?', '[{"text":"La Beer-Șeba.","correct":false},{"text":"La Silo.","correct":true},{"text":"La Rama.","correct":false}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:20', '3:21']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 3, ARRAY['3:1']::text[], 'pending_review', 'Care afirmații descriu vremea în care Samuel slujea înaintea lui Eli?'),
  ('1 Samuel', 3, ARRAY['3:2']::text[], 'pending_review', 'Ce detalii despre Eli sunt menționate când stătea culcat la locul lui?'),
  ('1 Samuel', 3, ARRAY['3:3']::text[], 'pending_review', 'Ce spune textul despre locul și momentul în care Samuel era culcat?'),
  ('1 Samuel', 3, ARRAY['3:4', '3:5']::text[], 'pending_review', 'Ce detalii apar după prima chemare auzită de Samuel?'),
  ('1 Samuel', 3, ARRAY['3:6']::text[], 'pending_review', 'Ce se întâmplă în relatarea despre a doua chemare a lui Samuel?'),
  ('1 Samuel', 3, ARRAY['3:8']::text[], 'pending_review', 'Ce afirmații despre chemările repetate și reacția lui Eli sunt susținute de text?'),
  ('1 Samuel', 3, ARRAY['3:8', '3:9']::text[], 'pending_review', 'Ce cuprinde îndrumarea pe care Eli i-o dă lui Samuel pentru următoarea chemare?'),
  ('1 Samuel', 3, ARRAY['3:10']::text[], 'pending_review', 'Care detalii sunt menționate despre chemarea Domnului și răspunsul lui Samuel?'),
  ('1 Samuel', 3, ARRAY['3:11', '3:12']::text[], 'pending_review', 'Ce a anunțat Domnul că va face în Israel și asupra casei lui Eli?'),
  ('1 Samuel', 3, ARRAY['3:13']::text[], 'pending_review', 'Ce elemente sunt incluse în motivul pedepsei anunțate pentru casa lui Eli?'),
  ('1 Samuel', 3, ARRAY['3:14']::text[], 'pending_review', 'Ce precizează Domnul despre ispășirea fărădelegii casei lui Eli?'),
  ('1 Samuel', 3, ARRAY['3:15', '3:16']::text[], 'pending_review', 'Ce detalii despre dimineața de după vedenie sunt menționate?'),
  ('1 Samuel', 3, ARRAY['3:16', '3:17']::text[], 'pending_review', 'Ce i-a spus Eli lui Samuel când l-a chemat să afle cuvântul Domnului?'),
  ('1 Samuel', 3, ARRAY['3:19', '3:20', '3:21']::text[], 'pending_review', 'Ce se întâmplă după ce Samuel crește și Domnul este cu el?')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_abc_multi (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Care afirmații descriu vremea în care Samuel slujea înaintea lui Eli?', '[{"text":"Cuvântul Domnului era rar.","correct":true},{"text":"Samuel slujea în casa lui Elcana.","correct":false},{"text":"Vedenii nu erau dese.","correct":true}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:1']::text[], 'pending_review', 'Codex'),
  ('Ce detalii despre Eli sunt menționate când stătea culcat la locul lui?', '[{"text":"Stătea în picioare la ușile Casei Domnului.","correct":false},{"text":"Ochii lui începuseră să fie tulburi.","correct":true},{"text":"Nu mai putea să vadă.","correct":true}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:2']::text[], 'pending_review', 'Codex'),
  ('Ce spune textul despre locul și momentul în care Samuel era culcat?', '[{"text":"Samuel era în Templul Domnului, unde era chivotul.","correct":true},{"text":"Candela lui Dumnezeu nu se stinsese încă.","correct":true},{"text":"Samuel dormea în casa lui Eli.","correct":false}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:3']::text[], 'pending_review', 'Codex'),
  ('Ce detalii apar după prima chemare auzită de Samuel?', '[{"text":"Samuel a răspuns: „Iată-mă!”","correct":true},{"text":"Eli i-a spus că îl chemase el.","correct":false},{"text":"A alergat la Eli, crezând că Eli îl chemase.","correct":true}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:4', '3:5']::text[], 'pending_review', 'Codex'),
  ('Ce se întâmplă în relatarea despre a doua chemare a lui Samuel?', '[{"text":"Eli îi spune că Samuel nu mai trebuie să se culce.","correct":false},{"text":"Samuel se scoală și merge la Eli.","correct":true},{"text":"Eli îi spune: „Nu te-am chemat, fiule.”","correct":true}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:6']::text[], 'pending_review', 'Codex'),
  ('Ce afirmații despre chemările repetate și reacția lui Eli sunt susținute de text?', '[{"text":"Eli înțelege că Domnul cheamă copilul.","correct":true},{"text":"Domnul îl cheamă pe Samuel a treia oară.","correct":true},{"text":"Samuel îi cere lui Eli să se ducă la Hebron.","correct":false}]'::jsonb, 3, 3, '1 Samuel', ARRAY['3:8']::text[], 'pending_review', 'Codex'),
  ('Ce cuprinde îndrumarea pe care Eli i-o dă lui Samuel pentru următoarea chemare?', '[{"text":"Să se ducă să se culce.","correct":true},{"text":"Să spună că Eli l-a chemat.","correct":false},{"text":"Să spună: „Vorbește, Doamne, căci robul Tău ascultă.”","correct":true}]'::jsonb, 3, 3, '1 Samuel', ARRAY['3:8', '3:9']::text[], 'pending_review', 'Codex'),
  ('Care detalii sunt menționate despre chemarea Domnului și răspunsul lui Samuel?', '[{"text":"Samuel a răspuns: „Nu te-am chemat.”","correct":false},{"text":"Domnul a venit și S-a înfățișat.","correct":true},{"text":"Domnul l-a chemat spunându-i de două ori numele.","correct":true}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:10']::text[], 'pending_review', 'Codex'),
  ('Ce a anunțat Domnul că va face în Israel și asupra casei lui Eli?', '[{"text":"Va împlini tot ce rostise împotriva casei lui Eli.","correct":true},{"text":"Va face un lucru care va asurzi urechile celor care îl aud.","correct":true},{"text":"Va lăsa fără împlinire cuvintele rostite împotriva lui Eli.","correct":false}]'::jsonb, 3, 3, '1 Samuel', ARRAY['3:11', '3:12']::text[], 'pending_review', 'Codex'),
  ('Ce elemente sunt incluse în motivul pedepsei anunțate pentru casa lui Eli?', '[{"text":"Eli știa despre fărădelege.","correct":true},{"text":"Eli îi oprise pe fiii lui.","correct":false},{"text":"Fiii lui se făcuseră vrednici de lepădat.","correct":true}]'::jsonb, 3, 3, '1 Samuel', ARRAY['3:13']::text[], 'pending_review', 'Codex'),
  ('Ce precizează Domnul despre ispășirea fărădelegii casei lui Eli?', '[{"text":"Va fi ispășită prin faptul că Samuel deschide ușile.","correct":false},{"text":"Nu va fi ispășită prin jertfe.","correct":true},{"text":"Nu va fi ispășită prin daruri de mâncare.","correct":true}]'::jsonb, 3, 3, '1 Samuel', ARRAY['3:14']::text[], 'pending_review', 'Codex'),
  ('Ce detalii despre dimineața de după vedenie sunt menționate?', '[{"text":"A deschis ușile Casei Domnului.","correct":true},{"text":"Samuel a rămas culcat până dimineața.","correct":true},{"text":"I-a istorisit vedenia lui Eli înainte ca acesta să-l cheme.","correct":false}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:15', '3:16']::text[], 'pending_review', 'Codex'),
  ('Ce i-a spus Eli lui Samuel când l-a chemat să afle cuvântul Domnului?', '[{"text":"L-a strigat: „Samuele, fiule!”","correct":true},{"text":"I-a cerut să-i spună numai ce era ușor de auzit.","correct":false},{"text":"I-a cerut să nu-i ascundă nimic.","correct":true}]'::jsonb, 3, 2, '1 Samuel', ARRAY['3:16', '3:17']::text[], 'pending_review', 'Codex'),
  ('Ce se întâmplă după ce Samuel crește și Domnul este cu el?', '[{"text":"Domnul încetează să Se arate în Silo.","correct":false},{"text":"Domnul nu lasă să cadă la pământ niciunul dintre cuvintele lui Samuel.","correct":true},{"text":"Tot Israelul, de la Dan până la Beer-Șeba, îl recunoaște ca proroc al Domnului.","correct":true}]'::jsonb, 3, 3, '1 Samuel', ARRAY['3:19', '3:20', '3:21']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 3, ARRAY['3:1', '3:2', '3:3']::text[], 'pending_review', '[{"left":"Cuvântul Domnului în vremea aceea","right":"Era rar"},{"left":"Vedenii","right":"Nu erau dese"},{"left":"Ochii lui Eli","right":"Începuseră să fie tulburi"},{"left":"Candela lui Dumnezeu","right":"Nu se stinsese încă"},{"left":"Samuel culcat în Templu","right":"Era în locul unde se afla chivotul lui Dumnezeu"}]'::jsonb),
  ('1 Samuel', 3, ARRAY['3:4', '3:5', '3:8', '3:9', '3:10']::text[], 'pending_review', '[{"left":"Prima chemare a Domnului","right":"Samuel răspunde: „Iată-mă!”"},{"left":"După ce aude chemarea","right":"Samuel aleargă la Eli"},{"left":"A treia chemare","right":"Eli înțelege că Domnul cheamă copilul"},{"left":"Îndrumarea lui Eli","right":"Samuel să spună: „Vorbește, Doamne, căci robul Tău ascultă”"},{"left":"Chemarea în care Domnul Se înfățișează","right":"Samuel răspunde că robul Lui ascultă"}]'::jsonb),
  ('1 Samuel', 3, ARRAY['3:11', '3:12', '3:13', '3:14']::text[], 'pending_review', '[{"left":"Lucrul pe care Domnul îl va face în Israel","right":"Va asurzi urechile oricui îl va auzi"},{"left":"În ziua aceea","right":"Domnul va împlini ce a rostit împotriva casei lui Eli"},{"left":"Fiii lui Eli","right":"S-au făcut vrednici de lepădat prin fărădelegea lor"},{"left":"Eli","right":"Știa despre fărădelege și nu și-a oprit fiii"},{"left":"Fărădelegea casei lui Eli","right":"Nu va fi ispășită prin jertfe sau daruri de mâncare"}]'::jsonb),
  ('1 Samuel', 3, ARRAY['3:15', '3:16', '3:17', '3:18']::text[], 'pending_review', '[{"left":"Samuel până dimineața","right":"Rămâne culcat"},{"left":"După ce se scoală dimineața","right":"Deschide ușile Casei Domnului"},{"left":"Samuel după vedenie","right":"Se teme să i-o istorisească lui Eli"},{"left":"Eli către Samuel","right":"Îi cere să nu-i ascundă nimic"},{"left":"Samuel către Eli","right":"Îi istorisește totul fără să ascundă nimic"}]'::jsonb),
  ('1 Samuel', 3, ARRAY['3:19', '3:20', '3:21']::text[], 'pending_review', '[{"left":"Samuel pe măsură ce crește","right":"Domnul este cu el"},{"left":"Cuvintele lui Samuel","right":"Niciunul nu cade la pământ"},{"left":"Dan până la Beer-Șeba","right":"Tot Israelul cunoaște că Samuel este proroc"},{"left":"Silo","right":"Domnul Se arată și Se descoperă lui Samuel"},{"left":"Felul descoperirii la Silo","right":"Prin Cuvântul Domnului"}]'::jsonb),
  ('1 Samuel', 3, ARRAY['3:4', '3:5', '3:9', '3:10', '3:18']::text[], 'pending_review', '[{"left":"Răspunsul lui Samuel la chemarea Domnului","right":"„Iată-mă!”"},{"left":"Răspunsul lui Eli când Samuel vine la el","right":"„Nu te-am chemat; întoarce-te și te culcă.”"},{"left":"Răspunsul recomandat de Eli la o nouă chemare","right":"„Vorbește, Doamne, căci robul Tău ascultă.”"},{"left":"Răspunsul lui Samuel după ce Domnul îl cheamă din nou","right":"„Vorbește, căci robul Tău ascultă.”"},{"left":"Răspunsul lui Eli după ce află vedenia","right":"„Domnul este Acesta, să facă ce va crede!”"}]'::jsonb)
) as incoming (book, chapter, source_references, status, pairs)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.pairs = incoming.pairs;

insert into public.questions_match (pairs, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.pairs, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('[{"left":"Cuvântul Domnului în vremea aceea","right":"Era rar"},{"left":"Vedenii","right":"Nu erau dese"},{"left":"Ochii lui Eli","right":"Începuseră să fie tulburi"},{"left":"Candela lui Dumnezeu","right":"Nu se stinsese încă"},{"left":"Samuel culcat în Templu","right":"Era în locul unde se afla chivotul lui Dumnezeu"}]'::jsonb, 3, 3, '1 Samuel', ARRAY['3:1', '3:2', '3:3']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Prima chemare a Domnului","right":"Samuel răspunde: „Iată-mă!”"},{"left":"După ce aude chemarea","right":"Samuel aleargă la Eli"},{"left":"A treia chemare","right":"Eli înțelege că Domnul cheamă copilul"},{"left":"Îndrumarea lui Eli","right":"Samuel să spună: „Vorbește, Doamne, căci robul Tău ascultă”"},{"left":"Chemarea în care Domnul Se înfățișează","right":"Samuel răspunde că robul Lui ascultă"}]'::jsonb, 3, 4, '1 Samuel', ARRAY['3:4', '3:5', '3:8', '3:9', '3:10']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Lucrul pe care Domnul îl va face în Israel","right":"Va asurzi urechile oricui îl va auzi"},{"left":"În ziua aceea","right":"Domnul va împlini ce a rostit împotriva casei lui Eli"},{"left":"Fiii lui Eli","right":"S-au făcut vrednici de lepădat prin fărădelegea lor"},{"left":"Eli","right":"Știa despre fărădelege și nu și-a oprit fiii"},{"left":"Fărădelegea casei lui Eli","right":"Nu va fi ispășită prin jertfe sau daruri de mâncare"}]'::jsonb, 3, 4, '1 Samuel', ARRAY['3:11', '3:12', '3:13', '3:14']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Samuel până dimineața","right":"Rămâne culcat"},{"left":"După ce se scoală dimineața","right":"Deschide ușile Casei Domnului"},{"left":"Samuel după vedenie","right":"Se teme să i-o istorisească lui Eli"},{"left":"Eli către Samuel","right":"Îi cere să nu-i ascundă nimic"},{"left":"Samuel către Eli","right":"Îi istorisește totul fără să ascundă nimic"}]'::jsonb, 3, 3, '1 Samuel', ARRAY['3:15', '3:16', '3:17', '3:18']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Samuel pe măsură ce crește","right":"Domnul este cu el"},{"left":"Cuvintele lui Samuel","right":"Niciunul nu cade la pământ"},{"left":"Dan până la Beer-Șeba","right":"Tot Israelul cunoaște că Samuel este proroc"},{"left":"Silo","right":"Domnul Se arată și Se descoperă lui Samuel"},{"left":"Felul descoperirii la Silo","right":"Prin Cuvântul Domnului"}]'::jsonb, 3, 4, '1 Samuel', ARRAY['3:19', '3:20', '3:21']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Răspunsul lui Samuel la chemarea Domnului","right":"„Iată-mă!”"},{"left":"Răspunsul lui Eli când Samuel vine la el","right":"„Nu te-am chemat; întoarce-te și te culcă.”"},{"left":"Răspunsul recomandat de Eli la o nouă chemare","right":"„Vorbește, Doamne, căci robul Tău ascultă.”"},{"left":"Răspunsul lui Samuel după ce Domnul îl cheamă din nou","right":"„Vorbește, căci robul Tău ascultă.”"},{"left":"Răspunsul lui Eli după ce află vedenia","right":"„Domnul este Acesta, să facă ce va crede!”"}]'::jsonb, 3, 4, '1 Samuel', ARRAY['3:4', '3:5', '3:9', '3:10', '3:18']::text[], 'pending_review', 'Codex')
) as incoming (pairs, chapter, difficulty, book, source_references, status, added_by)
where not exists (
  select 1 from public.questions_match existing
  where existing.book = incoming.book
    and existing.chapter = incoming.chapter
    and existing.source_references = incoming.source_references
    and existing.pairs = incoming.pairs
);

commit;
