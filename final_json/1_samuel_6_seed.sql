begin;

alter table public.questions_tf add column if not exists source_references text[] not null default '{}';

alter table public.questions_abc_one add column if not exists source_references text[] not null default '{}';

alter table public.questions_abc_multi add column if not exists source_references text[] not null default '{}';

alter table public.questions_match add column if not exists source_references text[] not null default '{}';

update public.questions_tf as existing
set status = incoming.status
from (values
  ('1 Samuel', 6, ARRAY['6:1']::text[], 'pending_review', 'Chivotul Domnului a stat șapte luni în țara filistenilor.'),
  ('1 Samuel', 6, ARRAY['6:2']::text[], 'pending_review', 'Filistenii i-au chemat pe preoți și pe ghicitori și i-au întrebat cum să trimită chivotul înapoi.'),
  ('1 Samuel', 6, ARRAY['6:3']::text[], 'pending_review', 'Preoții și ghicitorii i-au sfătuit pe filisteni să trimită chivotul cu mâna goală.'),
  ('1 Samuel', 6, ARRAY['6:4']::text[], 'pending_review', 'Ei au spus ca darul pentru vină să cuprindă cinci umflături de aur și cinci șoareci de aur.'),
  ('1 Samuel', 6, ARRAY['6:4']::text[], 'pending_review', 'Aceeași urgie fusese peste filisteni și peste domnitorii lor.'),
  ('1 Samuel', 6, ARRAY['6:5']::text[], 'pending_review', 'Sfatul era să facă chipuri numai după șoareci, nu și după umflături.'),
  ('1 Samuel', 6, ARRAY['6:5']::text[], 'pending_review', 'Filistenii au fost îndemnați să dea slavă Dumnezeului lui Israel.'),
  ('1 Samuel', 6, ARRAY['6:6']::text[], 'pending_review', 'În sfatul dat filistenilor a fost amintită împietrirea inimii egiptenilor și a lui Faraon.'),
  ('1 Samuel', 6, ARRAY['6:6']::text[], 'pending_review', 'Egiptenii și Faraon au fost pedepsiți, iar apoi au lăsat poporul Israel să plece.'),
  ('1 Samuel', 6, ARRAY['6:7']::text[], 'pending_review', 'Filistenii trebuiau să facă un car nou și să ia două vaci tinere care alăptau și nu trăseseră la jug.'),
  ('1 Samuel', 6, ARRAY['6:7', '6:10']::text[], 'pending_review', 'Vițeii vacilor urmau să meargă cu mamele lor la Bet-Șemeș.'),
  ('1 Samuel', 6, ARRAY['6:8']::text[], 'pending_review', 'Chivotul urma să fie pus în car, iar lucrurile de aur într-o ladă alături de el.'),
  ('1 Samuel', 6, ARRAY['6:9']::text[], 'pending_review', 'Dacă vacile mergeau spre Bet-Șemeș pe drumul hotarului lor, filistenii urmau să considere că Domnul le făcuse răul.'),
  ('1 Samuel', 6, ARRAY['6:9']::text[], 'pending_review', 'Dacă vacile nu mergeau pe drumul spre Bet-Șemeș, filistenii urmau să știe că mâna Domnului îi lovise.'),
  ('1 Samuel', 6, ARRAY['6:12']::text[], 'pending_review', 'Vacile au mers spre Bet-Șemeș mugind și nu s-au abătut nici la dreapta, nici la stânga.'),
  ('1 Samuel', 6, ARRAY['6:12']::text[], 'pending_review', 'Domnitorii filistenilor au mers după vaci până la hotarul Bet-Șemeșului.'),
  ('1 Samuel', 6, ARRAY['6:13']::text[], 'pending_review', 'Locuitorii din Bet-Șemeș secerau grânele în vale când au zărit chivotul și s-au bucurat.'),
  ('1 Samuel', 6, ARRAY['6:14']::text[], 'pending_review', 'Carul s-a oprit în câmpul lui Iosua din Bet-Șemeș, unde se afla o piatră mare.'),
  ('1 Samuel', 6, ARRAY['6:14']::text[], 'pending_review', 'Oamenii au desfăcut carul, iar vacile le-au adus ca ardere-de-tot Domnului.'),
  ('1 Samuel', 6, ARRAY['6:15']::text[], 'pending_review', 'Leviții au coborât chivotul și lada cu lucrurile de aur și le-au pus pe piatra cea mare.'),
  ('1 Samuel', 6, ARRAY['6:16']::text[], 'pending_review', 'Cei cinci domnitori filisteni s-au întors la Gat în aceeași zi.'),
  ('1 Samuel', 6, ARRAY['6:17']::text[], 'pending_review', 'Filistenii au dat câte o umflătură de aur pentru fiecare dintre cele cinci cetăți numite în relatare.'),
  ('1 Samuel', 6, ARRAY['6:18']::text[], 'pending_review', 'Șoarecii de aur erau după numărul cetăților tuturor celor cinci căpetenii, fie că aveau ziduri, fie că nu aveau.'),
  ('1 Samuel', 6, ARRAY['6:19', '6:20']::text[], 'pending_review', 'După ce s-au uitat în chivot, locuitorii Bet-Șemeșului au sărbătorit și au hotărât să-l păstreze acolo.')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_tf (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Chivotul Domnului a stat șapte luni în țara filistenilor.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 6, 1, '1 Samuel', ARRAY['6:1']::text[], 'pending_review', 'Codex'),
  ('Filistenii i-au chemat pe preoți și pe ghicitori și i-au întrebat cum să trimită chivotul înapoi.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 6, 1, '1 Samuel', ARRAY['6:2']::text[], 'pending_review', 'Codex'),
  ('Preoții și ghicitorii i-au sfătuit pe filisteni să trimită chivotul cu mâna goală.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:3']::text[], 'pending_review', 'Codex'),
  ('Ei au spus ca darul pentru vină să cuprindă cinci umflături de aur și cinci șoareci de aur.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 6, 1, '1 Samuel', ARRAY['6:4']::text[], 'pending_review', 'Codex'),
  ('Aceeași urgie fusese peste filisteni și peste domnitorii lor.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:4']::text[], 'pending_review', 'Codex'),
  ('Sfatul era să facă chipuri numai după șoareci, nu și după umflături.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:5']::text[], 'pending_review', 'Codex'),
  ('Filistenii au fost îndemnați să dea slavă Dumnezeului lui Israel.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 6, 1, '1 Samuel', ARRAY['6:5']::text[], 'pending_review', 'Codex'),
  ('În sfatul dat filistenilor a fost amintită împietrirea inimii egiptenilor și a lui Faraon.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:6']::text[], 'pending_review', 'Codex'),
  ('Egiptenii și Faraon au fost pedepsiți, iar apoi au lăsat poporul Israel să plece.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:6']::text[], 'pending_review', 'Codex'),
  ('Filistenii trebuiau să facă un car nou și să ia două vaci tinere care alăptau și nu trăseseră la jug.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:7']::text[], 'pending_review', 'Codex'),
  ('Vițeii vacilor urmau să meargă cu mamele lor la Bet-Șemeș.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 6, 1, '1 Samuel', ARRAY['6:7', '6:10']::text[], 'pending_review', 'Codex'),
  ('Chivotul urma să fie pus în car, iar lucrurile de aur într-o ladă alături de el.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:8']::text[], 'pending_review', 'Codex'),
  ('Dacă vacile mergeau spre Bet-Șemeș pe drumul hotarului lor, filistenii urmau să considere că Domnul le făcuse răul.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 6, 3, '1 Samuel', ARRAY['6:9']::text[], 'pending_review', 'Codex'),
  ('Dacă vacile nu mergeau pe drumul spre Bet-Șemeș, filistenii urmau să știe că mâna Domnului îi lovise.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 6, 3, '1 Samuel', ARRAY['6:9']::text[], 'pending_review', 'Codex'),
  ('Vacile au mers spre Bet-Șemeș mugind și nu s-au abătut nici la dreapta, nici la stânga.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 6, 1, '1 Samuel', ARRAY['6:12']::text[], 'pending_review', 'Codex'),
  ('Domnitorii filistenilor au mers după vaci până la hotarul Bet-Șemeșului.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:12']::text[], 'pending_review', 'Codex'),
  ('Locuitorii din Bet-Șemeș secerau grânele în vale când au zărit chivotul și s-au bucurat.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 6, 1, '1 Samuel', ARRAY['6:13']::text[], 'pending_review', 'Codex'),
  ('Carul s-a oprit în câmpul lui Iosua din Bet-Șemeș, unde se afla o piatră mare.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:14']::text[], 'pending_review', 'Codex'),
  ('Oamenii au desfăcut carul, iar vacile le-au adus ca ardere-de-tot Domnului.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:14']::text[], 'pending_review', 'Codex'),
  ('Leviții au coborât chivotul și lada cu lucrurile de aur și le-au pus pe piatra cea mare.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:15']::text[], 'pending_review', 'Codex'),
  ('Cei cinci domnitori filisteni s-au întors la Gat în aceeași zi.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 6, 1, '1 Samuel', ARRAY['6:16']::text[], 'pending_review', 'Codex'),
  ('Filistenii au dat câte o umflătură de aur pentru fiecare dintre cele cinci cetăți numite în relatare.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:17']::text[], 'pending_review', 'Codex'),
  ('Șoarecii de aur erau după numărul cetăților tuturor celor cinci căpetenii, fie că aveau ziduri, fie că nu aveau.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 6, 3, '1 Samuel', ARRAY['6:18']::text[], 'pending_review', 'Codex'),
  ('După ce s-au uitat în chivot, locuitorii Bet-Șemeșului au sărbătorit și au hotărât să-l păstreze acolo.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:19', '6:20']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 6, ARRAY['6:1']::text[], 'pending_review', 'Cât timp a stat chivotul Domnului în țara filistenilor?'),
  ('1 Samuel', 6, ARRAY['6:2']::text[], 'pending_review', 'Pe cine au chemat filistenii ca să-i întrebe ce să facă cu chivotul?'),
  ('1 Samuel', 6, ARRAY['6:2']::text[], 'pending_review', 'Ce i-au rugat filistenii pe preoți și pe ghicitori să le arate?'),
  ('1 Samuel', 6, ARRAY['6:3']::text[], 'pending_review', 'Ce trebuiau să aducă filistenii împreună cu chivotul, potrivit răspunsului primit?'),
  ('1 Samuel', 6, ARRAY['6:4']::text[], 'pending_review', 'Câte umflături de aur și câți șoareci de aur au fost recomandați ca dar pentru vină?'),
  ('1 Samuel', 6, ARRAY['6:4']::text[], 'pending_review', 'După numărul cui trebuia făcut darul cu umflături și șoareci de aur?'),
  ('1 Samuel', 6, ARRAY['6:5']::text[], 'pending_review', 'După ce urmau să facă filistenii chipuri de aur, potrivit sfatului?'),
  ('1 Samuel', 6, ARRAY['6:6']::text[], 'pending_review', 'Pe cine au fost îndemnați filistenii să ia ca exemplu în privința împietririi inimii?'),
  ('1 Samuel', 6, ARRAY['6:7']::text[], 'pending_review', 'Cum trebuia să fie carul pe care urmau să-l pregătească filistenii?'),
  ('1 Samuel', 6, ARRAY['6:7']::text[], 'pending_review', 'Ce fel de vaci urmau să fie înjugate la car?'),
  ('1 Samuel', 6, ARRAY['6:7']::text[], 'pending_review', 'Ce trebuiau să facă filistenii cu vițeii vacilor?'),
  ('1 Samuel', 6, ARRAY['6:8']::text[], 'pending_review', 'Unde trebuiau puse lucrurile de aur oferite ca dar pentru vină?'),
  ('1 Samuel', 6, ARRAY['6:9']::text[], 'pending_review', 'Spre ce cetate trebuia să urce carul pentru ca filistenii să urmărească drumul vacilor?'),
  ('1 Samuel', 6, ARRAY['6:9']::text[], 'pending_review', 'Ce urmau să înțeleagă filistenii dacă vacile nu mergeau spre Bet-Șemeș?'),
  ('1 Samuel', 6, ARRAY['6:12']::text[], 'pending_review', 'Cum au mers vacile pe drumul spre Bet-Șemeș?'),
  ('1 Samuel', 6, ARRAY['6:12']::text[], 'pending_review', 'Până unde au mers după vaci domnitorii filistenilor?'),
  ('1 Samuel', 6, ARRAY['6:13']::text[], 'pending_review', 'Ce făceau locuitorii din Bet-Șemeș în vale când au văzut chivotul?'),
  ('1 Samuel', 6, ARRAY['6:14']::text[], 'pending_review', 'În al cui câmp a ajuns carul în Bet-Șemeș?'),
  ('1 Samuel', 6, ARRAY['6:14']::text[], 'pending_review', 'Ce au adus oamenii ca ardere-de-tot Domnului după ce carul s-a oprit?'),
  ('1 Samuel', 6, ARRAY['6:15']::text[], 'pending_review', 'Cine a coborât chivotul Domnului și lada cu lucrurile de aur?'),
  ('1 Samuel', 6, ARRAY['6:16']::text[], 'pending_review', 'Unde s-au întors cei cinci domnitori ai filistenilor după ce au văzut ce s-a întâmplat?'),
  ('1 Samuel', 6, ARRAY['6:17']::text[], 'pending_review', 'Care dintre acestea este una dintre cetățile pentru care filistenii au dat câte o umflătură de aur?'),
  ('1 Samuel', 6, ARRAY['6:20', '6:21']::text[], 'pending_review', 'La cine au trimis soli locuitorii din Bet-Șemeș ca să le ducă chivotul?'),
  ('1 Samuel', 6, ARRAY['6:15']::text[], 'pending_review', 'Pe ce au pus leviții chivotul și lada după ce le-au coborât?')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_abc_one (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Cât timp a stat chivotul Domnului în țara filistenilor?', '[{"text":"Șapte luni","correct":true},{"text":"Șapte zile","correct":false},{"text":"Un an","correct":false}]'::jsonb, 6, 1, '1 Samuel', ARRAY['6:1']::text[], 'pending_review', 'Codex'),
  ('Pe cine au chemat filistenii ca să-i întrebe ce să facă cu chivotul?', '[{"text":"Pe preoți și pe ghicitori","correct":true},{"text":"Pe domnitorii din Bet-Șemeș","correct":false},{"text":"Pe locuitorii din Chiriat-Iearim","correct":false}]'::jsonb, 6, 1, '1 Samuel', ARRAY['6:2']::text[], 'pending_review', 'Codex'),
  ('Ce i-au rugat filistenii pe preoți și pe ghicitori să le arate?', '[{"text":"Cum să trimită chivotul înapoi la locul lui","correct":true},{"text":"Cum să-l așeze în casa lui Dagon","correct":false},{"text":"Cum să-l păstreze în țara filistenilor","correct":false}]'::jsonb, 6, 1, '1 Samuel', ARRAY['6:2']::text[], 'pending_review', 'Codex'),
  ('Ce trebuiau să aducă filistenii împreună cu chivotul, potrivit răspunsului primit?', '[{"text":"O jertfă pentru vină","correct":true},{"text":"Un car vechi","correct":false},{"text":"O ardere-de-tot din grâne","correct":false}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:3']::text[], 'pending_review', 'Codex'),
  ('Câte umflături de aur și câți șoareci de aur au fost recomandați ca dar pentru vină?', '[{"text":"Cinci umflături și cinci șoareci","correct":true},{"text":"Șapte umflături și cinci șoareci","correct":false},{"text":"Cinci umflături și șapte șoareci","correct":false}]'::jsonb, 6, 1, '1 Samuel', ARRAY['6:4']::text[], 'pending_review', 'Codex'),
  ('După numărul cui trebuia făcut darul cu umflături și șoareci de aur?', '[{"text":"Al domnitorilor filistenilor","correct":true},{"text":"Al preoților lui Dagon","correct":false},{"text":"Al cetăților din Israel","correct":false}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:4']::text[], 'pending_review', 'Codex'),
  ('După ce urmau să facă filistenii chipuri de aur, potrivit sfatului?', '[{"text":"După umflăturile lor și după șoarecii care pustiau țara","correct":true},{"text":"După vacile care trăgeau carul","correct":false},{"text":"După piatra din câmpul lui Iosua","correct":false}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:5']::text[], 'pending_review', 'Codex'),
  ('Pe cine au fost îndemnați filistenii să ia ca exemplu în privința împietririi inimii?', '[{"text":"Pe egipteni și pe Faraon","correct":true},{"text":"Pe locuitorii din Bet-Șemeș","correct":false},{"text":"Pe cei cinci domnitori","correct":false}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:6']::text[], 'pending_review', 'Codex'),
  ('Cum trebuia să fie carul pe care urmau să-l pregătească filistenii?', '[{"text":"Nou de tot","correct":true},{"text":"Vechi și întărit","correct":false},{"text":"Făcut din aur","correct":false}]'::jsonb, 6, 1, '1 Samuel', ARRAY['6:7']::text[], 'pending_review', 'Codex'),
  ('Ce fel de vaci urmau să fie înjugate la car?', '[{"text":"Două vaci tinere, care alăptau și nu trăseseră la jug","correct":true},{"text":"Două vaci bătrâne, care mai trăseseră la jug","correct":false},{"text":"O vacă și un vițel","correct":false}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:7']::text[], 'pending_review', 'Codex'),
  ('Ce trebuiau să facă filistenii cu vițeii vacilor?', '[{"text":"Să-i mâne înapoi acasă","correct":true},{"text":"Să-i pună în car lângă chivot","correct":false},{"text":"Să-i ducă la Bet-Șemeș","correct":false}]'::jsonb, 6, 1, '1 Samuel', ARRAY['6:7']::text[], 'pending_review', 'Codex'),
  ('Unde trebuiau puse lucrurile de aur oferite ca dar pentru vină?', '[{"text":"Într-o ladă alături de chivot, în car","correct":true},{"text":"În interiorul chivotului","correct":false},{"text":"Pe spatele vacilor","correct":false}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:8']::text[], 'pending_review', 'Codex'),
  ('Spre ce cetate trebuia să urce carul pentru ca filistenii să urmărească drumul vacilor?', '[{"text":"Bet-Șemeș","correct":true},{"text":"Ecron","correct":false},{"text":"Gat","correct":false}]'::jsonb, 6, 1, '1 Samuel', ARRAY['6:9']::text[], 'pending_review', 'Codex'),
  ('Ce urmau să înțeleagă filistenii dacă vacile nu mergeau spre Bet-Șemeș?', '[{"text":"Că mâna Domnului nu îi lovise și că lucrul se întâmplase din întâmplare","correct":true},{"text":"Că Domnul le făcuse acest mare rău","correct":false},{"text":"Că locuitorii din Gat au luat chivotul","correct":false}]'::jsonb, 6, 3, '1 Samuel', ARRAY['6:9']::text[], 'pending_review', 'Codex'),
  ('Cum au mers vacile pe drumul spre Bet-Șemeș?', '[{"text":"Drept, mugind, fără să se abată la dreapta sau la stânga","correct":true},{"text":"Au mers în cerc și s-au întors la Asdod","correct":false},{"text":"Au mers la dreapta și apoi la stânga","correct":false}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:12']::text[], 'pending_review', 'Codex'),
  ('Până unde au mers după vaci domnitorii filistenilor?', '[{"text":"Până la hotarul Bet-Șemeșului","correct":true},{"text":"Până la Chiriat-Iearim","correct":false},{"text":"Până la Ecron","correct":false}]'::jsonb, 6, 1, '1 Samuel', ARRAY['6:12']::text[], 'pending_review', 'Codex'),
  ('Ce făceau locuitorii din Bet-Șemeș în vale când au văzut chivotul?', '[{"text":"Secerau grânele","correct":true},{"text":"Înjugau vacile","correct":false},{"text":"Tăiau lemnele carului","correct":false}]'::jsonb, 6, 1, '1 Samuel', ARRAY['6:13']::text[], 'pending_review', 'Codex'),
  ('În al cui câmp a ajuns carul în Bet-Șemeș?', '[{"text":"În câmpul lui Iosua","correct":true},{"text":"În câmpul leviților","correct":false},{"text":"În câmpul domnitorilor filisteni","correct":false}]'::jsonb, 6, 1, '1 Samuel', ARRAY['6:14']::text[], 'pending_review', 'Codex'),
  ('Ce au adus oamenii ca ardere-de-tot Domnului după ce carul s-a oprit?', '[{"text":"Vacile","correct":true},{"text":"Vițeii","correct":false},{"text":"Șoarecii de aur","correct":false}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:14']::text[], 'pending_review', 'Codex'),
  ('Cine a coborât chivotul Domnului și lada cu lucrurile de aur?', '[{"text":"Leviții","correct":true},{"text":"Cei cinci domnitori filisteni","correct":false},{"text":"Locuitorii din Chiriat-Iearim","correct":false}]'::jsonb, 6, 1, '1 Samuel', ARRAY['6:15']::text[], 'pending_review', 'Codex'),
  ('Unde s-au întors cei cinci domnitori ai filistenilor după ce au văzut ce s-a întâmplat?', '[{"text":"La Ecron","correct":true},{"text":"La Gat","correct":false},{"text":"La Bet-Șemeș","correct":false}]'::jsonb, 6, 1, '1 Samuel', ARRAY['6:16']::text[], 'pending_review', 'Codex'),
  ('Care dintre acestea este una dintre cetățile pentru care filistenii au dat câte o umflătură de aur?', '[{"text":"Ascalon","correct":true},{"text":"Bet-Șemeș","correct":false},{"text":"Chiriat-Iearim","correct":false}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:17']::text[], 'pending_review', 'Codex'),
  ('La cine au trimis soli locuitorii din Bet-Șemeș ca să le ducă chivotul?', '[{"text":"La locuitorii din Chiriat-Iearim","correct":true},{"text":"La preoții și ghicitorii filistenilor","correct":false},{"text":"La domnitorii din Ecron","correct":false}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:20', '6:21']::text[], 'pending_review', 'Codex'),
  ('Pe ce au pus leviții chivotul și lada după ce le-au coborât?', '[{"text":"Pe piatra cea mare","correct":true},{"text":"În câmpul din Ecron","correct":false},{"text":"În carul nou","correct":false}]'::jsonb, 6, 1, '1 Samuel', ARRAY['6:15']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 6, ARRAY['6:2', '6:3']::text[], 'pending_review', 'Ce instrucțiuni au primit filistenii despre întoarcerea chivotului?'),
  ('1 Samuel', 6, ARRAY['6:4']::text[], 'pending_review', 'Ce precizări au fost făcute despre darul de aur pentru vină?'),
  ('1 Samuel', 6, ARRAY['6:5']::text[], 'pending_review', 'După ce imagini de aur au fost sfătuiți filistenii să facă și ce urmau să facă?'),
  ('1 Samuel', 6, ARRAY['6:3']::text[], 'pending_review', 'Ce rezultate sperau preoții și ghicitorii să urmeze după darul pentru vină?'),
  ('1 Samuel', 6, ARRAY['6:6']::text[], 'pending_review', 'Ce s-a spus despre împietrirea inimii egiptenilor și despre plecarea copiilor lui Israel?'),
  ('1 Samuel', 6, ARRAY['6:7']::text[], 'pending_review', 'Cum trebuia pregătit carul și ce fel de vaci urmau să fie puse la el?'),
  ('1 Samuel', 6, ARRAY['6:7', '6:10']::text[], 'pending_review', 'Ce trebuiau să facă filistenii cu vițeii și cu vacile înainte să trimită carul?'),
  ('1 Samuel', 6, ARRAY['6:8']::text[], 'pending_review', 'Cum trebuiau așezate chivotul și darurile de aur pentru drum?'),
  ('1 Samuel', 6, ARRAY['6:9']::text[], 'pending_review', 'Ce condiții au stabilit filistenii ca să judece dacă Domnul îi lovise?'),
  ('1 Samuel', 6, ARRAY['6:10']::text[], 'pending_review', 'Ce au făcut oamenii când au pus în practică instrucțiunile despre vaci?'),
  ('1 Samuel', 6, ARRAY['6:11']::text[], 'pending_review', 'Ce au pus oamenii în car înainte ca vacile să pornească?'),
  ('1 Samuel', 6, ARRAY['6:12']::text[], 'pending_review', 'Cum au mers vacile după ce au fost înjugate și au pornit spre Bet-Șemeș?'),
  ('1 Samuel', 6, ARRAY['6:12', '6:16']::text[], 'pending_review', 'Ce au făcut cei cinci domnitori filisteni în timpul și după mersul vacilor?'),
  ('1 Samuel', 6, ARRAY['6:13']::text[], 'pending_review', 'Ce se spune despre locuitorii din Bet-Șemeș când chivotul s-a apropiat?'),
  ('1 Samuel', 6, ARRAY['6:14']::text[], 'pending_review', 'Ce detalii sunt date despre locul unde s-a oprit carul?'),
  ('1 Samuel', 6, ARRAY['6:14']::text[], 'pending_review', 'Ce au făcut locuitorii din Bet-Șemeș cu carul și cu vacile?'),
  ('1 Samuel', 6, ARRAY['6:15']::text[], 'pending_review', 'Ce au făcut leviții și locuitorii din Bet-Șemeș după ce carul s-a oprit?'),
  ('1 Samuel', 6, ARRAY['6:17', '6:18']::text[], 'pending_review', 'Ce precizează relatarea despre darurile filistenilor și cetățile lor?'),
  ('1 Samuel', 6, ARRAY['6:19']::text[], 'pending_review', 'Ce spune textul despre lovirea și reacția locuitorilor din Bet-Șemeș?'),
  ('1 Samuel', 6, ARRAY['6:20']::text[], 'pending_review', 'Ce au spus locuitorii din Bet-Șemeș despre Domnul și despre plecarea chivotului?')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_abc_multi (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Ce instrucțiuni au primit filistenii despre întoarcerea chivotului?', '[{"text":"Să nu-l trimită cu mâna goală.","correct":true},{"text":"Să aducă lui Dumnezeu o jertfă pentru vină.","correct":true},{"text":"Să-l trimită înapoi fără niciun dar.","correct":false}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:2', '6:3']::text[], 'pending_review', 'Codex'),
  ('Ce precizări au fost făcute despre darul de aur pentru vină?', '[{"text":"Să fie cinci umflături de aur.","correct":true},{"text":"Să fie cinci șoareci de aur.","correct":true},{"text":"Să fie făcut după numărul preoților lui Dagon.","correct":false}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:4']::text[], 'pending_review', 'Codex'),
  ('După ce imagini de aur au fost sfătuiți filistenii să facă și ce urmau să facă?', '[{"text":"După umflăturile lor.","correct":true},{"text":"După șoarecii care pustiau țara.","correct":true},{"text":"După chivotul Domnului și să-l ascundă.","correct":false}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:5']::text[], 'pending_review', 'Codex'),
  ('Ce rezultate sperau preoții și ghicitorii să urmeze după darul pentru vină?', '[{"text":"Filistenii aveau să se vindece.","correct":true},{"text":"Avea să li se arate de ce mâna Domnului nu se îndepărtase de peste ei.","correct":true},{"text":"Chivotul urma să rămână pentru totdeauna la Asdod.","correct":false}]'::jsonb, 6, 3, '1 Samuel', ARRAY['6:3']::text[], 'pending_review', 'Codex'),
  ('Ce s-a spus despre împietrirea inimii egiptenilor și despre plecarea copiilor lui Israel?', '[{"text":"Egiptenii și Faraon își împietriseră inima.","correct":true},{"text":"Dumnezeu i-a pedepsit, iar apoi au lăsat poporul Israel să plece.","correct":true},{"text":"Egiptenii au primit chivotul și l-au dus la Bet-Șemeș.","correct":false}]'::jsonb, 6, 3, '1 Samuel', ARRAY['6:6']::text[], 'pending_review', 'Codex'),
  ('Cum trebuia pregătit carul și ce fel de vaci urmau să fie puse la el?', '[{"text":"Carul trebuia să fie nou de tot.","correct":true},{"text":"Trebuiau luate două vaci tinere care alăptau și nu trăseseră la jug.","correct":true},{"text":"Trebuia folosit un car vechi tras de boi.","correct":false}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:7']::text[], 'pending_review', 'Codex'),
  ('Ce trebuiau să facă filistenii cu vițeii și cu vacile înainte să trimită carul?', '[{"text":"Să mâne vițeii înapoi acasă.","correct":true},{"text":"Să înjuge vacile la car.","correct":true},{"text":"Să lase vițeii să meargă în car alături de mamele lor.","correct":false}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:7', '6:10']::text[], 'pending_review', 'Codex'),
  ('Cum trebuiau așezate chivotul și darurile de aur pentru drum?', '[{"text":"Chivotul trebuia pus în car.","correct":true},{"text":"Lucrurile de aur trebuiau puse într-o ladă alături de chivot.","correct":true},{"text":"Lucrurile de aur trebuiau puse înăuntrul chivotului.","correct":false}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:8']::text[], 'pending_review', 'Codex'),
  ('Ce condiții au stabilit filistenii ca să judece dacă Domnul îi lovise?', '[{"text":"Dacă vacile urcau spre Bet-Șemeș, aveau să știe că Domnul le făcuse răul.","correct":true},{"text":"Dacă nu mergeau pe acel drum, aveau să știe că lucrul se întâmplase din întâmplare.","correct":true},{"text":"Dacă vacile mergeau spre Ecron, aveau să știe că Domnul le făcuse răul.","correct":false}]'::jsonb, 6, 3, '1 Samuel', ARRAY['6:9']::text[], 'pending_review', 'Codex'),
  ('Ce au făcut oamenii când au pus în practică instrucțiunile despre vaci?', '[{"text":"Au luat două vaci care alăptau și le-au înjugat la car.","correct":true},{"text":"Au închis vițeii acasă.","correct":true},{"text":"Au lăsat vițeii să meargă în fața vacilor.","correct":false}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:10']::text[], 'pending_review', 'Codex'),
  ('Ce au pus oamenii în car înainte ca vacile să pornească?', '[{"text":"Chivotul Domnului.","correct":true},{"text":"Lada cu șoarecii de aur și chipurile umflăturilor lor.","correct":true},{"text":"Vițeii vacilor care alăptau.","correct":false}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:11']::text[], 'pending_review', 'Codex'),
  ('Cum au mers vacile după ce au fost înjugate și au pornit spre Bet-Șemeș?', '[{"text":"Au ținut mereu același drum.","correct":true},{"text":"Mugeau și nu s-au abătut nici la dreapta, nici la stânga.","correct":true},{"text":"S-au întors după vițeii lor și au mers la Asdod.","correct":false}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:12']::text[], 'pending_review', 'Codex'),
  ('Ce au făcut cei cinci domnitori filisteni în timpul și după mersul vacilor?', '[{"text":"Au mers după vaci până la hotarul Bet-Șemeșului.","correct":true},{"text":"S-au întors la Ecron în aceeași zi.","correct":true},{"text":"Au rămas în Bet-Șemeș și au luat chivotul.","correct":false}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:12', '6:16']::text[], 'pending_review', 'Codex'),
  ('Ce se spune despre locuitorii din Bet-Șemeș când chivotul s-a apropiat?', '[{"text":"Secerau grânele în vale.","correct":true},{"text":"Au zărit chivotul și s-au bucurat când l-au văzut.","correct":true},{"text":"Au fugit din vale fără să-l privească.","correct":false}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:13']::text[], 'pending_review', 'Codex'),
  ('Ce detalii sunt date despre locul unde s-a oprit carul?', '[{"text":"A ajuns în câmpul lui Iosua din Bet-Șemeș.","correct":true},{"text":"S-a oprit acolo lângă o piatră mare.","correct":true},{"text":"S-a oprit în câmpul din Chiriat-Iearim.","correct":false}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:14']::text[], 'pending_review', 'Codex'),
  ('Ce au făcut locuitorii din Bet-Șemeș cu carul și cu vacile?', '[{"text":"Au despicat lemnele carului.","correct":true},{"text":"Au adus vacile ca ardere-de-tot Domnului.","correct":true},{"text":"Au dus lemnele carului la Ecron și vacile la Gat.","correct":false}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:14']::text[], 'pending_review', 'Codex'),
  ('Ce au făcut leviții și locuitorii din Bet-Șemeș după ce carul s-a oprit?', '[{"text":"Leviții au coborât chivotul și lada cu lucrurile de aur.","correct":true},{"text":"Locuitorii au adus arderi-de-tot și jertfe Domnului în ziua aceea.","correct":true},{"text":"Domnitorii filistenilor au pus lada pe piatra cea mare.","correct":false}]'::jsonb, 6, 3, '1 Samuel', ARRAY['6:15']::text[], 'pending_review', 'Codex'),
  ('Ce precizează relatarea despre darurile filistenilor și cetățile lor?', '[{"text":"Au dat câte o umflătură de aur pentru Asdod, Gaza, Ascalon, Gat și Ecron.","correct":true},{"text":"Șoarecii de aur erau după numărul cetăților tuturor celor cinci căpetenii.","correct":true},{"text":"Au dat o umflătură de aur doar pentru Bet-Șemeș.","correct":false}]'::jsonb, 6, 3, '1 Samuel', ARRAY['6:17', '6:18']::text[], 'pending_review', 'Codex'),
  ('Ce spune textul despre lovirea și reacția locuitorilor din Bet-Șemeș?', '[{"text":"Domnul i-a lovit pe cei care s-au uitat în chivot.","correct":true},{"text":"Poporul a plâns din pricina marii urgii.","correct":true},{"text":"Locuitorii au râs și au hotărât să păstreze chivotul.","correct":false}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:19']::text[], 'pending_review', 'Codex'),
  ('Ce au spus locuitorii din Bet-Șemeș despre Domnul și despre plecarea chivotului?', '[{"text":"Au întrebat cine poate sta înaintea Domnului, acest Dumnezeu sfânt.","correct":true},{"text":"Au întrebat la cine trebuie să se suie chivotul dacă se depărtează de la ei.","correct":true},{"text":"Au spus că nimeni nu trebuie să trimită soli la Chiriat-Iearim.","correct":false}]'::jsonb, 6, 3, '1 Samuel', ARRAY['6:20']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 6, ARRAY['6:1', '6:2', '6:3']::text[], 'pending_review', '[{"left":"Cât timp a fost chivotul în țara filistenilor","right":"Șapte luni"},{"left":"Pe cine au chemat filistenii pentru sfat","right":"Preoții și ghicitorii"},{"left":"Ce au cerut să afle despre chivot","right":"Cum să-l trimită înapoi la locul lui"},{"left":"Cum să fie trimis chivotul","right":"Nu cu mâna goală"},{"left":"Ce trebuia adus lui Dumnezeu","right":"O jertfă pentru vină"}]'::jsonb),
  ('1 Samuel', 6, ARRAY['6:4', '6:5']::text[], 'pending_review', '[{"left":"Cele două feluri de obiecte de aur","right":"Umflături și șoareci"},{"left":"Numărul fiecărui fel de obiect","right":"Cinci din fiecare"},{"left":"Numărul după care s-a făcut darul","right":"Domnitorii filistenilor"},{"left":"Chipul făcut după umflăturile filistenilor","right":"Umflături după ale lor"},{"left":"Chipul făcut după șoareci","right":"Șoarecii care pustiau țara"}]'::jsonb),
  ('1 Samuel', 6, ARRAY['6:5', '6:6']::text[], 'pending_review', '[{"left":"Cei a căror inimă se împietrise","right":"Egiptenii și Faraon"},{"left":"Ce a făcut Dumnezeu cu ei","right":"I-a pedepsit"},{"left":"Ce a făcut poporul după pedepsire","right":"A lăsat copiii lui Israel să plece"},{"left":"Cu cine erau comparați filistenii dacă își împietreau inima","right":"Cu Egiptul și Faraon"},{"left":"Întrebarea pusă filistenilor despre inimă","right":"Pentru ce să v-o împietriți?"}]'::jsonb),
  ('1 Samuel', 6, ARRAY['6:7', '6:10']::text[], 'pending_review', '[{"left":"Carul pe care îl fac filistenii","right":"Nou de tot"},{"left":"Numărul vacilor luate","right":"Două"},{"left":"Starea vacilor","right":"Tinere și alăptau"},{"left":"Experiența vacilor cu jugul","right":"Nu trăseseră la jug"},{"left":"Ce fac cu vițeii lor","right":"Îi mână înapoi acasă"}]'::jsonb),
  ('1 Samuel', 6, ARRAY['6:8', '6:9']::text[], 'pending_review', '[{"left":"Unde este pus chivotul","right":"În car"},{"left":"Unde sunt puse lucrurile de aur","right":"Într-o ladă alături de chivot"},{"left":"Ce drum urmăresc filistenii","right":"Drumul hotarului spre Bet-Șemeș"},{"left":"Dacă vacile merg spre Bet-Șemeș, ce înseamnă","right":"Domnul le-a făcut marele rău"},{"left":"Dacă vacile nu merg pe acel drum, ce înseamnă","right":"S-a întâmplat din întâmplare"}]'::jsonb),
  ('1 Samuel', 6, ARRAY['6:10', '6:12']::text[], 'pending_review', '[{"left":"În ce direcție au mers vacile","right":"Drept spre Bet-Șemeș"},{"left":"Ce sunet scoteau în drum","right":"Mugeau"},{"left":"Cum se țineau de drum","right":"Nu se abăteau la dreapta sau la stânga"},{"left":"Cine le urma","right":"Domnitorii filistenilor"},{"left":"Până unde le-au urmat","right":"Până la hotarul Bet-Șemeșului"}]'::jsonb),
  ('1 Samuel', 6, ARRAY['6:13', '6:14']::text[], 'pending_review', '[{"left":"Ce făceau locuitorii când au văzut chivotul","right":"Secerau grâne în vale"},{"left":"Cum au reacționat la vederea chivotului","right":"S-au bucurat"},{"left":"Câmpul unde a ajuns carul","right":"Câmpul lui Iosua"},{"left":"Ce se întâmplă cu carul în acel loc","right":"Se oprește"},{"left":"Piatra aflată în câmp","right":"O piatră mare"}]'::jsonb),
  ('1 Samuel', 6, ARRAY['6:14', '6:15']::text[], 'pending_review', '[{"left":"Ce fac oamenii cu lemnul carului","right":"Îl despică"},{"left":"Ce aduc ca ardere-de-tot Domnului","right":"Vacile"},{"left":"Cine coboară chivotul și lada","right":"Leviții"},{"left":"Unde pun leviții chivotul și lucrurile de aur","right":"Pe piatra cea mare"},{"left":"Ce aduc locuitorii în ziua aceea","right":"Arderi-de-tot și jertfe"}]'::jsonb),
  ('1 Samuel', 6, ARRAY['6:17', '6:18']::text[], 'pending_review', '[{"left":"Numărul cetăților pentru care s-au dat umflături de aur","right":"Cinci"},{"left":"Cetatea din listă: Asdod, Gaza, Ascalon, Gat și ...","right":"Ecron"},{"left":"Numărul șoarecilor de aur","right":"După numărul tuturor cetăților celor cinci căpetenii"},{"left":"Felurile cetăților numărate","right":"Întărite și fără ziduri"},{"left":"Piatra mare era în câmpul cui","right":"Iosua din Bet-Șemeș"}]'::jsonb),
  ('1 Samuel', 6, ARRAY['6:19', '6:20', '6:21']::text[], 'pending_review', '[{"left":"Când sunt loviți oamenii din Bet-Șemeș","right":"Când se uită în chivotul Domnului"},{"left":"Cum răspunde poporul la urgie","right":"Plânge"},{"left":"Întrebarea despre stat înaintea Domnului","right":"Cine poate sta înaintea acestui Dumnezeu sfânt?"},{"left":"Întrebarea despre următorul loc al chivotului","right":"La cine trebuie să se suie dacă se depărtează"},{"left":"Cui trimit soli","right":"Locuitorilor din Chiriat-Iearim"}]'::jsonb)
) as incoming (book, chapter, source_references, status, pairs)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.pairs = incoming.pairs;

insert into public.questions_match (pairs, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.pairs, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('[{"left":"Cât timp a fost chivotul în țara filistenilor","right":"Șapte luni"},{"left":"Pe cine au chemat filistenii pentru sfat","right":"Preoții și ghicitorii"},{"left":"Ce au cerut să afle despre chivot","right":"Cum să-l trimită înapoi la locul lui"},{"left":"Cum să fie trimis chivotul","right":"Nu cu mâna goală"},{"left":"Ce trebuia adus lui Dumnezeu","right":"O jertfă pentru vină"}]'::jsonb, 6, 2, '1 Samuel', ARRAY['6:1', '6:2', '6:3']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Cele două feluri de obiecte de aur","right":"Umflături și șoareci"},{"left":"Numărul fiecărui fel de obiect","right":"Cinci din fiecare"},{"left":"Numărul după care s-a făcut darul","right":"Domnitorii filistenilor"},{"left":"Chipul făcut după umflăturile filistenilor","right":"Umflături după ale lor"},{"left":"Chipul făcut după șoareci","right":"Șoarecii care pustiau țara"}]'::jsonb, 6, 3, '1 Samuel', ARRAY['6:4', '6:5']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Cei a căror inimă se împietrise","right":"Egiptenii și Faraon"},{"left":"Ce a făcut Dumnezeu cu ei","right":"I-a pedepsit"},{"left":"Ce a făcut poporul după pedepsire","right":"A lăsat copiii lui Israel să plece"},{"left":"Cu cine erau comparați filistenii dacă își împietreau inima","right":"Cu Egiptul și Faraon"},{"left":"Întrebarea pusă filistenilor despre inimă","right":"Pentru ce să v-o împietriți?"}]'::jsonb, 6, 4, '1 Samuel', ARRAY['6:5', '6:6']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Carul pe care îl fac filistenii","right":"Nou de tot"},{"left":"Numărul vacilor luate","right":"Două"},{"left":"Starea vacilor","right":"Tinere și alăptau"},{"left":"Experiența vacilor cu jugul","right":"Nu trăseseră la jug"},{"left":"Ce fac cu vițeii lor","right":"Îi mână înapoi acasă"}]'::jsonb, 6, 3, '1 Samuel', ARRAY['6:7', '6:10']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Unde este pus chivotul","right":"În car"},{"left":"Unde sunt puse lucrurile de aur","right":"Într-o ladă alături de chivot"},{"left":"Ce drum urmăresc filistenii","right":"Drumul hotarului spre Bet-Șemeș"},{"left":"Dacă vacile merg spre Bet-Șemeș, ce înseamnă","right":"Domnul le-a făcut marele rău"},{"left":"Dacă vacile nu merg pe acel drum, ce înseamnă","right":"S-a întâmplat din întâmplare"}]'::jsonb, 6, 4, '1 Samuel', ARRAY['6:8', '6:9']::text[], 'pending_review', 'Codex'),
  ('[{"left":"În ce direcție au mers vacile","right":"Drept spre Bet-Șemeș"},{"left":"Ce sunet scoteau în drum","right":"Mugeau"},{"left":"Cum se țineau de drum","right":"Nu se abăteau la dreapta sau la stânga"},{"left":"Cine le urma","right":"Domnitorii filistenilor"},{"left":"Până unde le-au urmat","right":"Până la hotarul Bet-Șemeșului"}]'::jsonb, 6, 3, '1 Samuel', ARRAY['6:10', '6:12']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Ce făceau locuitorii când au văzut chivotul","right":"Secerau grâne în vale"},{"left":"Cum au reacționat la vederea chivotului","right":"S-au bucurat"},{"left":"Câmpul unde a ajuns carul","right":"Câmpul lui Iosua"},{"left":"Ce se întâmplă cu carul în acel loc","right":"Se oprește"},{"left":"Piatra aflată în câmp","right":"O piatră mare"}]'::jsonb, 6, 3, '1 Samuel', ARRAY['6:13', '6:14']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Ce fac oamenii cu lemnul carului","right":"Îl despică"},{"left":"Ce aduc ca ardere-de-tot Domnului","right":"Vacile"},{"left":"Cine coboară chivotul și lada","right":"Leviții"},{"left":"Unde pun leviții chivotul și lucrurile de aur","right":"Pe piatra cea mare"},{"left":"Ce aduc locuitorii în ziua aceea","right":"Arderi-de-tot și jertfe"}]'::jsonb, 6, 3, '1 Samuel', ARRAY['6:14', '6:15']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Numărul cetăților pentru care s-au dat umflături de aur","right":"Cinci"},{"left":"Cetatea din listă: Asdod, Gaza, Ascalon, Gat și ...","right":"Ecron"},{"left":"Numărul șoarecilor de aur","right":"După numărul tuturor cetăților celor cinci căpetenii"},{"left":"Felurile cetăților numărate","right":"Întărite și fără ziduri"},{"left":"Piatra mare era în câmpul cui","right":"Iosua din Bet-Șemeș"}]'::jsonb, 6, 4, '1 Samuel', ARRAY['6:17', '6:18']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Când sunt loviți oamenii din Bet-Șemeș","right":"Când se uită în chivotul Domnului"},{"left":"Cum răspunde poporul la urgie","right":"Plânge"},{"left":"Întrebarea despre stat înaintea Domnului","right":"Cine poate sta înaintea acestui Dumnezeu sfânt?"},{"left":"Întrebarea despre următorul loc al chivotului","right":"La cine trebuie să se suie dacă se depărtează"},{"left":"Cui trimit soli","right":"Locuitorilor din Chiriat-Iearim"}]'::jsonb, 6, 4, '1 Samuel', ARRAY['6:19', '6:20', '6:21']::text[], 'pending_review', 'Codex')
) as incoming (pairs, chapter, difficulty, book, source_references, status, added_by)
where not exists (
  select 1 from public.questions_match existing
  where existing.book = incoming.book
    and existing.chapter = incoming.chapter
    and existing.source_references = incoming.source_references
    and existing.pairs = incoming.pairs
);

commit;
