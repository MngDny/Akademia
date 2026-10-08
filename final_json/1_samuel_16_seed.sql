begin;

update public.questions_tf as existing
set status = incoming.status
from (values
  ('1 Samuel', 16, ARRAY['16:1']::text[], 'pending_review', 'Domnul l-a întrebat pe Samuel până când avea să-l plângă pe Saul, pe care îl lepădase ca să nu mai domnească peste Israel.'),
  ('1 Samuel', 16, ARRAY['16:1']::text[], 'pending_review', 'Domnul i-a spus lui Samuel să-și umple cornul cu untdelemn și să meargă la Isai Betleemitul, fiindcă alesese unul dintre fiii lui ca împărat.'),
  ('1 Samuel', 16, ARRAY['16:2']::text[], 'pending_review', 'Samuel i-a spus Domnului că Saul nu-l va putea ucide, așa că putea merge la Isai fără teamă.'),
  ('1 Samuel', 16, ARRAY['16:2']::text[], 'pending_review', 'Domnul i-a spus lui Samuel să ia un vițel și să spună că merge să aducă o jertfă Domnului.'),
  ('1 Samuel', 16, ARRAY['16:3']::text[], 'pending_review', 'Samuel trebuia să-l poftească pe Isai la jertfă, iar Domnul avea să-i arate pe cine să ungă.'),
  ('1 Samuel', 16, ARRAY['16:4']::text[], 'pending_review', 'Bătrânii Betleemului au alergat înspăimântați la Samuel și l-au întrebat dacă venirea lui vestește ceva bun.'),
  ('1 Samuel', 16, ARRAY['16:5']::text[], 'pending_review', 'Samuel le-a spus celor veniți să se sfințească și să vină la jertfă; i-a sfințit pe Isai și pe fiii lui și i-a poftit.'),
  ('1 Samuel', 16, ARRAY['16:6']::text[], 'pending_review', 'Văzându-l pe Eliab, Samuel s-a gândit că unsul Domnului era înaintea lui.'),
  ('1 Samuel', 16, ARRAY['16:7']::text[], 'pending_review', 'Domnul i-a spus lui Samuel că omul se uită la inimă, iar Domnul la înfățișare și înălțime.'),
  ('1 Samuel', 16, ARRAY['16:7']::text[], 'pending_review', 'Domnul i-a spus lui Samuel că El Se uită la inimă, în timp ce omul se uită la ceea ce izbește ochii.'),
  ('1 Samuel', 16, ARRAY['16:8']::text[], 'pending_review', 'Domnul l-a ales pe Abinadab, fiul trecut înaintea lui Samuel după Eliab.'),
  ('1 Samuel', 16, ARRAY['16:9']::text[], 'pending_review', 'Isai l-a trecut pe Șama înaintea lui Samuel, iar Samuel a spus că Domnul nici pe acesta nu-l alesese.'),
  ('1 Samuel', 16, ARRAY['16:10']::text[], 'pending_review', 'Isai a trecut pe dinaintea lui Samuel șapte fii ai săi, iar Samuel a spus că Domnul nu alesese pe niciunul dintre ei.'),
  ('1 Samuel', 16, ARRAY['16:11']::text[], 'pending_review', 'Cel mai tânăr fiu al lui Isai era la oi, iar Samuel a spus că nu vor ședea la masă până nu va veni.'),
  ('1 Samuel', 16, ARRAY['16:12']::text[], 'pending_review', 'David avea păr bălai, ochi frumoși și față frumoasă; Domnul i-a spus lui Samuel să se scoale și să-l ungă.'),
  ('1 Samuel', 16, ARRAY['16:13']::text[], 'pending_review', 'Samuel l-a uns pe David în mijlocul fraților lui, iar Duhul Domnului a venit peste David din ziua aceea.'),
  ('1 Samuel', 16, ARRAY['16:13']::text[], 'pending_review', 'După ce l-a uns pe David, Samuel s-a dus înapoi la Betleem.'),
  ('1 Samuel', 16, ARRAY['16:14', '16:15']::text[], 'pending_review', 'Duhul Domnului se depărtase de Saul și un duh rău îl muncea; slujitorii lui Saul i-au spus acest lucru.'),
  ('1 Samuel', 16, ARRAY['16:16', '16:17']::text[], 'pending_review', 'Slujitorii au propus să caute un om care știe să cânte la harpă, iar Saul le-a cerut să găsească un om care cântă bine și să-l aducă.'),
  ('1 Samuel', 16, ARRAY['16:22', '16:23']::text[], 'pending_review', 'Saul i-a cerut lui Isai să-l lase pe David în slujba sa; când duhul venea peste Saul, David cânta la harpă, iar Saul se simțea ușurat.')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_tf (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Domnul l-a întrebat pe Samuel până când avea să-l plângă pe Saul, pe care îl lepădase ca să nu mai domnească peste Israel.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:1']::text[], 'pending_review', 'Codex'),
  ('Domnul i-a spus lui Samuel să-și umple cornul cu untdelemn și să meargă la Isai Betleemitul, fiindcă alesese unul dintre fiii lui ca împărat.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:1']::text[], 'pending_review', 'Codex'),
  ('Samuel i-a spus Domnului că Saul nu-l va putea ucide, așa că putea merge la Isai fără teamă.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:2']::text[], 'pending_review', 'Codex'),
  ('Domnul i-a spus lui Samuel să ia un vițel și să spună că merge să aducă o jertfă Domnului.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:2']::text[], 'pending_review', 'Codex'),
  ('Samuel trebuia să-l poftească pe Isai la jertfă, iar Domnul avea să-i arate pe cine să ungă.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:3']::text[], 'pending_review', 'Codex'),
  ('Bătrânii Betleemului au alergat înspăimântați la Samuel și l-au întrebat dacă venirea lui vestește ceva bun.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:4']::text[], 'pending_review', 'Codex'),
  ('Samuel le-a spus celor veniți să se sfințească și să vină la jertfă; i-a sfințit pe Isai și pe fiii lui și i-a poftit.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:5']::text[], 'pending_review', 'Codex'),
  ('Văzându-l pe Eliab, Samuel s-a gândit că unsul Domnului era înaintea lui.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:6']::text[], 'pending_review', 'Codex'),
  ('Domnul i-a spus lui Samuel că omul se uită la inimă, iar Domnul la înfățișare și înălțime.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:7']::text[], 'pending_review', 'Codex'),
  ('Domnul i-a spus lui Samuel că El Se uită la inimă, în timp ce omul se uită la ceea ce izbește ochii.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:7']::text[], 'pending_review', 'Codex'),
  ('Domnul l-a ales pe Abinadab, fiul trecut înaintea lui Samuel după Eliab.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:8']::text[], 'pending_review', 'Codex'),
  ('Isai l-a trecut pe Șama înaintea lui Samuel, iar Samuel a spus că Domnul nici pe acesta nu-l alesese.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:9']::text[], 'pending_review', 'Codex'),
  ('Isai a trecut pe dinaintea lui Samuel șapte fii ai săi, iar Samuel a spus că Domnul nu alesese pe niciunul dintre ei.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:10']::text[], 'pending_review', 'Codex'),
  ('Cel mai tânăr fiu al lui Isai era la oi, iar Samuel a spus că nu vor ședea la masă până nu va veni.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:11']::text[], 'pending_review', 'Codex'),
  ('David avea păr bălai, ochi frumoși și față frumoasă; Domnul i-a spus lui Samuel să se scoale și să-l ungă.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:12']::text[], 'pending_review', 'Codex'),
  ('Samuel l-a uns pe David în mijlocul fraților lui, iar Duhul Domnului a venit peste David din ziua aceea.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:13']::text[], 'pending_review', 'Codex'),
  ('După ce l-a uns pe David, Samuel s-a dus înapoi la Betleem.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:13']::text[], 'pending_review', 'Codex'),
  ('Duhul Domnului se depărtase de Saul și un duh rău îl muncea; slujitorii lui Saul i-au spus acest lucru.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:14', '16:15']::text[], 'pending_review', 'Codex'),
  ('Slujitorii au propus să caute un om care știe să cânte la harpă, iar Saul le-a cerut să găsească un om care cântă bine și să-l aducă.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:16', '16:17']::text[], 'pending_review', 'Codex'),
  ('Saul i-a cerut lui Isai să-l lase pe David în slujba sa; când duhul venea peste Saul, David cânta la harpă, iar Saul se simțea ușurat.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:22', '16:23']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 16, ARRAY['16:1']::text[], 'pending_review', 'La cine i-a spus Domnul lui Samuel să meargă pentru a unge unul dintre fiii lui împărat?'),
  ('1 Samuel', 16, ARRAY['16:1']::text[], 'pending_review', 'Ce trebuia Samuel să-și umple cu untdelemn înainte de a pleca?'),
  ('1 Samuel', 16, ARRAY['16:2']::text[], 'pending_review', 'De ce s-a temut Samuel când Domnul l-a trimis la Isai?'),
  ('1 Samuel', 16, ARRAY['16:2']::text[], 'pending_review', 'Ce trebuia Samuel să ia cu el și să spună despre venirea sa?'),
  ('1 Samuel', 16, ARRAY['16:3']::text[], 'pending_review', 'Pe cine i-a spus Domnul lui Samuel să-l poftească la jertfă?'),
  ('1 Samuel', 16, ARRAY['16:4']::text[], 'pending_review', 'Ce i-au întrebat bătrânii Betleemului pe Samuel când au alergat înspăimântați înaintea lui?'),
  ('1 Samuel', 16, ARRAY['16:5']::text[], 'pending_review', 'Ce le-a cerut Samuel celor poftiți la jertfă?'),
  ('1 Samuel', 16, ARRAY['16:6']::text[], 'pending_review', 'Pe care fiu al lui Isai l-a văzut Samuel primul și l-a socotit, în gândul lui, unsul Domnului?'),
  ('1 Samuel', 16, ARRAY['16:7']::text[], 'pending_review', 'La ce a spus Domnul că Se uită El, în timp ce omul se uită la ceea ce izbește ochii?'),
  ('1 Samuel', 16, ARRAY['16:8']::text[], 'pending_review', 'Care fiu al lui Isai a fost trecut înaintea lui Samuel după Eliab?'),
  ('1 Samuel', 16, ARRAY['16:9']::text[], 'pending_review', 'Cum se numea fiul lui Isai trecut înaintea lui Samuel după Abinadab?'),
  ('1 Samuel', 16, ARRAY['16:10']::text[], 'pending_review', 'Câți dintre fiii lui Isai au trecut înaintea lui Samuel înainte ca acesta să întrebe dacă mai este vreunul?'),
  ('1 Samuel', 16, ARRAY['16:11']::text[], 'pending_review', 'Ce făcea fiul cel mai tânăr al lui Isai când ceilalți fuseseră aduși înaintea lui Samuel?'),
  ('1 Samuel', 16, ARRAY['16:11']::text[], 'pending_review', 'Până când a spus Samuel că nu se vor așeza la masă?'),
  ('1 Samuel', 16, ARRAY['16:12']::text[], 'pending_review', 'Ce trăsături ale lui David sunt menționate când a fost adus la Samuel?'),
  ('1 Samuel', 16, ARRAY['16:13']::text[], 'pending_review', 'În mijlocul cui l-a uns Samuel pe David?'),
  ('1 Samuel', 16, ARRAY['16:13']::text[], 'pending_review', 'Unde s-a dus Samuel după ce s-a sculat, după ungerea lui David?'),
  ('1 Samuel', 16, ARRAY['16:15']::text[], 'pending_review', 'Ce le-au spus slujitorii lui Saul că îl muncea?'),
  ('1 Samuel', 16, ARRAY['16:16']::text[], 'pending_review', 'Ce instrument au spus slujitorii că ar trebui să cânte omul căutat pentru Saul?'),
  ('1 Samuel', 16, ARRAY['16:18']::text[], 'pending_review', 'Cum l-a descris slujitorul pe fiul lui Isai din Betleem?')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_abc_one (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('La cine i-a spus Domnul lui Samuel să meargă pentru a unge unul dintre fiii lui împărat?', '[{"text":"La Isai Betleemitul","correct":true},{"text":"La Saul, la Ghibea","correct":false},{"text":"La Eliab, la Rama","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:1']::text[], 'pending_review', 'Codex'),
  ('Ce trebuia Samuel să-și umple cu untdelemn înainte de a pleca?', '[{"text":"Cornul","correct":true},{"text":"Un burduf","correct":false},{"text":"Un potir","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:1']::text[], 'pending_review', 'Codex'),
  ('De ce s-a temut Samuel când Domnul l-a trimis la Isai?', '[{"text":"Că Saul va afla și îl va ucide","correct":true},{"text":"Că Isai va refuza să-l primească","correct":false},{"text":"Că bătrânii din Betleem îl vor alunga","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:2']::text[], 'pending_review', 'Codex'),
  ('Ce trebuia Samuel să ia cu el și să spună despre venirea sa?', '[{"text":"Un vițel și că venea să aducă o jertfă Domnului","correct":true},{"text":"O oaie și că venea să-l întâlnească pe Saul","correct":false},{"text":"Un măgar și că venea să cumpere pâine","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:2']::text[], 'pending_review', 'Codex'),
  ('Pe cine i-a spus Domnul lui Samuel să-l poftească la jertfă?', '[{"text":"Pe Isai","correct":true},{"text":"Pe Saul","correct":false},{"text":"Pe Abinadab","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:3']::text[], 'pending_review', 'Codex'),
  ('Ce i-au întrebat bătrânii Betleemului pe Samuel când au alergat înspăimântați înaintea lui?', '[{"text":"Dacă venirea lui vestește ceva bun","correct":true},{"text":"Dacă a venit să-l ungă pe Saul","correct":false},{"text":"Dacă aduce vești despre amaleciți","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:4']::text[], 'pending_review', 'Codex'),
  ('Ce le-a cerut Samuel celor poftiți la jertfă?', '[{"text":"Să se sfințească și să vină cu el la jertfă","correct":true},{"text":"Să se întoarcă la casele lor și să aștepte","correct":false},{"text":"Să-l aleagă pe unul dintre fiii lui Isai","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:5']::text[], 'pending_review', 'Codex'),
  ('Pe care fiu al lui Isai l-a văzut Samuel primul și l-a socotit, în gândul lui, unsul Domnului?', '[{"text":"Pe Eliab","correct":true},{"text":"Pe Abinadab","correct":false},{"text":"Pe Șama","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:6']::text[], 'pending_review', 'Codex'),
  ('La ce a spus Domnul că Se uită El, în timp ce omul se uită la ceea ce izbește ochii?', '[{"text":"La inimă","correct":true},{"text":"La înălțimea staturii","correct":false},{"text":"La înfățișare","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:7']::text[], 'pending_review', 'Codex'),
  ('Care fiu al lui Isai a fost trecut înaintea lui Samuel după Eliab?', '[{"text":"Abinadab","correct":true},{"text":"Șama","correct":false},{"text":"David","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:8']::text[], 'pending_review', 'Codex'),
  ('Cum se numea fiul lui Isai trecut înaintea lui Samuel după Abinadab?', '[{"text":"Șama","correct":true},{"text":"Eliab","correct":false},{"text":"Ionatan","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:9']::text[], 'pending_review', 'Codex'),
  ('Câți dintre fiii lui Isai au trecut înaintea lui Samuel înainte ca acesta să întrebe dacă mai este vreunul?', '[{"text":"Șapte","correct":true},{"text":"Trei","correct":false},{"text":"Doisprezece","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:10']::text[], 'pending_review', 'Codex'),
  ('Ce făcea fiul cel mai tânăr al lui Isai când ceilalți fuseseră aduși înaintea lui Samuel?', '[{"text":"Păștea oile","correct":true},{"text":"Păzea poarta Betleemului","correct":false},{"text":"Pregătea jertfa","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:11']::text[], 'pending_review', 'Codex'),
  ('Până când a spus Samuel că nu se vor așeza la masă?', '[{"text":"Până când va veni cel mai tânăr fiu al lui Isai","correct":true},{"text":"Până când se va întoarce Saul din Ghibea","correct":false},{"text":"Până când vor sosi toți bătrânii cetății","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:11']::text[], 'pending_review', 'Codex'),
  ('Ce trăsături ale lui David sunt menționate când a fost adus la Samuel?', '[{"text":"Păr bălai, ochi frumoși și față frumoasă","correct":true},{"text":"Păr negru, statură înaltă și voce puternică","correct":false},{"text":"Ochi negri, barbă lungă și statură mică","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:12']::text[], 'pending_review', 'Codex'),
  ('În mijlocul cui l-a uns Samuel pe David?', '[{"text":"În mijlocul fraților lui","correct":true},{"text":"În mijlocul bătrânilor Betleemului","correct":false},{"text":"În mijlocul slujitorilor lui Saul","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:13']::text[], 'pending_review', 'Codex'),
  ('Unde s-a dus Samuel după ce s-a sculat, după ungerea lui David?', '[{"text":"La Rama","correct":true},{"text":"La Ghibea","correct":false},{"text":"La Carmel","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:13']::text[], 'pending_review', 'Codex'),
  ('Ce le-au spus slujitorii lui Saul că îl muncea?', '[{"text":"Un duh rău de la Dumnezeu","correct":true},{"text":"Duhul Domnului care venise peste David","correct":false},{"text":"O boală de la Betleem","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:15']::text[], 'pending_review', 'Codex'),
  ('Ce instrument au spus slujitorii că ar trebui să cânte omul căutat pentru Saul?', '[{"text":"Harpa","correct":true},{"text":"Trâmbița","correct":false},{"text":"Toba","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:16']::text[], 'pending_review', 'Codex'),
  ('Cum l-a descris slujitorul pe fiul lui Isai din Betleem?', '[{"text":"Știa să cânte, era tare și voinic, războinic, vorbea bine, era frumos la chip și Domnul era cu el","correct":true},{"text":"Era păstor, nu știa să cânte și se temea de Saul","correct":false},{"text":"Era preot la Silo, purta efodul și locuia la Rama","correct":false}]'::jsonb, 16, 3, '1 Samuel', ARRAY['16:18']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 16, ARRAY['16:1', '16:2', '16:3']::text[], 'pending_review', 'Ce indicații i-a dat Domnul lui Samuel pentru plecarea la Isai?'),
  ('1 Samuel', 16, ARRAY['16:4', '16:5', '16:6', '16:7']::text[], 'pending_review', 'Ce relatări sunt adevărate despre venirea lui Samuel la Betleem și despre cuvintele Domnului?'),
  ('1 Samuel', 16, ARRAY['16:8', '16:9', '16:10', '16:11', '16:12', '16:13']::text[], 'pending_review', 'Ce s-a întâmplat când Isai și-a adus fiii înaintea lui Samuel?'),
  ('1 Samuel', 16, ARRAY['16:14', '16:15', '16:16', '16:17', '16:18']::text[], 'pending_review', 'Ce afirmații corespund relatării despre starea lui Saul și despre sfatul slujitorilor?'),
  ('1 Samuel', 16, ARRAY['16:19', '16:20']::text[], 'pending_review', 'Ce detalii sunt date despre chemarea lui David și lucrurile trimise de Isai?'),
  ('1 Samuel', 16, ARRAY['16:21', '16:22', '16:23']::text[], 'pending_review', 'Ce s-a întâmplat după ce David a ajuns la Saul?')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_abc_multi (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Ce indicații i-a dat Domnul lui Samuel pentru plecarea la Isai?', '[{"text":"Să meargă la Isai, betleemitul, și să-l ungă pe cel pe care Domnul i-l va arăta.","correct":true},{"text":"Să ia un vițel, să spună că merge la jertfă și să-l poftească pe Isai.","correct":true},{"text":"Să meargă la Saul și să-l roage să-l aleagă pe David.","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:1', '16:2', '16:3']::text[], 'pending_review', 'Codex'),
  ('Ce relatări sunt adevărate despre venirea lui Samuel la Betleem și despre cuvintele Domnului?', '[{"text":"Bătrânii au alergat înspăimântați și l-au întrebat dacă venirea lui vestește ceva bun.","correct":true},{"text":"Domnul i-a spus lui Samuel că Se uită la inimă, nu la ceea ce izbește ochii.","correct":true},{"text":"Domnul i-a spus lui Samuel să-l ungă pe Eliab pentru că era înalt.","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:4', '16:5', '16:6', '16:7']::text[], 'pending_review', 'Codex'),
  ('Ce s-a întâmplat când Isai și-a adus fiii înaintea lui Samuel?', '[{"text":"După ce au trecut șapte fii, Samuel a spus că Domnul nu alesese pe niciunul dintre ei.","correct":true},{"text":"Cel mai tânăr era la oi; după ce a fost adus, Samuel l-a uns în mijlocul fraților lui, iar Duhul Domnului a venit peste el.","correct":true},{"text":"Samuel l-a uns pe Abinadab, iar David a fost lăsat să păzească oile.","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:8', '16:9', '16:10', '16:11', '16:12', '16:13']::text[], 'pending_review', 'Codex'),
  ('Ce afirmații corespund relatării despre starea lui Saul și despre sfatul slujitorilor?', '[{"text":"Duhul Domnului se depărtase de Saul, iar slujitorii au spus că un duh rău de la Dumnezeu îl muncea.","correct":true},{"text":"Slujitorii au propus să fie căutat un om care știa să cânte la harpă; unul dintre ei l-a descris pe David ca fiu al lui Isai din Betleem.","correct":true},{"text":"Slujitorii i-au spus lui Saul să meargă el însuși la Betleem și să-l ungă pe Eliab.","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:14', '16:15', '16:16', '16:17', '16:18']::text[], 'pending_review', 'Codex'),
  ('Ce detalii sunt date despre chemarea lui David și lucrurile trimise de Isai?', '[{"text":"Saul a trimis oameni la Isai să-i trimită pe fiul său David, care era cu oile.","correct":true},{"text":"Isai a trimis prin David un măgar cu pâine, un burduf cu vin și un ied.","correct":true},{"text":"Isai i-a trimis lui Saul șapte oi și un corn cu untdelemn prin Samuel.","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:19', '16:20']::text[], 'pending_review', 'Codex'),
  ('Ce s-a întâmplat după ce David a ajuns la Saul?', '[{"text":"Saul l-a plăcut mult pe David și l-a pus să-i poarte armele; apoi i-a cerut lui Isai să-l lase în slujba lui.","correct":true},{"text":"Când David cânta la harpă, Saul se simțea ușurat, iar duhul rău pleca de la el.","correct":true},{"text":"Saul l-a trimis pe David înapoi la oi și i-a interzis să mai cânte la harpă.","correct":false}]'::jsonb, 16, 2, '1 Samuel', ARRAY['16:21', '16:22', '16:23']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 16, ARRAY['16:1', '16:2', '16:3', '16:4', '16:5', '16:6', '16:7']::text[], 'pending_review', '[{"left":"Misiunea lui Samuel","right":"Să ungă împărat pe unul dintre fiii lui Isai"},{"left":"Temerea lui Samuel","right":"Saul ar putea afla și l-ar putea ucide"},{"left":"Ce trebuia să ia Samuel","right":"Un vițel pentru jertfă"},{"left":"Reacția bătrânilor din Betleem","right":"Au alergat înspăimântați și l-au întrebat dacă venirea lui vestește ceva bun"},{"left":"La ce Se uită Domnul","right":"La inimă"}]'::jsonb),
  ('1 Samuel', 16, ARRAY['16:8', '16:9', '16:10', '16:11', '16:12', '16:13', '16:21', '16:22', '16:23']::text[], 'pending_review', '[{"left":"Eliab","right":"Primul fiu văzut de Samuel, socotit de el ca unsul Domnului"},{"left":"Abinadab și Șama","right":"Fii pe care Domnul nu i-a ales"},{"left":"Cel mai tânăr fiu al lui Isai","right":"Păștea oile când Samuel a întrebat dacă mai este vreunul"},{"left":"Slujba lui David la Saul","right":"A fost pus să-i poarte armele"},{"left":"Cântatul la harpă al lui David","right":"Saul se simțea ușurat și duhul rău pleca de la el"}]'::jsonb)
) as incoming (book, chapter, source_references, status, pairs)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.pairs = incoming.pairs;

insert into public.questions_match (pairs, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.pairs, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('[{"left":"Misiunea lui Samuel","right":"Să ungă împărat pe unul dintre fiii lui Isai"},{"left":"Temerea lui Samuel","right":"Saul ar putea afla și l-ar putea ucide"},{"left":"Ce trebuia să ia Samuel","right":"Un vițel pentru jertfă"},{"left":"Reacția bătrânilor din Betleem","right":"Au alergat înspăimântați și l-au întrebat dacă venirea lui vestește ceva bun"},{"left":"La ce Se uită Domnul","right":"La inimă"}]'::jsonb, 16, 3, '1 Samuel', ARRAY['16:1', '16:2', '16:3', '16:4', '16:5', '16:6', '16:7']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Eliab","right":"Primul fiu văzut de Samuel, socotit de el ca unsul Domnului"},{"left":"Abinadab și Șama","right":"Fii pe care Domnul nu i-a ales"},{"left":"Cel mai tânăr fiu al lui Isai","right":"Păștea oile când Samuel a întrebat dacă mai este vreunul"},{"left":"Slujba lui David la Saul","right":"A fost pus să-i poarte armele"},{"left":"Cântatul la harpă al lui David","right":"Saul se simțea ușurat și duhul rău pleca de la el"}]'::jsonb, 16, 3, '1 Samuel', ARRAY['16:8', '16:9', '16:10', '16:11', '16:12', '16:13', '16:21', '16:22', '16:23']::text[], 'pending_review', 'Codex')
) as incoming (pairs, chapter, difficulty, book, source_references, status, added_by)
where not exists (
  select 1 from public.questions_match existing
  where existing.book = incoming.book
    and existing.chapter = incoming.chapter
    and existing.source_references = incoming.source_references
    and existing.pairs = incoming.pairs
);

commit;
