begin;

alter table public.questions_tf add column if not exists source_references text[] not null default '{}';

alter table public.questions_abc_one add column if not exists source_references text[] not null default '{}';

alter table public.questions_abc_multi add column if not exists source_references text[] not null default '{}';

alter table public.questions_match add column if not exists source_references text[] not null default '{}';

update public.questions_tf as existing
set status = incoming.status
from (values
  ('1 Samuel', 9, ARRAY['9:1']::text[], 'pending_review', 'Chis era un beniamit, fiul lui Abiel, dintr-o familie descrisă ca tare și voinică.'),
  ('1 Samuel', 9, ARRAY['9:2']::text[], 'pending_review', 'Saul, fiul lui Chis, era tânăr și frumos și îi întrecea pe ceilalți israeliți în înălțime de la umăr în sus.'),
  ('1 Samuel', 9, ARRAY['9:3']::text[], 'pending_review', 'Măgărițele lui Chis, tatăl lui Saul, s-au rătăcit.'),
  ('1 Samuel', 9, ARRAY['9:3']::text[], 'pending_review', 'Chis i-a spus lui Saul să plece singur să caute măgărițele.'),
  ('1 Samuel', 9, ARRAY['9:4']::text[], 'pending_review', 'Saul și sluga lui au trecut prin muntele lui Efraim și prin țările Șalișa, Șaalim și Beniamin fără să găsească măgărițele.'),
  ('1 Samuel', 9, ARRAY['9:5']::text[], 'pending_review', 'Când au ajuns în țara Țuf, Saul s-a temut că tatăl lui va fi îngrijorat de ei.'),
  ('1 Samuel', 9, ARRAY['9:6']::text[], 'pending_review', 'Sluga i-a spus lui Saul că în cetate era un om al lui Dumnezeu cu vază, ale cărui cuvinte se împlineau.'),
  ('1 Samuel', 9, ARRAY['9:6']::text[], 'pending_review', 'Sluga i-a spus că omul lui Dumnezeu îi putea ajuta să afle drumul pe care trebuiau să apuce.'),
  ('1 Samuel', 9, ARRAY['9:7']::text[], 'pending_review', 'Saul a spus că aveau destule merinde în saci și un dar pregătit pentru omul lui Dumnezeu.'),
  ('1 Samuel', 9, ARRAY['9:8']::text[], 'pending_review', 'Sluga avea la ea un sfert de siclu de argint, pe care s-a oferit să-l dea omului lui Dumnezeu.'),
  ('1 Samuel', 9, ARRAY['9:6']::text[], 'pending_review', 'Sluga i-a spus lui Saul că tot ce spunea omul lui Dumnezeu se împlinea.'),
  ('1 Samuel', 9, ARRAY['9:10']::text[], 'pending_review', 'Saul a fost de acord cu sluga și au mers în cetatea unde se afla omul lui Dumnezeu.'),
  ('1 Samuel', 9, ARRAY['9:11']::text[], 'pending_review', 'Saul și sluga au întâlnit fete care ieșiseră să scoată apă în timp ce urcau spre cetate.'),
  ('1 Samuel', 9, ARRAY['9:12']::text[], 'pending_review', 'Fetele le-au spus că Samuel plecase din cetate și nu se va întoarce în ziua aceea.'),
  ('1 Samuel', 9, ARRAY['9:13']::text[], 'pending_review', 'Poporul nu mânca până nu venea Samuel, pentru că el trebuia să binecuvânteze jertfa.'),
  ('1 Samuel', 9, ARRAY['9:14']::text[], 'pending_review', 'Când Saul și sluga au intrat pe poarta cetății, Samuel ieșea să se suie pe înălțime.'),
  ('1 Samuel', 9, ARRAY['9:15']::text[], 'pending_review', 'Domnul îl înștiințase pe Samuel cu o zi înainte de venirea lui Saul.'),
  ('1 Samuel', 9, ARRAY['9:16']::text[], 'pending_review', 'Domnul îi spusese lui Samuel că va trimite un om din țara lui Beniamin și că Samuel trebuia să-l ungă drept căpetenie.'),
  ('1 Samuel', 9, ARRAY['9:16']::text[], 'pending_review', 'Domnul a spus că omul trimis din Beniamin urma să-și scape poporul din mâna filistenilor.'),
  ('1 Samuel', 9, ARRAY['9:17']::text[], 'pending_review', 'Când Samuel l-a văzut pe Saul, Domnul i-a spus că acesta era omul despre care îi vorbise.'),
  ('1 Samuel', 9, ARRAY['9:18']::text[], 'pending_review', 'Saul l-a întrebat pe Samuel unde era casa văzătorului.'),
  ('1 Samuel', 9, ARRAY['9:19']::text[], 'pending_review', 'Samuel i-a spus lui Saul să urce înaintea lui la înălțime și să mănânce cu el în ziua aceea.'),
  ('1 Samuel', 9, ARRAY['9:20']::text[], 'pending_review', 'Samuel i-a spus lui Saul să nu se neliniștească pentru măgărițele pierdute, fiindcă fuseseră găsite.'),
  ('1 Samuel', 9, ARRAY['9:21']::text[], 'pending_review', 'Saul a spus că era din seminția cea mai mare a lui Israel și din cea mai mare familie a lui Beniamin.'),
  ('1 Samuel', 9, ARRAY['9:22']::text[], 'pending_review', 'Samuel le-a dat lui Saul și slugii lui locul cel dintâi între cei poftiți, aproape treizeci de oameni.'),
  ('1 Samuel', 9, ARRAY['9:23', '9:24']::text[], 'pending_review', 'Bucătarul a pus înaintea lui Saul porția pe care Samuel îi ceruse să o păstreze.'),
  ('1 Samuel', 9, ARRAY['9:25']::text[], 'pending_review', 'Samuel a stat de vorbă cu Saul pe acoperișul casei după ce au coborât în cetate.'),
  ('1 Samuel', 9, ARRAY['9:26']::text[], 'pending_review', 'În revărsatul zorilor, Samuel l-a chemat pe Saul de pe acoperiș și i-a spus că îl va însoți.'),
  ('1 Samuel', 9, ARRAY['9:27']::text[], 'pending_review', 'La marginea cetății, Samuel i-a cerut slugii lui Saul să treacă înainte, apoi i-a spus lui Saul să se oprească pentru a-i face cunoscut cuvântul lui Dumnezeu.')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_tf (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Chis era un beniamit, fiul lui Abiel, dintr-o familie descrisă ca tare și voinică.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:1']::text[], 'pending_review', 'Codex'),
  ('Saul, fiul lui Chis, era tânăr și frumos și îi întrecea pe ceilalți israeliți în înălțime de la umăr în sus.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:2']::text[], 'pending_review', 'Codex'),
  ('Măgărițele lui Chis, tatăl lui Saul, s-au rătăcit.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 9, 1, '1 Samuel', ARRAY['9:3']::text[], 'pending_review', 'Codex'),
  ('Chis i-a spus lui Saul să plece singur să caute măgărițele.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 9, 1, '1 Samuel', ARRAY['9:3']::text[], 'pending_review', 'Codex'),
  ('Saul și sluga lui au trecut prin muntele lui Efraim și prin țările Șalișa, Șaalim și Beniamin fără să găsească măgărițele.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:4']::text[], 'pending_review', 'Codex'),
  ('Când au ajuns în țara Țuf, Saul s-a temut că tatăl lui va fi îngrijorat de ei.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:5']::text[], 'pending_review', 'Codex'),
  ('Sluga i-a spus lui Saul că în cetate era un om al lui Dumnezeu cu vază, ale cărui cuvinte se împlineau.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:6']::text[], 'pending_review', 'Codex'),
  ('Sluga i-a spus că omul lui Dumnezeu îi putea ajuta să afle drumul pe care trebuiau să apuce.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:6']::text[], 'pending_review', 'Codex'),
  ('Saul a spus că aveau destule merinde în saci și un dar pregătit pentru omul lui Dumnezeu.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:7']::text[], 'pending_review', 'Codex'),
  ('Sluga avea la ea un sfert de siclu de argint, pe care s-a oferit să-l dea omului lui Dumnezeu.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:8']::text[], 'pending_review', 'Codex'),
  ('Sluga i-a spus lui Saul că tot ce spunea omul lui Dumnezeu se împlinea.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 9, 3, '1 Samuel', ARRAY['9:6']::text[], 'pending_review', 'Codex'),
  ('Saul a fost de acord cu sluga și au mers în cetatea unde se afla omul lui Dumnezeu.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 9, 1, '1 Samuel', ARRAY['9:10']::text[], 'pending_review', 'Codex'),
  ('Saul și sluga au întâlnit fete care ieșiseră să scoată apă în timp ce urcau spre cetate.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 9, 1, '1 Samuel', ARRAY['9:11']::text[], 'pending_review', 'Codex'),
  ('Fetele le-au spus că Samuel plecase din cetate și nu se va întoarce în ziua aceea.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:12']::text[], 'pending_review', 'Codex'),
  ('Poporul nu mânca până nu venea Samuel, pentru că el trebuia să binecuvânteze jertfa.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:13']::text[], 'pending_review', 'Codex'),
  ('Când Saul și sluga au intrat pe poarta cetății, Samuel ieșea să se suie pe înălțime.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:14']::text[], 'pending_review', 'Codex'),
  ('Domnul îl înștiințase pe Samuel cu o zi înainte de venirea lui Saul.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:15']::text[], 'pending_review', 'Codex'),
  ('Domnul îi spusese lui Samuel că va trimite un om din țara lui Beniamin și că Samuel trebuia să-l ungă drept căpetenie.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:16']::text[], 'pending_review', 'Codex'),
  ('Domnul a spus că omul trimis din Beniamin urma să-și scape poporul din mâna filistenilor.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:16']::text[], 'pending_review', 'Codex'),
  ('Când Samuel l-a văzut pe Saul, Domnul i-a spus că acesta era omul despre care îi vorbise.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:17']::text[], 'pending_review', 'Codex'),
  ('Saul l-a întrebat pe Samuel unde era casa văzătorului.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 9, 1, '1 Samuel', ARRAY['9:18']::text[], 'pending_review', 'Codex'),
  ('Samuel i-a spus lui Saul să urce înaintea lui la înălțime și să mănânce cu el în ziua aceea.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:19']::text[], 'pending_review', 'Codex'),
  ('Samuel i-a spus lui Saul să nu se neliniștească pentru măgărițele pierdute, fiindcă fuseseră găsite.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:20']::text[], 'pending_review', 'Codex'),
  ('Saul a spus că era din seminția cea mai mare a lui Israel și din cea mai mare familie a lui Beniamin.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:21']::text[], 'pending_review', 'Codex'),
  ('Samuel le-a dat lui Saul și slugii lui locul cel dintâi între cei poftiți, aproape treizeci de oameni.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:22']::text[], 'pending_review', 'Codex'),
  ('Bucătarul a pus înaintea lui Saul porția pe care Samuel îi ceruse să o păstreze.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:23', '9:24']::text[], 'pending_review', 'Codex'),
  ('Samuel a stat de vorbă cu Saul pe acoperișul casei după ce au coborât în cetate.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:25']::text[], 'pending_review', 'Codex'),
  ('În revărsatul zorilor, Samuel l-a chemat pe Saul de pe acoperiș și i-a spus că îl va însoți.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:26']::text[], 'pending_review', 'Codex'),
  ('La marginea cetății, Samuel i-a cerut slugii lui Saul să treacă înainte, apoi i-a spus lui Saul să se oprească pentru a-i face cunoscut cuvântul lui Dumnezeu.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 9, 3, '1 Samuel', ARRAY['9:27']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 9, ARRAY['9:1']::text[], 'pending_review', 'Din ce seminție era Chis, tatăl lui Saul?'),
  ('1 Samuel', 9, ARRAY['9:1']::text[], 'pending_review', 'Cum este descris Chis în relatarea despre familia sa?'),
  ('1 Samuel', 9, ARRAY['9:2']::text[], 'pending_review', 'Cum îl descrie capitolul pe Saul în comparație cu ceilalți copii ai lui Israel?'),
  ('1 Samuel', 9, ARRAY['9:3']::text[], 'pending_review', 'Ce i s-a întâmplat turmei de măgărițe a lui Chis?'),
  ('1 Samuel', 9, ARRAY['9:3']::text[], 'pending_review', 'Pe cine i-a cerut Chis lui Saul să ia cu el când a plecat în căutarea măgărițelor?'),
  ('1 Samuel', 9, ARRAY['9:4']::text[], 'pending_review', 'Prin ce țară au ajuns Saul și sluga lui după ce au trecut prin țara Șalișa?'),
  ('1 Samuel', 9, ARRAY['9:5']::text[], 'pending_review', 'În ce țară au ajuns Saul și sluga înainte ca Saul să propună întoarcerea?'),
  ('1 Samuel', 9, ARRAY['9:5']::text[], 'pending_review', 'De ce a propus Saul să se întoarcă atunci când au ajuns în țara Țuf?'),
  ('1 Samuel', 9, ARRAY['9:6']::text[], 'pending_review', 'Ce i-a spus sluga lui Saul despre omul lui Dumnezeu din cetate?'),
  ('1 Samuel', 9, ARRAY['9:8']::text[], 'pending_review', 'Ce sumă de argint avea sluga și s-a oferit să o dea omului lui Dumnezeu?'),
  ('1 Samuel', 9, ARRAY['9:6']::text[], 'pending_review', 'Ce i-a spus sluga lui Saul că ar putea face omul lui Dumnezeu pentru ei?'),
  ('1 Samuel', 9, ARRAY['9:11']::text[], 'pending_review', 'Pe cine au întâlnit Saul și sluga când urcau spre cetate?'),
  ('1 Samuel', 9, ARRAY['9:12']::text[], 'pending_review', 'De ce era Samuel în cetate în ziua aceea, potrivit fetelor întâlnite de Saul și de slugă?'),
  ('1 Samuel', 9, ARRAY['9:13']::text[], 'pending_review', 'Ce trebuia să facă Samuel înainte ca poporul și cei poftiți să mănânce?'),
  ('1 Samuel', 9, ARRAY['9:14']::text[], 'pending_review', 'Unde a fost întâlnit Samuel de Saul și de slugă?'),
  ('1 Samuel', 9, ARRAY['9:15']::text[], 'pending_review', 'Când îl înștiințase Domnul pe Samuel despre venirea lui Saul?'),
  ('1 Samuel', 9, ARRAY['9:16']::text[], 'pending_review', 'Din ce țară urma să trimită Domnul omul pe care Samuel trebuia să-l ungă drept căpetenie?'),
  ('1 Samuel', 9, ARRAY['9:16']::text[], 'pending_review', 'Din mâna cui urma să scape omul uns drept căpetenie poporul lui Israel?'),
  ('1 Samuel', 9, ARRAY['9:19']::text[], 'pending_review', 'Ce i-a spus Samuel lui Saul că va face cu el în ziua aceea?'),
  ('1 Samuel', 9, ARRAY['9:20']::text[], 'pending_review', 'De câte zile erau pierdute măgărițele despre care Samuel i-a spus lui Saul să nu se neliniștească?'),
  ('1 Samuel', 9, ARRAY['9:21']::text[], 'pending_review', 'Ce a spus Saul despre seminția și familia lui?'),
  ('1 Samuel', 9, ARRAY['9:22']::text[], 'pending_review', 'Câți oameni erau aproximativ printre cei poftiți, între care Samuel i-a dat lui Saul locul cel dintâi?'),
  ('1 Samuel', 9, ARRAY['9:24']::text[], 'pending_review', 'Ce parte din mâncare a pus bucătarul înaintea lui Saul?'),
  ('1 Samuel', 9, ARRAY['9:25']::text[], 'pending_review', 'Unde a stat Samuel de vorbă cu Saul după ce au coborât în cetate?'),
  ('1 Samuel', 9, ARRAY['9:27']::text[], 'pending_review', 'Ce i-a spus Samuel slugii lui Saul să facă la marginea cetății?')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_abc_one (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Din ce seminție era Chis, tatăl lui Saul?', '[{"text":"Din Beniamin","correct":true},{"text":"Din Efraim","correct":false},{"text":"Din Iuda","correct":false}]'::jsonb, 9, 1, '1 Samuel', ARRAY['9:1']::text[], 'pending_review', 'Codex'),
  ('Cum este descris Chis în relatarea despre familia sa?', '[{"text":"Un om tare și voinic","correct":true},{"text":"Un om bătrân și bolnav","correct":false},{"text":"Un om care locuia la Beer-Șeba","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:1']::text[], 'pending_review', 'Codex'),
  ('Cum îl descrie capitolul pe Saul în comparație cu ceilalți copii ai lui Israel?', '[{"text":"Era tânăr și frumos și îi întrecea în înălțime","correct":true},{"text":"Era cel mai în vârstă și cel mai scund","correct":false},{"text":"Era un judecător la Beer-Șeba","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:2']::text[], 'pending_review', 'Codex'),
  ('Ce i s-a întâmplat turmei de măgărițe a lui Chis?', '[{"text":"S-a rătăcit","correct":true},{"text":"A fost luată de filisteni","correct":false},{"text":"A fost dusă la Samuel","correct":false}]'::jsonb, 9, 1, '1 Samuel', ARRAY['9:3']::text[], 'pending_review', 'Codex'),
  ('Pe cine i-a cerut Chis lui Saul să ia cu el când a plecat în căutarea măgărițelor?', '[{"text":"O slugă","correct":true},{"text":"Pe Samuel","correct":false},{"text":"Pe unul dintre bătrânii lui Israel","correct":false}]'::jsonb, 9, 1, '1 Samuel', ARRAY['9:3']::text[], 'pending_review', 'Codex'),
  ('Prin ce țară au ajuns Saul și sluga lui după ce au trecut prin țara Șalișa?', '[{"text":"Prin țara Șaalim","correct":true},{"text":"Prin țara Țuf","correct":false},{"text":"Prin țara filistenilor","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:4']::text[], 'pending_review', 'Codex'),
  ('În ce țară au ajuns Saul și sluga înainte ca Saul să propună întoarcerea?', '[{"text":"În țara Țuf","correct":true},{"text":"În țara lui Iuda","correct":false},{"text":"În țara Efraimului","correct":false}]'::jsonb, 9, 1, '1 Samuel', ARRAY['9:5']::text[], 'pending_review', 'Codex'),
  ('De ce a propus Saul să se întoarcă atunci când au ajuns în țara Țuf?', '[{"text":"Ca tatăl lui să nu fie îngrijorat pentru ei","correct":true},{"text":"Ca să ducă darul la Samuel","correct":false},{"text":"Pentru că găsiseră măgărițele","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:5']::text[], 'pending_review', 'Codex'),
  ('Ce i-a spus sluga lui Saul despre omul lui Dumnezeu din cetate?', '[{"text":"Era un om cu vază și cuvintele lui se împlineau","correct":true},{"text":"Era un om care nu cunoștea drumul","correct":false},{"text":"Era unul dintre bătrânii veniți la Rama","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:6']::text[], 'pending_review', 'Codex'),
  ('Ce sumă de argint avea sluga și s-a oferit să o dea omului lui Dumnezeu?', '[{"text":"Un sfert de siclu","correct":true},{"text":"O jumătate de siclu","correct":false},{"text":"Un siclu întreg","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:8']::text[], 'pending_review', 'Codex'),
  ('Ce i-a spus sluga lui Saul că ar putea face omul lui Dumnezeu pentru ei?', '[{"text":"Să le arate drumul pe care trebuiau să apuce","correct":true},{"text":"Să-i conducă la poarta cetății și să-i așeze între cei poftiți","correct":false},{"text":"Să-i trimită la filisteni ca să-și găsească măgărițele","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:6']::text[], 'pending_review', 'Codex'),
  ('Pe cine au întâlnit Saul și sluga când urcau spre cetate?', '[{"text":"Niște fete care ieșiseră să scoată apă","correct":true},{"text":"Bătrânii lui Israel care veneau la Rama","correct":false},{"text":"Căpeteniile filistenilor","correct":false}]'::jsonb, 9, 1, '1 Samuel', ARRAY['9:11']::text[], 'pending_review', 'Codex'),
  ('De ce era Samuel în cetate în ziua aceea, potrivit fetelor întâlnite de Saul și de slugă?', '[{"text":"Poporul aducea jertfă pe înălțime","correct":true},{"text":"Căuta măgărițele lui Chis","correct":false},{"text":"Se întorcea de la Beer-Șeba","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:12']::text[], 'pending_review', 'Codex'),
  ('Ce trebuia să facă Samuel înainte ca poporul și cei poftiți să mănânce?', '[{"text":"Să binecuvânteze jertfa","correct":true},{"text":"Să găsească măgărițele","correct":false},{"text":"Să ungă un împărat în fața porții","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:13']::text[], 'pending_review', 'Codex'),
  ('Unde a fost întâlnit Samuel de Saul și de slugă?', '[{"text":"La poarta cetății, când Samuel ieșea spre înălțime","correct":true},{"text":"În odaia de mâncare, între cei poftiți","correct":false},{"text":"Pe acoperișul casei lui Chis","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:14']::text[], 'pending_review', 'Codex'),
  ('Când îl înștiințase Domnul pe Samuel despre venirea lui Saul?', '[{"text":"Cu o zi înainte","correct":true},{"text":"Cu trei zile înainte","correct":false},{"text":"În aceeași clipă în care Saul a intrat în cetate","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:15']::text[], 'pending_review', 'Codex'),
  ('Din ce țară urma să trimită Domnul omul pe care Samuel trebuia să-l ungă drept căpetenie?', '[{"text":"Din țara lui Beniamin","correct":true},{"text":"Din țara lui Efraim","correct":false},{"text":"Din țara filistenilor","correct":false}]'::jsonb, 9, 1, '1 Samuel', ARRAY['9:16']::text[], 'pending_review', 'Codex'),
  ('Din mâna cui urma să scape omul uns drept căpetenie poporul lui Israel?', '[{"text":"Din mâna filistenilor","correct":true},{"text":"Din mâna amoriților","correct":false},{"text":"Din mâna egiptenilor","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:16']::text[], 'pending_review', 'Codex'),
  ('Ce i-a spus Samuel lui Saul că va face cu el în ziua aceea?', '[{"text":"Va mânca împreună cu el","correct":true},{"text":"Îl va trimite imediat la tatăl lui","correct":false},{"text":"Îl va pune să judece la Beer-Șeba","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:19']::text[], 'pending_review', 'Codex'),
  ('De câte zile erau pierdute măgărițele despre care Samuel i-a spus lui Saul să nu se neliniștească?', '[{"text":"De trei zile","correct":true},{"text":"De o zi","correct":false},{"text":"De șapte zile","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:20']::text[], 'pending_review', 'Codex'),
  ('Ce a spus Saul despre seminția și familia lui?', '[{"text":"Era beniamit dintr-o seminție mică, iar familia lui era cea mai mică în Beniamin","correct":true},{"text":"Era din seminția lui Efraim și dintr-o familie mare","correct":false},{"text":"Era din seminția lui Iuda și din casa cea mai de preț","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:21']::text[], 'pending_review', 'Codex'),
  ('Câți oameni erau aproximativ printre cei poftiți, între care Samuel i-a dat lui Saul locul cel dintâi?', '[{"text":"Aproape treizeci","correct":true},{"text":"Aproape douăzeci","correct":false},{"text":"Aproape cincizeci","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:22']::text[], 'pending_review', 'Codex'),
  ('Ce parte din mâncare a pus bucătarul înaintea lui Saul?', '[{"text":"Spata și ce era pe ea","correct":true},{"text":"Capul și picioarele","correct":false},{"text":"O pâine și un sfert de siclu","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:24']::text[], 'pending_review', 'Codex'),
  ('Unde a stat Samuel de vorbă cu Saul după ce au coborât în cetate?', '[{"text":"Pe acoperișul casei","correct":true},{"text":"La poarta cetății","correct":false},{"text":"În odaia de mâncare","correct":false}]'::jsonb, 9, 1, '1 Samuel', ARRAY['9:25']::text[], 'pending_review', 'Codex'),
  ('Ce i-a spus Samuel slugii lui Saul să facă la marginea cetății?', '[{"text":"Să treacă înaintea lor","correct":true},{"text":"Să se întoarcă în cetate","correct":false},{"text":"Să urce la locul înalt","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:27']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 9, ARRAY['9:1', '9:2']::text[], 'pending_review', 'Ce detalii sunt consemnate despre familia lui Chis și despre Saul?'),
  ('1 Samuel', 9, ARRAY['9:2']::text[], 'pending_review', 'Ce trăsături ale lui Saul sunt menționate la începutul capitolului?'),
  ('1 Samuel', 9, ARRAY['9:3']::text[], 'pending_review', 'Ce i-a spus Chis lui Saul când s-au rătăcit măgărițele?'),
  ('1 Samuel', 9, ARRAY['9:4']::text[], 'pending_review', 'Ce ținuturi a străbătut Saul în căutarea măgărițelor fără să le găsească?'),
  ('1 Samuel', 9, ARRAY['9:5']::text[], 'pending_review', 'Ce a spus Saul când au ajuns în țara Țuf?'),
  ('1 Samuel', 9, ARRAY['9:6']::text[], 'pending_review', 'Ce i-a spus sluga lui Saul despre omul lui Dumnezeu din cetate?'),
  ('1 Samuel', 9, ARRAY['9:7', '9:8']::text[], 'pending_review', 'Ce două motive au avut Saul și sluga să se întrebe ce să ducă omului lui Dumnezeu?'),
  ('1 Samuel', 9, ARRAY['9:11', '9:12']::text[], 'pending_review', 'Ce se spune despre întâlnirea lui Saul și a slugii cu fetele care scoteau apă?'),
  ('1 Samuel', 9, ARRAY['9:12', '9:13']::text[], 'pending_review', 'Ce le-au spus fetele despre Samuel și despre jertfa din ziua aceea?'),
  ('1 Samuel', 9, ARRAY['9:14']::text[], 'pending_review', 'Ce s-a întâmplat când Saul și sluga au ajuns la poarta cetății?'),
  ('1 Samuel', 9, ARRAY['9:15', '9:16']::text[], 'pending_review', 'Ce îi spusese Domnul lui Samuel despre omul din Beniamin?'),
  ('1 Samuel', 9, ARRAY['9:16']::text[], 'pending_review', 'Ce motive a dat Domnul în legătură cu ajutorul pe care urma să-l aducă poporului?'),
  ('1 Samuel', 9, ARRAY['9:17']::text[], 'pending_review', 'Ce i-a spus Domnul lui Samuel când Samuel l-a zărit pe Saul?'),
  ('1 Samuel', 9, ARRAY['9:18', '9:19']::text[], 'pending_review', 'Ce i-a spus Samuel lui Saul când acesta a întrebat unde este casa văzătorului?'),
  ('1 Samuel', 9, ARRAY['9:20']::text[], 'pending_review', 'Ce două vești i-a dat Samuel lui Saul despre măgărițele pierdute?'),
  ('1 Samuel', 9, ARRAY['9:21']::text[], 'pending_review', 'Ce a spus Saul despre poziția lui în seminția lui Beniamin?'),
  ('1 Samuel', 9, ARRAY['9:22']::text[], 'pending_review', 'Cum i-a așezat Samuel pe Saul și pe sluga lui între cei poftiți?'),
  ('1 Samuel', 9, ARRAY['9:23', '9:24']::text[], 'pending_review', 'Ce a cerut Samuel bucătarului și ce a pus acesta înaintea lui Saul?'),
  ('1 Samuel', 9, ARRAY['9:24']::text[], 'pending_review', 'Ce explicație i-a dat Samuel lui Saul despre porția pusă înaintea lui?'),
  ('1 Samuel', 9, ARRAY['9:24', '9:25']::text[], 'pending_review', 'Ce s-a întâmplat după ce Saul a mâncat cu Samuel în ziua aceea?'),
  ('1 Samuel', 9, ARRAY['9:26']::text[], 'pending_review', 'Ce s-a întâmplat în dimineața următoare înainte ca Saul și Samuel să iasă din cetate?'),
  ('1 Samuel', 9, ARRAY['9:27']::text[], 'pending_review', 'Ce i-a spus Samuel lui Saul la marginea cetății?'),
  ('1 Samuel', 9, ARRAY['9:15', '9:16']::text[], 'pending_review', 'Ce îi spusese Domnul lui Samuel despre omul care urma să vină?'),
  ('1 Samuel', 9, ARRAY['9:3', '9:6', '9:10']::text[], 'pending_review', 'Ce persoane au fost implicate în căutarea măgărițelor și în întâlnirea cu omul lui Dumnezeu?')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_abc_multi (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Ce detalii sunt consemnate despre familia lui Chis și despre Saul?', '[{"text":"Chis era din Beniamin, iar tatăl lui se numea Abiel.","correct":true},{"text":"Saul era fiul lui Chis și este descris ca tânăr și frumos.","correct":true},{"text":"Chis era din Efraim, iar Saul era fiul întâi născut al lui Samuel.","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:1', '9:2']::text[], 'pending_review', 'Codex'),
  ('Ce trăsături ale lui Saul sunt menționate la începutul capitolului?', '[{"text":"Era tânăr și frumos.","correct":true},{"text":"Îi întrecea pe ceilalți copii ai lui Israel în înălțime de la umăr în sus.","correct":true},{"text":"Era deja judecător la Beer-Șeba și locuia în Rama.","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:2']::text[], 'pending_review', 'Codex'),
  ('Ce i-a spus Chis lui Saul când s-au rătăcit măgărițele?', '[{"text":"Să ia cu el o slugă.","correct":true},{"text":"Să se scoale și să meargă să caute măgărițele.","correct":true},{"text":"Să meargă singur la Samuel și să-i ceară un împărat.","correct":false}]'::jsonb, 9, 1, '1 Samuel', ARRAY['9:3']::text[], 'pending_review', 'Codex'),
  ('Ce ținuturi a străbătut Saul în căutarea măgărițelor fără să le găsească?', '[{"text":"Țara Șalișa și țara Șaalim.","correct":true},{"text":"Țara lui Beniamin.","correct":true},{"text":"Țara lui Iuda și cetatea Rama.","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:4']::text[], 'pending_review', 'Codex'),
  ('Ce a spus Saul când au ajuns în țara Țuf?', '[{"text":"Să se întoarcă, ca tatăl lui să nu se îngrijoreze pentru ei.","correct":true},{"text":"Tatăl lui putea fi îngrijorat pentru ei dacă lăsa măgărițele.","correct":true},{"text":"Să continue spre țara filistenilor, fiindcă măgărițele fuseseră găsite.","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:5']::text[], 'pending_review', 'Codex'),
  ('Ce i-a spus sluga lui Saul despre omul lui Dumnezeu din cetate?', '[{"text":"Era un om cu vază.","correct":true},{"text":"Tot ce spunea el se împlinea.","correct":true},{"text":"Era un om care le datora lui Chis și lui Saul bani.","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:6']::text[], 'pending_review', 'Codex'),
  ('Ce două motive au avut Saul și sluga să se întrebe ce să ducă omului lui Dumnezeu?', '[{"text":"Nu mai aveau merinde în saci.","correct":true},{"text":"Saul a spus că nu aveau niciun dar de dus, iar sluga a oferit un sfert de siclu de argint.","correct":true},{"text":"Aveau deja un dar pregătit și destule merinde pentru drum.","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:7', '9:8']::text[], 'pending_review', 'Codex'),
  ('Ce se spune despre întâlnirea lui Saul și a slugii cu fetele care scoteau apă?', '[{"text":"Fetele ieșiseră să scoată apă când ei urcau spre cetate.","correct":true},{"text":"Saul și sluga le-au întrebat dacă acolo era văzătorul.","correct":true},{"text":"Fetele le-au spus că Samuel se afla la Rama, departe de cetate.","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:11', '9:12']::text[], 'pending_review', 'Codex'),
  ('Ce le-au spus fetele despre Samuel și despre jertfa din ziua aceea?', '[{"text":"Samuel venise în cetate în ziua aceea, pentru că poporul aducea jertfă pe înălțime.","correct":true},{"text":"Poporul aștepta să vină Samuel, fiindcă el trebuia să binecuvânteze jertfa.","correct":true},{"text":"Samuel urma să binecuvânteze jertfa după ce mâncau toți ceilalți.","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:12', '9:13']::text[], 'pending_review', 'Codex'),
  ('Ce s-a întâmplat când Saul și sluga au ajuns la poarta cetății?', '[{"text":"Au fost întâlniți de Samuel.","correct":true},{"text":"Samuel ieșea să se suie pe înălțime.","correct":true},{"text":"Samuel i-a așteptat în odaia de mâncare alături de cei treizeci de poftiți.","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:14']::text[], 'pending_review', 'Codex'),
  ('Ce îi spusese Domnul lui Samuel despre omul din Beniamin?', '[{"text":"Să-l ungă drept căpetenie a poporului Israel.","correct":true},{"text":"El urma să scape poporul din mâna filistenilor.","correct":true},{"text":"Să-l trimită înapoi la tatăl său fără să-l ungă.","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:15', '9:16']::text[], 'pending_review', 'Codex'),
  ('Ce motive a dat Domnul în legătură cu ajutorul pe care urma să-l aducă poporului?', '[{"text":"Căutase cu îndurare spre poporul Său.","correct":true},{"text":"Strigătul poporului ajunsese până la El.","correct":true},{"text":"Poporul nu-I ceruse niciodată ajutor și nu strigase către El.","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:16']::text[], 'pending_review', 'Codex'),
  ('Ce i-a spus Domnul lui Samuel când Samuel l-a zărit pe Saul?', '[{"text":"Acesta era omul despre care îi vorbise Domnul.","correct":true},{"text":"Saul urma să domnească peste poporul Domnului.","correct":true},{"text":"Saul era unul dintre bătrânii veniți să ceară un împărat.","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:17']::text[], 'pending_review', 'Codex'),
  ('Ce i-a spus Samuel lui Saul când acesta a întrebat unde este casa văzătorului?', '[{"text":"Că el era văzătorul.","correct":true},{"text":"Să urce înaintea lui pe înălțime și să mănânce cu el în ziua aceea.","correct":true},{"text":"Că trebuia să se întoarcă imediat la tatăl său.","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:18', '9:19']::text[], 'pending_review', 'Codex'),
  ('Ce două vești i-a dat Samuel lui Saul despre măgărițele pierdute?', '[{"text":"Să nu se neliniștească pentru ele.","correct":true},{"text":"Măgărițele se găsiseră și erau pierdute de trei zile.","correct":true},{"text":"Măgărițele fuseseră duse de filisteni la Chiriat-Iearim.","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:20']::text[], 'pending_review', 'Codex'),
  ('Ce a spus Saul despre poziția lui în seminția lui Beniamin?', '[{"text":"Era din una dintre cele mai mici seminții ale lui Israel.","correct":true},{"text":"Familia lui era cea mai mică dintre familiile seminției lui Beniamin.","correct":true},{"text":"Familia lui era cea mai de preț din întregul Israel.","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:21']::text[], 'pending_review', 'Codex'),
  ('Cum i-a așezat Samuel pe Saul și pe sluga lui între cei poftiți?', '[{"text":"I-a dus în odaia de mâncare.","correct":true},{"text":"Le-a dat locul cel dintâi, între aproape treizeci de oameni.","correct":true},{"text":"I-a așezat la poartă, alături de fetele care scoteau apă.","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:22']::text[], 'pending_review', 'Codex'),
  ('Ce a cerut Samuel bucătarului și ce a pus acesta înaintea lui Saul?', '[{"text":"Samuel a cerut porția păstrată deoparte.","correct":true},{"text":"Bucătarul a pus înaintea lui Saul spata și ce era pe ea.","correct":true},{"text":"Bucătarul i-a dat lui Saul sfertul de siclu al slugii.","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:23', '9:24']::text[], 'pending_review', 'Codex'),
  ('Ce explicație i-a dat Samuel lui Saul despre porția pusă înaintea lui?', '[{"text":"Porția fusese păstrată pentru Saul.","correct":true},{"text":"Fusese păstrată când Samuel poftise poporul.","correct":true},{"text":"Porția fusese pregătită pentru sluga lui Saul, care urma să o împartă cu cei treizeci.","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:24']::text[], 'pending_review', 'Codex'),
  ('Ce s-a întâmplat după ce Saul a mâncat cu Samuel în ziua aceea?', '[{"text":"Au coborât de pe înălțime în cetate.","correct":true},{"text":"Samuel a stat de vorbă cu Saul pe acoperișul casei.","correct":true},{"text":"Saul s-a întors imediat la Chis împreună cu măgărițele.","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:24', '9:25']::text[], 'pending_review', 'Codex'),
  ('Ce s-a întâmplat în dimineața următoare înainte ca Saul și Samuel să iasă din cetate?', '[{"text":"Samuel l-a chemat pe Saul de pe acoperiș în revărsatul zorilor.","correct":true},{"text":"Samuel i-a spus lui Saul că îl va însoți.","correct":true},{"text":"Samuel i-a cerut slugii să rămână în odaia de mâncare.","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:26']::text[], 'pending_review', 'Codex'),
  ('Ce i-a spus Samuel lui Saul la marginea cetății?', '[{"text":"Să-i ceară slugii să treacă înaintea lor.","correct":true},{"text":"Să se oprească, pentru ca Samuel să-i facă cunoscut cuvântul lui Dumnezeu.","correct":true},{"text":"Să se întoarcă singur la masa celor poftiți.","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:27']::text[], 'pending_review', 'Codex'),
  ('Ce îi spusese Domnul lui Samuel despre omul care urma să vină?', '[{"text":"Cu o zi înainte, Domnul îl înștiințase pe Samuel despre venirea lui Saul.","correct":true},{"text":"Domnul spusese că va trimite a doua zi un om din țara lui Beniamin.","correct":true},{"text":"Samuel a aflat despre Saul abia după ce acesta a fost găsit de fetele care scoteau apă.","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:15', '9:16']::text[], 'pending_review', 'Codex'),
  ('Ce persoane au fost implicate în căutarea măgărițelor și în întâlnirea cu omul lui Dumnezeu?', '[{"text":"Saul a mers împreună cu o slugă, la cererea lui Chis.","correct":true},{"text":"Sluga i-a propus lui Saul să ceară îndrumare omului lui Dumnezeu.","correct":true},{"text":"Samuel i-a trimis pe fiii săi să caute măgărițele.","correct":false}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:3', '9:6', '9:10']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 9, ARRAY['9:1', '9:2']::text[], 'pending_review', '[{"left":"Seminția lui Chis","right":"Beniamin"},{"left":"Tatăl lui Chis","right":"Abiel"},{"left":"Fiul lui Chis","right":"Saul"},{"left":"Cum era Saul înfățișat","right":"Tânăr și frumos"},{"left":"Înălțimea lui Saul față de ceilalți","right":"Îi întrecea de la umăr în sus"}]'::jsonb),
  ('1 Samuel', 9, ARRAY['9:3', '9:4', '9:5']::text[], 'pending_review', '[{"left":"Ce s-a rătăcit","right":"Măgărițele lui Chis"},{"left":"Cine i-a spus lui Saul să le caute","right":"Chis, tatăl lui"},{"left":"Cu cine trebuia Saul să plece","right":"Cu o slugă"},{"left":"Țara străbătută înainte de Șaalim","right":"Țara Șalișa"},{"left":"Țara în care se aflau când Saul a propus întoarcerea","right":"Țara Țuf"}]'::jsonb),
  ('1 Samuel', 9, ARRAY['9:5', '9:6', '9:7', '9:8']::text[], 'pending_review', '[{"left":"Grija lui Saul când a ajuns în țara Țuf","right":"Tatăl lui s-ar putea îngrijora pentru ei"},{"left":"Ce era în cetatea despre care a vorbit sluga","right":"Un om al lui Dumnezeu cu vază"},{"left":"Ce nu mai aveau în saci","right":"Merinde"},{"left":"Ce a oferit sluga omului lui Dumnezeu","right":"Un sfert de siclu de argint"},{"left":"La ce spera sluga după dar","right":"Să li se arate drumul"}]'::jsonb),
  ('1 Samuel', 9, ARRAY['9:6', '9:7', '9:8', '9:10']::text[], 'pending_review', '[{"left":"Întrebarea lui Saul despre vizita la omul lui Dumnezeu","right":"Ce dar să-i ducă"},{"left":"Darul propus de slugă","right":"Un sfert de siclu de argint"},{"left":"Ce le-ar fi arătat omul lui Dumnezeu","right":"Drumul pe care trebuiau să apuce"},{"left":"Ce au hotărât Saul și sluga","right":"Să meargă în cetate"},{"left":"Unde se afla omul lui Dumnezeu","right":"În cetate"}]'::jsonb),
  ('1 Samuel', 9, ARRAY['9:11', '9:12', '9:13']::text[], 'pending_review', '[{"left":"Pe cine au întâlnit Saul și sluga pe drum","right":"Fete care ieșiseră să scoată apă"},{"left":"Ce au întrebat fetele","right":"Dacă acolo era văzătorul"},{"left":"De ce venise Samuel în cetate în ziua aceea","right":"Poporul aducea jertfă pe înălțime"},{"left":"Ce trebuia Samuel să facă înainte să mănânce poporul","right":"Să binecuvânteze jertfa"},{"left":"Cine mânca după aceea","right":"Cei poftiți"}]'::jsonb),
  ('1 Samuel', 9, ARRAY['9:12', '9:13', '9:14']::text[], 'pending_review', '[{"left":"Unde urma Samuel să se suie","right":"La locul înalt"},{"left":"Când ajung Saul și sluga la poartă","right":"Îl întâlnesc pe Samuel"},{"left":"În ce direcție ieșea Samuel","right":"Spre înălțime"},{"left":"Cine le-a spus că Samuel se afla acolo","right":"Fetele care scoteau apă"},{"left":"În ce zi ajunsese Samuel în cetate","right":"În ziua aceea"}]'::jsonb),
  ('1 Samuel', 9, ARRAY['9:14', '9:15', '9:16', '9:17']::text[], 'pending_review', '[{"left":"Cine l-a întâlnit pe Saul la poarta cetății","right":"Samuel"},{"left":"Când îl înștiințase Domnul pe Samuel","right":"Cu o zi înainte"},{"left":"Din ce țară urma să vină omul trimis","right":"Din țara lui Beniamin"},{"left":"Ce trebuia Samuel să facă omului","right":"Să-l ungă drept căpetenie"},{"left":"Cine urma să domnească peste popor","right":"Saul"}]'::jsonb),
  ('1 Samuel', 9, ARRAY['9:15', '9:16', '9:17']::text[], 'pending_review', '[{"left":"Ce a ajuns până la Domnul","right":"Strigătul poporului"},{"left":"Cum privise Domnul spre poporul Său","right":"Cu îndurare"},{"left":"Din mâna cui urma să fie scăpat poporul","right":"Din mâna filistenilor"},{"left":"Ce urma să facă omul din Beniamin","right":"Să scape poporul"},{"left":"Ce i-a spus Domnul lui Samuel despre Saul","right":"Va domni peste poporul Domnului"}]'::jsonb),
  ('1 Samuel', 9, ARRAY['9:18', '9:19', '9:20']::text[], 'pending_review', '[{"left":"Ce căuta Saul când s-a apropiat de Samuel","right":"Casa văzătorului"},{"left":"Cum s-a identificat Samuel","right":"„Eu sunt văzătorul.”"},{"left":"Unde l-a invitat Samuel pe Saul să urce","right":"Pe înălțime"},{"left":"Cu cine urma Saul să mănânce în ziua aceea","right":"Cu Samuel"},{"left":"Ce i-a spus Samuel despre măgărițe","right":"Se găsiseră"}]'::jsonb),
  ('1 Samuel', 9, ARRAY['9:19', '9:20', '9:21']::text[], 'pending_review', '[{"left":"Ce urma Samuel să-i spună lui Saul a doua zi","right":"Tot ce se petrecea în inima lui"},{"left":"De câte zile erau pierdute măgărițele","right":"Trei zile"},{"left":"Seminția lui Saul","right":"Beniamin"},{"left":"Cum descrie Saul seminția lui Israel","right":"Una dintre cele mai mici"},{"left":"Cum descrie Saul familia lui în Beniamin","right":"Cea mai mică"}]'::jsonb),
  ('1 Samuel', 9, ARRAY['9:21', '9:22', '9:23', '9:24']::text[], 'pending_review', '[{"left":"Ce a spus Saul despre familia sa","right":"Cea mai mică dintre familiile din Beniamin"},{"left":"Unde i-a dus Samuel pe Saul și pe slugă","right":"În odaia de mâncare"},{"left":"Locul dat lui Saul între cei poftiți","right":"Locul cel dintâi"},{"left":"Numărul aproximativ al celor poftiți","right":"Aproape treizeci"},{"left":"Porția păstrată pentru Saul","right":"Spata și ce era pe ea"}]'::jsonb),
  ('1 Samuel', 9, ARRAY['9:22', '9:23', '9:24', '9:25']::text[], 'pending_review', '[{"left":"Cine a pus porția înaintea lui Saul","right":"Bucătarul"},{"left":"Ce îi ceruse Samuel bucătarului să aducă","right":"Porția pusă deoparte"},{"left":"Pentru cine fusese păstrată porția","right":"Pentru Saul"},{"left":"Cu cine a mâncat Saul în ziua aceea","right":"Cu Samuel"},{"left":"Unde au stat de vorbă după masă","right":"Pe acoperișul casei"}]'::jsonb),
  ('1 Samuel', 9, ARRAY['9:25', '9:26', '9:27']::text[], 'pending_review', '[{"left":"Unde a vorbit Samuel cu Saul în cetate","right":"Pe acoperișul casei"},{"left":"Când l-a chemat Samuel pe Saul în dimineața următoare","right":"În revărsatul zorilor"},{"left":"Ce i-a spus Samuel lui Saul la plecare","right":"„Te voi însoți.”"},{"left":"Ce i-a spus Samuel slugii la marginea cetății","right":"Să treacă înainte"},{"left":"Ce urma Samuel să-i facă cunoscut lui Saul","right":"Cuvântul lui Dumnezeu"}]'::jsonb),
  ('1 Samuel', 9, ARRAY['9:3', '9:6', '9:8', '9:10', '9:11']::text[], 'pending_review', '[{"left":"Ce a căutat Saul","right":"Măgărițele rătăcite"},{"left":"Cu cine a plecat în căutare","right":"Cu o slugă"},{"left":"Sfatul slugii după ce au ajuns în Țuf","right":"Să meargă la omul lui Dumnezeu"},{"left":"Ce a oferit sluga ca dar","right":"Un sfert de siclu de argint"},{"left":"Pe cine au întâlnit în urcarea spre cetate","right":"Fete care scoteau apă"}]'::jsonb),
  ('1 Samuel', 9, ARRAY['9:12', '9:13', '9:14', '9:16', '9:17']::text[], 'pending_review', '[{"left":"De ce era poporul adunat în ziua aceea","right":"Aducea jertfă pe înălțime"},{"left":"Ce trebuia Samuel să facă pentru jertfă","right":"Să o binecuvânteze"},{"left":"Unde l-au întâlnit Saul și sluga","right":"La poarta cetății"},{"left":"Ce rol urma Saul să primească","right":"Căpetenie peste Israel"},{"left":"Din mâna cui urma să scape poporul","right":"Din mâna filistenilor"}]'::jsonb),
  ('1 Samuel', 9, ARRAY['9:16', '9:19', '9:20', '9:24', '9:27']::text[], 'pending_review', '[{"left":"Cui îi trimitea Domnul om din Beniamin","right":"Lui Samuel"},{"left":"Ce a promis Samuel că îi va spune lui Saul","right":"Tot ce se petrecea în inima lui"},{"left":"De ce să nu se neliniștească Saul","right":"Măgărițele se găsiseră"},{"left":"Ce a fost păstrat și pus înaintea lui Saul","right":"Spata și ce era pe ea"},{"left":"Ce cuvânt urma Samuel să-i facă auzit lui Saul","right":"Cuvântul lui Dumnezeu"}]'::jsonb)
) as incoming (book, chapter, source_references, status, pairs)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.pairs = incoming.pairs;

insert into public.questions_match (pairs, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.pairs, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('[{"left":"Seminția lui Chis","right":"Beniamin"},{"left":"Tatăl lui Chis","right":"Abiel"},{"left":"Fiul lui Chis","right":"Saul"},{"left":"Cum era Saul înfățișat","right":"Tânăr și frumos"},{"left":"Înălțimea lui Saul față de ceilalți","right":"Îi întrecea de la umăr în sus"}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:1', '9:2']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Ce s-a rătăcit","right":"Măgărițele lui Chis"},{"left":"Cine i-a spus lui Saul să le caute","right":"Chis, tatăl lui"},{"left":"Cu cine trebuia Saul să plece","right":"Cu o slugă"},{"left":"Țara străbătută înainte de Șaalim","right":"Țara Șalișa"},{"left":"Țara în care se aflau când Saul a propus întoarcerea","right":"Țara Țuf"}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:3', '9:4', '9:5']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Grija lui Saul când a ajuns în țara Țuf","right":"Tatăl lui s-ar putea îngrijora pentru ei"},{"left":"Ce era în cetatea despre care a vorbit sluga","right":"Un om al lui Dumnezeu cu vază"},{"left":"Ce nu mai aveau în saci","right":"Merinde"},{"left":"Ce a oferit sluga omului lui Dumnezeu","right":"Un sfert de siclu de argint"},{"left":"La ce spera sluga după dar","right":"Să li se arate drumul"}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:5', '9:6', '9:7', '9:8']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Întrebarea lui Saul despre vizita la omul lui Dumnezeu","right":"Ce dar să-i ducă"},{"left":"Darul propus de slugă","right":"Un sfert de siclu de argint"},{"left":"Ce le-ar fi arătat omul lui Dumnezeu","right":"Drumul pe care trebuiau să apuce"},{"left":"Ce au hotărât Saul și sluga","right":"Să meargă în cetate"},{"left":"Unde se afla omul lui Dumnezeu","right":"În cetate"}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:6', '9:7', '9:8', '9:10']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Pe cine au întâlnit Saul și sluga pe drum","right":"Fete care ieșiseră să scoată apă"},{"left":"Ce au întrebat fetele","right":"Dacă acolo era văzătorul"},{"left":"De ce venise Samuel în cetate în ziua aceea","right":"Poporul aducea jertfă pe înălțime"},{"left":"Ce trebuia Samuel să facă înainte să mănânce poporul","right":"Să binecuvânteze jertfa"},{"left":"Cine mânca după aceea","right":"Cei poftiți"}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:11', '9:12', '9:13']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Unde urma Samuel să se suie","right":"La locul înalt"},{"left":"Când ajung Saul și sluga la poartă","right":"Îl întâlnesc pe Samuel"},{"left":"În ce direcție ieșea Samuel","right":"Spre înălțime"},{"left":"Cine le-a spus că Samuel se afla acolo","right":"Fetele care scoteau apă"},{"left":"În ce zi ajunsese Samuel în cetate","right":"În ziua aceea"}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:12', '9:13', '9:14']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Cine l-a întâlnit pe Saul la poarta cetății","right":"Samuel"},{"left":"Când îl înștiințase Domnul pe Samuel","right":"Cu o zi înainte"},{"left":"Din ce țară urma să vină omul trimis","right":"Din țara lui Beniamin"},{"left":"Ce trebuia Samuel să facă omului","right":"Să-l ungă drept căpetenie"},{"left":"Cine urma să domnească peste popor","right":"Saul"}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:14', '9:15', '9:16', '9:17']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Ce a ajuns până la Domnul","right":"Strigătul poporului"},{"left":"Cum privise Domnul spre poporul Său","right":"Cu îndurare"},{"left":"Din mâna cui urma să fie scăpat poporul","right":"Din mâna filistenilor"},{"left":"Ce urma să facă omul din Beniamin","right":"Să scape poporul"},{"left":"Ce i-a spus Domnul lui Samuel despre Saul","right":"Va domni peste poporul Domnului"}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:15', '9:16', '9:17']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Ce căuta Saul când s-a apropiat de Samuel","right":"Casa văzătorului"},{"left":"Cum s-a identificat Samuel","right":"„Eu sunt văzătorul.”"},{"left":"Unde l-a invitat Samuel pe Saul să urce","right":"Pe înălțime"},{"left":"Cu cine urma Saul să mănânce în ziua aceea","right":"Cu Samuel"},{"left":"Ce i-a spus Samuel despre măgărițe","right":"Se găsiseră"}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:18', '9:19', '9:20']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Ce urma Samuel să-i spună lui Saul a doua zi","right":"Tot ce se petrecea în inima lui"},{"left":"De câte zile erau pierdute măgărițele","right":"Trei zile"},{"left":"Seminția lui Saul","right":"Beniamin"},{"left":"Cum descrie Saul seminția lui Israel","right":"Una dintre cele mai mici"},{"left":"Cum descrie Saul familia lui în Beniamin","right":"Cea mai mică"}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:19', '9:20', '9:21']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Ce a spus Saul despre familia sa","right":"Cea mai mică dintre familiile din Beniamin"},{"left":"Unde i-a dus Samuel pe Saul și pe slugă","right":"În odaia de mâncare"},{"left":"Locul dat lui Saul între cei poftiți","right":"Locul cel dintâi"},{"left":"Numărul aproximativ al celor poftiți","right":"Aproape treizeci"},{"left":"Porția păstrată pentru Saul","right":"Spata și ce era pe ea"}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:21', '9:22', '9:23', '9:24']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Cine a pus porția înaintea lui Saul","right":"Bucătarul"},{"left":"Ce îi ceruse Samuel bucătarului să aducă","right":"Porția pusă deoparte"},{"left":"Pentru cine fusese păstrată porția","right":"Pentru Saul"},{"left":"Cu cine a mâncat Saul în ziua aceea","right":"Cu Samuel"},{"left":"Unde au stat de vorbă după masă","right":"Pe acoperișul casei"}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:22', '9:23', '9:24', '9:25']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Unde a vorbit Samuel cu Saul în cetate","right":"Pe acoperișul casei"},{"left":"Când l-a chemat Samuel pe Saul în dimineața următoare","right":"În revărsatul zorilor"},{"left":"Ce i-a spus Samuel lui Saul la plecare","right":"„Te voi însoți.”"},{"left":"Ce i-a spus Samuel slugii la marginea cetății","right":"Să treacă înainte"},{"left":"Ce urma Samuel să-i facă cunoscut lui Saul","right":"Cuvântul lui Dumnezeu"}]'::jsonb, 9, 2, '1 Samuel', ARRAY['9:25', '9:26', '9:27']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Ce a căutat Saul","right":"Măgărițele rătăcite"},{"left":"Cu cine a plecat în căutare","right":"Cu o slugă"},{"left":"Sfatul slugii după ce au ajuns în Țuf","right":"Să meargă la omul lui Dumnezeu"},{"left":"Ce a oferit sluga ca dar","right":"Un sfert de siclu de argint"},{"left":"Pe cine au întâlnit în urcarea spre cetate","right":"Fete care scoteau apă"}]'::jsonb, 9, 3, '1 Samuel', ARRAY['9:3', '9:6', '9:8', '9:10', '9:11']::text[], 'pending_review', 'Codex'),
  ('[{"left":"De ce era poporul adunat în ziua aceea","right":"Aducea jertfă pe înălțime"},{"left":"Ce trebuia Samuel să facă pentru jertfă","right":"Să o binecuvânteze"},{"left":"Unde l-au întâlnit Saul și sluga","right":"La poarta cetății"},{"left":"Ce rol urma Saul să primească","right":"Căpetenie peste Israel"},{"left":"Din mâna cui urma să scape poporul","right":"Din mâna filistenilor"}]'::jsonb, 9, 3, '1 Samuel', ARRAY['9:12', '9:13', '9:14', '9:16', '9:17']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Cui îi trimitea Domnul om din Beniamin","right":"Lui Samuel"},{"left":"Ce a promis Samuel că îi va spune lui Saul","right":"Tot ce se petrecea în inima lui"},{"left":"De ce să nu se neliniștească Saul","right":"Măgărițele se găsiseră"},{"left":"Ce a fost păstrat și pus înaintea lui Saul","right":"Spata și ce era pe ea"},{"left":"Ce cuvânt urma Samuel să-i facă auzit lui Saul","right":"Cuvântul lui Dumnezeu"}]'::jsonb, 9, 3, '1 Samuel', ARRAY['9:16', '9:19', '9:20', '9:24', '9:27']::text[], 'pending_review', 'Codex')
) as incoming (pairs, chapter, difficulty, book, source_references, status, added_by)
where not exists (
  select 1 from public.questions_match existing
  where existing.book = incoming.book
    and existing.chapter = incoming.chapter
    and existing.source_references = incoming.source_references
    and existing.pairs = incoming.pairs
);

commit;
