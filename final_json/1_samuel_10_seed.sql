begin;

alter table public.questions_tf add column if not exists source_references text[] not null default '{}';

alter table public.questions_abc_one add column if not exists source_references text[] not null default '{}';

alter table public.questions_abc_multi add column if not exists source_references text[] not null default '{}';

alter table public.questions_match add column if not exists source_references text[] not null default '{}';

update public.questions_tf as existing
set status = incoming.status
from (values
  ('1 Samuel', 10, ARRAY['10:1']::text[], 'pending_review', 'Samuel a luat sticluța cu untdelemn și a turnat-o pe capul lui Saul.'),
  ('1 Samuel', 10, ARRAY['10:1']::text[], 'pending_review', 'După ce l-a uns pe Saul, Samuel l-a sărutat și i-a spus că Domnul îl unsese căpetenie a moștenirii Lui.'),
  ('1 Samuel', 10, ARRAY['10:2']::text[], 'pending_review', 'Saul urma să întâlnească doi oameni la mormântul Rahelei, în hotarul lui Beniamin, la Țelțah.'),
  ('1 Samuel', 10, ARRAY['10:2']::text[], 'pending_review', 'Cei doi oameni aveau să-i spună lui Saul că măgărițele nu fuseseră găsite și că tatăl lui era îngrijorat.'),
  ('1 Samuel', 10, ARRAY['10:2']::text[], 'pending_review', 'Tatăl lui Saul nu se mai gândea la măgărițe, ci era îngrijorat pentru Saul și întreba ce să facă pentru fiul lui.'),
  ('1 Samuel', 10, ARRAY['10:3']::text[], 'pending_review', 'La stejarul din Tabor, Saul urma să întâlnească trei oameni care se suiau la Dumnezeu, în Betel.'),
  ('1 Samuel', 10, ARRAY['10:3']::text[], 'pending_review', 'Unul dintre cei trei oameni ducea trei iezi, altul trei turte de pâine, iar al treilea un burduf cu vin.'),
  ('1 Samuel', 10, ARRAY['10:3', '10:4']::text[], 'pending_review', 'Cei trei oameni urmau să-i dea lui Saul un singur burduf cu vin.'),
  ('1 Samuel', 10, ARRAY['10:4']::text[], 'pending_review', 'Cei trei oameni urmau să-l întrebe pe Saul de sănătate și să-i dea două pâini.'),
  ('1 Samuel', 10, ARRAY['10:5']::text[], 'pending_review', 'La Ghibea Elohim se afla o garnizoană a filistenilor.'),
  ('1 Samuel', 10, ARRAY['10:5']::text[], 'pending_review', 'Când Saul intra în cetate, urma să întâlnească o ceată de proroci coborând de pe înălțimea pentru jertfă.'),
  ('1 Samuel', 10, ARRAY['10:5']::text[], 'pending_review', 'Prorocii întâlniți la Ghibea Elohim aveau înainte lăute, timpane, fluiere și cobze și proroceau.'),
  ('1 Samuel', 10, ARRAY['10:6']::text[], 'pending_review', 'Duhul Domnului urma să vină peste Saul, iar Saul urma să prorocească și să fie prefăcut într-alt om.'),
  ('1 Samuel', 10, ARRAY['10:8']::text[], 'pending_review', 'Samuel i-a spus lui Saul să aștepte o zi la Ghilgal până să ajungă el.'),
  ('1 Samuel', 10, ARRAY['10:8']::text[], 'pending_review', 'Samuel i-a spus lui Saul să aștepte șapte zile la Ghilgal până va ajunge el.'),
  ('1 Samuel', 10, ARRAY['10:7']::text[], 'pending_review', 'După împlinirea semnelor, Samuel i-a spus lui Saul să facă ce găsește de făcut, fiindcă Dumnezeu este cu el.'),
  ('1 Samuel', 10, ARRAY['10:9']::text[], 'pending_review', 'Când Saul s-a întors ca să se despartă de Samuel, Dumnezeu i-a dat o altă inimă, iar semnele s-au împlinit în aceeași zi.'),
  ('1 Samuel', 10, ARRAY['10:10']::text[], 'pending_review', 'La Ghibea, Duhul lui Dumnezeu a venit peste Saul și el a prorocit în mijlocul cetei de proroci.'),
  ('1 Samuel', 10, ARRAY['10:11']::text[], 'pending_review', 'Cei care îl cunoscuseră pe Saul s-au întrebat dacă și el era între proroci.'),
  ('1 Samuel', 10, ARRAY['10:13']::text[], 'pending_review', 'După ce a sfârșit de prorocit, Saul s-a dus la mormântul Rahelei.'),
  ('1 Samuel', 10, ARRAY['10:14']::text[], 'pending_review', 'Saul i-a spus unchiului său că el și sluga plecaseră să caute măgărițele și apoi se duseseră la Samuel.'),
  ('1 Samuel', 10, ARRAY['10:15', '10:16']::text[], 'pending_review', 'Când unchiul i-a cerut să-i spună ce i-a zis Samuel, Saul i-a povestit și despre împărăție.'),
  ('1 Samuel', 10, ARRAY['10:16']::text[], 'pending_review', 'Saul i-a spus unchiului că Samuel le zisese că măgărițele s-au găsit, dar nu i-a spus nimic despre împărăție.'),
  ('1 Samuel', 10, ARRAY['10:17']::text[], 'pending_review', 'Samuel a chemat poporul înaintea Domnului la Mițpa.'),
  ('1 Samuel', 10, ARRAY['10:18']::text[], 'pending_review', 'Samuel le-a amintit israeliților că Domnul îi scosese din Egipt și îi izbăvise din mâna egiptenilor și a împărățiilor care-i apăsau.'),
  ('1 Samuel', 10, ARRAY['10:19']::text[], 'pending_review', 'Samuel le-a spus că, cerând un împărat, israeliții Îl lepădau pe Dumnezeul care îi izbăvise.'),
  ('1 Samuel', 10, ARRAY['10:20']::text[], 'pending_review', 'La alegerea prin sorți, seminția aleasă a fost cea a lui Beniamin.'),
  ('1 Samuel', 10, ARRAY['10:21']::text[], 'pending_review', 'Din seminția lui Beniamin a ieșit la sorți familia lui Matri, apoi Saul, fiul lui Chis.'),
  ('1 Samuel', 10, ARRAY['10:21', '10:22']::text[], 'pending_review', 'Când Saul a fost căutat după alegerea prin sorți, poporul l-a găsit imediat în mijlocul adunării.'),
  ('1 Samuel', 10, ARRAY['10:22']::text[], 'pending_review', 'Saul era ascuns între vase când poporul a întrebat pe Domnul unde era.'),
  ('1 Samuel', 10, ARRAY['10:23']::text[], 'pending_review', 'Când a fost adus înaintea poporului, Saul îi întrecea pe toți în înălțime de la umăr în sus.'),
  ('1 Samuel', 10, ARRAY['10:24']::text[], 'pending_review', 'Samuel a spus că nu era nimeni în tot poporul ca omul ales de Domnul, iar poporul a strigat: «Trăiască împăratul!»'),
  ('1 Samuel', 10, ARRAY['10:25']::text[], 'pending_review', 'Samuel a scris dreptul împărăției într-o carte și a pus cartea înaintea Domnului.'),
  ('1 Samuel', 10, ARRAY['10:26']::text[], 'pending_review', 'Saul s-a dus acasă în Ghibea, însoțit de o parte dintre ostași a căror inimă o mișcase Dumnezeu.'),
  ('1 Samuel', 10, ARRAY['10:27']::text[], 'pending_review', 'Oamenii răi care l-au disprețuit pe Saul i-au adus daruri, iar Saul le-a mulțumit.'),
  ('1 Samuel', 10, ARRAY['10:27']::text[], 'pending_review', 'Saul s-a făcut că nu-i auzea pe oamenii care îl disprețuiau.')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_tf (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Samuel a luat sticluța cu untdelemn și a turnat-o pe capul lui Saul.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 10, 1, '1 Samuel', ARRAY['10:1']::text[], 'pending_review', 'Codex'),
  ('După ce l-a uns pe Saul, Samuel l-a sărutat și i-a spus că Domnul îl unsese căpetenie a moștenirii Lui.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:1']::text[], 'pending_review', 'Codex'),
  ('Saul urma să întâlnească doi oameni la mormântul Rahelei, în hotarul lui Beniamin, la Țelțah.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:2']::text[], 'pending_review', 'Codex'),
  ('Cei doi oameni aveau să-i spună lui Saul că măgărițele nu fuseseră găsite și că tatăl lui era îngrijorat.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:2']::text[], 'pending_review', 'Codex'),
  ('Tatăl lui Saul nu se mai gândea la măgărițe, ci era îngrijorat pentru Saul și întreba ce să facă pentru fiul lui.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:2']::text[], 'pending_review', 'Codex'),
  ('La stejarul din Tabor, Saul urma să întâlnească trei oameni care se suiau la Dumnezeu, în Betel.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:3']::text[], 'pending_review', 'Codex'),
  ('Unul dintre cei trei oameni ducea trei iezi, altul trei turte de pâine, iar al treilea un burduf cu vin.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 10, 1, '1 Samuel', ARRAY['10:3']::text[], 'pending_review', 'Codex'),
  ('Cei trei oameni urmau să-i dea lui Saul un singur burduf cu vin.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:3', '10:4']::text[], 'pending_review', 'Codex'),
  ('Cei trei oameni urmau să-l întrebe pe Saul de sănătate și să-i dea două pâini.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:4']::text[], 'pending_review', 'Codex'),
  ('La Ghibea Elohim se afla o garnizoană a filistenilor.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 10, 1, '1 Samuel', ARRAY['10:5']::text[], 'pending_review', 'Codex'),
  ('Când Saul intra în cetate, urma să întâlnească o ceată de proroci coborând de pe înălțimea pentru jertfă.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:5']::text[], 'pending_review', 'Codex'),
  ('Prorocii întâlniți la Ghibea Elohim aveau înainte lăute, timpane, fluiere și cobze și proroceau.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:5']::text[], 'pending_review', 'Codex'),
  ('Duhul Domnului urma să vină peste Saul, iar Saul urma să prorocească și să fie prefăcut într-alt om.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:6']::text[], 'pending_review', 'Codex'),
  ('Samuel i-a spus lui Saul să aștepte o zi la Ghilgal până să ajungă el.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:8']::text[], 'pending_review', 'Codex'),
  ('Samuel i-a spus lui Saul să aștepte șapte zile la Ghilgal până va ajunge el.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:8']::text[], 'pending_review', 'Codex'),
  ('După împlinirea semnelor, Samuel i-a spus lui Saul să facă ce găsește de făcut, fiindcă Dumnezeu este cu el.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:7']::text[], 'pending_review', 'Codex'),
  ('Când Saul s-a întors ca să se despartă de Samuel, Dumnezeu i-a dat o altă inimă, iar semnele s-au împlinit în aceeași zi.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 10, 3, '1 Samuel', ARRAY['10:9']::text[], 'pending_review', 'Codex'),
  ('La Ghibea, Duhul lui Dumnezeu a venit peste Saul și el a prorocit în mijlocul cetei de proroci.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:10']::text[], 'pending_review', 'Codex'),
  ('Cei care îl cunoscuseră pe Saul s-au întrebat dacă și el era între proroci.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 10, 1, '1 Samuel', ARRAY['10:11']::text[], 'pending_review', 'Codex'),
  ('După ce a sfârșit de prorocit, Saul s-a dus la mormântul Rahelei.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:13']::text[], 'pending_review', 'Codex'),
  ('Saul i-a spus unchiului său că el și sluga plecaseră să caute măgărițele și apoi se duseseră la Samuel.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:14']::text[], 'pending_review', 'Codex'),
  ('Când unchiul i-a cerut să-i spună ce i-a zis Samuel, Saul i-a povestit și despre împărăție.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:15', '10:16']::text[], 'pending_review', 'Codex'),
  ('Saul i-a spus unchiului că Samuel le zisese că măgărițele s-au găsit, dar nu i-a spus nimic despre împărăție.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:16']::text[], 'pending_review', 'Codex'),
  ('Samuel a chemat poporul înaintea Domnului la Mițpa.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 10, 1, '1 Samuel', ARRAY['10:17']::text[], 'pending_review', 'Codex'),
  ('Samuel le-a amintit israeliților că Domnul îi scosese din Egipt și îi izbăvise din mâna egiptenilor și a împărățiilor care-i apăsau.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:18']::text[], 'pending_review', 'Codex'),
  ('Samuel le-a spus că, cerând un împărat, israeliții Îl lepădau pe Dumnezeul care îi izbăvise.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:19']::text[], 'pending_review', 'Codex'),
  ('La alegerea prin sorți, seminția aleasă a fost cea a lui Beniamin.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 10, 1, '1 Samuel', ARRAY['10:20']::text[], 'pending_review', 'Codex'),
  ('Din seminția lui Beniamin a ieșit la sorți familia lui Matri, apoi Saul, fiul lui Chis.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:21']::text[], 'pending_review', 'Codex'),
  ('Când Saul a fost căutat după alegerea prin sorți, poporul l-a găsit imediat în mijlocul adunării.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:21', '10:22']::text[], 'pending_review', 'Codex'),
  ('Saul era ascuns între vase când poporul a întrebat pe Domnul unde era.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:22']::text[], 'pending_review', 'Codex'),
  ('Când a fost adus înaintea poporului, Saul îi întrecea pe toți în înălțime de la umăr în sus.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:23']::text[], 'pending_review', 'Codex'),
  ('Samuel a spus că nu era nimeni în tot poporul ca omul ales de Domnul, iar poporul a strigat: «Trăiască împăratul!»', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:24']::text[], 'pending_review', 'Codex'),
  ('Samuel a scris dreptul împărăției într-o carte și a pus cartea înaintea Domnului.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:25']::text[], 'pending_review', 'Codex'),
  ('Saul s-a dus acasă în Ghibea, însoțit de o parte dintre ostași a căror inimă o mișcase Dumnezeu.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:26']::text[], 'pending_review', 'Codex'),
  ('Oamenii răi care l-au disprețuit pe Saul i-au adus daruri, iar Saul le-a mulțumit.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:27']::text[], 'pending_review', 'Codex'),
  ('Saul s-a făcut că nu-i auzea pe oamenii care îl disprețuiau.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 10, 1, '1 Samuel', ARRAY['10:27']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 10, ARRAY['10:1']::text[], 'pending_review', 'Cu ce a uns Samuel capul lui Saul?'),
  ('1 Samuel', 10, ARRAY['10:1']::text[], 'pending_review', 'Ce i-a spus Samuel lui Saul după ce l-a uns?'),
  ('1 Samuel', 10, ARRAY['10:2']::text[], 'pending_review', 'Unde urma Saul să întâlnească doi oameni care îi vor da vești despre măgărițe?'),
  ('1 Samuel', 10, ARRAY['10:2']::text[], 'pending_review', 'Ce veste urmau să-i dea cei doi oameni lui Saul?'),
  ('1 Samuel', 10, ARRAY['10:3']::text[], 'pending_review', 'Unde urma Saul să ajungă după întâlnirea cu cei doi oameni de la Țelțah?'),
  ('1 Samuel', 10, ARRAY['10:3']::text[], 'pending_review', 'Câți oameni urma Saul să întâlnească la stejarul din Tabor?'),
  ('1 Samuel', 10, ARRAY['10:3']::text[], 'pending_review', 'Ce ducea unul dintre cei trei oameni întâlniți la stejarul din Tabor?'),
  ('1 Samuel', 10, ARRAY['10:4']::text[], 'pending_review', 'Ce urmau să-i dea cei trei oameni lui Saul după ce îl întrebau de sănătate?'),
  ('1 Samuel', 10, ARRAY['10:5']::text[], 'pending_review', 'Ce se afla la Ghibea Elohim, potrivit semnului vestit de Samuel?'),
  ('1 Samuel', 10, ARRAY['10:5']::text[], 'pending_review', 'Ce instrumente urmau să aibă înainte prorocii întâlniți de Saul la Ghibea Elohim?'),
  ('1 Samuel', 10, ARRAY['10:6']::text[], 'pending_review', 'Ce urma să se întâmple cu Saul când Duhul Domnului venea peste el?'),
  ('1 Samuel', 10, ARRAY['10:8']::text[], 'pending_review', 'Câte zile trebuia Saul să-l aștepte pe Samuel la Ghilgal?'),
  ('1 Samuel', 10, ARRAY['10:9']::text[], 'pending_review', 'Ce s-a întâmplat cu semnele vestite lui Saul după ce a plecat de la Samuel?'),
  ('1 Samuel', 10, ARRAY['10:10']::text[], 'pending_review', 'Unde se afla Saul când i-a ieșit înainte o ceată de proroci, iar el a prorocit cu ei?'),
  ('1 Samuel', 10, ARRAY['10:11']::text[], 'pending_review', 'Ce întrebare își puneau cei care îl cunoscuseră pe Saul când l-au văzut prorocind?'),
  ('1 Samuel', 10, ARRAY['10:13']::text[], 'pending_review', 'Ce s-a dus Saul să facă după ce a sfârșit de prorocit?'),
  ('1 Samuel', 10, ARRAY['10:14']::text[], 'pending_review', 'Ce l-a întrebat unchiul lui Saul pe Saul și pe sluga lui?'),
  ('1 Samuel', 10, ARRAY['10:16']::text[], 'pending_review', 'Ce i-a spus Saul unchiului despre ce îi zisese Samuel?'),
  ('1 Samuel', 10, ARRAY['10:17']::text[], 'pending_review', 'Unde a chemat Samuel poporul înaintea Domnului?'),
  ('1 Samuel', 10, ARRAY['10:20']::text[], 'pending_review', 'Ce seminție a ieșit la sorți când Samuel a apropiat semințiile lui Israel?'),
  ('1 Samuel', 10, ARRAY['10:21']::text[], 'pending_review', 'Ce familie a ieșit la sorți din seminția lui Beniamin?'),
  ('1 Samuel', 10, ARRAY['10:22']::text[], 'pending_review', 'Unde a fost găsit Saul după ce poporul a întrebat pe Domnul?'),
  ('1 Samuel', 10, ARRAY['10:24']::text[], 'pending_review', 'Ce a spus Samuel despre omul ales de Domnul când Saul a fost adus înaintea poporului?'),
  ('1 Samuel', 10, ARRAY['10:25']::text[], 'pending_review', 'Ce a făcut Samuel cu dreptul împărăției după ce l-a făcut cunoscut poporului?'),
  ('1 Samuel', 10, ARRAY['10:26']::text[], 'pending_review', 'Unde s-a dus Saul acasă după ce a fost ales?'),
  ('1 Samuel', 10, ARRAY['10:27']::text[], 'pending_review', 'Cum a răspuns Saul oamenilor răi care l-au disprețuit și nu i-au adus dar?')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_abc_one (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Cu ce a uns Samuel capul lui Saul?', '[{"text":"Cu untdelemn dintr-o sticluță","correct":true},{"text":"Cu apă dintr-un burduf","correct":false},{"text":"Cu vin dintr-un vas","correct":false}]'::jsonb, 10, 1, '1 Samuel', ARRAY['10:1']::text[], 'pending_review', 'Codex'),
  ('Ce i-a spus Samuel lui Saul după ce l-a uns?', '[{"text":"Că Domnul îl unsese să fie căpetenia moștenirii Lui","correct":true},{"text":"Că urma să păzească chivotul la Chiriat-Iearim","correct":false},{"text":"Că urma să judece la Beer-Șeba","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:1']::text[], 'pending_review', 'Codex'),
  ('Unde urma Saul să întâlnească doi oameni care îi vor da vești despre măgărițe?', '[{"text":"La mormântul Rahelei, în hotarul lui Beniamin, la Țelțah","correct":true},{"text":"La stejarul din Tabor, în țara lui Efraim","correct":false},{"text":"La poarta cetății Ghibea","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:2']::text[], 'pending_review', 'Codex'),
  ('Ce veste urmau să-i dea cei doi oameni lui Saul?', '[{"text":"Că măgărițele s-au găsit și tatăl lui este îngrijorat pentru ei","correct":true},{"text":"Că măgărițele au fost vândute la Betel","correct":false},{"text":"Că tatăl lui a plecat la Ghilgal","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:2']::text[], 'pending_review', 'Codex'),
  ('Unde urma Saul să ajungă după întâlnirea cu cei doi oameni de la Țelțah?', '[{"text":"La stejarul din Tabor","correct":true},{"text":"La Mițpa","correct":false},{"text":"La mormântul lui Samuel","correct":false}]'::jsonb, 10, 1, '1 Samuel', ARRAY['10:3']::text[], 'pending_review', 'Codex'),
  ('Câți oameni urma Saul să întâlnească la stejarul din Tabor?', '[{"text":"Trei","correct":true},{"text":"Doi","correct":false},{"text":"Șapte","correct":false}]'::jsonb, 10, 1, '1 Samuel', ARRAY['10:3']::text[], 'pending_review', 'Codex'),
  ('Ce ducea unul dintre cei trei oameni întâlniți la stejarul din Tabor?', '[{"text":"Trei iezi","correct":true},{"text":"Trei pâini","correct":false},{"text":"Un burduf cu vin","correct":false}]'::jsonb, 10, 1, '1 Samuel', ARRAY['10:3']::text[], 'pending_review', 'Codex'),
  ('Ce urmau să-i dea cei trei oameni lui Saul după ce îl întrebau de sănătate?', '[{"text":"Două pâini","correct":true},{"text":"Trei iezi","correct":false},{"text":"Un burduf cu vin","correct":false}]'::jsonb, 10, 1, '1 Samuel', ARRAY['10:4']::text[], 'pending_review', 'Codex'),
  ('Ce se afla la Ghibea Elohim, potrivit semnului vestit de Samuel?', '[{"text":"Garnizoana filistenilor","correct":true},{"text":"Casa lui Samuel","correct":false},{"text":"Mormântul Rahelei","correct":false}]'::jsonb, 10, 1, '1 Samuel', ARRAY['10:5']::text[], 'pending_review', 'Codex'),
  ('Ce instrumente urmau să aibă înainte prorocii întâlniți de Saul la Ghibea Elohim?', '[{"text":"Lăute, timpane, fluiere și cobze","correct":true},{"text":"Trâmbițe, chimvale și harpe","correct":false},{"text":"Lăute, scuturi și săbii","correct":false}]'::jsonb, 10, 1, '1 Samuel', ARRAY['10:5']::text[], 'pending_review', 'Codex'),
  ('Ce urma să se întâmple cu Saul când Duhul Domnului venea peste el?', '[{"text":"Avea să prorocească și să fie prefăcut într-alt om","correct":true},{"text":"Avea să se ascundă între vase","correct":false},{"text":"Avea să se întoarcă la tatăl său","correct":false}]'::jsonb, 10, 1, '1 Samuel', ARRAY['10:6']::text[], 'pending_review', 'Codex'),
  ('Câte zile trebuia Saul să-l aștepte pe Samuel la Ghilgal?', '[{"text":"Șapte zile","correct":true},{"text":"Trei zile","correct":false},{"text":"O zi","correct":false}]'::jsonb, 10, 1, '1 Samuel', ARRAY['10:8']::text[], 'pending_review', 'Codex'),
  ('Ce s-a întâmplat cu semnele vestite lui Saul după ce a plecat de la Samuel?', '[{"text":"S-au împlinit în aceeași zi","correct":true},{"text":"S-au împlinit după șapte zile","correct":false},{"text":"Nu s-au împlinit","correct":false}]'::jsonb, 10, 1, '1 Samuel', ARRAY['10:9']::text[], 'pending_review', 'Codex'),
  ('Unde se afla Saul când i-a ieșit înainte o ceată de proroci, iar el a prorocit cu ei?', '[{"text":"La Ghibea","correct":true},{"text":"La Mițpa","correct":false},{"text":"La Betel","correct":false}]'::jsonb, 10, 1, '1 Samuel', ARRAY['10:10']::text[], 'pending_review', 'Codex'),
  ('Ce întrebare își puneau cei care îl cunoscuseră pe Saul când l-au văzut prorocind?', '[{"text":"„Oare și Saul este între proroci?”","correct":true},{"text":"„Oare a găsit Saul măgărițele?”","correct":false},{"text":"„Oare Samuel va domni peste Israel?”","correct":false}]'::jsonb, 10, 1, '1 Samuel', ARRAY['10:11']::text[], 'pending_review', 'Codex'),
  ('Ce s-a dus Saul să facă după ce a sfârșit de prorocit?', '[{"text":"S-a dus pe înălțime","correct":true},{"text":"S-a dus la mormântul Rahelei","correct":false},{"text":"S-a întors la casa lui Chis","correct":false}]'::jsonb, 10, 1, '1 Samuel', ARRAY['10:13']::text[], 'pending_review', 'Codex'),
  ('Ce l-a întrebat unchiul lui Saul pe Saul și pe sluga lui?', '[{"text":"Unde se duseseră","correct":true},{"text":"Câte pâini primiseră","correct":false},{"text":"De ce merseseră la Mițpa","correct":false}]'::jsonb, 10, 1, '1 Samuel', ARRAY['10:14']::text[], 'pending_review', 'Codex'),
  ('Ce i-a spus Saul unchiului despre ce îi zisese Samuel?', '[{"text":"Că măgărițele s-au găsit","correct":true},{"text":"Că el urma să fie împărat","correct":false},{"text":"Că trebuie să aștepte șapte zile la Ghilgal","correct":false}]'::jsonb, 10, 1, '1 Samuel', ARRAY['10:16']::text[], 'pending_review', 'Codex'),
  ('Unde a chemat Samuel poporul înaintea Domnului?', '[{"text":"La Mițpa","correct":true},{"text":"La Ghilgal","correct":false},{"text":"La Ghibea","correct":false}]'::jsonb, 10, 1, '1 Samuel', ARRAY['10:17']::text[], 'pending_review', 'Codex'),
  ('Ce seminție a ieșit la sorți când Samuel a apropiat semințiile lui Israel?', '[{"text":"Beniamin","correct":true},{"text":"Efraim","correct":false},{"text":"Iuda","correct":false}]'::jsonb, 10, 1, '1 Samuel', ARRAY['10:20']::text[], 'pending_review', 'Codex'),
  ('Ce familie a ieșit la sorți din seminția lui Beniamin?', '[{"text":"Familia lui Matri","correct":true},{"text":"Familia lui Chis","correct":false},{"text":"Familia lui Abiel","correct":false}]'::jsonb, 10, 1, '1 Samuel', ARRAY['10:21']::text[], 'pending_review', 'Codex'),
  ('Unde a fost găsit Saul după ce poporul a întrebat pe Domnul?', '[{"text":"Ascuns între vase","correct":true},{"text":"La mormântul Rahelei","correct":false},{"text":"Pe înălțimea de la Betel","correct":false}]'::jsonb, 10, 1, '1 Samuel', ARRAY['10:22']::text[], 'pending_review', 'Codex'),
  ('Ce a spus Samuel despre omul ales de Domnul când Saul a fost adus înaintea poporului?', '[{"text":"Că nu era nimeni în tot poporul ca el","correct":true},{"text":"Că era cel mai mic dintre toți în înălțime","correct":false},{"text":"Că va judeca doar la Beer-Șeba","correct":false}]'::jsonb, 10, 1, '1 Samuel', ARRAY['10:24']::text[], 'pending_review', 'Codex'),
  ('Ce a făcut Samuel cu dreptul împărăției după ce l-a făcut cunoscut poporului?', '[{"text":"L-a scris într-o carte și a pus cartea înaintea Domnului","correct":true},{"text":"L-a dat lui Saul să-l ducă la Ghibea","correct":false},{"text":"L-a trimis bătrânilor din Israel la Mițpa","correct":false}]'::jsonb, 10, 1, '1 Samuel', ARRAY['10:25']::text[], 'pending_review', 'Codex'),
  ('Unde s-a dus Saul acasă după ce a fost ales?', '[{"text":"La Ghibea","correct":true},{"text":"La Rama","correct":false},{"text":"La Betel","correct":false}]'::jsonb, 10, 1, '1 Samuel', ARRAY['10:26']::text[], 'pending_review', 'Codex'),
  ('Cum a răspuns Saul oamenilor răi care l-au disprețuit și nu i-au adus dar?', '[{"text":"S-a făcut că nu-i aude","correct":true},{"text":"I-a alungat din cetate","correct":false},{"text":"Le-a cerut să plece la Mițpa","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:27']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 10, ARRAY['10:1']::text[], 'pending_review', 'Ce i-a făcut Samuel lui Saul și ce i-a spus după ungere?'),
  ('1 Samuel', 10, ARRAY['10:2']::text[], 'pending_review', 'Ce li se va întâmpla lui Saul și tatălui său potrivit veștii celor doi oameni de la Țelțah?'),
  ('1 Samuel', 10, ARRAY['10:3']::text[], 'pending_review', 'Ce detalii despre cei trei oameni de la stejarul din Tabor i-a spus Samuel lui Saul?'),
  ('1 Samuel', 10, ARRAY['10:4']::text[], 'pending_review', 'Ce aveau să facă cei trei oameni după ce îl întâlneau pe Saul?'),
  ('1 Samuel', 10, ARRAY['10:5']::text[], 'pending_review', 'Ce semne urma Saul să întâlnească la Ghibea Elohim?'),
  ('1 Samuel', 10, ARRAY['10:5']::text[], 'pending_review', 'Ce instrumente sunt numite în relatarea despre ceata de proroci?'),
  ('1 Samuel', 10, ARRAY['10:6']::text[], 'pending_review', 'Ce i-a spus Samuel lui Saul că se va întâmpla când Duhul Domnului va veni peste el?'),
  ('1 Samuel', 10, ARRAY['10:7', '10:8']::text[], 'pending_review', 'Ce instrucțiuni i-a dat Samuel lui Saul după ce i-a vorbit despre semne?'),
  ('1 Samuel', 10, ARRAY['10:9']::text[], 'pending_review', 'Ce s-a întâmplat după ce Saul s-a despărțit de Samuel?'),
  ('1 Samuel', 10, ARRAY['10:10', '10:11']::text[], 'pending_review', 'Ce au văzut cei care îl cunoscuseră pe Saul când a prorocit la Ghibea?'),
  ('1 Samuel', 10, ARRAY['10:11', '10:12']::text[], 'pending_review', 'Ce s-a spus în legătură cu întrebarea dacă Saul era între proroci?'),
  ('1 Samuel', 10, ARRAY['10:14', '10:16']::text[], 'pending_review', 'Ce i-a spus Saul unchiului său despre călătoria lui?'),
  ('1 Samuel', 10, ARRAY['10:17', '10:18']::text[], 'pending_review', 'Ce a făcut Samuel înaintea poporului la Mițpa?'),
  ('1 Samuel', 10, ARRAY['10:19']::text[], 'pending_review', 'Ce le-a spus Samuel israeliților despre cererea lor de a avea împărat?'),
  ('1 Samuel', 10, ARRAY['10:20', '10:21']::text[], 'pending_review', 'Cum s-a desfășurat alegerea prin sorți relatată în capitol?'),
  ('1 Samuel', 10, ARRAY['10:21', '10:22']::text[], 'pending_review', 'Ce s-a întâmplat când Saul a ieșit la sorți?'),
  ('1 Samuel', 10, ARRAY['10:22', '10:23']::text[], 'pending_review', 'Ce detalii sunt date când Saul a fost adus înaintea poporului?'),
  ('1 Samuel', 10, ARRAY['10:24']::text[], 'pending_review', 'Cum a reacționat poporul după ce Samuel l-a arătat pe Saul, ales de Domnul?'),
  ('1 Samuel', 10, ARRAY['10:25']::text[], 'pending_review', 'Ce a făcut Samuel cu dreptul împărăției?'),
  ('1 Samuel', 10, ARRAY['10:26']::text[], 'pending_review', 'Ce spune capitolul despre întoarcerea lui Saul acasă și oamenii care l-au însoțit?'),
  ('1 Samuel', 10, ARRAY['10:27']::text[], 'pending_review', 'Cum au reacționat oamenii răi la alegerea lui Saul și cum a răspuns el?'),
  ('1 Samuel', 10, ARRAY['10:2', '10:3', '10:4']::text[], 'pending_review', 'Ce semne vestite de Samuel sunt legate de locuri diferite?'),
  ('1 Samuel', 10, ARRAY['10:7', '10:8']::text[], 'pending_review', 'Ce instrucțiuni și încurajări i-a dat Samuel lui Saul pentru ceea ce urma să facă?'),
  ('1 Samuel', 10, ARRAY['10:26', '10:27']::text[], 'pending_review', 'Ce contraste sunt consemnate după alegerea lui Saul?')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_abc_multi (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Ce i-a făcut Samuel lui Saul și ce i-a spus după ungere?', '[{"text":"A turnat untdelemn pe capul lui Saul.","correct":true},{"text":"I-a spus că Domnul îl unsese căpetenie a moștenirii Lui.","correct":true},{"text":"L-a uns să fie judecător la Beer-Șeba și i-a dat un burduf cu vin.","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:1']::text[], 'pending_review', 'Codex'),
  ('Ce li se va întâmpla lui Saul și tatălui său potrivit veștii celor doi oameni de la Țelțah?', '[{"text":"Saul va afla că măgărițele s-au găsit.","correct":true},{"text":"Va afla că tatăl lui este îngrijorat pentru el și sluga lui.","correct":true},{"text":"Tatăl lui va veni la mormântul Rahelei să-l ducă la Ghilgal.","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:2']::text[], 'pending_review', 'Codex'),
  ('Ce detalii despre cei trei oameni de la stejarul din Tabor i-a spus Samuel lui Saul?', '[{"text":"Ei se suiau la Dumnezeu, în Betel.","correct":true},{"text":"Unul ducea trei iezi, iar altul trei turte de pâine.","correct":true},{"text":"Toți trei duceau untdelemn pentru ungerea lui Saul.","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:3']::text[], 'pending_review', 'Codex'),
  ('Ce aveau să facă cei trei oameni după ce îl întâlneau pe Saul?', '[{"text":"Îl întrebau de sănătate.","correct":true},{"text":"Îi dădeau două pâini pe care să le ia din mâna lor.","correct":true},{"text":"Îl trimiteau la casa lui Chis fără să-i vorbească.","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:4']::text[], 'pending_review', 'Codex'),
  ('Ce semne urma Saul să întâlnească la Ghibea Elohim?', '[{"text":"Acolo se afla o garnizoană a filistenilor.","correct":true},{"text":"O ceată de proroci cobora de pe înălțimea pentru jertfă.","correct":true},{"text":"Samuel îl aștepta singur la poarta cetății cu măgărițele.","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:5']::text[], 'pending_review', 'Codex'),
  ('Ce instrumente sunt numite în relatarea despre ceata de proroci?', '[{"text":"Lăute și timpane.","correct":true},{"text":"Fluiere și cobze.","correct":true},{"text":"Săbii și scuturi.","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:5']::text[], 'pending_review', 'Codex'),
  ('Ce i-a spus Samuel lui Saul că se va întâmpla când Duhul Domnului va veni peste el?', '[{"text":"Va proroci împreună cu prorocii.","correct":true},{"text":"Va fi prefăcut într-alt om.","correct":true},{"text":"Va uita unde se află Ghilgal și se va întoarce la tatăl său.","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:6']::text[], 'pending_review', 'Codex'),
  ('Ce instrucțiuni i-a dat Samuel lui Saul după ce i-a vorbit despre semne?', '[{"text":"Să facă ce va găsi de făcut când se vor împlini semnele.","correct":true},{"text":"Să coboare înaintea lui la Ghilgal și să-l aștepte șapte zile.","correct":true},{"text":"Să rămână la mormântul Rahelei până când va ajunge Samuel.","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:7', '10:8']::text[], 'pending_review', 'Codex'),
  ('Ce s-a întâmplat după ce Saul s-a despărțit de Samuel?', '[{"text":"Dumnezeu i-a dat o altă inimă.","correct":true},{"text":"Toate semnele s-au împlinit în aceeași zi.","correct":true},{"text":"Saul a fost găsit ascuns între vase la Mițpa.","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:9']::text[], 'pending_review', 'Codex'),
  ('Ce au văzut cei care îl cunoscuseră pe Saul când a prorocit la Ghibea?', '[{"text":"Că prorocea împreună cu ceata de proroci.","correct":true},{"text":"Au întrebat dacă și Saul era între proroci.","correct":true},{"text":"Că Samuel îl unsese deja în mijlocul mulțimii.","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:10', '10:11']::text[], 'pending_review', 'Codex'),
  ('Ce s-a spus în legătură cu întrebarea dacă Saul era între proroci?', '[{"text":"Cineva din Ghibea a întrebat: „Și cine este tatăl lor?”","correct":true},{"text":"De acolo a rămas zicala: „Oare și Saul este între proroci?”","correct":true},{"text":"Saul a răspuns că tatăl lui era Samuel.","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:11', '10:12']::text[], 'pending_review', 'Codex'),
  ('Ce i-a spus Saul unchiului său despre călătoria lui?', '[{"text":"El și sluga căutaseră măgărițele.","correct":true},{"text":"După ce nu le-au găsit, s-au dus la Samuel.","correct":true},{"text":"Samuel le spusese să se ducă la Mițpa să aleagă un împărat.","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:14', '10:16']::text[], 'pending_review', 'Codex'),
  ('Ce a făcut Samuel înaintea poporului la Mițpa?', '[{"text":"A chemat poporul înaintea Domnului.","correct":true},{"text":"Le-a amintit că Domnul îi scosese din Egipt și îi izbăvise de împărățiile care-i apăsau.","correct":true},{"text":"A cerut ca poporul să se întoarcă la Ghibea Elohim.","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:17', '10:18']::text[], 'pending_review', 'Codex'),
  ('Ce le-a spus Samuel israeliților despre cererea lor de a avea împărat?', '[{"text":"Îl lepădau pe Dumnezeul care îi izbăvise din toate relele și suferințele.","correct":true},{"text":"Îi cereau lui Dumnezeu să pună un împărat peste ei.","correct":true},{"text":"Îi mulțumeau Domnului că nu-i izbăvise din mâna egiptenilor.","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:19']::text[], 'pending_review', 'Codex'),
  ('Cum s-a desfășurat alegerea prin sorți relatată în capitol?', '[{"text":"A fost aleasă mai întâi seminția lui Beniamin.","correct":true},{"text":"Din ea a ieșit familia lui Matri, apoi Saul, fiul lui Chis.","correct":true},{"text":"A fost aleasă mai întâi seminția lui Iuda, apoi familia lui Samuel.","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:20', '10:21']::text[], 'pending_review', 'Codex'),
  ('Ce s-a întâmplat când Saul a ieșit la sorți?', '[{"text":"L-au căutat și nu l-au găsit.","correct":true},{"text":"Domnul a spus că era ascuns între vase.","correct":true},{"text":"Saul s-a prezentat imediat de bunăvoie în mijlocul poporului.","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:21', '10:22']::text[], 'pending_review', 'Codex'),
  ('Ce detalii sunt date când Saul a fost adus înaintea poporului?', '[{"text":"A fost scos din locul unde se ascunsese.","correct":true},{"text":"Îi întrecea pe toți în înălțime de la umăr în sus.","correct":true},{"text":"Era mai scund decât ceilalți bărbați ai lui Israel.","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:22', '10:23']::text[], 'pending_review', 'Codex'),
  ('Cum a reacționat poporul după ce Samuel l-a arătat pe Saul, ales de Domnul?', '[{"text":"Samuel a spus că nu era nimeni în tot poporul ca el.","correct":true},{"text":"Poporul a strigat: „Trăiască împăratul!”","correct":true},{"text":"Poporul a refuzat să-l primească și s-a întors la Mițpa.","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:24']::text[], 'pending_review', 'Codex'),
  ('Ce a făcut Samuel cu dreptul împărăției?', '[{"text":"L-a făcut cunoscut poporului.","correct":true},{"text":"L-a scris într-o carte și a pus cartea înaintea Domnului.","correct":true},{"text":"L-a dat unchiului lui Saul să-l păstreze la Ghibea.","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:25']::text[], 'pending_review', 'Codex'),
  ('Ce spune capitolul despre întoarcerea lui Saul acasă și oamenii care l-au însoțit?', '[{"text":"Saul s-a dus acasă în Ghibea.","correct":true},{"text":"O parte dintre ostași l-au însoțit, fiindcă Dumnezeu le mișcase inima.","correct":true},{"text":"Toți ostașii lui Israel au refuzat să meargă cu el.","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:26']::text[], 'pending_review', 'Codex'),
  ('Cum au reacționat oamenii răi la alegerea lui Saul și cum a răspuns el?', '[{"text":"L-au disprețuit și au întrebat ce îi putea ajuta acesta.","correct":true},{"text":"Nu i-au adus niciun dar, iar Saul s-a făcut că nu-i aude.","correct":true},{"text":"I-au adus daruri, iar Saul i-a alungat.","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:27']::text[], 'pending_review', 'Codex'),
  ('Ce semne vestite de Samuel sunt legate de locuri diferite?', '[{"text":"La mormântul Rahelei, doi oameni îi spun lui Saul că măgărițele s-au găsit.","correct":true},{"text":"La stejarul din Tabor, trei oameni îi dau două pâini.","correct":true},{"text":"La Ghibea, trei oameni îl ung cu untdelemn.","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:2', '10:3', '10:4']::text[], 'pending_review', 'Codex'),
  ('Ce instrucțiuni și încurajări i-a dat Samuel lui Saul pentru ceea ce urma să facă?', '[{"text":"Să facă ce va găsi de făcut când se împlinesc semnele, fiindcă Dumnezeu este cu el.","correct":true},{"text":"Să-l aștepte la Ghilgal șapte zile până când Samuel ajunge și-i spune ce să facă.","correct":true},{"text":"Să se întoarcă imediat acasă și să nu mai vină la Ghilgal.","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:7', '10:8']::text[], 'pending_review', 'Codex'),
  ('Ce contraste sunt consemnate după alegerea lui Saul?', '[{"text":"Unii ostași l-au însoțit acasă, cu inima mișcată de Dumnezeu.","correct":true},{"text":"Unii oameni răi l-au disprețuit și nu i-au adus niciun dar.","correct":true},{"text":"Toți oamenii din Israel l-au disprețuit și au refuzat să-l urmeze.","correct":false}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:26', '10:27']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 10, ARRAY['10:1', '10:2']::text[], 'pending_review', '[{"left":"Ce a turnat Samuel pe capul lui Saul","right":"Untdelemn"},{"left":"Ce a făcut Samuel după ungere","right":"L-a sărutat"},{"left":"Rolul pentru care l-a uns Domnul","right":"Căpetenia moștenirii Lui"},{"left":"Câți oameni urma Saul să întâlnească la Țelțah","right":"Doi"},{"left":"Locul întâlnirii","right":"Mormântul Rahelei, în hotarul lui Beniamin"}]'::jsonb),
  ('1 Samuel', 10, ARRAY['10:2', '10:3', '10:4']::text[], 'pending_review', '[{"left":"Ce veste primea Saul la Țelțah","right":"Măgărițele s-au găsit"},{"left":"Cine era îngrijorat pentru Saul și sluga lui","right":"Tatăl lui Saul"},{"left":"Următorul reper după întâlnirea de la Țelțah","right":"Stejarul din Tabor"},{"left":"Câți oameni îl întâlneau la stejar","right":"Trei"},{"left":"Ce primea Saul din mâna lor","right":"Două pâini"}]'::jsonb),
  ('1 Samuel', 10, ARRAY['10:3', '10:4']::text[], 'pending_review', '[{"left":"Unde se suiau cei trei oameni","right":"La Dumnezeu, în Betel"},{"left":"Ce ducea unul dintre ei","right":"Trei iezi"},{"left":"Ce ducea altul","right":"Trei turte de pâine"},{"left":"Ce ducea al treilea","right":"Un burduf cu vin"},{"left":"Ce făceau înainte să-i dea pâinile","right":"Îl întrebau de sănătate"}]'::jsonb),
  ('1 Samuel', 10, ARRAY['10:5', '10:6', '10:10']::text[], 'pending_review', '[{"left":"Locul unde se afla garnizoana filistenilor","right":"Ghibea Elohim"},{"left":"Cine cobora de pe înălțimea pentru jertfă","right":"O ceată de proroci"},{"left":"Instrumente purtate înaintea prorocilor","right":"Lăute și timpane"},{"left":"Ce a venit peste Saul la Ghibea","right":"Duhul Domnului / al lui Dumnezeu"},{"left":"Ce a făcut Saul în mijlocul lor","right":"A prorocit"}]'::jsonb),
  ('1 Samuel', 10, ARRAY['10:5', '10:6']::text[], 'pending_review', '[{"left":"Un instrument folosit de proroci","right":"Fluier"},{"left":"Alt instrument folosit de proroci","right":"Cobză"},{"left":"Locul de unde coborau prorocii","right":"Înălțimea pentru jertfă"},{"left":"Ce urma să facă Saul cu prorocii","right":"Să prorocească împreună cu ei"},{"left":"Cum urma să fie Saul după venirea Duhului","right":"Prefăcut într-alt om"}]'::jsonb),
  ('1 Samuel', 10, ARRAY['10:7', '10:8', '10:9']::text[], 'pending_review', '[{"left":"Ce trebuia Saul să facă după împlinirea semnelor","right":"Ce va găsi de făcut"},{"left":"De ce putea să facă acest lucru","right":"Dumnezeu era cu el"},{"left":"Unde trebuia Saul să-l aștepte pe Samuel","right":"La Ghilgal"},{"left":"Câte zile trebuia să aștepte","right":"Șapte zile"},{"left":"Când s-au împlinit semnele vestite","right":"În aceeași zi"}]'::jsonb),
  ('1 Samuel', 10, ARRAY['10:9', '10:10', '10:11']::text[], 'pending_review', '[{"left":"Ce i-a dat Dumnezeu lui Saul după ce s-a despărțit de Samuel","right":"O altă inimă"},{"left":"Unde a prorocit Saul cu ceata de proroci","right":"La Ghibea"},{"left":"Cine a venit peste Saul acolo","right":"Duhul lui Dumnezeu"},{"left":"Ce au văzut cei care îl cunoșteau","right":"Că prorocea cu prorocii"},{"left":"Ce întrebare au pus oamenii","right":"„Oare și Saul este între proroci?”"}]'::jsonb),
  ('1 Samuel', 10, ARRAY['10:11', '10:12', '10:13']::text[], 'pending_review', '[{"left":"Cine l-a văzut pe Saul prorocind cu prorocii?","right":"Toți cei ce-l cunoscuseră mai înainte"},{"left":"Ce întrebare și-au pus unii despre Saul?","right":"„Oare și Saul este între proroci?”"},{"left":"Cine a pus întrebarea „Și cine este tatăl lor?”","right":"Cineva din Ghibea"},{"left":"Ce întrebare a pus cineva din Ghibea?","right":"„Și cine este tatăl lor?”"},{"left":"Unde s-a dus Saul după ce a sfârșit de prorocit?","right":"Pe înălțime"}]'::jsonb),
  ('1 Samuel', 10, ARRAY['10:14', '10:15', '10:16']::text[], 'pending_review', '[{"left":"Cine l-a întrebat pe Saul unde se dusese","right":"Unchiul lui Saul"},{"left":"Ce căutaseră Saul și sluga","right":"Măgărițele"},{"left":"Unde s-au dus după ce nu le-au găsit","right":"La Samuel"},{"left":"Ce a cerut unchiul să-i povestească","right":"Ce le spusese Samuel"},{"left":"Ce veste i-a spus Saul unchiului","right":"Că măgărițele s-au găsit"}]'::jsonb),
  ('1 Samuel', 10, ARRAY['10:16', '10:17', '10:18', '10:19']::text[], 'pending_review', '[{"left":"Ce nu i-a spus Saul unchiului său","right":"Despre împărăția despre care vorbise Samuel"},{"left":"Unde a chemat Samuel poporul","right":"La Mițpa"},{"left":"Înaintea cui a strâns Samuel poporul","right":"Înaintea Domnului"},{"left":"Din ce țară spusese Domnul că a scos Israelul","right":"Egipt"},{"left":"Cine îi izbăvise pe israeliți","right":"Domnul Dumnezeul lui Israel"}]'::jsonb),
  ('1 Samuel', 10, ARRAY['10:18', '10:19']::text[], 'pending_review', '[{"left":"Din mâna cui i-a izbăvit Domnul","right":"A egiptenilor"},{"left":"Și din mâna cui i-a mai izbăvit","right":"A împărățiilor care îi apăsau"},{"left":"Pe cine lepădau israeliții prin cererea lor","right":"Pe Dumnezeul care îi izbăvise"},{"left":"Ce conducător cereau","right":"Un împărat"},{"left":"Cum trebuiau să se înfățișeze înaintea Domnului","right":"După seminții și miile lor"}]'::jsonb),
  ('1 Samuel', 10, ARRAY['10:20', '10:21']::text[], 'pending_review', '[{"left":"Ce a apropiat Samuel pentru alegerea prin sorți","right":"Toate semințiile lui Israel"},{"left":"Ce seminție a ieșit la sorți","right":"Beniamin"},{"left":"Ce a apropiat apoi Samuel","right":"Familiile seminției lui Beniamin"},{"left":"Ce familie a ieșit la sorți","right":"Matri"},{"left":"Cine a ieșit în cele din urmă la sorți","right":"Saul, fiul lui Chis"}]'::jsonb),
  ('1 Samuel', 10, ARRAY['10:21', '10:22', '10:23']::text[], 'pending_review', '[{"left":"Ce au făcut după ce Saul a ieșit la sorți","right":"L-au căutat, dar nu l-au găsit"},{"left":"Pe cine au întrebat din nou","right":"Pe Domnul"},{"left":"Unde a spus Domnul că se afla Saul","right":"Ascuns între vase"},{"left":"Ce au făcut oamenii după răspuns","right":"Au alergat și l-au scos"},{"left":"Cum era Saul în înălțime față de ceilalți","right":"Îi întrecea de la umăr în sus"}]'::jsonb),
  ('1 Samuel', 10, ARRAY['10:22', '10:23', '10:24']::text[], 'pending_review', '[{"left":"Unde era ascuns Saul","right":"Între vase"},{"left":"Unde l-au adus după ce l-au scos","right":"În mijlocul poporului"},{"left":"Ce a spus Samuel despre omul ales","right":"Nu era nimeni în popor ca el"},{"left":"Cine îl alesese pe Saul","right":"Domnul"},{"left":"Ce a strigat poporul","right":"„Trăiască împăratul!”"}]'::jsonb),
  ('1 Samuel', 10, ARRAY['10:24', '10:25']::text[], 'pending_review', '[{"left":"Ce a spus Samuel despre omul ales","right":"Nu era nimeni în popor ca el"},{"left":"Ce a spus poporul după aceea","right":"„Trăiască împăratul!”"},{"left":"Ce a făcut Samuel cunoscut poporului","right":"Dreptul împărăției"},{"left":"Unde a scris Samuel dreptul împărăției","right":"Într-o carte"},{"left":"Unde a pus cartea","right":"Înaintea Domnului"}]'::jsonb),
  ('1 Samuel', 10, ARRAY['10:25', '10:26', '10:27']::text[], 'pending_review', '[{"left":"Ce a făcut Samuel după ce a scris dreptul împărăției","right":"A dat drumul poporului"},{"left":"Unde s-a dus Saul acasă","right":"În Ghibea"},{"left":"Cine l-a însoțit pe Saul","right":"O parte dintre ostași"},{"left":"Cine le mișcase inima ostașilor","right":"Dumnezeu"},{"left":"Cum a răspuns Saul disprețuitorilor","right":"S-a făcut că nu-i aude"}]'::jsonb),
  ('1 Samuel', 10, ARRAY['10:1', '10:2', '10:3', '10:4', '10:5', '10:6']::text[], 'pending_review', '[{"left":"Cum a fost uns Saul","right":"Samuel i-a turnat untdelemn pe cap"},{"left":"Ce urma să-i spună doi oameni la Țelțah","right":"Măgărițele s-au găsit"},{"left":"Ce primea Saul de la trei oameni la stejarul din Tabor","right":"Două pâini"},{"left":"Unde se afla garnizoana filistenilor","right":"La Ghibea Elohim"},{"left":"Ce se întâmpla cu Saul când venea Duhul Domnului","right":"Prorocea și era prefăcut într-alt om"}]'::jsonb),
  ('1 Samuel', 10, ARRAY['10:17', '10:18', '10:19', '10:20', '10:21', '10:22', '10:23', '10:24']::text[], 'pending_review', '[{"left":"Unde a strâns Samuel poporul","right":"La Mițpa"},{"left":"Ce a amintit Samuel că făcuse Domnul pentru Israel","right":"Îl scosese din Egipt și îl izbăvise"},{"left":"Ce a cerut poporul deși îl lepăda pe Dumnezeul lui","right":"Un împărat"},{"left":"Ce seminție a ieșit la sorți","right":"Beniamin"},{"left":"Unde a fost găsit Saul","right":"Ascuns între vase"}]'::jsonb)
) as incoming (book, chapter, source_references, status, pairs)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.pairs = incoming.pairs;

insert into public.questions_match (pairs, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.pairs, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('[{"left":"Ce a turnat Samuel pe capul lui Saul","right":"Untdelemn"},{"left":"Ce a făcut Samuel după ungere","right":"L-a sărutat"},{"left":"Rolul pentru care l-a uns Domnul","right":"Căpetenia moștenirii Lui"},{"left":"Câți oameni urma Saul să întâlnească la Țelțah","right":"Doi"},{"left":"Locul întâlnirii","right":"Mormântul Rahelei, în hotarul lui Beniamin"}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:1', '10:2']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Ce veste primea Saul la Țelțah","right":"Măgărițele s-au găsit"},{"left":"Cine era îngrijorat pentru Saul și sluga lui","right":"Tatăl lui Saul"},{"left":"Următorul reper după întâlnirea de la Țelțah","right":"Stejarul din Tabor"},{"left":"Câți oameni îl întâlneau la stejar","right":"Trei"},{"left":"Ce primea Saul din mâna lor","right":"Două pâini"}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:2', '10:3', '10:4']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Unde se suiau cei trei oameni","right":"La Dumnezeu, în Betel"},{"left":"Ce ducea unul dintre ei","right":"Trei iezi"},{"left":"Ce ducea altul","right":"Trei turte de pâine"},{"left":"Ce ducea al treilea","right":"Un burduf cu vin"},{"left":"Ce făceau înainte să-i dea pâinile","right":"Îl întrebau de sănătate"}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:3', '10:4']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Locul unde se afla garnizoana filistenilor","right":"Ghibea Elohim"},{"left":"Cine cobora de pe înălțimea pentru jertfă","right":"O ceată de proroci"},{"left":"Instrumente purtate înaintea prorocilor","right":"Lăute și timpane"},{"left":"Ce a venit peste Saul la Ghibea","right":"Duhul Domnului / al lui Dumnezeu"},{"left":"Ce a făcut Saul în mijlocul lor","right":"A prorocit"}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:5', '10:6', '10:10']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Un instrument folosit de proroci","right":"Fluier"},{"left":"Alt instrument folosit de proroci","right":"Cobză"},{"left":"Locul de unde coborau prorocii","right":"Înălțimea pentru jertfă"},{"left":"Ce urma să facă Saul cu prorocii","right":"Să prorocească împreună cu ei"},{"left":"Cum urma să fie Saul după venirea Duhului","right":"Prefăcut într-alt om"}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:5', '10:6']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Ce trebuia Saul să facă după împlinirea semnelor","right":"Ce va găsi de făcut"},{"left":"De ce putea să facă acest lucru","right":"Dumnezeu era cu el"},{"left":"Unde trebuia Saul să-l aștepte pe Samuel","right":"La Ghilgal"},{"left":"Câte zile trebuia să aștepte","right":"Șapte zile"},{"left":"Când s-au împlinit semnele vestite","right":"În aceeași zi"}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:7', '10:8', '10:9']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Ce i-a dat Dumnezeu lui Saul după ce s-a despărțit de Samuel","right":"O altă inimă"},{"left":"Unde a prorocit Saul cu ceata de proroci","right":"La Ghibea"},{"left":"Cine a venit peste Saul acolo","right":"Duhul lui Dumnezeu"},{"left":"Ce au văzut cei care îl cunoșteau","right":"Că prorocea cu prorocii"},{"left":"Ce întrebare au pus oamenii","right":"„Oare și Saul este între proroci?”"}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:9', '10:10', '10:11']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Cine l-a văzut pe Saul prorocind cu prorocii?","right":"Toți cei ce-l cunoscuseră mai înainte"},{"left":"Ce întrebare și-au pus unii despre Saul?","right":"„Oare și Saul este între proroci?”"},{"left":"Cine a pus întrebarea „Și cine este tatăl lor?”","right":"Cineva din Ghibea"},{"left":"Ce întrebare a pus cineva din Ghibea?","right":"„Și cine este tatăl lor?”"},{"left":"Unde s-a dus Saul după ce a sfârșit de prorocit?","right":"Pe înălțime"}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:11', '10:12', '10:13']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Cine l-a întrebat pe Saul unde se dusese","right":"Unchiul lui Saul"},{"left":"Ce căutaseră Saul și sluga","right":"Măgărițele"},{"left":"Unde s-au dus după ce nu le-au găsit","right":"La Samuel"},{"left":"Ce a cerut unchiul să-i povestească","right":"Ce le spusese Samuel"},{"left":"Ce veste i-a spus Saul unchiului","right":"Că măgărițele s-au găsit"}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:14', '10:15', '10:16']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Ce nu i-a spus Saul unchiului său","right":"Despre împărăția despre care vorbise Samuel"},{"left":"Unde a chemat Samuel poporul","right":"La Mițpa"},{"left":"Înaintea cui a strâns Samuel poporul","right":"Înaintea Domnului"},{"left":"Din ce țară spusese Domnul că a scos Israelul","right":"Egipt"},{"left":"Cine îi izbăvise pe israeliți","right":"Domnul Dumnezeul lui Israel"}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:16', '10:17', '10:18', '10:19']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Din mâna cui i-a izbăvit Domnul","right":"A egiptenilor"},{"left":"Și din mâna cui i-a mai izbăvit","right":"A împărățiilor care îi apăsau"},{"left":"Pe cine lepădau israeliții prin cererea lor","right":"Pe Dumnezeul care îi izbăvise"},{"left":"Ce conducător cereau","right":"Un împărat"},{"left":"Cum trebuiau să se înfățișeze înaintea Domnului","right":"După seminții și miile lor"}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:18', '10:19']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Ce a apropiat Samuel pentru alegerea prin sorți","right":"Toate semințiile lui Israel"},{"left":"Ce seminție a ieșit la sorți","right":"Beniamin"},{"left":"Ce a apropiat apoi Samuel","right":"Familiile seminției lui Beniamin"},{"left":"Ce familie a ieșit la sorți","right":"Matri"},{"left":"Cine a ieșit în cele din urmă la sorți","right":"Saul, fiul lui Chis"}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:20', '10:21']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Ce au făcut după ce Saul a ieșit la sorți","right":"L-au căutat, dar nu l-au găsit"},{"left":"Pe cine au întrebat din nou","right":"Pe Domnul"},{"left":"Unde a spus Domnul că se afla Saul","right":"Ascuns între vase"},{"left":"Ce au făcut oamenii după răspuns","right":"Au alergat și l-au scos"},{"left":"Cum era Saul în înălțime față de ceilalți","right":"Îi întrecea de la umăr în sus"}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:21', '10:22', '10:23']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Unde era ascuns Saul","right":"Între vase"},{"left":"Unde l-au adus după ce l-au scos","right":"În mijlocul poporului"},{"left":"Ce a spus Samuel despre omul ales","right":"Nu era nimeni în popor ca el"},{"left":"Cine îl alesese pe Saul","right":"Domnul"},{"left":"Ce a strigat poporul","right":"„Trăiască împăratul!”"}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:22', '10:23', '10:24']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Ce a spus Samuel despre omul ales","right":"Nu era nimeni în popor ca el"},{"left":"Ce a spus poporul după aceea","right":"„Trăiască împăratul!”"},{"left":"Ce a făcut Samuel cunoscut poporului","right":"Dreptul împărăției"},{"left":"Unde a scris Samuel dreptul împărăției","right":"Într-o carte"},{"left":"Unde a pus cartea","right":"Înaintea Domnului"}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:24', '10:25']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Ce a făcut Samuel după ce a scris dreptul împărăției","right":"A dat drumul poporului"},{"left":"Unde s-a dus Saul acasă","right":"În Ghibea"},{"left":"Cine l-a însoțit pe Saul","right":"O parte dintre ostași"},{"left":"Cine le mișcase inima ostașilor","right":"Dumnezeu"},{"left":"Cum a răspuns Saul disprețuitorilor","right":"S-a făcut că nu-i aude"}]'::jsonb, 10, 2, '1 Samuel', ARRAY['10:25', '10:26', '10:27']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Cum a fost uns Saul","right":"Samuel i-a turnat untdelemn pe cap"},{"left":"Ce urma să-i spună doi oameni la Țelțah","right":"Măgărițele s-au găsit"},{"left":"Ce primea Saul de la trei oameni la stejarul din Tabor","right":"Două pâini"},{"left":"Unde se afla garnizoana filistenilor","right":"La Ghibea Elohim"},{"left":"Ce se întâmpla cu Saul când venea Duhul Domnului","right":"Prorocea și era prefăcut într-alt om"}]'::jsonb, 10, 3, '1 Samuel', ARRAY['10:1', '10:2', '10:3', '10:4', '10:5', '10:6']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Unde a strâns Samuel poporul","right":"La Mițpa"},{"left":"Ce a amintit Samuel că făcuse Domnul pentru Israel","right":"Îl scosese din Egipt și îl izbăvise"},{"left":"Ce a cerut poporul deși îl lepăda pe Dumnezeul lui","right":"Un împărat"},{"left":"Ce seminție a ieșit la sorți","right":"Beniamin"},{"left":"Unde a fost găsit Saul","right":"Ascuns între vase"}]'::jsonb, 10, 3, '1 Samuel', ARRAY['10:17', '10:18', '10:19', '10:20', '10:21', '10:22', '10:23', '10:24']::text[], 'pending_review', 'Codex')
) as incoming (pairs, chapter, difficulty, book, source_references, status, added_by)
where not exists (
  select 1 from public.questions_match existing
  where existing.book = incoming.book
    and existing.chapter = incoming.chapter
    and existing.source_references = incoming.source_references
    and existing.pairs = incoming.pairs
);

commit;
