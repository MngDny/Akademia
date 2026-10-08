begin;

alter table public.questions_tf add column if not exists source_references text[] not null default '{}';

alter table public.questions_abc_one add column if not exists source_references text[] not null default '{}';

alter table public.questions_abc_multi add column if not exists source_references text[] not null default '{}';

alter table public.questions_match add column if not exists source_references text[] not null default '{}';

update public.questions_tf as existing
set status = incoming.status
from (values
  ('1 Samuel', 5, ARRAY['5:1']::text[], 'pending_review', 'Filistenii au luat chivotul lui Dumnezeu de la Eben-Ezer și l-au dus la Asdod.'),
  ('1 Samuel', 5, ARRAY['5:1', '5:8']::text[], 'pending_review', 'Filistenii au dus chivotul la Gat înainte să-l ducă la Asdod.'),
  ('1 Samuel', 5, ARRAY['5:2']::text[], 'pending_review', 'În Asdod, filistenii au așezat chivotul în casa lui Dagon, lângă Dagon.'),
  ('1 Samuel', 5, ARRAY['5:3']::text[], 'pending_review', 'Dis-de-dimineață, asdodenii l-au găsit pe Dagon întins cu fața la pământ înaintea chivotului Domnului.'),
  ('1 Samuel', 5, ARRAY['5:3']::text[], 'pending_review', 'După ce l-au găsit pe Dagon căzut, asdodenii l-au scos din casă și nu l-au mai pus la loc.'),
  ('1 Samuel', 5, ARRAY['5:4']::text[], 'pending_review', 'A doua dimineață, Dagon a fost găsit din nou cu fața la pământ înaintea chivotului.'),
  ('1 Samuel', 5, ARRAY['5:4']::text[], 'pending_review', 'Capul și amândouă mâinile lui Dagon erau tăiate pe prag, iar trunchiul îi rămăsese.'),
  ('1 Samuel', 5, ARRAY['5:5']::text[], 'pending_review', 'Până în ziua de azi, preoții lui Dagon și cei ce intră în casa lui din Asdod nu calcă pe prag.'),
  ('1 Samuel', 5, ARRAY['5:6']::text[], 'pending_review', 'Mâna Domnului a apăsat asupra celor din Asdod și i-a lovit numai pe cei din cetate, nu și din ținutul ei.'),
  ('1 Samuel', 5, ARRAY['5:7']::text[], 'pending_review', 'Oamenii din Asdod au spus că mâna Dumnezeului lui Israel apăsa asupra lor și asupra lui Dagon.'),
  ('1 Samuel', 5, ARRAY['5:8']::text[], 'pending_review', 'Domnitorii filistenilor au hotărât ca chivotul să rămână la Asdod.'),
  ('1 Samuel', 5, ARRAY['5:8']::text[], 'pending_review', 'Domnitorii filistenilor au spus să fie dus chivotul Dumnezeului lui Israel la Gat.'),
  ('1 Samuel', 5, ARRAY['5:9']::text[], 'pending_review', 'După ce chivotul a ajuns la Gat, mâna Domnului a apăsat asupra cetății și s-a făcut o mare groază.'),
  ('1 Samuel', 5, ARRAY['5:9']::text[], 'pending_review', 'La Gat, oamenii de la mic până la mare au fost loviți cu o spuzeală de bube la șezut.'),
  ('1 Samuel', 5, ARRAY['5:10']::text[], 'pending_review', 'După Gat, filistenii au trimis chivotul lui Dumnezeu la Ecron.'),
  ('1 Samuel', 5, ARRAY['5:10']::text[], 'pending_review', 'Ecroniții au strigat că li se adusese chivotul Dumnezeului lui Israel ca să-i omoare pe ei și poporul lor.'),
  ('1 Samuel', 5, ARRAY['5:11']::text[], 'pending_review', 'Domnitorii filistenilor au cerut ca chivotul să fie trimis înapoi la locul lui, pentru ca ei și poporul lor să nu moară.'),
  ('1 Samuel', 5, ARRAY['5:11']::text[], 'pending_review', 'În toată Ecronul era o groază de moarte, iar mâna lui Dumnezeu apăsa cu putere.'),
  ('1 Samuel', 5, ARRAY['5:12']::text[], 'pending_review', 'Oamenii care nu mureau erau loviți cu bube la șezut, iar țipetele cetății se înălțau până la cer.'),
  ('1 Samuel', 5, ARRAY['5:10', '5:12']::text[], 'pending_review', 'La sfârșitul capitolului, țipetele cetății au încetat după ce filistenii au mutat chivotul.')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_tf (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Filistenii au luat chivotul lui Dumnezeu de la Eben-Ezer și l-au dus la Asdod.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 5, 1, '1 Samuel', ARRAY['5:1']::text[], 'pending_review', 'Codex'),
  ('Filistenii au dus chivotul la Gat înainte să-l ducă la Asdod.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 5, 1, '1 Samuel', ARRAY['5:1', '5:8']::text[], 'pending_review', 'Codex'),
  ('În Asdod, filistenii au așezat chivotul în casa lui Dagon, lângă Dagon.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 5, 1, '1 Samuel', ARRAY['5:2']::text[], 'pending_review', 'Codex'),
  ('Dis-de-dimineață, asdodenii l-au găsit pe Dagon întins cu fața la pământ înaintea chivotului Domnului.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 5, 1, '1 Samuel', ARRAY['5:3']::text[], 'pending_review', 'Codex'),
  ('După ce l-au găsit pe Dagon căzut, asdodenii l-au scos din casă și nu l-au mai pus la loc.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 5, 2, '1 Samuel', ARRAY['5:3']::text[], 'pending_review', 'Codex'),
  ('A doua dimineață, Dagon a fost găsit din nou cu fața la pământ înaintea chivotului.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 5, 1, '1 Samuel', ARRAY['5:4']::text[], 'pending_review', 'Codex'),
  ('Capul și amândouă mâinile lui Dagon erau tăiate pe prag, iar trunchiul îi rămăsese.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 5, 2, '1 Samuel', ARRAY['5:4']::text[], 'pending_review', 'Codex'),
  ('Până în ziua de azi, preoții lui Dagon și cei ce intră în casa lui din Asdod nu calcă pe prag.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 5, 2, '1 Samuel', ARRAY['5:5']::text[], 'pending_review', 'Codex'),
  ('Mâna Domnului a apăsat asupra celor din Asdod și i-a lovit numai pe cei din cetate, nu și din ținutul ei.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 5, 2, '1 Samuel', ARRAY['5:6']::text[], 'pending_review', 'Codex'),
  ('Oamenii din Asdod au spus că mâna Dumnezeului lui Israel apăsa asupra lor și asupra lui Dagon.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 5, 2, '1 Samuel', ARRAY['5:7']::text[], 'pending_review', 'Codex'),
  ('Domnitorii filistenilor au hotărât ca chivotul să rămână la Asdod.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 5, 2, '1 Samuel', ARRAY['5:8']::text[], 'pending_review', 'Codex'),
  ('Domnitorii filistenilor au spus să fie dus chivotul Dumnezeului lui Israel la Gat.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 5, 1, '1 Samuel', ARRAY['5:8']::text[], 'pending_review', 'Codex'),
  ('După ce chivotul a ajuns la Gat, mâna Domnului a apăsat asupra cetății și s-a făcut o mare groază.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 5, 2, '1 Samuel', ARRAY['5:9']::text[], 'pending_review', 'Codex'),
  ('La Gat, oamenii de la mic până la mare au fost loviți cu o spuzeală de bube la șezut.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 5, 2, '1 Samuel', ARRAY['5:9']::text[], 'pending_review', 'Codex'),
  ('După Gat, filistenii au trimis chivotul lui Dumnezeu la Ecron.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 5, 1, '1 Samuel', ARRAY['5:10']::text[], 'pending_review', 'Codex'),
  ('Ecroniții au strigat că li se adusese chivotul Dumnezeului lui Israel ca să-i omoare pe ei și poporul lor.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 5, 2, '1 Samuel', ARRAY['5:10']::text[], 'pending_review', 'Codex'),
  ('Domnitorii filistenilor au cerut ca chivotul să fie trimis înapoi la locul lui, pentru ca ei și poporul lor să nu moară.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 5, 2, '1 Samuel', ARRAY['5:11']::text[], 'pending_review', 'Codex'),
  ('În toată Ecronul era o groază de moarte, iar mâna lui Dumnezeu apăsa cu putere.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 5, 2, '1 Samuel', ARRAY['5:11']::text[], 'pending_review', 'Codex'),
  ('Oamenii care nu mureau erau loviți cu bube la șezut, iar țipetele cetății se înălțau până la cer.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 5, 1, '1 Samuel', ARRAY['5:12']::text[], 'pending_review', 'Codex'),
  ('La sfârșitul capitolului, țipetele cetății au încetat după ce filistenii au mutat chivotul.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 5, 2, '1 Samuel', ARRAY['5:10', '5:12']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 5, ARRAY['5:1']::text[], 'pending_review', 'Din ce loc au luat filistenii chivotul lui Dumnezeu înainte să-l ducă la Asdod?'),
  ('1 Samuel', 5, ARRAY['5:1']::text[], 'pending_review', 'În care cetate au dus filistenii chivotul prima dată?'),
  ('1 Samuel', 5, ARRAY['5:2']::text[], 'pending_review', 'Unde au așezat filistenii chivotul după ce l-au adus în Asdod?'),
  ('1 Samuel', 5, ARRAY['5:3']::text[], 'pending_review', 'Cum l-au găsit asdodenii pe Dagon în dimineața de după aducerea chivotului?'),
  ('1 Samuel', 5, ARRAY['5:3']::text[], 'pending_review', 'Ce au făcut asdodenii după ce l-au găsit pe Dagon căzut la pământ în prima dimineață?'),
  ('1 Samuel', 5, ARRAY['5:4']::text[], 'pending_review', 'Ce părți ale lui Dagon au fost găsite tăiate pe prag a doua zi?'),
  ('1 Samuel', 5, ARRAY['5:4']::text[], 'pending_review', 'Ce nu mai rămăsese din Dagon după ce au fost găsite capul și mâinile tăiate?'),
  ('1 Samuel', 5, ARRAY['5:5']::text[], 'pending_review', 'Ce obicei țineau preoții lui Dagon și cei ce intrau în casa lui din Asdod?'),
  ('1 Samuel', 5, ARRAY['5:6']::text[], 'pending_review', 'Unde s-a răspândit lovitura cu bube pe care au primit-o cei din Asdod?'),
  ('1 Samuel', 5, ARRAY['5:7']::text[], 'pending_review', 'Ce au spus oamenii din Asdod că nu trebuie să rămână la ei?'),
  ('1 Samuel', 5, ARRAY['5:8']::text[], 'pending_review', 'Ce cetate au ales domnitorii filistenilor pentru a primi chivotul după Asdod?'),
  ('1 Samuel', 5, ARRAY['5:9']::text[], 'pending_review', 'Ce s-a petrecut în cetatea Gat după sosirea chivotului?'),
  ('1 Samuel', 5, ARRAY['5:9']::text[], 'pending_review', 'De la ce categorie de oameni au fost loviți locuitorii Gatului?'),
  ('1 Samuel', 5, ARRAY['5:10']::text[], 'pending_review', 'În ce cetate au trimis filistenii chivotul după ce fusese la Gat?'),
  ('1 Samuel', 5, ARRAY['5:10']::text[], 'pending_review', 'Ce spuneau ecroniții că le-ar putea face sosirea chivotului?'),
  ('1 Samuel', 5, ARRAY['5:11']::text[], 'pending_review', 'Ce le-au cerut domnitorii filistenilor să facă cu chivotul?'),
  ('1 Samuel', 5, ARRAY['5:12']::text[], 'pending_review', 'Până unde se înălțau țipetele cetății?'),
  ('1 Samuel', 5, ARRAY['5:12']::text[], 'pending_review', 'Ce se întâmpla cu oamenii care nu mureau?')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_abc_one (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Din ce loc au luat filistenii chivotul lui Dumnezeu înainte să-l ducă la Asdod?', '[{"text":"Eben-Ezer","correct":true},{"text":"Silo","correct":false},{"text":"Gat","correct":false}]'::jsonb, 5, 1, '1 Samuel', ARRAY['5:1']::text[], 'pending_review', 'Codex'),
  ('În care cetate au dus filistenii chivotul prima dată?', '[{"text":"La Ecron","correct":false},{"text":"La Asdod","correct":true},{"text":"La Gat","correct":false}]'::jsonb, 5, 1, '1 Samuel', ARRAY['5:1']::text[], 'pending_review', 'Codex'),
  ('Unde au așezat filistenii chivotul după ce l-au adus în Asdod?', '[{"text":"În casa lui Dagon, lângă Dagon","correct":true},{"text":"La poarta cetății","correct":false},{"text":"În casa domnitorilor filistenilor","correct":false}]'::jsonb, 5, 1, '1 Samuel', ARRAY['5:2']::text[], 'pending_review', 'Codex'),
  ('Cum l-au găsit asdodenii pe Dagon în dimineața de după aducerea chivotului?', '[{"text":"Întins cu fața la pământ înaintea chivotului","correct":true},{"text":"Stând în picioare lângă prag","correct":false},{"text":"Cu fața spre poarta cetății","correct":false}]'::jsonb, 5, 1, '1 Samuel', ARRAY['5:3']::text[], 'pending_review', 'Codex'),
  ('Ce au făcut asdodenii după ce l-au găsit pe Dagon căzut la pământ în prima dimineață?', '[{"text":"L-au ridicat și l-au pus la locul lui","correct":true},{"text":"L-au dus la Gat","correct":false},{"text":"L-au lăsat întins înaintea chivotului","correct":false}]'::jsonb, 5, 1, '1 Samuel', ARRAY['5:3']::text[], 'pending_review', 'Codex'),
  ('Ce părți ale lui Dagon au fost găsite tăiate pe prag a doua zi?', '[{"text":"Capul și cele două mâini","correct":true},{"text":"Capul și un picior","correct":false},{"text":"Amândouă picioarele","correct":false}]'::jsonb, 5, 2, '1 Samuel', ARRAY['5:4']::text[], 'pending_review', 'Codex'),
  ('Ce nu mai rămăsese din Dagon după ce au fost găsite capul și mâinile tăiate?', '[{"text":"Decât trunchiul","correct":true},{"text":"Decât capul","correct":false},{"text":"Decât mâinile","correct":false}]'::jsonb, 5, 1, '1 Samuel', ARRAY['5:4']::text[], 'pending_review', 'Codex'),
  ('Ce obicei țineau preoții lui Dagon și cei ce intrau în casa lui din Asdod?', '[{"text":"Nu călcau pe prag","correct":true},{"text":"Nu intrau dimineața în casă","correct":false},{"text":"Nu se apropiau de chivot","correct":false}]'::jsonb, 5, 2, '1 Samuel', ARRAY['5:5']::text[], 'pending_review', 'Codex'),
  ('Unde s-a răspândit lovitura cu bube pe care au primit-o cei din Asdod?', '[{"text":"În Asdod și în ținutul lui","correct":true},{"text":"Numai în casa lui Dagon","correct":false},{"text":"Numai asupra domnitorilor filistenilor","correct":false}]'::jsonb, 5, 2, '1 Samuel', ARRAY['5:6']::text[], 'pending_review', 'Codex'),
  ('Ce au spus oamenii din Asdod că nu trebuie să rămână la ei?', '[{"text":"Chivotul Dumnezeului lui Israel","correct":true},{"text":"Dagon","correct":false},{"text":"Domnitorii filistenilor","correct":false}]'::jsonb, 5, 1, '1 Samuel', ARRAY['5:7']::text[], 'pending_review', 'Codex'),
  ('Ce cetate au ales domnitorii filistenilor pentru a primi chivotul după Asdod?', '[{"text":"Gat","correct":true},{"text":"Ecron","correct":false},{"text":"Silo","correct":false}]'::jsonb, 5, 1, '1 Samuel', ARRAY['5:8']::text[], 'pending_review', 'Codex'),
  ('Ce s-a petrecut în cetatea Gat după sosirea chivotului?', '[{"text":"Mâna Domnului a apăsat asupra cetății și s-a făcut mare groază","correct":true},{"text":"Dagon a fost pus din nou la locul lui","correct":false},{"text":"Oamenii au trimis imediat chivotul la Silo","correct":false}]'::jsonb, 5, 2, '1 Samuel', ARRAY['5:9']::text[], 'pending_review', 'Codex'),
  ('De la ce categorie de oameni au fost loviți locuitorii Gatului?', '[{"text":"De la mic până la mare","correct":true},{"text":"Numai domnitorii","correct":false},{"text":"Numai preoții lui Dagon","correct":false}]'::jsonb, 5, 1, '1 Samuel', ARRAY['5:9']::text[], 'pending_review', 'Codex'),
  ('În ce cetate au trimis filistenii chivotul după ce fusese la Gat?', '[{"text":"Ecron","correct":true},{"text":"Asdod","correct":false},{"text":"Eben-Ezer","correct":false}]'::jsonb, 5, 1, '1 Samuel', ARRAY['5:10']::text[], 'pending_review', 'Codex'),
  ('Ce spuneau ecroniții că le-ar putea face sosirea chivotului?', '[{"text":"Să-i omoare pe ei și poporul lor","correct":true},{"text":"Să-i trimită înapoi la Gat","correct":false},{"text":"Să-i facă să calce pe prag","correct":false}]'::jsonb, 5, 2, '1 Samuel', ARRAY['5:10']::text[], 'pending_review', 'Codex'),
  ('Ce le-au cerut domnitorii filistenilor să facă cu chivotul?', '[{"text":"Să-l trimită înapoi la locul lui","correct":true},{"text":"Să-l ducă la Asdod","correct":false},{"text":"Să-l așeze din nou lângă Dagon","correct":false}]'::jsonb, 5, 1, '1 Samuel', ARRAY['5:11']::text[], 'pending_review', 'Codex'),
  ('Până unde se înălțau țipetele cetății?', '[{"text":"Până la cer","correct":true},{"text":"Până la poarta cetății","correct":false},{"text":"Până la casa lui Dagon","correct":false}]'::jsonb, 5, 1, '1 Samuel', ARRAY['5:12']::text[], 'pending_review', 'Codex'),
  ('Ce se întâmpla cu oamenii care nu mureau?', '[{"text":"Erau loviți cu bube la șezut","correct":true},{"text":"Erau duși la Silo","correct":false},{"text":"Erau puși să păzească pragul","correct":false}]'::jsonb, 5, 1, '1 Samuel', ARRAY['5:12']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 5, ARRAY['5:1']::text[], 'pending_review', 'Ce detalii despre mutarea chivotului la începutul capitolului sunt menționate?'),
  ('1 Samuel', 5, ARRAY['5:2']::text[], 'pending_review', 'Cum au așezat filistenii chivotul când l-au adus în Asdod?'),
  ('1 Samuel', 5, ARRAY['5:2', '5:3']::text[], 'pending_review', 'Ce au făcut asdodenii în prima dimineață după ce chivotul fusese așezat lângă Dagon?'),
  ('1 Samuel', 5, ARRAY['5:3']::text[], 'pending_review', 'Ce au făcut asdodenii după ce l-au găsit pe Dagon întins cu fața la pământ?'),
  ('1 Samuel', 5, ARRAY['5:3', '5:4']::text[], 'pending_review', 'Ce s-a întâmplat cu Dagon în prima dimineață și în dimineața următoare?'),
  ('1 Samuel', 5, ARRAY['5:4']::text[], 'pending_review', 'Ce detalii sunt menționate despre ce au găsit în casa lui Dagon a doua dimineață?'),
  ('1 Samuel', 5, ARRAY['5:5']::text[], 'pending_review', 'Cine respecta obiceiul legat de pragul casei lui Dagon și ce făceau?'),
  ('1 Samuel', 5, ARRAY['5:6']::text[], 'pending_review', 'Ce spune textul despre pedeapsa care a venit asupra celor din Asdod?'),
  ('1 Samuel', 5, ARRAY['5:7']::text[], 'pending_review', 'Ce au afirmat oamenii din Asdod despre chivot și apăsarea mâinii Domnului?'),
  ('1 Samuel', 5, ARRAY['5:7', '5:8']::text[], 'pending_review', 'Ce au făcut domnitorii filistenilor în legătură cu chivotul după ce oamenii din Asdod au vorbit?'),
  ('1 Samuel', 5, ARRAY['5:8', '5:9']::text[], 'pending_review', 'Ce s-a întâmplat după ce chivotul a fost dus la Gat?'),
  ('1 Samuel', 5, ARRAY['5:9']::text[], 'pending_review', 'Ce efecte asupra locuitorilor Gatului sunt precizate?'),
  ('1 Samuel', 5, ARRAY['5:10']::text[], 'pending_review', 'Ce au făcut filistenii când au trimis chivotul în Ecron și ce au strigat ecroniții?'),
  ('1 Samuel', 5, ARRAY['5:11']::text[], 'pending_review', 'Ce au cerut domnitorii filistenilor după ce au strâns adunarea?'),
  ('1 Samuel', 5, ARRAY['5:11']::text[], 'pending_review', 'Ce motive și împrejurări sunt menționate când domnitorii cer întoarcerea chivotului?'),
  ('1 Samuel', 5, ARRAY['5:11', '5:12']::text[], 'pending_review', 'Ce se spune despre mâna lui Dumnezeu și despre oamenii din Ecron?'),
  ('1 Samuel', 5, ARRAY['5:11', '5:12']::text[], 'pending_review', 'Ce detalii apar la sfârșitul capitolului despre cei rămași în viață și despre cetate?'),
  ('1 Samuel', 5, ARRAY['5:8', '5:10']::text[], 'pending_review', 'Ce două cetăți sunt menționate după plecarea chivotului din Asdod?'),
  ('1 Samuel', 5, ARRAY['5:2', '5:5']::text[], 'pending_review', 'Ce lucruri despre casa lui Dagon sunt menționate în capitol?'),
  ('1 Samuel', 5, ARRAY['5:7', '5:10']::text[], 'pending_review', 'Ce reacții ale locuitorilor sunt legate de sosirea sau prezența chivotului în cetățile filistenilor?')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_abc_multi (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Ce detalii despre mutarea chivotului la începutul capitolului sunt menționate?', '[{"text":"Filistenii au luat chivotul lui Dumnezeu.","correct":true},{"text":"L-au dus din Eben-Ezer la Asdod.","correct":true},{"text":"L-au dus din Gat la Silo.","correct":false}]'::jsonb, 5, 2, '1 Samuel', ARRAY['5:1']::text[], 'pending_review', 'Codex'),
  ('Cum au așezat filistenii chivotul când l-au adus în Asdod?', '[{"text":"L-au dus în casa lui Dagon.","correct":true},{"text":"L-au așezat lângă Dagon.","correct":true},{"text":"L-au așezat în afara cetății, lângă poartă.","correct":false}]'::jsonb, 5, 2, '1 Samuel', ARRAY['5:2']::text[], 'pending_review', 'Codex'),
  ('Ce au făcut asdodenii în prima dimineață după ce chivotul fusese așezat lângă Dagon?', '[{"text":"S-au sculat dis-de-dimineață.","correct":true},{"text":"L-au găsit pe Dagon întins cu fața la pământ înaintea chivotului.","correct":true},{"text":"Au găsit chivotul întins înaintea lui Dagon.","correct":false}]'::jsonb, 5, 2, '1 Samuel', ARRAY['5:2', '5:3']::text[], 'pending_review', 'Codex'),
  ('Ce au făcut asdodenii după ce l-au găsit pe Dagon întins cu fața la pământ?', '[{"text":"L-au luat pe Dagon.","correct":true},{"text":"L-au pus înapoi la locul lui.","correct":true},{"text":"L-au scos din casa lui și l-au trimis la Ecron.","correct":false}]'::jsonb, 5, 2, '1 Samuel', ARRAY['5:3']::text[], 'pending_review', 'Codex'),
  ('Ce s-a întâmplat cu Dagon în prima dimineață și în dimineața următoare?', '[{"text":"În prima dimineață a fost găsit cu fața la pământ și a fost pus la locul lui.","correct":true},{"text":"În dimineața următoare a fost găsit din nou căzut, cu capul și mâinile tăiate pe prag.","correct":true},{"text":"În prima dimineață a fost găsit cu capul și mâinile tăiate pe prag.","correct":false}]'::jsonb, 5, 3, '1 Samuel', ARRAY['5:3', '5:4']::text[], 'pending_review', 'Codex'),
  ('Ce detalii sunt menționate despre ce au găsit în casa lui Dagon a doua dimineață?', '[{"text":"Capul și amândouă mâinile lui Dagon au fost tăiate pe prag.","correct":true},{"text":"Nu-i mai rămăsese decât trunchiul.","correct":true},{"text":"I-au fost tăiate și picioarele, iar capul a rămas neatins.","correct":false}]'::jsonb, 5, 2, '1 Samuel', ARRAY['5:4']::text[], 'pending_review', 'Codex'),
  ('Cine respecta obiceiul legat de pragul casei lui Dagon și ce făceau?', '[{"text":"Preoții lui Dagon nu călcau pe prag.","correct":true},{"text":"Toți cei ce intrau în casa lui Dagon nu călcau pe prag.","correct":true},{"text":"Oamenii din Gat nu intrau în casa lui Dagon.","correct":false}]'::jsonb, 5, 2, '1 Samuel', ARRAY['5:5']::text[], 'pending_review', 'Codex'),
  ('Ce spune textul despre pedeapsa care a venit asupra celor din Asdod?', '[{"text":"Mâna Domnului a apăsat asupra lor și i-a pustiit.","correct":true},{"text":"Au fost loviți cu bube la șezut.","correct":true},{"text":"Au fost loviți numai preoții care intrau în casa lui Dagon.","correct":false}]'::jsonb, 5, 2, '1 Samuel', ARRAY['5:6']::text[], 'pending_review', 'Codex'),
  ('Ce au afirmat oamenii din Asdod despre chivot și apăsarea mâinii Domnului?', '[{"text":"Au spus că chivotul Dumnezeului lui Israel nu trebuie să rămână la ei.","correct":true},{"text":"Au spus că mâna Lui apăsa asupra lor și asupra lui Dagon.","correct":true},{"text":"Au spus că mâna lui Dagon apăsa asupra Domnului.","correct":false}]'::jsonb, 5, 2, '1 Samuel', ARRAY['5:7']::text[], 'pending_review', 'Codex'),
  ('Ce au făcut domnitorii filistenilor în legătură cu chivotul după ce oamenii din Asdod au vorbit?', '[{"text":"Au fost strânși laolaltă.","correct":true},{"text":"Au spus să fie dus la Gat.","correct":true},{"text":"Au hotărât să fie dus la Silo.","correct":false}]'::jsonb, 5, 2, '1 Samuel', ARRAY['5:7', '5:8']::text[], 'pending_review', 'Codex'),
  ('Ce s-a întâmplat după ce chivotul a fost dus la Gat?', '[{"text":"Mâna Domnului a apăsat asupra cetății.","correct":true},{"text":"A fost o mare groază.","correct":true},{"text":"Dagon a fost ridicat și pus înapoi la locul lui.","correct":false}]'::jsonb, 5, 2, '1 Samuel', ARRAY['5:8', '5:9']::text[], 'pending_review', 'Codex'),
  ('Ce efecte asupra locuitorilor Gatului sunt precizate?', '[{"text":"Oamenii de la mic până la mare au fost loviți.","correct":true},{"text":"Au avut o spuzeală de bube la șezut.","correct":true},{"text":"Numai domnitorii filistenilor au fost loviți.","correct":false}]'::jsonb, 5, 2, '1 Samuel', ARRAY['5:9']::text[], 'pending_review', 'Codex'),
  ('Ce au făcut filistenii când au trimis chivotul în Ecron și ce au strigat ecroniții?', '[{"text":"Au trimis chivotul lui Dumnezeu la Ecron.","correct":true},{"text":"Ecroniții au strigat că fusese adus ca să-i omoare pe ei și poporul lor.","correct":true},{"text":"Ecroniții au cerut să fie dus la Eben-Ezer ca să-l așeze lângă Dagon.","correct":false}]'::jsonb, 5, 3, '1 Samuel', ARRAY['5:10']::text[], 'pending_review', 'Codex'),
  ('Ce au cerut domnitorii filistenilor după ce au strâns adunarea?', '[{"text":"Să trimită înapoi chivotul Dumnezeului lui Israel.","correct":true},{"text":"Să se întoarcă la locul lui.","correct":true},{"text":"Să-l ducă înapoi la casa lui Dagon din Asdod.","correct":false}]'::jsonb, 5, 2, '1 Samuel', ARRAY['5:11']::text[], 'pending_review', 'Codex'),
  ('Ce motive și împrejurări sunt menționate când domnitorii cer întoarcerea chivotului?', '[{"text":"Ca să nu-i omoare pe ei și poporul lor.","correct":true},{"text":"În toată cetatea era o groază de moarte.","correct":true},{"text":"Ca să-i ajute pe cei din Gat să ridice statuia lui Dagon.","correct":false}]'::jsonb, 5, 3, '1 Samuel', ARRAY['5:11']::text[], 'pending_review', 'Codex'),
  ('Ce se spune despre mâna lui Dumnezeu și despre oamenii din Ecron?', '[{"text":"Mâna lui Dumnezeu apăsa cu putere.","correct":true},{"text":"Oamenii care nu mureau erau loviți cu bube la șezut.","correct":true},{"text":"Toți oamenii muriseră înainte să se strângă domnitorii.","correct":false}]'::jsonb, 5, 3, '1 Samuel', ARRAY['5:11', '5:12']::text[], 'pending_review', 'Codex'),
  ('Ce detalii apar la sfârșitul capitolului despre cei rămași în viață și despre cetate?', '[{"text":"Cei care nu mureau erau loviți cu bube la șezut.","correct":true},{"text":"Țipetele cetății se înălțau până la cer.","correct":true},{"text":"Locuitorii au tăcut și au sărbătorit întoarcerea chivotului.","correct":false}]'::jsonb, 5, 2, '1 Samuel', ARRAY['5:11', '5:12']::text[], 'pending_review', 'Codex'),
  ('Ce două cetăți sunt menționate după plecarea chivotului din Asdod?', '[{"text":"Gat, unde domnitorii l-au trimis.","correct":true},{"text":"Ecron, unde a ajuns după aceea.","correct":true},{"text":"Silo, unde l-au dus domnitorii filistenilor.","correct":false}]'::jsonb, 5, 2, '1 Samuel', ARRAY['5:8', '5:10']::text[], 'pending_review', 'Codex'),
  ('Ce lucruri despre casa lui Dagon sunt menționate în capitol?', '[{"text":"Chivotul a fost așezat în ea, lângă Dagon.","correct":true},{"text":"Cei ce intrau în ea nu călcau pe prag.","correct":true},{"text":"Casa se afla în cetatea Gat.","correct":false}]'::jsonb, 5, 2, '1 Samuel', ARRAY['5:2', '5:5']::text[], 'pending_review', 'Codex'),
  ('Ce reacții ale locuitorilor sunt legate de sosirea sau prezența chivotului în cetățile filistenilor?', '[{"text":"Oamenii din Asdod au spus că chivotul nu trebuie să rămână la ei.","correct":true},{"text":"Ecroniții au strigat când chivotul a intrat în cetatea lor.","correct":true},{"text":"Locuitorii Gatului au cerut ca Dagon să fie dus la Silo.","correct":false}]'::jsonb, 5, 3, '1 Samuel', ARRAY['5:7', '5:10']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 5, ARRAY['5:1', '5:2', '5:8', '5:10']::text[], 'pending_review', '[{"left":"Locul de unde au luat filistenii chivotul","right":"Eben-Ezer"},{"left":"Prima cetate unde au dus chivotul","right":"Asdod"},{"left":"Locul unde l-au așezat în Asdod","right":"Casa lui Dagon"},{"left":"Cetatea aleasă apoi de domnitorii filistenilor","right":"Gat"},{"left":"Cetatea unde au trimis chivotul după Gat","right":"Ecron"}]'::jsonb),
  ('1 Samuel', 5, ARRAY['5:3', '5:4']::text[], 'pending_review', '[{"left":"Dimineața după așezarea chivotului lângă Dagon","right":"Dagon este găsit cu fața la pământ"},{"left":"După ce îl găsesc căzut","right":"Asdodenii îl pun înapoi la locul lui"},{"left":"Dimineața următoare","right":"Îl găsesc din nou căzut înaintea chivotului"},{"left":"Capul și mâinile lui Dagon","right":"Sunt tăiate pe prag"},{"left":"Ce îi mai rămăsese lui Dagon","right":"Trunchiul"}]'::jsonb),
  ('1 Samuel', 5, ARRAY['5:2', '5:5']::text[], 'pending_review', '[{"left":"Persoanele vizate de obiceiul pragului","right":"Preoții lui Dagon și toți cei ce intră"},{"left":"Casa în care a fost dus chivotul","right":"Casa lui Dagon"},{"left":"Cetatea în care se afla casa lui Dagon","right":"Asdod"},{"left":"Locul pe care nu îl calcă","right":"Pragul"},{"left":"Până când se ține obiceiul","right":"Până în ziua de azi"}]'::jsonb),
  ('1 Samuel', 5, ARRAY['5:6', '5:7']::text[], 'pending_review', '[{"left":"Asupra cui a apăsat mâna Domnului în Asdod","right":"Asdodenilor"},{"left":"Până unde a ajuns lovitura din Asdod","right":"În cetate și în ținutul ei"},{"left":"Cu ce au fost loviți oamenii","right":"Bube la șezut"},{"left":"Ce au cerut oamenii despre chivot","right":"Să nu rămână la ei"},{"left":"Asupra cui au spus că apăsa mâna Domnului, alături de ei","right":"Asupra lui Dagon"}]'::jsonb),
  ('1 Samuel', 5, ARRAY['5:8', '5:9']::text[], 'pending_review', '[{"left":"Pe cine au strâns oamenii din Asdod","right":"Pe domnitorii filistenilor"},{"left":"Ce i-au întrebat despre chivot","right":"Ce să facă cu el"},{"left":"Ce cetate au ales domnitorii","right":"Gat"},{"left":"Ce s-a întâmplat după aducerea chivotului acolo","right":"Mâna Domnului a apăsat asupra cetății"},{"left":"Starea care a cuprins cetatea","right":"O mare groază"}]'::jsonb),
  ('1 Samuel', 5, ARRAY['5:8', '5:9']::text[], 'pending_review', '[{"left":"Grupul de oameni lovit în Gat","right":"De la mic până la mare"},{"left":"Cum este descrisă groaza din Gat","right":"A fost o mare groază"},{"left":"Apariția pe care au avut-o oamenii","right":"O spuzeală de bube"},{"left":"Locul bubei menționat în text","right":"La șezut"},{"left":"Cetatea în care s-au petrecut acestea","right":"Gat"}]'::jsonb),
  ('1 Samuel', 5, ARRAY['5:10', '5:11']::text[], 'pending_review', '[{"left":"Chivotul intră în Ecron","right":"Ecroniții strigă"},{"left":"Ce cred ecroniții că li s-a adus","right":"Chivotul Dumnezeului lui Israel"},{"left":"Ce spun că li se va întâmpla","right":"Vor fi omorâți"},{"left":"Cine se tem ecroniții că va fi omorât alături de ei","right":"Poporul lor"},{"left":"Ce cereau domnitorii după aceea","right":"Trimiterea înapoi a chivotului"}]'::jsonb),
  ('1 Samuel', 5, ARRAY['5:11', '5:12']::text[], 'pending_review', '[{"left":"Ce s-a cerut să fie trimis înapoi","right":"Chivotul Dumnezeului lui Israel"},{"left":"Unde trebuia să se întoarcă","right":"La locul lui"},{"left":"Ce voiau să evite domnitorii","right":"Moartea lor și a poporului"},{"left":"Ce se simțea în toată cetatea","right":"O groază de moarte"},{"left":"Ce se întâmplă cu oamenii care nu mor","right":"Sunt loviți cu bube la șezut"}]'::jsonb),
  ('1 Samuel', 5, ARRAY['5:10', '5:11', '5:12']::text[], 'pending_review', '[{"left":"Ce au făcut ecroniții când chivotul a intrat în cetate","right":"Au strigat"},{"left":"Ce credeau ecroniții că le-a fost adus","right":"Chivotul Dumnezeului lui Israel"},{"left":"Ce au cerut domnitorii filistenilor să se facă cu chivotul","right":"Să fie trimis înapoi la locul lui"},{"left":"Cu ce erau loviți cei care nu mureau","right":"Cu bube la șezut"},{"left":"Până unde se înălțau țipetele cetății","right":"Până la cer"}]'::jsonb),
  ('1 Samuel', 5, ARRAY['5:1', '5:2', '5:5', '5:8', '5:10']::text[], 'pending_review', '[{"left":"Asdod","right":"Chivotul este dus acolo de la Eben-Ezer"},{"left":"Gat","right":"Domnitorii îl trimit acolo din Asdod"},{"left":"Ecron","right":"Chivotul este dus acolo după Gat"},{"left":"Casa lui Dagon","right":"Locul unde este pus chivotul la Asdod"},{"left":"Pragul casei lui Dagon","right":"Loc pe care cei ce intră nu-l calcă"}]'::jsonb)
) as incoming (book, chapter, source_references, status, pairs)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.pairs = incoming.pairs;

insert into public.questions_match (pairs, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.pairs, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('[{"left":"Locul de unde au luat filistenii chivotul","right":"Eben-Ezer"},{"left":"Prima cetate unde au dus chivotul","right":"Asdod"},{"left":"Locul unde l-au așezat în Asdod","right":"Casa lui Dagon"},{"left":"Cetatea aleasă apoi de domnitorii filistenilor","right":"Gat"},{"left":"Cetatea unde au trimis chivotul după Gat","right":"Ecron"}]'::jsonb, 5, 2, '1 Samuel', ARRAY['5:1', '5:2', '5:8', '5:10']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Dimineața după așezarea chivotului lângă Dagon","right":"Dagon este găsit cu fața la pământ"},{"left":"După ce îl găsesc căzut","right":"Asdodenii îl pun înapoi la locul lui"},{"left":"Dimineața următoare","right":"Îl găsesc din nou căzut înaintea chivotului"},{"left":"Capul și mâinile lui Dagon","right":"Sunt tăiate pe prag"},{"left":"Ce îi mai rămăsese lui Dagon","right":"Trunchiul"}]'::jsonb, 5, 3, '1 Samuel', ARRAY['5:3', '5:4']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Persoanele vizate de obiceiul pragului","right":"Preoții lui Dagon și toți cei ce intră"},{"left":"Casa în care a fost dus chivotul","right":"Casa lui Dagon"},{"left":"Cetatea în care se afla casa lui Dagon","right":"Asdod"},{"left":"Locul pe care nu îl calcă","right":"Pragul"},{"left":"Până când se ține obiceiul","right":"Până în ziua de azi"}]'::jsonb, 5, 3, '1 Samuel', ARRAY['5:2', '5:5']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Asupra cui a apăsat mâna Domnului în Asdod","right":"Asdodenilor"},{"left":"Până unde a ajuns lovitura din Asdod","right":"În cetate și în ținutul ei"},{"left":"Cu ce au fost loviți oamenii","right":"Bube la șezut"},{"left":"Ce au cerut oamenii despre chivot","right":"Să nu rămână la ei"},{"left":"Asupra cui au spus că apăsa mâna Domnului, alături de ei","right":"Asupra lui Dagon"}]'::jsonb, 5, 3, '1 Samuel', ARRAY['5:6', '5:7']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Pe cine au strâns oamenii din Asdod","right":"Pe domnitorii filistenilor"},{"left":"Ce i-au întrebat despre chivot","right":"Ce să facă cu el"},{"left":"Ce cetate au ales domnitorii","right":"Gat"},{"left":"Ce s-a întâmplat după aducerea chivotului acolo","right":"Mâna Domnului a apăsat asupra cetății"},{"left":"Starea care a cuprins cetatea","right":"O mare groază"}]'::jsonb, 5, 3, '1 Samuel', ARRAY['5:8', '5:9']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Grupul de oameni lovit în Gat","right":"De la mic până la mare"},{"left":"Cum este descrisă groaza din Gat","right":"A fost o mare groază"},{"left":"Apariția pe care au avut-o oamenii","right":"O spuzeală de bube"},{"left":"Locul bubei menționat în text","right":"La șezut"},{"left":"Cetatea în care s-au petrecut acestea","right":"Gat"}]'::jsonb, 5, 3, '1 Samuel', ARRAY['5:8', '5:9']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Chivotul intră în Ecron","right":"Ecroniții strigă"},{"left":"Ce cred ecroniții că li s-a adus","right":"Chivotul Dumnezeului lui Israel"},{"left":"Ce spun că li se va întâmpla","right":"Vor fi omorâți"},{"left":"Cine se tem ecroniții că va fi omorât alături de ei","right":"Poporul lor"},{"left":"Ce cereau domnitorii după aceea","right":"Trimiterea înapoi a chivotului"}]'::jsonb, 5, 3, '1 Samuel', ARRAY['5:10', '5:11']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Ce s-a cerut să fie trimis înapoi","right":"Chivotul Dumnezeului lui Israel"},{"left":"Unde trebuia să se întoarcă","right":"La locul lui"},{"left":"Ce voiau să evite domnitorii","right":"Moartea lor și a poporului"},{"left":"Ce se simțea în toată cetatea","right":"O groază de moarte"},{"left":"Ce se întâmplă cu oamenii care nu mor","right":"Sunt loviți cu bube la șezut"}]'::jsonb, 5, 3, '1 Samuel', ARRAY['5:11', '5:12']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Ce au făcut ecroniții când chivotul a intrat în cetate","right":"Au strigat"},{"left":"Ce credeau ecroniții că le-a fost adus","right":"Chivotul Dumnezeului lui Israel"},{"left":"Ce au cerut domnitorii filistenilor să se facă cu chivotul","right":"Să fie trimis înapoi la locul lui"},{"left":"Cu ce erau loviți cei care nu mureau","right":"Cu bube la șezut"},{"left":"Până unde se înălțau țipetele cetății","right":"Până la cer"}]'::jsonb, 5, 4, '1 Samuel', ARRAY['5:10', '5:11', '5:12']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Asdod","right":"Chivotul este dus acolo de la Eben-Ezer"},{"left":"Gat","right":"Domnitorii îl trimit acolo din Asdod"},{"left":"Ecron","right":"Chivotul este dus acolo după Gat"},{"left":"Casa lui Dagon","right":"Locul unde este pus chivotul la Asdod"},{"left":"Pragul casei lui Dagon","right":"Loc pe care cei ce intră nu-l calcă"}]'::jsonb, 5, 3, '1 Samuel', ARRAY['5:1', '5:2', '5:5', '5:8', '5:10']::text[], 'pending_review', 'Codex')
) as incoming (pairs, chapter, difficulty, book, source_references, status, added_by)
where not exists (
  select 1 from public.questions_match existing
  where existing.book = incoming.book
    and existing.chapter = incoming.chapter
    and existing.source_references = incoming.source_references
    and existing.pairs = incoming.pairs
);

commit;
