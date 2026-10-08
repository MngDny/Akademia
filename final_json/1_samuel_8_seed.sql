begin;

alter table public.questions_tf add column if not exists source_references text[] not null default '{}';

alter table public.questions_abc_one add column if not exists source_references text[] not null default '{}';

alter table public.questions_abc_multi add column if not exists source_references text[] not null default '{}';

alter table public.questions_match add column if not exists source_references text[] not null default '{}';

update public.questions_tf as existing
set status = incoming.status
from (values
  ('1 Samuel', 8, ARRAY['8:1']::text[], 'pending_review', 'Când a îmbătrânit, Samuel i-a pus pe fiii săi judecători peste Israel.'),
  ('1 Samuel', 8, ARRAY['8:2']::text[], 'pending_review', 'Fiul întâi născut al lui Samuel se numea Ioel, iar al doilea Abia; amândoi judecau la Beer-Șeba.'),
  ('1 Samuel', 8, ARRAY['8:3']::text[], 'pending_review', 'Fiii lui Samuel au călcat pe urmele tatălui lor și au judecat cu dreptate.'),
  ('1 Samuel', 8, ARRAY['8:3']::text[], 'pending_review', 'Fiii lui Samuel se dădeau la lăcomie, luau mită și călcau dreptatea.'),
  ('1 Samuel', 8, ARRAY['8:4']::text[], 'pending_review', 'Bătrânii lui Israel s-au strâns și au venit la Samuel, la Rama.'),
  ('1 Samuel', 8, ARRAY['8:5']::text[], 'pending_review', 'Bătrânii i-au cerut lui Samuel un împărat care să-i judece, asemenea celorlalte neamuri.'),
  ('1 Samuel', 8, ARRAY['8:6']::text[], 'pending_review', 'Samuel a primit cu plăcere cererea poporului de a avea un împărat și nu s-a rugat Domnului.'),
  ('1 Samuel', 8, ARRAY['8:6']::text[], 'pending_review', 'Cererea bătrânilor ca să li se dea un împărat nu i-a plăcut lui Samuel, iar el s-a rugat Domnului.'),
  ('1 Samuel', 8, ARRAY['8:7']::text[], 'pending_review', 'Domnul i-a spus lui Samuel că poporul nu îl lepăda pe el, ci Îl lepăda pe Domnul.'),
  ('1 Samuel', 8, ARRAY['8:7']::text[], 'pending_review', 'Domnul a spus că poporul Îl lepăda ca să nu mai domnească El peste ei.'),
  ('1 Samuel', 8, ARRAY['8:8']::text[], 'pending_review', 'Domnul a spus că Israel se purtase astfel încă din ziua scoaterii lui din Egipt și că slujise altor dumnezei.'),
  ('1 Samuel', 8, ARRAY['8:9']::text[], 'pending_review', 'Domnul i-a spus lui Samuel să nu asculte cererea poporului și să nu-i avertizeze despre dreptul împăratului.'),
  ('1 Samuel', 8, ARRAY['8:10']::text[], 'pending_review', 'Samuel a spus poporului toate cuvintele Domnului, după ce acesta ceruse un împărat.'),
  ('1 Samuel', 8, ARRAY['8:11']::text[], 'pending_review', 'Împăratul urma să-i ia pe fiii poporului și să-i pună la carele și între călăreții lui.'),
  ('1 Samuel', 8, ARRAY['8:12']::text[], 'pending_review', 'Împăratul urma să-i pună pe unii dintre fiii poporului căpetenii peste o mie și peste cincizeci.'),
  ('1 Samuel', 8, ARRAY['8:12']::text[], 'pending_review', 'Împăratul urma să-i folosească pe fiii poporului la arat, la secerat și la facerea armelor și a uneltelor carelor lui.'),
  ('1 Samuel', 8, ARRAY['8:13']::text[], 'pending_review', 'Împăratul urma să ia pe fetele poporului ca să-i facă miresme, mâncare și pâine.'),
  ('1 Samuel', 8, ARRAY['8:14']::text[], 'pending_review', 'Cea mai bună parte din câmpii, vii și măslini urma să fie dată slujitorilor împăratului.'),
  ('1 Samuel', 8, ARRAY['8:15']::text[], 'pending_review', 'Împăratul urma să ia zeciuială din rodul semințelor și al viilor și să o dea slujitorilor lui.'),
  ('1 Samuel', 8, ARRAY['8:16']::text[], 'pending_review', 'Împăratul urma să ia robii, roabele, cei mai buni boi și măgari și să-i folosească la lucrările lui.'),
  ('1 Samuel', 8, ARRAY['8:17']::text[], 'pending_review', 'Împăratul urma să ia zeciuială din oi, iar poporul urma să fie slujitorul lui.'),
  ('1 Samuel', 8, ARRAY['8:18']::text[], 'pending_review', 'Domnul a promis că va asculta poporul când acesta va striga împotriva împăratului pe care îl alesese.'),
  ('1 Samuel', 8, ARRAY['8:19']::text[], 'pending_review', 'Poporul n-a vrut să asculte glasul lui Samuel și a insistat să aibă un împărat.'),
  ('1 Samuel', 8, ARRAY['8:20']::text[], 'pending_review', 'Poporul voia ca împăratul să-l judece, să meargă înaintea lui și să-l cârmuiască în războaie.'),
  ('1 Samuel', 8, ARRAY['8:21']::text[], 'pending_review', 'După ce a auzit cuvintele poporului, Samuel le-a spus în auzul Domnului.'),
  ('1 Samuel', 8, ARRAY['8:22']::text[], 'pending_review', 'Domnul i-a spus lui Samuel să asculte glasul poporului și să pună un împărat peste ei.'),
  ('1 Samuel', 8, ARRAY['8:22']::text[], 'pending_review', 'După ce le-a transmis bărbaților lui Israel răspunsul Domnului, Samuel le-a spus să se întoarcă fiecare în cetatea lui.')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_tf (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Când a îmbătrânit, Samuel i-a pus pe fiii săi judecători peste Israel.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 8, 1, '1 Samuel', ARRAY['8:1']::text[], 'pending_review', 'Codex'),
  ('Fiul întâi născut al lui Samuel se numea Ioel, iar al doilea Abia; amândoi judecau la Beer-Șeba.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 8, 1, '1 Samuel', ARRAY['8:2']::text[], 'pending_review', 'Codex'),
  ('Fiii lui Samuel au călcat pe urmele tatălui lor și au judecat cu dreptate.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:3']::text[], 'pending_review', 'Codex'),
  ('Fiii lui Samuel se dădeau la lăcomie, luau mită și călcau dreptatea.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:3']::text[], 'pending_review', 'Codex'),
  ('Bătrânii lui Israel s-au strâns și au venit la Samuel, la Rama.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 8, 1, '1 Samuel', ARRAY['8:4']::text[], 'pending_review', 'Codex'),
  ('Bătrânii i-au cerut lui Samuel un împărat care să-i judece, asemenea celorlalte neamuri.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 8, 1, '1 Samuel', ARRAY['8:5']::text[], 'pending_review', 'Codex'),
  ('Samuel a primit cu plăcere cererea poporului de a avea un împărat și nu s-a rugat Domnului.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:6']::text[], 'pending_review', 'Codex'),
  ('Cererea bătrânilor ca să li se dea un împărat nu i-a plăcut lui Samuel, iar el s-a rugat Domnului.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:6']::text[], 'pending_review', 'Codex'),
  ('Domnul i-a spus lui Samuel că poporul nu îl lepăda pe el, ci Îl lepăda pe Domnul.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:7']::text[], 'pending_review', 'Codex'),
  ('Domnul a spus că poporul Îl lepăda ca să nu mai domnească El peste ei.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:7']::text[], 'pending_review', 'Codex'),
  ('Domnul a spus că Israel se purtase astfel încă din ziua scoaterii lui din Egipt și că slujise altor dumnezei.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 8, 3, '1 Samuel', ARRAY['8:8']::text[], 'pending_review', 'Codex'),
  ('Domnul i-a spus lui Samuel să nu asculte cererea poporului și să nu-i avertizeze despre dreptul împăratului.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:9']::text[], 'pending_review', 'Codex'),
  ('Samuel a spus poporului toate cuvintele Domnului, după ce acesta ceruse un împărat.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:10']::text[], 'pending_review', 'Codex'),
  ('Împăratul urma să-i ia pe fiii poporului și să-i pună la carele și între călăreții lui.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:11']::text[], 'pending_review', 'Codex'),
  ('Împăratul urma să-i pună pe unii dintre fiii poporului căpetenii peste o mie și peste cincizeci.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:12']::text[], 'pending_review', 'Codex'),
  ('Împăratul urma să-i folosească pe fiii poporului la arat, la secerat și la facerea armelor și a uneltelor carelor lui.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:12']::text[], 'pending_review', 'Codex'),
  ('Împăratul urma să ia pe fetele poporului ca să-i facă miresme, mâncare și pâine.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:13']::text[], 'pending_review', 'Codex'),
  ('Cea mai bună parte din câmpii, vii și măslini urma să fie dată slujitorilor împăratului.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:14']::text[], 'pending_review', 'Codex'),
  ('Împăratul urma să ia zeciuială din rodul semințelor și al viilor și să o dea slujitorilor lui.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:15']::text[], 'pending_review', 'Codex'),
  ('Împăratul urma să ia robii, roabele, cei mai buni boi și măgari și să-i folosească la lucrările lui.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:16']::text[], 'pending_review', 'Codex'),
  ('Împăratul urma să ia zeciuială din oi, iar poporul urma să fie slujitorul lui.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:17']::text[], 'pending_review', 'Codex'),
  ('Domnul a promis că va asculta poporul când acesta va striga împotriva împăratului pe care îl alesese.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 8, 3, '1 Samuel', ARRAY['8:18']::text[], 'pending_review', 'Codex'),
  ('Poporul n-a vrut să asculte glasul lui Samuel și a insistat să aibă un împărat.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 8, 1, '1 Samuel', ARRAY['8:19']::text[], 'pending_review', 'Codex'),
  ('Poporul voia ca împăratul să-l judece, să meargă înaintea lui și să-l cârmuiască în războaie.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:20']::text[], 'pending_review', 'Codex'),
  ('După ce a auzit cuvintele poporului, Samuel le-a spus în auzul Domnului.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:21']::text[], 'pending_review', 'Codex'),
  ('Domnul i-a spus lui Samuel să asculte glasul poporului și să pună un împărat peste ei.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 8, 1, '1 Samuel', ARRAY['8:22']::text[], 'pending_review', 'Codex'),
  ('După ce le-a transmis bărbaților lui Israel răspunsul Domnului, Samuel le-a spus să se întoarcă fiecare în cetatea lui.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:22']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 8, ARRAY['8:1']::text[], 'pending_review', 'Ce rol le-a dat Samuel fiilor săi când a îmbătrânit?'),
  ('1 Samuel', 8, ARRAY['8:2']::text[], 'pending_review', 'Cum se numeau fiii lui Samuel, în ordinea menționată în capitol?'),
  ('1 Samuel', 8, ARRAY['8:2']::text[], 'pending_review', 'Unde judecau fiii lui Samuel?'),
  ('1 Samuel', 8, ARRAY['8:3']::text[], 'pending_review', 'Ce făceau fiii lui Samuel, potrivit relatării despre purtarea lor?'),
  ('1 Samuel', 8, ARRAY['8:4']::text[], 'pending_review', 'Unde au venit bătrânii lui Israel când s-au strâns la Samuel?'),
  ('1 Samuel', 8, ARRAY['8:5']::text[], 'pending_review', 'Ce le-au cerut bătrânii lui Israel lui Samuel?'),
  ('1 Samuel', 8, ARRAY['8:6']::text[], 'pending_review', 'Cum a reacționat Samuel când poporul i-a cerut un împărat?'),
  ('1 Samuel', 8, ARRAY['8:7']::text[], 'pending_review', 'Pe cine a spus Domnul că lepăda poporul prin cererea lui pentru un împărat?'),
  ('1 Samuel', 8, ARRAY['8:8']::text[], 'pending_review', 'Ce făcuse Israel, potrivit cuvintelor Domnului, din vremea ieșirii din Egipt?'),
  ('1 Samuel', 8, ARRAY['8:9']::text[], 'pending_review', 'Ce trebuia să facă Samuel după ce asculta cererea poporului, potrivit Domnului?'),
  ('1 Samuel', 8, ARRAY['8:11']::text[], 'pending_review', 'Ce urma să facă împăratul cu o parte dintre fiii poporului?'),
  ('1 Samuel', 8, ARRAY['8:12']::text[], 'pending_review', 'Peste ce grupuri urma împăratul să pună căpetenii dintre fiii poporului?'),
  ('1 Samuel', 8, ARRAY['8:12']::text[], 'pending_review', 'La ce lucrări urma să-i folosească împăratul pe fiii poporului, potrivit avertizării lui Samuel?'),
  ('1 Samuel', 8, ARRAY['8:13']::text[], 'pending_review', 'Pentru ce urma împăratul să ia pe fetele poporului?'),
  ('1 Samuel', 8, ARRAY['8:14']::text[], 'pending_review', 'Cui urma împăratul să dea cea mai bună parte din câmpii, vii și măslini?'),
  ('1 Samuel', 8, ARRAY['8:15']::text[], 'pending_review', 'Ce urma împăratul să facă cu zeciuiala din rodul semințelor și al viilor?'),
  ('1 Samuel', 8, ARRAY['8:16']::text[], 'pending_review', 'Ce animale ale poporului urma împăratul să ia pentru lucrările lui?'),
  ('1 Samuel', 8, ARRAY['8:17']::text[], 'pending_review', 'Ce urma să ia împăratul din turmele poporului și ce urmau să fie oamenii înșiși?'),
  ('1 Samuel', 8, ARRAY['8:18']::text[], 'pending_review', 'Ce a spus Samuel că se va întâmpla când poporul va striga din pricina împăratului ales?'),
  ('1 Samuel', 8, ARRAY['8:19', '8:20']::text[], 'pending_review', 'De ce spunea poporul că voia să aibă un împărat?'),
  ('1 Samuel', 8, ARRAY['8:20']::text[], 'pending_review', 'Ce trei lucruri spunea poporul că va face împăratul pentru ei?'),
  ('1 Samuel', 8, ARRAY['8:21']::text[], 'pending_review', 'Ce a făcut Samuel după ce a auzit toate cuvintele poporului?'),
  ('1 Samuel', 8, ARRAY['8:22']::text[], 'pending_review', 'Ce i-a poruncit Domnul lui Samuel să facă în cele din urmă?'),
  ('1 Samuel', 8, ARRAY['8:22']::text[], 'pending_review', 'Ce le-a spus Samuel bărbaților lui Israel după ce Domnul a răspuns?')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_abc_one (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Ce rol le-a dat Samuel fiilor săi când a îmbătrânit?', '[{"text":"I-a pus judecători peste Israel","correct":true},{"text":"I-a pus preoți la Mițpa","correct":false},{"text":"I-a trimis să păzească chivotul la Chiriat-Iearim","correct":false}]'::jsonb, 8, 1, '1 Samuel', ARRAY['8:1']::text[], 'pending_review', 'Codex'),
  ('Cum se numeau fiii lui Samuel, în ordinea menționată în capitol?', '[{"text":"Ioel și Abia","correct":true},{"text":"Abinadab și Eleazar","correct":false},{"text":"Saul și David","correct":false}]'::jsonb, 8, 1, '1 Samuel', ARRAY['8:2']::text[], 'pending_review', 'Codex'),
  ('Unde judecau fiii lui Samuel?', '[{"text":"La Beer-Șeba","correct":true},{"text":"La Rama","correct":false},{"text":"La Mițpa","correct":false}]'::jsonb, 8, 1, '1 Samuel', ARRAY['8:2']::text[], 'pending_review', 'Codex'),
  ('Ce făceau fiii lui Samuel, potrivit relatării despre purtarea lor?', '[{"text":"Se dădeau la lăcomie, luau mită și călcau dreptatea","correct":true},{"text":"Se rugau pentru popor și judecau la Mițpa","correct":false},{"text":"Păzeau chivotul și slujeau la altar","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:3']::text[], 'pending_review', 'Codex'),
  ('Unde au venit bătrânii lui Israel când s-au strâns la Samuel?', '[{"text":"La Rama","correct":true},{"text":"La Beer-Șeba","correct":false},{"text":"La Betel","correct":false}]'::jsonb, 8, 1, '1 Samuel', ARRAY['8:4']::text[], 'pending_review', 'Codex'),
  ('Ce le-au cerut bătrânii lui Israel lui Samuel?', '[{"text":"Să pună un împărat peste ei ca să-i judece","correct":true},{"text":"Să-i mute pe fiii lui Samuel la Rama","correct":false},{"text":"Să aducă chivotul la Beer-Șeba","correct":false}]'::jsonb, 8, 1, '1 Samuel', ARRAY['8:5']::text[], 'pending_review', 'Codex'),
  ('Cum a reacționat Samuel când poporul i-a cerut un împărat?', '[{"text":"Nu i-a plăcut cererea și s-a rugat Domnului","correct":true},{"text":"A acceptat imediat și a ales un împărat","correct":false},{"text":"A chemat filistenii să hotărască","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:6']::text[], 'pending_review', 'Codex'),
  ('Pe cine a spus Domnul că lepăda poporul prin cererea lui pentru un împărat?', '[{"text":"Pe Domnul","correct":true},{"text":"Pe Samuel","correct":false},{"text":"Pe fiii lui Samuel","correct":false}]'::jsonb, 8, 1, '1 Samuel', ARRAY['8:7']::text[], 'pending_review', 'Codex'),
  ('Ce făcuse Israel, potrivit cuvintelor Domnului, din vremea ieșirii din Egipt?', '[{"text":"Îl părăsise pe Domnul și slujise altor dumnezei","correct":true},{"text":"Îl rugase pe Samuel să fie împărat","correct":false},{"text":"Îi ceruse lui Samuel să ridice un altar la Rama","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:8']::text[], 'pending_review', 'Codex'),
  ('Ce trebuia să facă Samuel după ce asculta cererea poporului, potrivit Domnului?', '[{"text":"Să-i înștiințeze despre dreptul împăratului","correct":true},{"text":"Să aleagă el însuși un împărat fără să-i spună poporului","correct":false},{"text":"Să-i trimită pe bătrâni la Beer-Șeba","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:9']::text[], 'pending_review', 'Codex'),
  ('Ce urma să facă împăratul cu o parte dintre fiii poporului?', '[{"text":"Să-i pună la carele și între călăreții lui","correct":true},{"text":"Să-i trimită să judece la Beer-Șeba","correct":false},{"text":"Să-i pună să păzească chivotul","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:11']::text[], 'pending_review', 'Codex'),
  ('Peste ce grupuri urma împăratul să pună căpetenii dintre fiii poporului?', '[{"text":"Peste o mie și peste cincizeci","correct":true},{"text":"Peste douăsprezece și peste șaptezeci","correct":false},{"text":"Peste cinci și peste zece","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:12']::text[], 'pending_review', 'Codex'),
  ('La ce lucrări urma să-i folosească împăratul pe fiii poporului, potrivit avertizării lui Samuel?', '[{"text":"La arat, secerat și facerea armelor și uneltelor carelor lui","correct":true},{"text":"La păzirea chivotului și la judecată","correct":false},{"text":"La construirea de case pentru bătrânii lui Israel","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:12']::text[], 'pending_review', 'Codex'),
  ('Pentru ce urma împăratul să ia pe fetele poporului?', '[{"text":"Ca să-i facă miresme, mâncare și pâine","correct":true},{"text":"Ca să judece la Beer-Șeba","correct":false},{"text":"Ca să păzească viile și măslinii","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:13']::text[], 'pending_review', 'Codex'),
  ('Cui urma împăratul să dea cea mai bună parte din câmpii, vii și măslini?', '[{"text":"Slujitorilor lui","correct":true},{"text":"Bătrânilor lui Israel","correct":false},{"text":"Fiilor lui Samuel","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:14']::text[], 'pending_review', 'Codex'),
  ('Ce urma împăratul să facă cu zeciuiala din rodul semințelor și al viilor?', '[{"text":"S-o dea famenilor și slujitorilor lui","correct":true},{"text":"S-o împartă între bătrâni","correct":false},{"text":"S-o trimită la Beer-Șeba","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:15']::text[], 'pending_review', 'Codex'),
  ('Ce animale ale poporului urma împăratul să ia pentru lucrările lui?', '[{"text":"Cei mai buni boi și măgari","correct":true},{"text":"Mieii și vacile care alăptau","correct":false},{"text":"Caii și cămilele","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:16']::text[], 'pending_review', 'Codex'),
  ('Ce urma să ia împăratul din turmele poporului și ce urmau să fie oamenii înșiși?', '[{"text":"Zeciuială din oi, iar oamenii urmau să-i fie slujitori","correct":true},{"text":"Toate oile, iar oamenii urmau să fie judecători","correct":false},{"text":"Cei mai buni miei, iar oamenii urmau să păzească cetățile","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:17']::text[], 'pending_review', 'Codex'),
  ('Ce a spus Samuel că se va întâmpla când poporul va striga din pricina împăratului ales?', '[{"text":"Domnul nu-l va asculta","correct":true},{"text":"Domnul îi va da imediat un alt împărat","correct":false},{"text":"Samuel va lua împăratul de la ei","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:18']::text[], 'pending_review', 'Codex'),
  ('De ce spunea poporul că voia să aibă un împărat?', '[{"text":"Ca să fie ca toate neamurile","correct":true},{"text":"Ca să se întoarcă la Egipt","correct":false},{"text":"Ca să nu mai aibă judecători","correct":false}]'::jsonb, 8, 1, '1 Samuel', ARRAY['8:19', '8:20']::text[], 'pending_review', 'Codex'),
  ('Ce trei lucruri spunea poporul că va face împăratul pentru ei?', '[{"text":"Îi va judeca, va merge înaintea lor și îi va cârmui în războaie","correct":true},{"text":"Va păzi chivotul, va ridica un altar și va judeca la Beer-Șeba","correct":false},{"text":"Va da zeciuială, va judeca bătrânii și va conduce jertfele","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:20']::text[], 'pending_review', 'Codex'),
  ('Ce a făcut Samuel după ce a auzit toate cuvintele poporului?', '[{"text":"Le-a spus în auzul Domnului","correct":true},{"text":"Le-a spus numai fiilor săi la Beer-Șeba","correct":false},{"text":"Le-a trimis domnitorilor filistenilor","correct":false}]'::jsonb, 8, 1, '1 Samuel', ARRAY['8:21']::text[], 'pending_review', 'Codex'),
  ('Ce i-a poruncit Domnul lui Samuel să facă în cele din urmă?', '[{"text":"Să asculte glasul poporului și să pună un împărat peste ei","correct":true},{"text":"Să refuze cererea și să-i trimită pe bătrâni acasă","correct":false},{"text":"Să-i pună pe fiii lui judecători peste toate neamurile","correct":false}]'::jsonb, 8, 1, '1 Samuel', ARRAY['8:22']::text[], 'pending_review', 'Codex'),
  ('Ce le-a spus Samuel bărbaților lui Israel după ce Domnul a răspuns?', '[{"text":"Să se ducă fiecare în cetatea lui","correct":true},{"text":"Să se adune la Beer-Șeba","correct":false},{"text":"Să aleagă un împărat prin tragere la sorți","correct":false}]'::jsonb, 8, 1, '1 Samuel', ARRAY['8:22']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 8, ARRAY['8:1', '8:2']::text[], 'pending_review', 'Ce informații oferă capitolul despre fiii lui Samuel și locul unde judecau?'),
  ('1 Samuel', 8, ARRAY['8:3']::text[], 'pending_review', 'Ce spune relatarea despre felul în care se purtau fiii lui Samuel?'),
  ('1 Samuel', 8, ARRAY['8:4', '8:5']::text[], 'pending_review', 'Ce au făcut bătrânii lui Israel înainte să ceară un împărat?'),
  ('1 Samuel', 8, ARRAY['8:5']::text[], 'pending_review', 'Ce i-au spus bătrânii lui Samuel când au cerut un împărat?'),
  ('1 Samuel', 8, ARRAY['8:6']::text[], 'pending_review', 'Ce a făcut Samuel după ce i-a auzit pe bătrâni cerând un împărat?'),
  ('1 Samuel', 8, ARRAY['8:7']::text[], 'pending_review', 'Cum a explicat Domnul cererea poporului adresată lui Samuel?'),
  ('1 Samuel', 8, ARRAY['8:8']::text[], 'pending_review', 'Ce a amintit Domnul despre purtarea lui Israel de la ieșirea din Egipt până atunci?'),
  ('1 Samuel', 8, ARRAY['8:9']::text[], 'pending_review', 'Ce i-a cerut Domnul lui Samuel să facă în legătură cu cererea poporului?'),
  ('1 Samuel', 8, ARRAY['8:10', '8:11']::text[], 'pending_review', 'Ce avertizare despre fiii poporului le-a transmis Samuel?'),
  ('1 Samuel', 8, ARRAY['8:12']::text[], 'pending_review', 'La ce slujbe urma să-i folosească împăratul pe fiii poporului?'),
  ('1 Samuel', 8, ARRAY['8:12', '8:13']::text[], 'pending_review', 'Ce lucruri urma să ia împăratul pentru pregătirea războiului și a carelor sale?'),
  ('1 Samuel', 8, ARRAY['8:13']::text[], 'pending_review', 'Ce lucruri urma să facă fetele poporului pentru împărat?'),
  ('1 Samuel', 8, ARRAY['8:14']::text[], 'pending_review', 'Ce bunuri urma împăratul să ia și cui urma să le dea?'),
  ('1 Samuel', 8, ARRAY['8:15']::text[], 'pending_review', 'Ce urma să ia împăratul ca zeciuială din recoltele poporului?'),
  ('1 Samuel', 8, ARRAY['8:16']::text[], 'pending_review', 'Ce urma împăratul să ia și cum urma să le folosească?'),
  ('1 Samuel', 8, ARRAY['8:17']::text[], 'pending_review', 'Ce a spus Samuel despre zeciuiala din oi și despre poporul însuși?'),
  ('1 Samuel', 8, ARRAY['8:18']::text[], 'pending_review', 'Ce a avertizat Samuel că se va întâmpla când poporul va striga din pricina împăratului?'),
  ('1 Samuel', 8, ARRAY['8:19', '8:20']::text[], 'pending_review', 'Ce motive a dat poporul pentru a cere un împărat?'),
  ('1 Samuel', 8, ARRAY['8:20']::text[], 'pending_review', 'Ce roluri urma să aibă împăratul potrivit cuvintelor poporului?'),
  ('1 Samuel', 8, ARRAY['8:19', '8:21', '8:22']::text[], 'pending_review', 'Ce s-a întâmplat după ce poporul a insistat să aibă împărat?'),
  ('1 Samuel', 8, ARRAY['8:22']::text[], 'pending_review', 'Ce acțiuni au urmat după răspunsul Domnului către Samuel?'),
  ('1 Samuel', 8, ARRAY['8:11', '8:13', '8:16']::text[], 'pending_review', 'Ce categorii de oameni sau bunuri ale poporului sunt enumerate între lucrurile pe care împăratul urma să le ia?')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_abc_multi (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Ce informații oferă capitolul despre fiii lui Samuel și locul unde judecau?', '[{"text":"Întâiul născut se numea Ioel, iar al doilea Abia.","correct":true},{"text":"Ei erau judecători la Beer-Șeba.","correct":true},{"text":"Amândoi judecau la Rama, după ce Samuel a îmbătrânit.","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:1', '8:2']::text[], 'pending_review', 'Codex'),
  ('Ce spune relatarea despre felul în care se purtau fiii lui Samuel?', '[{"text":"Nu au călcat pe urmele lui Samuel.","correct":true},{"text":"Se dădeau la lăcomie, luau mită și călcau dreptatea.","correct":true},{"text":"Au refuzat să primească darurile bătrânilor și au plecat din Beer-Șeba.","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:3']::text[], 'pending_review', 'Codex'),
  ('Ce au făcut bătrânii lui Israel înainte să ceară un împărat?', '[{"text":"S-au strâns împreună.","correct":true},{"text":"Au venit la Samuel, la Rama.","correct":true},{"text":"Au venit la fiii lui Samuel, la Beer-Șeba, și i-au uns împărați.","correct":false}]'::jsonb, 8, 1, '1 Samuel', ARRAY['8:4', '8:5']::text[], 'pending_review', 'Codex'),
  ('Ce i-au spus bătrânii lui Samuel când au cerut un împărat?', '[{"text":"Samuel era bătrân.","correct":true},{"text":"Copiii lui Samuel nu călcau pe urmele lui.","correct":true},{"text":"Samuel nu mai judeca la Rama și le poruncise să plece.","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:5']::text[], 'pending_review', 'Codex'),
  ('Ce a făcut Samuel după ce i-a auzit pe bătrâni cerând un împărat?', '[{"text":"I-a displăcut cererea lor.","correct":true},{"text":"S-a rugat Domnului.","correct":true},{"text":"A ales el un împărat înainte să vorbească Domnul.","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:6']::text[], 'pending_review', 'Codex'),
  ('Cum a explicat Domnul cererea poporului adresată lui Samuel?', '[{"text":"Poporul Îl lepăda pe Domnul, nu pe Samuel.","correct":true},{"text":"Poporul cerea să nu mai domnească Domnul peste el.","correct":true},{"text":"Poporul cerea să-l lepede pe Samuel și să-l aleagă pe unul dintre fiii lui ca împărat.","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:7']::text[], 'pending_review', 'Codex'),
  ('Ce a amintit Domnul despre purtarea lui Israel de la ieșirea din Egipt până atunci?', '[{"text":"Poporul Îl părăsise pe Domnul.","correct":true},{"text":"Poporul slujise altor dumnezei.","correct":true},{"text":"Poporul Îl slujise numai pe Domnul și nu ceruse niciodată alt conducător.","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:8']::text[], 'pending_review', 'Codex'),
  ('Ce i-a cerut Domnul lui Samuel să facă în legătură cu cererea poporului?', '[{"text":"Să asculte glasul poporului.","correct":true},{"text":"Să-i înștiințeze și să le facă cunoscut dreptul împăratului.","correct":true},{"text":"Să le ascundă felul în care avea să domnească împăratul.","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:9']::text[], 'pending_review', 'Codex'),
  ('Ce avertizare despre fiii poporului le-a transmis Samuel?', '[{"text":"Împăratul îi va lua și-i va pune la carele sale și între călăreții lui.","correct":true},{"text":"Unii vor alerga înaintea carului împăratului.","correct":true},{"text":"Împăratul îi va trimite pe toți să judece la Beer-Șeba.","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:10', '8:11']::text[], 'pending_review', 'Codex'),
  ('La ce slujbe urma să-i folosească împăratul pe fiii poporului?', '[{"text":"Să fie căpetenii peste o mie și peste cincizeci.","correct":true},{"text":"Să are pământul lui și să strângă secerișul lui.","correct":true},{"text":"Să păzească chivotul și să se roage la Mițpa.","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:12']::text[], 'pending_review', 'Codex'),
  ('Ce lucruri urma să ia împăratul pentru pregătirea războiului și a carelor sale?', '[{"text":"Fiii poporului urmau să facă arme de război.","correct":true},{"text":"Fiii poporului urmau să facă uneltele carelor împăratului.","correct":true},{"text":"Fetele poporului urmau să fie puse să facă armele și carele.","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:12', '8:13']::text[], 'pending_review', 'Codex'),
  ('Ce lucruri urma să facă fetele poporului pentru împărat?', '[{"text":"Să-i facă miresme.","correct":true},{"text":"Să-i pregătească mâncare și pâine.","correct":true},{"text":"Să-i strângă zeciuiala din oi și din viile sale.","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:13']::text[], 'pending_review', 'Codex'),
  ('Ce bunuri urma împăratul să ia și cui urma să le dea?', '[{"text":"Cea mai bună parte din câmpii, vii și măslini.","correct":true},{"text":"Acestea urmau să fie date slujitorilor lui.","correct":true},{"text":"Toate câmpiile, viile și măslinii urmau să fie date bătrânilor lui Israel.","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:14']::text[], 'pending_review', 'Codex'),
  ('Ce urma să ia împăratul ca zeciuială din recoltele poporului?', '[{"text":"Din rodul semințelor.","correct":true},{"text":"Din rodul viilor.","correct":true},{"text":"Din rodul măslinilor și al oilor.","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:15']::text[], 'pending_review', 'Codex'),
  ('Ce urma împăratul să ia și cum urma să le folosească?', '[{"text":"Robii și roabele poporului.","correct":true},{"text":"Cei mai buni boi și măgari, pentru lucrările lui.","correct":true},{"text":"Toate oile, pentru arderile-de-tot aduse la Mițpa.","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:16']::text[], 'pending_review', 'Codex'),
  ('Ce a spus Samuel despre zeciuiala din oi și despre poporul însuși?', '[{"text":"Împăratul va lua zeciuială din oile poporului.","correct":true},{"text":"Poporul însuși va ajunge slujitorul împăratului.","correct":true},{"text":"Împăratul va da zeciuială din oi poporului, care va rămâne liber.","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:17']::text[], 'pending_review', 'Codex'),
  ('Ce a avertizat Samuel că se va întâmpla când poporul va striga din pricina împăratului?', '[{"text":"Poporul va striga împotriva împăratului pe care îl va alege.","correct":true},{"text":"Domnul nu-l va asculta în ziua aceea.","correct":true},{"text":"Domnul îi va asculta și va îndepărta împăratul ales.","correct":false}]'::jsonb, 8, 3, '1 Samuel', ARRAY['8:18']::text[], 'pending_review', 'Codex'),
  ('Ce motive a dat poporul pentru a cere un împărat?', '[{"text":"Voia să fie ca toate celelalte neamuri.","correct":true},{"text":"Voia ca împăratul să-l judece și să meargă în fruntea lui.","correct":true},{"text":"Voia ca Samuel să-i pună pe fiii lui judecători la Beer-Șeba.","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:19', '8:20']::text[], 'pending_review', 'Codex'),
  ('Ce roluri urma să aibă împăratul potrivit cuvintelor poporului?', '[{"text":"Să-i judece.","correct":true},{"text":"Să-i conducă în războaiele lor.","correct":true},{"text":"Să se roage Domnului în locul lor și să le dea viile sale.","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:20']::text[], 'pending_review', 'Codex'),
  ('Ce s-a întâmplat după ce poporul a insistat să aibă împărat?', '[{"text":"Samuel a spus în auzul Domnului toate cuvintele poporului pe care le auzise.","correct":true},{"text":"Domnul i-a spus lui Samuel să asculte glasul poporului și să pună un împărat peste ei.","correct":true},{"text":"Domnul i-a spus lui Samuel să nu mai asculte poporul și să nu pună împărat.","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:19', '8:21', '8:22']::text[], 'pending_review', 'Codex'),
  ('Ce acțiuni au urmat după răspunsul Domnului către Samuel?', '[{"text":"Domnul i-a spus să asculte glasul poporului și să pună un împărat peste ei.","correct":true},{"text":"Samuel le-a spus bărbaților lui Israel să se ducă fiecare în cetatea lui.","correct":true},{"text":"Samuel a mers la Beer-Șeba să-i pună pe fiii săi împărați.","correct":false}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:22']::text[], 'pending_review', 'Codex'),
  ('Ce categorii de oameni sau bunuri ale poporului sunt enumerate între lucrurile pe care împăratul urma să le ia?', '[{"text":"Fiii și fetele poporului.","correct":true},{"text":"Robii, roabele, boii și măgarii poporului.","correct":true},{"text":"Chivotul Domnului și altarul de la Rama.","correct":false}]'::jsonb, 8, 3, '1 Samuel', ARRAY['8:11', '8:13', '8:16']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 8, ARRAY['8:1', '8:2', '8:3']::text[], 'pending_review', '[{"left":"Rolul dat de Samuel fiilor săi","right":"Judecători peste Israel"},{"left":"Fiul întâi născut al lui Samuel","right":"Ioel"},{"left":"Al doilea fiu al lui Samuel","right":"Abia"},{"left":"Locul unde judecau cei doi fii","right":"Beer-Șeba"},{"left":"Purtarea fiilor față de dreptate","right":"Luau mită și călcau dreptatea"}]'::jsonb),
  ('1 Samuel', 8, ARRAY['8:4', '8:5', '8:6']::text[], 'pending_review', '[{"left":"Locul unde bătrânii s-au întâlnit cu Samuel","right":"Rama"},{"left":"Ce au spus despre vârsta lui Samuel","right":"Era bătrân"},{"left":"Ce au spus despre fiii lui","right":"Nu călcau pe urmele lui"},{"left":"Ce conducător au cerut","right":"Un împărat"},{"left":"Cum a reacționat Samuel la cererea lor","right":"Nu i-a plăcut și s-a rugat Domnului"}]'::jsonb),
  ('1 Samuel', 8, ARRAY['8:7', '8:8', '8:9']::text[], 'pending_review', '[{"left":"Pe cine lepăda poporul prin cererea făcută","right":"Pe Domnul"},{"left":"Ce nu mai voia poporul să facă Domnul","right":"Să domnească peste el"},{"left":"De când se purtase Israel astfel, potrivit Domnului","right":"De la scoaterea lui din Egipt"},{"left":"Cui slujise Israel","right":"Altori dumnezei"},{"left":"Ce trebuia Samuel să le facă cunoscut","right":"Dreptul împăratului"}]'::jsonb),
  ('1 Samuel', 8, ARRAY['8:10', '8:11', '8:12']::text[], 'pending_review', '[{"left":"Cui a transmis Samuel cuvintele Domnului","right":"Poporului care cerea împărat"},{"left":"Unde urma să-i pună împăratul pe unii dintre fii","right":"La carele și între călăreții lui"},{"left":"Ce trebuiau să facă unii dintre fii înaintea carului","right":"Să alerge înaintea lui"},{"left":"Peste ce număr urma să pună căpetenii","right":"Peste o mie"},{"left":"La ce lucrare a câmpului urma să-i folosească","right":"La arat și la secerat"}]'::jsonb),
  ('1 Samuel', 8, ARRAY['8:12', '8:13']::text[], 'pending_review', '[{"left":"O categorie de căpetenii puse de împărat","right":"Căpetenii peste cincizeci"},{"left":"Uneltele de război făcute de fii","right":"Armele împăratului"},{"left":"Uneltele făcute pentru care","right":"Uneltele carelor împăratului"},{"left":"Ce urma să facă fetele","right":"Miresme"},{"left":"Alte lucruri pregătite de fete","right":"Mâncare și pâine"}]'::jsonb),
  ('1 Samuel', 8, ARRAY['8:14', '8:15']::text[], 'pending_review', '[{"left":"Bunurile luate în cea mai bună parte","right":"Câmpii, vii și măslini"},{"left":"Cui dădea împăratul această parte","right":"Slujitorilor lui"},{"left":"Din ce rod lua zeciuială","right":"Din rodul semințelor"},{"left":"Alt rod din care lua zeciuială","right":"Rodul viilor"},{"left":"Cui dădea zeciuiala din aceste roade","right":"Famenilor și slujitorilor lui"}]'::jsonb),
  ('1 Samuel', 8, ARRAY['8:16', '8:17']::text[], 'pending_review', '[{"left":"Persoane luate de împărat pentru lucrările lui","right":"Robii și roabele"},{"left":"Cei mai buni boi și măgari","right":"Îi întrebuința la lucrările lui"},{"left":"Din ce animale lua zeciuială","right":"Din oi"},{"left":"Ce parte lua din oi","right":"Zeciuială"},{"left":"Ce urmau să ajungă oamenii înșiși","right":"Slugile împăratului"}]'::jsonb),
  ('1 Samuel', 8, ARRAY['8:18', '8:19', '8:20']::text[], 'pending_review', '[{"left":"De ce avea să strige poporul împotriva împăratului","right":"Din pricina împăratului pe care îl alesese"},{"left":"Ce a spus Samuel că va face Domnul atunci","right":"Nu-i va asculta"},{"left":"Ce a refuzat poporul să facă","right":"Să asculte glasul lui Samuel"},{"left":"Cum voia poporul să fie","right":"Ca toate neamurile"},{"left":"Ce urma să facă împăratul în războaie","right":"Să-i cârmuiască"}]'::jsonb),
  ('1 Samuel', 8, ARRAY['8:19', '8:20']::text[], 'pending_review', '[{"left":"Conducătorul cerut în ciuda avertizării lui Samuel","right":"Un împărat"},{"left":"Cu cine voia poporul să se asemene","right":"Cu toate neamurile"},{"left":"Ce trebuia să facă împăratul pentru popor","right":"Să-l judece"},{"left":"Unde urma împăratul să meargă","right":"În fruntea poporului"},{"left":"În ce împrejurări urma să-i cârmuiască","right":"În războaie"}]'::jsonb),
  ('1 Samuel', 8, ARRAY['8:21', '8:22']::text[], 'pending_review', '[{"left":"Ce a făcut Samuel cu cererea auzită","right":"A spus-o în auzul Domnului"},{"left":"Ce i-a spus Domnul să asculte","right":"Glasul poporului"},{"left":"Ce trebuia Samuel să pună peste popor","right":"Un împărat"},{"left":"Cui le-a transmis Samuel cuvintele Domnului","right":"Bărbaților lui Israel"},{"left":"Unde le-a spus să se ducă fiecare","right":"În cetatea lui"}]'::jsonb),
  ('1 Samuel', 8, ARRAY['8:11', '8:12', '8:14', '8:15']::text[], 'pending_review', '[{"left":"Ce urma împăratul să facă cu unii dintre fii","right":"Să-i pună la carele și între călăreții lui"},{"left":"Ce urma să facă unele dintre fiice","right":"Să pregătească miresme, mâncare și pâine"},{"left":"Ce parte din câmpii și vii urma să ia","right":"Cea mai bună parte"},{"left":"Cui urma să dea partea cea mai bună","right":"Slujitorilor lui"},{"left":"Ce urma să ia din roade","right":"Zeciuială din semințe și vii"}]'::jsonb),
  ('1 Samuel', 8, ARRAY['8:3', '8:5', '8:6', '8:9']::text[], 'pending_review', '[{"left":"Ce făceau fiii lui Samuel cu dreptatea","right":"O călcau"},{"left":"Ce conducător a cerut poporul","right":"Un împărat ca la celelalte neamuri"},{"left":"Ce a făcut Samuel după ce a auzit cererea","right":"S-a rugat Domnului"},{"left":"Ce trebuia să le facă Samuel cunoscut","right":"Dreptul împăratului"},{"left":"Ce fapt trebuia să însoțească avertizarea","right":"Samuel să-i înștiințeze"}]'::jsonb),
  ('1 Samuel', 8, ARRAY['8:7', '8:8', '8:18', '8:22']::text[], 'pending_review', '[{"left":"Pe cine lepăda poporul prin cererea lui","right":"Pe Domnul"},{"left":"Ce făcuse Israel potrivit Domnului","right":"Îl părăsise și slujise altor dumnezei"},{"left":"Ce avea să facă poporul când împăratul îl apăsa","right":"Să strige împotriva lui"},{"left":"Ce a spus Domnul că va face atunci","right":"Nu-l va asculta"},{"left":"Ce trebuia Samuel să pună peste Israel","right":"Un împărat"}]'::jsonb)
) as incoming (book, chapter, source_references, status, pairs)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.pairs = incoming.pairs;

insert into public.questions_match (pairs, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.pairs, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('[{"left":"Rolul dat de Samuel fiilor săi","right":"Judecători peste Israel"},{"left":"Fiul întâi născut al lui Samuel","right":"Ioel"},{"left":"Al doilea fiu al lui Samuel","right":"Abia"},{"left":"Locul unde judecau cei doi fii","right":"Beer-Șeba"},{"left":"Purtarea fiilor față de dreptate","right":"Luau mită și călcau dreptatea"}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:1', '8:2', '8:3']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Locul unde bătrânii s-au întâlnit cu Samuel","right":"Rama"},{"left":"Ce au spus despre vârsta lui Samuel","right":"Era bătrân"},{"left":"Ce au spus despre fiii lui","right":"Nu călcau pe urmele lui"},{"left":"Ce conducător au cerut","right":"Un împărat"},{"left":"Cum a reacționat Samuel la cererea lor","right":"Nu i-a plăcut și s-a rugat Domnului"}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:4', '8:5', '8:6']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Pe cine lepăda poporul prin cererea făcută","right":"Pe Domnul"},{"left":"Ce nu mai voia poporul să facă Domnul","right":"Să domnească peste el"},{"left":"De când se purtase Israel astfel, potrivit Domnului","right":"De la scoaterea lui din Egipt"},{"left":"Cui slujise Israel","right":"Altori dumnezei"},{"left":"Ce trebuia Samuel să le facă cunoscut","right":"Dreptul împăratului"}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:7', '8:8', '8:9']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Cui a transmis Samuel cuvintele Domnului","right":"Poporului care cerea împărat"},{"left":"Unde urma să-i pună împăratul pe unii dintre fii","right":"La carele și între călăreții lui"},{"left":"Ce trebuiau să facă unii dintre fii înaintea carului","right":"Să alerge înaintea lui"},{"left":"Peste ce număr urma să pună căpetenii","right":"Peste o mie"},{"left":"La ce lucrare a câmpului urma să-i folosească","right":"La arat și la secerat"}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:10', '8:11', '8:12']::text[], 'pending_review', 'Codex'),
  ('[{"left":"O categorie de căpetenii puse de împărat","right":"Căpetenii peste cincizeci"},{"left":"Uneltele de război făcute de fii","right":"Armele împăratului"},{"left":"Uneltele făcute pentru care","right":"Uneltele carelor împăratului"},{"left":"Ce urma să facă fetele","right":"Miresme"},{"left":"Alte lucruri pregătite de fete","right":"Mâncare și pâine"}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:12', '8:13']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Bunurile luate în cea mai bună parte","right":"Câmpii, vii și măslini"},{"left":"Cui dădea împăratul această parte","right":"Slujitorilor lui"},{"left":"Din ce rod lua zeciuială","right":"Din rodul semințelor"},{"left":"Alt rod din care lua zeciuială","right":"Rodul viilor"},{"left":"Cui dădea zeciuiala din aceste roade","right":"Famenilor și slujitorilor lui"}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:14', '8:15']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Persoane luate de împărat pentru lucrările lui","right":"Robii și roabele"},{"left":"Cei mai buni boi și măgari","right":"Îi întrebuința la lucrările lui"},{"left":"Din ce animale lua zeciuială","right":"Din oi"},{"left":"Ce parte lua din oi","right":"Zeciuială"},{"left":"Ce urmau să ajungă oamenii înșiși","right":"Slugile împăratului"}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:16', '8:17']::text[], 'pending_review', 'Codex'),
  ('[{"left":"De ce avea să strige poporul împotriva împăratului","right":"Din pricina împăratului pe care îl alesese"},{"left":"Ce a spus Samuel că va face Domnul atunci","right":"Nu-i va asculta"},{"left":"Ce a refuzat poporul să facă","right":"Să asculte glasul lui Samuel"},{"left":"Cum voia poporul să fie","right":"Ca toate neamurile"},{"left":"Ce urma să facă împăratul în războaie","right":"Să-i cârmuiască"}]'::jsonb, 8, 3, '1 Samuel', ARRAY['8:18', '8:19', '8:20']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Conducătorul cerut în ciuda avertizării lui Samuel","right":"Un împărat"},{"left":"Cu cine voia poporul să se asemene","right":"Cu toate neamurile"},{"left":"Ce trebuia să facă împăratul pentru popor","right":"Să-l judece"},{"left":"Unde urma împăratul să meargă","right":"În fruntea poporului"},{"left":"În ce împrejurări urma să-i cârmuiască","right":"În războaie"}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:19', '8:20']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Ce a făcut Samuel cu cererea auzită","right":"A spus-o în auzul Domnului"},{"left":"Ce i-a spus Domnul să asculte","right":"Glasul poporului"},{"left":"Ce trebuia Samuel să pună peste popor","right":"Un împărat"},{"left":"Cui le-a transmis Samuel cuvintele Domnului","right":"Bărbaților lui Israel"},{"left":"Unde le-a spus să se ducă fiecare","right":"În cetatea lui"}]'::jsonb, 8, 2, '1 Samuel', ARRAY['8:21', '8:22']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Ce urma împăratul să facă cu unii dintre fii","right":"Să-i pună la carele și între călăreții lui"},{"left":"Ce urma să facă unele dintre fiice","right":"Să pregătească miresme, mâncare și pâine"},{"left":"Ce parte din câmpii și vii urma să ia","right":"Cea mai bună parte"},{"left":"Cui urma să dea partea cea mai bună","right":"Slujitorilor lui"},{"left":"Ce urma să ia din roade","right":"Zeciuială din semințe și vii"}]'::jsonb, 8, 3, '1 Samuel', ARRAY['8:11', '8:12', '8:14', '8:15']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Ce făceau fiii lui Samuel cu dreptatea","right":"O călcau"},{"left":"Ce conducător a cerut poporul","right":"Un împărat ca la celelalte neamuri"},{"left":"Ce a făcut Samuel după ce a auzit cererea","right":"S-a rugat Domnului"},{"left":"Ce trebuia să le facă Samuel cunoscut","right":"Dreptul împăratului"},{"left":"Ce fapt trebuia să însoțească avertizarea","right":"Samuel să-i înștiințeze"}]'::jsonb, 8, 3, '1 Samuel', ARRAY['8:3', '8:5', '8:6', '8:9']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Pe cine lepăda poporul prin cererea lui","right":"Pe Domnul"},{"left":"Ce făcuse Israel potrivit Domnului","right":"Îl părăsise și slujise altor dumnezei"},{"left":"Ce avea să facă poporul când împăratul îl apăsa","right":"Să strige împotriva lui"},{"left":"Ce a spus Domnul că va face atunci","right":"Nu-l va asculta"},{"left":"Ce trebuia Samuel să pună peste Israel","right":"Un împărat"}]'::jsonb, 8, 3, '1 Samuel', ARRAY['8:7', '8:8', '8:18', '8:22']::text[], 'pending_review', 'Codex')
) as incoming (pairs, chapter, difficulty, book, source_references, status, added_by)
where not exists (
  select 1 from public.questions_match existing
  where existing.book = incoming.book
    and existing.chapter = incoming.chapter
    and existing.source_references = incoming.source_references
    and existing.pairs = incoming.pairs
);

commit;
