begin;

update public.questions_tf as existing
set status = incoming.status
from (values
  ('1 Samuel', 15, ARRAY['15:1']::text[], 'pending_review', 'Samuel i-a spus lui Saul că Domnul îl trimisese să-l ungă împărat peste Israel și i-a cerut să asculte ce avea să-i spună Domnul.'),
  ('1 Samuel', 15, ARRAY['15:2']::text[], 'pending_review', 'Amalec îi astupase lui Israel drumul când poporul ieșea din Egipt.'),
  ('1 Samuel', 15, ARRAY['15:3']::text[], 'pending_review', 'Porunca transmisă lui Saul cerea nimicirea amaleciților și enumeră bărbați, femei, copii, prunci și animale între cele care nu trebuiau cruțate.'),
  ('1 Samuel', 15, ARRAY['15:4']::text[], 'pending_review', 'La Telaim, Saul a numărat două sute de mii de oameni pedeștri și zece mii de oameni din Iuda.'),
  ('1 Samuel', 15, ARRAY['15:5']::text[], 'pending_review', 'Ajuns la cetatea lui Amalec, Saul a pus oameni la pândă pe munte.'),
  ('1 Samuel', 15, ARRAY['15:6']::text[], 'pending_review', 'Saul le-a spus cheniților să iasă din mijlocul amaleciților, amintind bunăvoința lor față de Israel la ieșirea din Egipt; cheniții au plecat.'),
  ('1 Samuel', 15, ARRAY['15:7']::text[], 'pending_review', 'Saul a lovit Amalec de la Havila până la Șur, în fața Egiptului.'),
  ('1 Samuel', 15, ARRAY['15:8']::text[], 'pending_review', 'Saul l-a prins viu pe Agag, împăratul lui Amalec, iar poporul amalecit a fost nimicit cu sabia.'),
  ('1 Samuel', 15, ARRAY['15:9']::text[], 'pending_review', 'Saul și poporul au nimicit cele mai bune animale și au cruțat numai animalele slabe și fără valoare.'),
  ('1 Samuel', 15, ARRAY['15:10', '15:11']::text[], 'pending_review', 'După ce Domnul i-a vorbit lui Samuel despre Saul, Samuel s-a mâhnit și a strigat toată noaptea către Domnul.'),
  ('1 Samuel', 15, ARRAY['15:12']::text[], 'pending_review', 'Când Samuel s-a sculat dis-de-dimineață să meargă la Saul, a aflat că acesta fusese la Carmel, își ridicase un semn de biruință și se coborâse la Ghilgal.'),
  ('1 Samuel', 15, ARRAY['15:13']::text[], 'pending_review', 'Când l-a întâlnit pe Samuel, Saul a recunoscut că nu păzise Cuvântul Domnului.'),
  ('1 Samuel', 15, ARRAY['15:14']::text[], 'pending_review', 'Samuel l-a întrebat pe Saul despre behăitul oilor și mugetul boilor pe care le auzea.'),
  ('1 Samuel', 15, ARRAY['15:15']::text[], 'pending_review', 'Saul i-a spus lui Samuel că poporul cruțase cele mai bune oi și vite ca să le jertfească Domnului, iar pe celelalte le nimicise.'),
  ('1 Samuel', 15, ARRAY['15:16']::text[], 'pending_review', 'Samuel i-a spus lui Saul să aștepte ca să-i spună ce îi comunicase Domnul în noaptea precedentă, iar Saul i-a răspuns să vorbească.'),
  ('1 Samuel', 15, ARRAY['15:17']::text[], 'pending_review', 'Samuel i-a amintit lui Saul că fusese căpetenia semințiilor lui Israel și că Domnul îl unsese împărat peste Israel.'),
  ('1 Samuel', 15, ARRAY['15:18']::text[], 'pending_review', 'Samuel i-a reamintit lui Saul că Domnul îi ceruse să lupte cu amaleciții până când aceștia aveau să fie nimiciți.'),
  ('1 Samuel', 15, ARRAY['15:19']::text[], 'pending_review', 'Samuel l-a întrebat pe Saul de ce nu ascultase glasul Domnului și de ce se aruncase asupra prăzii.'),
  ('1 Samuel', 15, ARRAY['15:20']::text[], 'pending_review', 'Saul a spus că el ascultase glasul Domnului, îl adusese pe Agag și nimicise amaleciții.'),
  ('1 Samuel', 15, ARRAY['15:21']::text[], 'pending_review', 'Saul a spus că el și armata lui aleseseră oi și boi pentru jertfă, fără să dea vina pe popor.'),
  ('1 Samuel', 15, ARRAY['15:22']::text[], 'pending_review', 'Samuel l-a învățat pe Saul că ascultarea de glasul Domnului și păzirea cuvântului Său prețuiesc mai mult decât jertfele și grăsimea berbecilor.'),
  ('1 Samuel', 15, ARRAY['15:23']::text[], 'pending_review', 'Samuel a asemănat neascultarea cu ghicirea și împotrivirea cu închinarea la idoli și terafimi.'),
  ('1 Samuel', 15, ARRAY['15:24']::text[], 'pending_review', 'Saul a mărturisit că se temuse de popor și îi ascultase glasul.'),
  ('1 Samuel', 15, ARRAY['15:25', '15:26']::text[], 'pending_review', 'Saul i-a cerut lui Samuel să se întoarcă împreună cu el ca să se închine Domnului, dar Samuel a refuzat pentru că Saul lepădase Cuvântul Domnului.'),
  ('1 Samuel', 15, ARRAY['15:27']::text[], 'pending_review', 'Când Samuel s-a întors să plece, Saul l-a apucat de pulpana hainei, iar aceasta s-a rupt.'),
  ('1 Samuel', 15, ARRAY['15:28']::text[], 'pending_review', 'Samuel i-a spus lui Saul că Domnul îi dădea domnia altuia mai bun decât el.'),
  ('1 Samuel', 15, ARRAY['15:29']::text[], 'pending_review', 'Samuel a spus că Tăria lui Israel minte și Se căiește, fiindcă este un om ca să-I pară rău.'),
  ('1 Samuel', 15, ARRAY['15:30', '15:31']::text[], 'pending_review', 'Saul i-a cerut lui Samuel să-l cinstească înaintea bătrânilor și a lui Israel; apoi Samuel s-a întors după Saul, iar Saul s-a închinat Domnului.'),
  ('1 Samuel', 15, ARRAY['15:32', '15:33']::text[], 'pending_review', 'Agag a înaintat vesel spre Samuel, iar Samuel l-a tăiat în bucăți înaintea Domnului, la Ghilgal.'),
  ('1 Samuel', 15, ARRAY['15:34', '15:35']::text[], 'pending_review', 'Samuel a plecat la Rama, Saul s-a suit acasă la Ghibea, iar Samuel l-a plâns pe Saul și nu s-a mai dus să-l vadă până la moartea sa.')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_tf (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Samuel i-a spus lui Saul că Domnul îl trimisese să-l ungă împărat peste Israel și i-a cerut să asculte ce avea să-i spună Domnul.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:1']::text[], 'pending_review', 'Codex'),
  ('Amalec îi astupase lui Israel drumul când poporul ieșea din Egipt.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:2']::text[], 'pending_review', 'Codex'),
  ('Porunca transmisă lui Saul cerea nimicirea amaleciților și enumeră bărbați, femei, copii, prunci și animale între cele care nu trebuiau cruțate.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:3']::text[], 'pending_review', 'Codex'),
  ('La Telaim, Saul a numărat două sute de mii de oameni pedeștri și zece mii de oameni din Iuda.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:4']::text[], 'pending_review', 'Codex'),
  ('Ajuns la cetatea lui Amalec, Saul a pus oameni la pândă pe munte.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:5']::text[], 'pending_review', 'Codex'),
  ('Saul le-a spus cheniților să iasă din mijlocul amaleciților, amintind bunăvoința lor față de Israel la ieșirea din Egipt; cheniții au plecat.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:6']::text[], 'pending_review', 'Codex'),
  ('Saul a lovit Amalec de la Havila până la Șur, în fața Egiptului.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:7']::text[], 'pending_review', 'Codex'),
  ('Saul l-a prins viu pe Agag, împăratul lui Amalec, iar poporul amalecit a fost nimicit cu sabia.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:8']::text[], 'pending_review', 'Codex'),
  ('Saul și poporul au nimicit cele mai bune animale și au cruțat numai animalele slabe și fără valoare.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:9']::text[], 'pending_review', 'Codex'),
  ('După ce Domnul i-a vorbit lui Samuel despre Saul, Samuel s-a mâhnit și a strigat toată noaptea către Domnul.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:10', '15:11']::text[], 'pending_review', 'Codex'),
  ('Când Samuel s-a sculat dis-de-dimineață să meargă la Saul, a aflat că acesta fusese la Carmel, își ridicase un semn de biruință și se coborâse la Ghilgal.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:12']::text[], 'pending_review', 'Codex'),
  ('Când l-a întâlnit pe Samuel, Saul a recunoscut că nu păzise Cuvântul Domnului.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:13']::text[], 'pending_review', 'Codex'),
  ('Samuel l-a întrebat pe Saul despre behăitul oilor și mugetul boilor pe care le auzea.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:14']::text[], 'pending_review', 'Codex'),
  ('Saul i-a spus lui Samuel că poporul cruțase cele mai bune oi și vite ca să le jertfească Domnului, iar pe celelalte le nimicise.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:15']::text[], 'pending_review', 'Codex'),
  ('Samuel i-a spus lui Saul să aștepte ca să-i spună ce îi comunicase Domnul în noaptea precedentă, iar Saul i-a răspuns să vorbească.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:16']::text[], 'pending_review', 'Codex'),
  ('Samuel i-a amintit lui Saul că fusese căpetenia semințiilor lui Israel și că Domnul îl unsese împărat peste Israel.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:17']::text[], 'pending_review', 'Codex'),
  ('Samuel i-a reamintit lui Saul că Domnul îi ceruse să lupte cu amaleciții până când aceștia aveau să fie nimiciți.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:18']::text[], 'pending_review', 'Codex'),
  ('Samuel l-a întrebat pe Saul de ce nu ascultase glasul Domnului și de ce se aruncase asupra prăzii.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:19']::text[], 'pending_review', 'Codex'),
  ('Saul a spus că el ascultase glasul Domnului, îl adusese pe Agag și nimicise amaleciții.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:20']::text[], 'pending_review', 'Codex'),
  ('Saul a spus că el și armata lui aleseseră oi și boi pentru jertfă, fără să dea vina pe popor.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:21']::text[], 'pending_review', 'Codex'),
  ('Samuel l-a învățat pe Saul că ascultarea de glasul Domnului și păzirea cuvântului Său prețuiesc mai mult decât jertfele și grăsimea berbecilor.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 15, 3, '1 Samuel', ARRAY['15:22']::text[], 'pending_review', 'Codex'),
  ('Samuel a asemănat neascultarea cu ghicirea și împotrivirea cu închinarea la idoli și terafimi.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 15, 3, '1 Samuel', ARRAY['15:23']::text[], 'pending_review', 'Codex'),
  ('Saul a mărturisit că se temuse de popor și îi ascultase glasul.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:24']::text[], 'pending_review', 'Codex'),
  ('Saul i-a cerut lui Samuel să se întoarcă împreună cu el ca să se închine Domnului, dar Samuel a refuzat pentru că Saul lepădase Cuvântul Domnului.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:25', '15:26']::text[], 'pending_review', 'Codex'),
  ('Când Samuel s-a întors să plece, Saul l-a apucat de pulpana hainei, iar aceasta s-a rupt.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:27']::text[], 'pending_review', 'Codex'),
  ('Samuel i-a spus lui Saul că Domnul îi dădea domnia altuia mai bun decât el.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:28']::text[], 'pending_review', 'Codex'),
  ('Samuel a spus că Tăria lui Israel minte și Se căiește, fiindcă este un om ca să-I pară rău.', '[{"text":"Adevărat","correct":false},{"text":"Fals","correct":true}]'::jsonb, 15, 3, '1 Samuel', ARRAY['15:29']::text[], 'pending_review', 'Codex'),
  ('Saul i-a cerut lui Samuel să-l cinstească înaintea bătrânilor și a lui Israel; apoi Samuel s-a întors după Saul, iar Saul s-a închinat Domnului.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:30', '15:31']::text[], 'pending_review', 'Codex'),
  ('Agag a înaintat vesel spre Samuel, iar Samuel l-a tăiat în bucăți înaintea Domnului, la Ghilgal.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:32', '15:33']::text[], 'pending_review', 'Codex'),
  ('Samuel a plecat la Rama, Saul s-a suit acasă la Ghibea, iar Samuel l-a plâns pe Saul și nu s-a mai dus să-l vadă până la moartea sa.', '[{"text":"Adevărat","correct":true},{"text":"Fals","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:34', '15:35']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 15, ARRAY['15:1']::text[], 'pending_review', 'Cine i-a spus lui Saul că Domnul îl trimisese să-l ungă împărat peste Israel?'),
  ('1 Samuel', 15, ARRAY['15:2']::text[], 'pending_review', 'Ce faptă a lui Amalec față de Israel a amintit Domnul?'),
  ('1 Samuel', 15, ARRAY['15:3']::text[], 'pending_review', 'Care variantă reproduce lista completă de animale din porunca adresată lui Saul despre nimicirea amaleciților?'),
  ('1 Samuel', 15, ARRAY['15:4']::text[], 'pending_review', 'Unde a numărat Saul poporul înainte de lupta cu Amalec?'),
  ('1 Samuel', 15, ARRAY['15:4']::text[], 'pending_review', 'Câți oameni din Iuda au fost numărați la Telaim?'),
  ('1 Samuel', 15, ARRAY['15:5']::text[], 'pending_review', 'Unde a pus Saul oameni la pândă când a ajuns la cetatea lui Amalec?'),
  ('1 Samuel', 15, ARRAY['15:6']::text[], 'pending_review', 'Ce motiv le-a dat Saul cheniților ca să plece din mijlocul amaleciților?'),
  ('1 Samuel', 15, ARRAY['15:7']::text[], 'pending_review', 'Între ce locuri a lovit Saul pe Amalec?'),
  ('1 Samuel', 15, ARRAY['15:8']::text[], 'pending_review', 'Cine era Agag, pe care Saul l-a prins viu?'),
  ('1 Samuel', 15, ARRAY['15:9']::text[], 'pending_review', 'Ce au cruțat Saul și poporul dintre prada amaleciților?'),
  ('1 Samuel', 15, ARRAY['15:11']::text[], 'pending_review', 'Cum a reacționat Samuel după ce Domnul i-a spus că Saul se abătuse și nu-I păzise cuvintele?'),
  ('1 Samuel', 15, ARRAY['15:12']::text[], 'pending_review', 'Ce a înălțat Saul la Carmel, potrivit celor spuse lui Samuel?'),
  ('1 Samuel', 15, ARRAY['15:13']::text[], 'pending_review', 'Ce a afirmat Saul când Samuel a ajuns la el?'),
  ('1 Samuel', 15, ARRAY['15:14']::text[], 'pending_review', 'Ce sunete i-au atras atenția lui Samuel când a vorbit cu Saul?'),
  ('1 Samuel', 15, ARRAY['15:15']::text[], 'pending_review', 'Potrivit explicației lui Saul, de ce au fost cruțate cele mai bune oi și vite?'),
  ('1 Samuel', 15, ARRAY['15:17']::text[], 'pending_review', 'Ce a spus Samuel despre cum se vedea Saul când Domnul l-a pus căpetenia semințiilor lui Israel?'),
  ('1 Samuel', 15, ARRAY['15:18']::text[], 'pending_review', 'Până când trebuia Saul să se războiască cu amaleciții, potrivit poruncii amintite de Samuel?'),
  ('1 Samuel', 15, ARRAY['15:19']::text[], 'pending_review', 'Ce l-a întrebat Samuel pe Saul că făcuse cu prada?'),
  ('1 Samuel', 15, ARRAY['15:29']::text[], 'pending_review', 'Ce a spus Samuel despre Tăria lui Israel când Saul i-a cerut să se întoarcă?'),
  ('1 Samuel', 15, ARRAY['15:21']::text[], 'pending_review', 'Unde a spus Saul că poporul urma să aducă oi și boi ca jertfă?'),
  ('1 Samuel', 15, ARRAY['15:22']::text[], 'pending_review', 'Potrivit lui Samuel, ce face mai mult decât jertfele?'),
  ('1 Samuel', 15, ARRAY['15:23']::text[], 'pending_review', 'Ce a spus Samuel că va face Domnul cu Saul după ce acesta a lepădat Cuvântul Domnului?'),
  ('1 Samuel', 15, ARRAY['15:24']::text[], 'pending_review', 'De ce a spus Saul că nu ascultase porunca Domnului?'),
  ('1 Samuel', 15, ARRAY['15:25']::text[], 'pending_review', 'Ce i-a cerut Saul lui Samuel după ce i-a cerut iertare?'),
  ('1 Samuel', 15, ARRAY['15:26']::text[], 'pending_review', 'De ce a refuzat Samuel să se întoarcă împreună cu Saul?'),
  ('1 Samuel', 15, ARRAY['15:28']::text[], 'pending_review', 'Cui urma Domnul să-i dea domnia, potrivit cuvintelor lui Samuel?'),
  ('1 Samuel', 15, ARRAY['15:30']::text[], 'pending_review', 'Înaintea cui i-a cerut Saul lui Samuel să-l cinstească?'),
  ('1 Samuel', 15, ARRAY['15:32']::text[], 'pending_review', 'Cum a înaintat Agag spre Samuel când a fost chemat?'),
  ('1 Samuel', 15, ARRAY['15:33']::text[], 'pending_review', 'Unde l-a tăiat Samuel pe Agag în bucăți?'),
  ('1 Samuel', 15, ARRAY['15:33']::text[], 'pending_review', 'Ce a spus Samuel despre mama lui Agag, comparând cu urmările sabiei lui Agag?')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_abc_one (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Cine i-a spus lui Saul că Domnul îl trimisese să-l ungă împărat peste Israel?', '[{"text":"Samuel","correct":true},{"text":"Ionatan","correct":false},{"text":"Ahia","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:1']::text[], 'pending_review', 'Codex'),
  ('Ce faptă a lui Amalec față de Israel a amintit Domnul?', '[{"text":"Că îi astupase drumul la ieșirea din Egipt","correct":true},{"text":"Că îi condusese prin pustie","correct":false},{"text":"Că îi dăduse hrană în Egipt","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:2']::text[], 'pending_review', 'Codex'),
  ('Care variantă reproduce lista completă de animale din porunca adresată lui Saul despre nimicirea amaleciților?', '[{"text":"Cămile, măgari, boi și oi","correct":true},{"text":"Cai, cămile, porumbei și capre","correct":false},{"text":"Numai boi și oi","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:3']::text[], 'pending_review', 'Codex'),
  ('Unde a numărat Saul poporul înainte de lupta cu Amalec?', '[{"text":"La Telaim","correct":true},{"text":"La Carmel","correct":false},{"text":"La Ghilgal","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:4']::text[], 'pending_review', 'Codex'),
  ('Câți oameni din Iuda au fost numărați la Telaim?', '[{"text":"Zece mii","correct":true},{"text":"Douăzeci de mii","correct":false},{"text":"Două sute de mii","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:4']::text[], 'pending_review', 'Codex'),
  ('Unde a pus Saul oameni la pândă când a ajuns la cetatea lui Amalec?', '[{"text":"În vale","correct":true},{"text":"Pe munte","correct":false},{"text":"La porțile cetății","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:5']::text[], 'pending_review', 'Codex'),
  ('Ce motiv le-a dat Saul cheniților ca să plece din mijlocul amaleciților?', '[{"text":"Se purtaseră cu bunăvoință față de Israel la ieșirea din Egipt","correct":true},{"text":"Îi ajutaseră pe amaleciți în luptă","correct":false},{"text":"Îi ceruseră lui Samuel să-i scape","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:6']::text[], 'pending_review', 'Codex'),
  ('Între ce locuri a lovit Saul pe Amalec?', '[{"text":"De la Havila până la Șur, în fața Egiptului","correct":true},{"text":"De la Carmel până la Ghilgal","correct":false},{"text":"De la Telaim până la Rama","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:7']::text[], 'pending_review', 'Codex'),
  ('Cine era Agag, pe care Saul l-a prins viu?', '[{"text":"Împăratul lui Amalec","correct":true},{"text":"Căpetenia oștirii lui Israel","correct":false},{"text":"Unul dintre cheniți","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:8']::text[], 'pending_review', 'Codex'),
  ('Ce au cruțat Saul și poporul dintre prada amaleciților?', '[{"text":"Pe Agag și animalele cele mai bune","correct":true},{"text":"Numai animalele slabe","correct":false},{"text":"Numai oile, fără vite","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:9']::text[], 'pending_review', 'Codex'),
  ('Cum a reacționat Samuel după ce Domnul i-a spus că Saul se abătuse și nu-I păzise cuvintele?', '[{"text":"S-a mâhnit și a strigat toată noaptea către Domnul","correct":true},{"text":"A plecat imediat la Ghilgal","correct":false},{"text":"A strâns poporul la Telaim","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:11']::text[], 'pending_review', 'Codex'),
  ('Ce a înălțat Saul la Carmel, potrivit celor spuse lui Samuel?', '[{"text":"Un semn de biruință","correct":true},{"text":"Un altar pentru Agag","correct":false},{"text":"Un cort pentru cheniți","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:12']::text[], 'pending_review', 'Codex'),
  ('Ce a afirmat Saul când Samuel a ajuns la el?', '[{"text":"Că păzise Cuvântul Domnului","correct":true},{"text":"Că nu îl întâlnise pe Agag","correct":false},{"text":"Că poporul nu adusese pradă","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:13']::text[], 'pending_review', 'Codex'),
  ('Ce sunete i-au atras atenția lui Samuel când a vorbit cu Saul?', '[{"text":"Behăitul oilor și mugetul boilor","correct":true},{"text":"Răgetul cămilelor și nechezatul cailor","correct":false},{"text":"Strigătele poporului și sunetul trâmbițelor","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:14']::text[], 'pending_review', 'Codex'),
  ('Potrivit explicației lui Saul, de ce au fost cruțate cele mai bune oi și vite?', '[{"text":"Ca să fie jertfite Domnului","correct":true},{"text":"Ca să fie date cheniților","correct":false},{"text":"Ca să hrănească armata la întoarcere","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:15']::text[], 'pending_review', 'Codex'),
  ('Ce a spus Samuel despre cum se vedea Saul când Domnul l-a pus căpetenia semințiilor lui Israel?', '[{"text":"Ca fiind mic în ochii lui","correct":true},{"text":"Ca fiind mai bun decât toți împărații","correct":false},{"text":"Ca fiind conducătorul cheniților","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:17']::text[], 'pending_review', 'Codex'),
  ('Până când trebuia Saul să se războiască cu amaleciții, potrivit poruncii amintite de Samuel?', '[{"text":"Până îi nimicea","correct":true},{"text":"Până se retrăgeau în Egipt","correct":false},{"text":"Până când Samuel îl chema înapoi","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:18']::text[], 'pending_review', 'Codex'),
  ('Ce l-a întrebat Samuel pe Saul că făcuse cu prada?', '[{"text":"De ce se aruncase asupra ei","correct":true},{"text":"De ce o dăduse cheniților","correct":false},{"text":"De ce o dusese la Carmel","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:19']::text[], 'pending_review', 'Codex'),
  ('Ce a spus Samuel despre Tăria lui Israel când Saul i-a cerut să se întoarcă?', '[{"text":"Că nu minte și nu Se căiește, fiindcă nu este un om","correct":true},{"text":"Că minte și Se căiește ca un om","correct":false},{"text":"Că Își schimbă cuvântul când un împărat Îi cere","correct":false}]'::jsonb, 15, 3, '1 Samuel', ARRAY['15:29']::text[], 'pending_review', 'Codex'),
  ('Unde a spus Saul că poporul urma să aducă oi și boi ca jertfă?', '[{"text":"La Ghilgal","correct":true},{"text":"La Rama","correct":false},{"text":"La Havila","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:21']::text[], 'pending_review', 'Codex'),
  ('Potrivit lui Samuel, ce face mai mult decât jertfele?', '[{"text":"Ascultarea de glasul Domnului","correct":true},{"text":"Ridicarea unui semn de biruință","correct":false},{"text":"Păstrarea celor mai bune animale","correct":false}]'::jsonb, 15, 3, '1 Samuel', ARRAY['15:22']::text[], 'pending_review', 'Codex'),
  ('Ce a spus Samuel că va face Domnul cu Saul după ce acesta a lepădat Cuvântul Domnului?', '[{"text":"Îl va lepăda ca împărat","correct":true},{"text":"Îl va trimite din nou împotriva Amalecului","correct":false},{"text":"Îl va pune căpetenie peste Iuda","correct":false}]'::jsonb, 15, 3, '1 Samuel', ARRAY['15:23']::text[], 'pending_review', 'Codex'),
  ('De ce a spus Saul că nu ascultase porunca Domnului?', '[{"text":"Se temuse de popor și îi ascultase glasul","correct":true},{"text":"Se temuse de cheniți și plecase din vale","correct":false},{"text":"Nu auzise porunca lui Samuel","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:24']::text[], 'pending_review', 'Codex'),
  ('Ce i-a cerut Saul lui Samuel după ce i-a cerut iertare?', '[{"text":"Să se întoarcă împreună cu el ca să se închine Domnului","correct":true},{"text":"Să-i aducă pe cheniți înapoi","correct":false},{"text":"Să-l lase pe Agag să plece","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:25']::text[], 'pending_review', 'Codex'),
  ('De ce a refuzat Samuel să se întoarcă împreună cu Saul?', '[{"text":"Pentru că Saul lepădase Cuvântul Domnului","correct":true},{"text":"Pentru că Samuel nu plecase încă la Carmel","correct":false},{"text":"Pentru că poporul îl alesese pe Agag","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:26']::text[], 'pending_review', 'Codex'),
  ('Cui urma Domnul să-i dea domnia, potrivit cuvintelor lui Samuel?', '[{"text":"Unui om mai bun decât Saul","correct":true},{"text":"Lui Agag","correct":false},{"text":"Căpeteniei cheniților","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:28']::text[], 'pending_review', 'Codex'),
  ('Înaintea cui i-a cerut Saul lui Samuel să-l cinstească?', '[{"text":"Înaintea bătrânilor poporului și a lui Israel","correct":true},{"text":"Înaintea amaleciților și a cheniților","correct":false},{"text":"Înaintea preoților din Rama","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:30']::text[], 'pending_review', 'Codex'),
  ('Cum a înaintat Agag spre Samuel când a fost chemat?', '[{"text":"Vesel, crezând că amărăciunea morții trecuse","correct":true},{"text":"Furios, cerându-i lui Saul să-l elibereze","correct":false},{"text":"Plângând și cerând să fie trimis în Egipt","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:32']::text[], 'pending_review', 'Codex'),
  ('Unde l-a tăiat Samuel pe Agag în bucăți?', '[{"text":"La Ghilgal, înaintea Domnului","correct":true},{"text":"La Rama, înaintea lui Saul","correct":false},{"text":"La Carmel, înaintea bătrânilor","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:33']::text[], 'pending_review', 'Codex'),
  ('Ce a spus Samuel despre mama lui Agag, comparând cu urmările sabiei lui Agag?', '[{"text":"Că și mama lui va fi lăsată fără copii între femei","correct":true},{"text":"Că mama lui îl va însoți la Ghibea","correct":false},{"text":"Că mama lui va fi cruțată și trimisă la Rama","correct":false}]'::jsonb, 15, 3, '1 Samuel', ARRAY['15:33']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 15, ARRAY['15:3', '15:4']::text[], 'pending_review', 'Care afirmații sunt susținute de porunca și numărătoarea făcute înaintea luptei?'),
  ('1 Samuel', 15, ARRAY['15:5', '15:6']::text[], 'pending_review', 'Ce detalii sunt relatate despre plecarea cheniților și pregătirea atacului?'),
  ('1 Samuel', 15, ARRAY['15:8', '15:9']::text[], 'pending_review', 'Ce au făcut Saul și poporul cu Agag și cu prada?'),
  ('1 Samuel', 15, ARRAY['15:11', '15:12']::text[], 'pending_review', 'Ce este relatat despre Samuel și Saul în dimineața de după cuvintele Domnului?'),
  ('1 Samuel', 15, ARRAY['15:13', '15:14', '15:15']::text[], 'pending_review', 'Ce afirmații apar în dialogul dintre Saul și Samuel la întâlnirea lor?'),
  ('1 Samuel', 15, ARRAY['15:17', '15:18', '15:19']::text[], 'pending_review', 'Ce i-a reamintit Samuel lui Saul despre însărcinarea și acțiunile lui?'),
  ('1 Samuel', 15, ARRAY['15:20', '15:21']::text[], 'pending_review', 'Ce afirmații a făcut Saul despre ascultarea sa și despre animalele luate din pradă?'),
  ('1 Samuel', 15, ARRAY['15:22', '15:23', '15:24']::text[], 'pending_review', 'Care idei apar în cuvintele lui Samuel și în mărturisirea lui Saul?'),
  ('1 Samuel', 15, ARRAY['15:25', '15:26', '15:27', '15:28', '15:30', '15:31']::text[], 'pending_review', 'Ce detalii sunt consemnate după ce Samuel a refuzat să se întoarcă împreună cu Saul?')
) as incoming (book, chapter, source_references, status, text)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.text = incoming.text;

insert into public.questions_abc_multi (text, options, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.text, incoming.options, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('Care afirmații sunt susținute de porunca și numărătoarea făcute înaintea luptei?', '[{"text":"Porunca cerea să nu fie cruțate nici femeile, nici copiii și pruncii.","correct":true},{"text":"La Telaim au fost numărați 200.000 de oameni pedeștri și 10.000 din Iuda.","correct":true},{"text":"La Telaim au fost numărați 10.000 de oameni în total.","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:3', '15:4']::text[], 'pending_review', 'Codex'),
  ('Ce detalii sunt relatate despre plecarea cheniților și pregătirea atacului?', '[{"text":"Saul a pus oameni la pândă în vale, lângă cetatea lui Amalec.","correct":true},{"text":"Cheniții au plecat după ce Saul le-a amintit bunăvoința arătată lui Israel.","correct":true},{"text":"Cheniții au rămas cu amaleciții, iar Saul i-a atacat primii.","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:5', '15:6']::text[], 'pending_review', 'Codex'),
  ('Ce au făcut Saul și poporul cu Agag și cu prada?', '[{"text":"Agag, împăratul lui Amalec, a fost prins viu.","correct":true},{"text":"Au cruțat cele mai bune oi, boi, vite grase și miei grași.","correct":true},{"text":"Au cruțat doar animalele slabe și fără valoare.","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:8', '15:9']::text[], 'pending_review', 'Codex'),
  ('Ce este relatat despre Samuel și Saul în dimineața de după cuvintele Domnului?', '[{"text":"Samuel a strigat către Domnul toată noaptea, fiind mâhnit.","correct":true},{"text":"Saul se dusese la Carmel, unde își înălțase un semn de biruință, apoi coborâse la Ghilgal.","correct":true},{"text":"Samuel a aflat că Saul se retrăsese la Rama și își dărâmase semnul de biruință.","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:11', '15:12']::text[], 'pending_review', 'Codex'),
  ('Ce afirmații apar în dialogul dintre Saul și Samuel la întâlnirea lor?', '[{"text":"Saul i-a spus lui Samuel că păzise Cuvântul Domnului.","correct":true},{"text":"Samuel l-a întrebat despre behăitul oilor și mugetul boilor.","correct":true},{"text":"Saul i-a spus că Agag adusese oile și boii ca să fie jertfiți.","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:13', '15:14', '15:15']::text[], 'pending_review', 'Codex'),
  ('Ce i-a reamintit Samuel lui Saul despre însărcinarea și acțiunile lui?', '[{"text":"Domnul îl unsese împărat peste Israel când era mic în ochii lui.","correct":true},{"text":"Domnul îi poruncise să lupte cu amaleciții până la nimicirea lor.","correct":true},{"text":"Domnul îi poruncise să păstreze prada pentru jertfe.","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:17', '15:18', '15:19']::text[], 'pending_review', 'Codex'),
  ('Ce afirmații a făcut Saul despre ascultarea sa și despre animalele luate din pradă?', '[{"text":"A susținut că ascultase glasul Domnului și adusese viu pe Agag.","correct":true},{"text":"A spus că poporul luase oi și boi pentru jertfă la Ghilgal.","correct":true},{"text":"A spus că Samuel îl îndemnase să păstreze prada.","correct":false}]'::jsonb, 15, 3, '1 Samuel', ARRAY['15:20', '15:21']::text[], 'pending_review', 'Codex'),
  ('Care idei apar în cuvintele lui Samuel și în mărturisirea lui Saul?', '[{"text":"Samuel a spus că ascultarea și păzirea Cuvântului valorează mai mult decât jertfele.","correct":true},{"text":"Samuel a asemănat neascultarea cu ghicirea și împotrivirea cu închinarea la idoli.","correct":true},{"text":"Saul a spus că se temuse de Samuel și nu îi ascultase glasul.","correct":false}]'::jsonb, 15, 3, '1 Samuel', ARRAY['15:22', '15:23', '15:24']::text[], 'pending_review', 'Codex'),
  ('Ce detalii sunt consemnate după ce Samuel a refuzat să se întoarcă împreună cu Saul?', '[{"text":"Saul a apucat de pulpana hainei lui Samuel, iar haina s-a rupt.","correct":true},{"text":"Samuel a spus că domnia va fi dată altuia mai bun decât Saul.","correct":true},{"text":"Samuel i-a promis lui Saul că nu va pierde domnia dacă îl cinstește înaintea bătrânilor.","correct":false}]'::jsonb, 15, 2, '1 Samuel', ARRAY['15:25', '15:26', '15:27', '15:28', '15:30', '15:31']::text[], 'pending_review', 'Codex')
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
  ('1 Samuel', 15, ARRAY['15:2', '15:3', '15:4', '15:5', '15:6']::text[], 'pending_review', '[{"left":"Amalec","right":"Astupase drumul lui Israel la ieșirea din Egipt"},{"left":"Locul numărării poporului","right":"Telaim"},{"left":"Oamenii din Iuda numărați","right":"Zece mii"},{"left":"Locul unde au fost puși oameni la pândă","right":"Valea de lângă cetatea lui Amalec"},{"left":"Motivul pentru care cheniții au fost cruțați","right":"Bunăvoința arătată lui Israel la ieșirea din Egipt"}]'::jsonb),
  ('1 Samuel', 15, ARRAY['15:7', '15:8', '15:9', '15:12', '15:14']::text[], 'pending_review', '[{"left":"Întinderea luptei cu Amalec","right":"De la Havila până la Șur, în fața Egiptului"},{"left":"Agag","right":"Împăratul lui Amalec, prins viu"},{"left":"Ce a fost cruțat din pradă","right":"Agag și animalele cele mai bune"},{"left":"Carmel","right":"Locul unde Saul și-a înălțat un semn de biruință"},{"left":"Samuel auzea","right":"Behăitul oilor și mugetul boilor"}]'::jsonb),
  ('1 Samuel', 15, ARRAY['15:17', '15:22', '15:23', '15:24', '15:28']::text[], 'pending_review', '[{"left":"Samuel îi amintește lui Saul","right":"Saul fusese mic în ochii lui, iar Domnul îl unsese împărat peste Israel"},{"left":"Ce prețuiește mai mult decât jertfele","right":"Ascultarea de glasul Domnului"},{"left":"Neascultarea","right":"Asemănată cu ghicirea"},{"left":"Motivul mărturisit de Saul","right":"Se temuse de popor și îi ascultase glasul"},{"left":"Soarta domniei lui Saul","right":"Dată unui om mai bun decât el"}]'::jsonb)
) as incoming (book, chapter, source_references, status, pairs)
where existing.added_by = 'Codex'
  and existing.book = incoming.book
  and existing.chapter = incoming.chapter
  and existing.source_references = incoming.source_references
  and existing.pairs = incoming.pairs;

insert into public.questions_match (pairs, chapter, difficulty, book, source_references, status, added_by, created_at)
select incoming.pairs, incoming.chapter, incoming.difficulty, incoming.book, incoming.source_references, incoming.status, incoming.added_by, now()
from (values
  ('[{"left":"Amalec","right":"Astupase drumul lui Israel la ieșirea din Egipt"},{"left":"Locul numărării poporului","right":"Telaim"},{"left":"Oamenii din Iuda numărați","right":"Zece mii"},{"left":"Locul unde au fost puși oameni la pândă","right":"Valea de lângă cetatea lui Amalec"},{"left":"Motivul pentru care cheniții au fost cruțați","right":"Bunăvoința arătată lui Israel la ieșirea din Egipt"}]'::jsonb, 15, 3, '1 Samuel', ARRAY['15:2', '15:3', '15:4', '15:5', '15:6']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Întinderea luptei cu Amalec","right":"De la Havila până la Șur, în fața Egiptului"},{"left":"Agag","right":"Împăratul lui Amalec, prins viu"},{"left":"Ce a fost cruțat din pradă","right":"Agag și animalele cele mai bune"},{"left":"Carmel","right":"Locul unde Saul și-a înălțat un semn de biruință"},{"left":"Samuel auzea","right":"Behăitul oilor și mugetul boilor"}]'::jsonb, 15, 3, '1 Samuel', ARRAY['15:7', '15:8', '15:9', '15:12', '15:14']::text[], 'pending_review', 'Codex'),
  ('[{"left":"Samuel îi amintește lui Saul","right":"Saul fusese mic în ochii lui, iar Domnul îl unsese împărat peste Israel"},{"left":"Ce prețuiește mai mult decât jertfele","right":"Ascultarea de glasul Domnului"},{"left":"Neascultarea","right":"Asemănată cu ghicirea"},{"left":"Motivul mărturisit de Saul","right":"Se temuse de popor și îi ascultase glasul"},{"left":"Soarta domniei lui Saul","right":"Dată unui om mai bun decât el"}]'::jsonb, 15, 3, '1 Samuel', ARRAY['15:17', '15:22', '15:23', '15:24', '15:28']::text[], 'pending_review', 'Codex')
) as incoming (pairs, chapter, difficulty, book, source_references, status, added_by)
where not exists (
  select 1 from public.questions_match existing
  where existing.book = incoming.book
    and existing.chapter = incoming.chapter
    and existing.source_references = incoming.source_references
    and existing.pairs = incoming.pairs
);

commit;
