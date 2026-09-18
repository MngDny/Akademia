const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const { spawnSync } = require('node:child_process');
const { JSDOM, VirtualConsole } = require('jsdom');
const root = path.resolve(__dirname, '..');
const read = p => fs.readFileSync(path.join(root, p), 'utf8');
const bibleSource = read('assets/js/core/bibleBooks.js');
const bibleListSource = bibleSource.match(/BIBLE_BOOKS = Object\.freeze\(\[([\s\S]*?)\]\);/)[1];
const bibleBooks = bibleListSource.match(/"[^"]+"/g).map(value => value.slice(1, -1));
const walk = d => fs.readdirSync(path.join(root,d), {withFileTypes:true}).flatMap(e => e.isDirectory() ? walk(path.join(d,e.name)) : [path.join(d,e.name)]);
const flush = async () => { for(let i=0;i<8;i++) await new Promise(resolve => setImmediate(resolve)); };
const rows = Array.from({length:12}, (_,i)=>({ id: `question-${i}`, text:`Întrebarea de verificare ${i+1}`, book:'Geneza', chapter:1, difficulty:2, status:'active', created_at:new Date().toISOString(), options:[{text:'Adevărat',correct:true},{text:'Fals',correct:false}], pairs:Array.from({length:5},(_,j)=>({left:`Stânga ${j}`,right:`Dreapta ${j}`})) }));

async function page(file, { role = file.includes('instructor') ? 'instructor' : file.includes('admin') ? 'admin' : 'student', mobile = false, fetcher, signIn, records, queryError, queryLog = [], localStorageData = {} } = {}) {
  const errors = [];
  const console = new VirtualConsole();
  console.on('jsdomError', error => errors.push(error));
  const dom = new JSDOM(read(file.split('?')[0]), {url:`http://localhost/${file.replaceAll('\\','/')}`, runScripts:'outside-only', virtualConsole:console, pretendToBeVisual:true});
  const w=dom.window, d=w.document;
  for(const [key,value] of Object.entries(localStorageData || {})) w.localStorage.setItem(key,value);
  const media = new w.EventTarget(); media.matches=mobile; w.matchMedia=()=>media;
  w.confirm=()=>false;
  w.fetch=fetcher || (async url=>({ok:true,json:async()=>String(url).includes('action=books') ? {books:['Geneza','Exodul']} : {rowsByType:{tf:rows.slice(0,2)}}}));
  w.supabase={createClient:()=>({
    auth:{getSession:async()=>({data:{session:{user:{id:'self',user_metadata:{username:'andrei'}},access_token:'test-only'}}}),signOut:async()=>({error:null}),signInWithPassword:signIn || (async()=>({error:{message:'Test failure'}})),resetPasswordForEmail:async()=>({error:null})},
    from(table) {
      let single=false;
      const query=new Proxy({}, {get(_,key) {
        if(key==='then') return resolve=>resolve({ data: single ? {role} : records?.[table] || (table==='accounts' ? [{id:'self',username:'andrei',role},{id:'student-1',username:'maria',role:'student'},{id:'instructor-1',username:'ioan',role:'instructor'}] : table.startsWith('questions_') ? rows : []), count:12, error:queryError || null });
        return (...args)=>{queryLog.push({table,method:key,args});if(key==='single')single=true;return query;};
      }}); return query;
    },
  })};
  const context=dom.getInternalVMContext();
  const cache=new Map();
  async function load(filename) {
    filename=path.resolve(filename);
    if(cache.has(filename))return cache.get(filename);
    const mod=new vm.SourceTextModule(fs.readFileSync(filename,'utf8'),{context,identifier:filename});
    cache.set(filename,mod);
    await mod.link((specifier,ref)=>load(path.resolve(path.dirname(ref.identifier),specifier)));
    return mod;
  }
  for(const script of d.querySelectorAll('script[type="module"][src]')) {
    const mod=await load(path.join(root,script.getAttribute('src')));
    await mod.evaluate();
  }
  await flush();
  return {dom,w,d,media,errors,load,close:()=>w.close()};
}

const htmlFiles=['index.html','login.html','register.html','reset-password.html',...walk('portal').filter(p=>p.endsWith('.html'))];
test('All portal pages have valid landmarks, unique IDs, labels and local resource targets',()=>{
  assert.equal(htmlFiles.length,22);
  for(const file of htmlFiles) {
    const dom=new JSDOM(read(file)); const d=dom.window.document;
    assert.equal(d.querySelectorAll('main').length,1,file);
    assert.equal(d.querySelectorAll('h1').length,1,file);
    const ids=[...d.querySelectorAll('[id]')].map(el=>el.id);
    assert.equal(new Set(ids).size,ids.length,`duplicate IDs: ${file}`);
    for(const el of d.querySelectorAll('input:not([type="hidden"]), textarea, select')) {
      assert.ok(el.labels?.length || el.hasAttribute('aria-label'),`missing label: ${file} #${el.id}`);
    }
    for(const el of d.querySelectorAll('[src],link[href],a[href]')) {
      const url=el.getAttribute('src')||el.getAttribute('href');
      if(!url || url.startsWith('#') || /^https?:/.test(url))continue;
      const target=decodeURI(url.split(/[?#]/)[0]);
      assert.ok(fs.existsSync(target.startsWith('/')?path.join(root,target):path.resolve(root,path.dirname(file),target)),`${file}: broken ${url}`);
    }
    dom.window.close();
  }
});

test('Every browser module has valid JavaScript syntax',()=>{
  for(const file of walk('assets/js').filter(p=>p.endsWith('.js'))) {
    const result=spawnSync(process.execPath,['--input-type=module','--check'],{input:read(file),encoding:'utf8'});
    assert.equal(result.status,0,`${file}: ${result.stderr}`);
  }
});

test('The canonical Bible catalogue contains 66 unique books',()=>{
  assert.equal(bibleBooks.length,66);
  assert.equal(new Set(bibleBooks).size,66);
  assert.equal(bibleBooks[0],'Geneza');
  assert.equal(bibleBooks.at(-1),'Apocalipsa');
});

for(const role of ['student','instructor','admin']) {
  test(`${role}: mobile navigation opens, traps focus, closes with Escape and resets on desktop`,async()=>{
    const p=await page(`portal/${role}/dashboard.html`,{mobile:true});
    try {
      const {d,w,media}=p, side=d.querySelector('#sidebar'), toggle=d.querySelector('.menu-toggle');
      assert.equal(side.inert,true); toggle.focus(); toggle.click();
      assert.equal(toggle.getAttribute('aria-expanded'),'true');
      assert.equal(d.querySelector('main').inert,true); assert.equal(side.inert,false);
      const last=side.querySelector('#logoutBtn');last.focus();
      d.dispatchEvent(new w.KeyboardEvent('keydown',{key:'Tab',bubbles:true,cancelable:true}));
      assert.equal(d.activeElement,side.querySelector('a'));
      d.dispatchEvent(new w.KeyboardEvent('keydown',{key:'Escape',bubbles:true}));
      assert.equal(toggle.getAttribute('aria-expanded'),'false'); assert.equal(d.activeElement,toggle); assert.equal(d.querySelector('main').inert,false);
      toggle.click(); media.matches=false;media.dispatchEvent(new w.Event('change'));
      assert.equal(side.inert,false);assert.equal(d.body.classList.contains('menu-open'),false);
      assert.equal(p.errors.length,0);
    } finally {p.close();}
  });
}

test('Every portal screen initializes with one active navigation destination',async()=>{
  const paths=htmlFiles.filter(p=>p.startsWith('portal'));
  for(const file of paths) {
    const p=await page(file);
    try {
      assert.equal(p.d.querySelectorAll('[aria-current="page"]').length,1,file);
      assert.equal(p.d.querySelectorAll('.portal-topbar').length,0,file);
      assert.equal(p.errors.length,0,`${file}: ${p.errors}`);
      for(const el of p.d.querySelectorAll('#sidebar a[href]')) assert.ok(fs.existsSync(path.join(root,new URL(el.href).pathname)),el.href);
    } finally {p.close();}
  }
});

test('Authentication submits once, keeps data on a network error, and recovers its button',async()=>{
  let calls=0;
  const p=await page('login.html',{signIn:async()=>{calls++;throw new Error('offline');}});
  try {
    p.d.querySelector('#email').value='test@example.com';p.d.querySelector('#password').value='Secret123!';
    const form=p.d.querySelector('form');
    form.dispatchEvent(new p.w.Event('submit',{bubbles:true,cancelable:true}));
    form.dispatchEvent(new p.w.Event('submit',{bubbles:true,cancelable:true}));
    await flush();assert.equal(calls,1);assert.equal(p.d.querySelector('#loginBtn').disabled,false);
    assert.match(p.d.querySelector('#error').innerText,/Conexiunea/);
    assert.equal(p.d.querySelector('#email').value,'test@example.com');
  } finally {p.close();}
});

test('Password visibility is keyboard-safe, announced, and does not submit registration',async()=>{
  let calls=0;
  const p=await page('register.html',{fetcher:async()=>{calls++;return {ok:false,json:async()=>({error:'Test'})};}});
  try {
    p.d.querySelector('#username').value='andrei'; p.d.querySelector('#email').value='test@example.com';
    p.d.querySelector('#password').value='Secret123!';p.d.querySelector('#confirmPassword').value='Secret123!';
    const toggle=p.d.querySelector('.toggle-password');toggle.click();
    assert.equal(p.d.querySelector('#password').type,'text');assert.equal(toggle.getAttribute('aria-pressed'),'true');
    toggle.dispatchEvent(new p.w.KeyboardEvent('keydown',{key:'Enter',bubbles:true}));await flush();assert.equal(calls,0);
    toggle.click();assert.equal(p.d.querySelector('#password').type,'password');
    p.d.querySelector('form').dispatchEvent(new p.w.Event('submit',{bubbles:true,cancelable:true}));await flush();assert.equal(calls,1);
  } finally {p.close();}
});

test('Administrator can filter users, switch sections, and cancel deletion',async()=>{
  let requests=0;
  const p=await page('portal/admin/dashboard.html',{fetcher:async()=>{requests++;throw new Error('No writes expected');}});
  try {
    p.d.querySelector('[data-section="manage-users"]').click();await flush();
    assert.equal(p.d.querySelector('#createUserSection').hidden,true);
    assert.equal(p.d.querySelectorAll('.user-row').length,3);
    p.d.querySelector('#userSearch').value='MAR';p.d.querySelector('#userSearch').dispatchEvent(new p.w.Event('input'));
    assert.equal(p.d.querySelectorAll('.user-row').length,1);assert.match(p.d.querySelector('.user-row').textContent,/maria/);
    p.d.querySelector('.delete-btn').click();await flush();assert.equal(requests,0);
    p.d.querySelector('#roleFilter').value='admin';p.d.querySelector('#roleFilter').dispatchEvent(new p.w.Event('change'));
    assert.match(p.d.querySelector('#usersList').textContent,/Niciun utilizator/);
    p.d.querySelector('[data-section="create-user"]').click();assert.equal(p.d.querySelector('#createUserSection').hidden,false);
  } finally {p.close();}
});

test('Question editor supports each type and exposes selected answers',async()=>{
  for(const type of ['tf','abc_one','abc_multi','match']) {
    const p=await page(`portal/instructor/questions/add.html?type=${type}`);
    try {
      assert.ok(p.d.querySelector('#formHost input'),type);
      for(const el of p.d.querySelectorAll('#formHost input:not([type="hidden"]), #formHost select, #formHost textarea')) assert.ok(el.labels?.length || el.hasAttribute('aria-label'),`${type}: unlabeled ${el.outerHTML}`);
      const chips=[...p.d.querySelectorAll('.answer-chip')];
      if(chips.length) { chips.at(-1).click();assert.equal(chips.at(-1).getAttribute('aria-pressed'),'true',type); }
      assert.equal(p.errors.length,0);
    } finally {p.close();}
  }
});

test('Learning flow selects a book, loads questions, checks an answer and filters progress',async()=>{
  const calls=[];
  const p=await page('portal/student/learning.html',{fetcher:async url=>{calls.push(String(url));return {ok:true,json:async()=>String(url).includes('action=books') ? {books:['Geneza','Exodul']} : {rowsByType:{tf:rows.slice(0,2)}}};}});
  try {
    p.d.querySelectorAll('.book-check-item input')[0].click();
    p.d.querySelectorAll('.book-check-item input')[1].click();
    assert.equal(p.d.querySelectorAll('.book-check-item input:checked').length,2);
    assert.equal(p.d.querySelectorAll('#selectedLearningBookChips .selected-book-chip').length,2);
    assert.equal(p.d.querySelector('#learningBookInfo').textContent,'2 cărți');
    p.d.querySelector('#learningStartBtn').click();await flush();
    assert.match(calls.find(url=>url.includes('action=questions')),/books=%5B%22Geneza%22%2C%22Exodul%22%5D/);
    assert.equal(p.d.querySelector('#learningStartBtn').disabled,false);
    assert.ok(p.d.querySelector('.option-input'));
    p.d.querySelector('.option-input').click();p.d.querySelector('#learningCheckBtn').click();await flush();
    assert.match(p.d.querySelector('#learningProgressText').textContent,/1\/2/);
    const filter=p.d.querySelector('[data-mode="wrong"]');filter.click();
    assert.equal(filter.getAttribute('aria-pressed'),'true');assert.equal(p.d.querySelector('#learningCheckBtn').disabled,true);
  } finally {p.close();}
});

test('Learning book picker falls back to all 66 canonical books when the function is unavailable',async()=>{
  const p=await page('portal/student/learning.html',{fetcher:async()=>({ok:false,json:async()=>({error:'offline'})})});
  try {
    assert.equal(p.d.querySelectorAll('#learningBookList .book-check-item').length,66);
    assert.match(p.d.querySelector('#learningStatus').textContent,/66 de cărți/);
    p.d.querySelector('#learningBookList .book-check-item input').click();
    assert.equal(p.d.querySelectorAll('#selectedLearningBookChips .selected-book-chip').length,1);
    assert.equal(p.errors.length,0);
  } finally {p.close();}
});

test('Quiz can start and retain selected answers when moving between questions',async()=>{
  let activeSnapshot;
  const queryLog=[];
  const p=await page('portal/student/quiz.html',{queryLog});
  try {
    p.d.querySelector('#selectAllBooksBtn').click();p.d.querySelector('#startBtn').click();await flush();
    assert.match(p.d.querySelector('#quizMeta').textContent,/Întrebarea 1 din 24/);
    assert.equal(p.d.querySelector('#startBtn').disabled,true);
    p.d.querySelector('.option-input').click();p.d.querySelector('#nextBtn').click();
    assert.match(p.d.querySelector('#quizMeta').textContent,/Întrebarea 2/);
    activeSnapshot=p.w.localStorage.getItem('akademia.quiz.active.v1');
    p.d.querySelector('#prevBtn').click();assert.ok(p.d.querySelector('.option-input:checked'));
    p.d.querySelector('#reportQuestionBtn').click();
    assert.equal(p.d.querySelector('#questionReportDialog').hidden,false);
    p.d.querySelector('#questionReportReason').value='incorrect';
    p.d.querySelector('#questionReportMessage').value='Răspunsul pare verificat greșit.';
    p.d.querySelector('#questionReportForm').dispatchEvent(new p.w.Event('submit',{bubbles:true,cancelable:true}));await flush();
    assert.match(p.d.querySelector('#questionReportStatus').textContent,/Raportarea a fost trimisă/);
    assert.ok(queryLog.some(entry=>entry.table==='question_reports' && entry.method==='insert'));
    assert.ok(activeSnapshot);
    assert.equal(p.d.querySelector('#abandonBtn').disabled,false);
    p.w.confirm=()=>true;p.d.querySelector('#abandonBtn').click();
    assert.equal(p.w.localStorage.getItem('akademia.quiz.active.v1'),null);
    assert.match(p.d.querySelector('#setupMessage').textContent,/abandonat/);
    assert.equal(p.errors.length,0);
  } finally {p.close();}

  const restored=await page('portal/student/quiz.html',{localStorageData:{'akademia.quiz.active.v1':activeSnapshot}});
  try {
    assert.match(restored.d.querySelector('#quizMeta').textContent,/Întrebarea 2 din 24/);
    assert.equal(restored.d.querySelector('#abandonBtn').disabled,false);
    assert.match(restored.d.querySelector('#setupMessage').textContent,/restaurat automat/);
    assert.equal(restored.d.querySelectorAll('#booksChecklist input:checked').length,66);
    assert.equal(restored.d.querySelectorAll('#selectedBooksChips .selected-book-chip').length,66);
    assert.match(restored.d.querySelector('#booksInfo').textContent,/66 cărți/);
    assert.equal(restored.errors.length,0);
  } finally {restored.close();}
});

test('Import source buttons switch the actual input panels',async()=>{
  const p=await page('portal/instructor/questions/import.html');
  try {
    p.d.querySelector('[data-source="file"]').click();
    assert.equal(p.d.querySelector('#filePanel').classList.contains('hidden'),false);
    assert.equal(p.d.querySelector('#textPanel').classList.contains('hidden'),true);
    p.d.querySelector('[data-source="text"]').click();assert.equal(p.d.querySelector('#textPanel').classList.contains('hidden'),false);
  } finally {p.close();}
});

test('Student dashboard filters the summary by year and includes all years',async()=>{
  const currentYear = new Date().getFullYear();
  const currentAttempt = {created_at:new Date().toISOString(),points_total:12,max_points:100,total_correct_answers:3,total_questions:10,duration_seconds:90};
  const previousAttempt = {created_at:new Date(currentYear - 1,5,15).toISOString(),points_total:8,max_points:100,total_correct_answers:2,total_questions:10,duration_seconds:60};
  const p=await page('portal/student/dashboard.html',{records:{student_test_attempts:[currentAttempt,previousAttempt]}});
  try {
    const filter=p.d.querySelector('#yearFilter');
    assert.equal(filter.value,String(currentYear));
    assert.ok([...filter.options].some(option=>option.value==='all'));
    assert.ok([...filter.options].some(option=>option.value===String(Math.max(2025,currentYear-1))));
    assert.equal(p.d.querySelector('#testsCount').textContent,'1');
    filter.value='all';filter.dispatchEvent(new p.w.Event('change'));
    assert.equal(p.d.querySelector('#testsCount').textContent,'2');
    assert.match(p.d.querySelector('#performancePeriod').textContent,/Toți anii/);
    assert.equal(p.errors.length,0);
  } finally {p.close();}
});

test('Bibliografia folosește perioada 2026-2027 și filtrează categoria',async()=>{
  const student=await page('portal/student/bibliography.html');
  try {
    await flush();
    assert.equal(student.d.querySelector('#periodFilter').value,'2026-2027');
    assert.equal(student.d.querySelector('#categoryFilterWrap'),null);
    assert.match(student.d.querySelector('#categoryHeading').textContent,/Clasele 2/);
    assert.match(student.d.querySelector('#bookList').textContent,/1 & 2 Samuel/);
    assert.match(student.d.querySelector('#memorizationTitle').textContent,/Apocalipsa/);
    assert.equal(student.errors.length,0);
  } finally {student.close();}

  const instructor=await page('portal/instructor/bibliography.html',{records:{accounts:[{id:'self',username:'andrei',role:'instructor',study_category:'10-11'}]}});
  try {
    await flush();
    assert.equal(instructor.d.querySelector('#categoryFilterWrap').hidden,false);
    assert.equal(instructor.d.querySelector('#categoryFilter').value,'2-3');
    instructor.d.querySelector('#categoryFilter').value='10-11';
    instructor.d.querySelector('#categoryFilter').dispatchEvent(new instructor.w.Event('change'));
    assert.match(instructor.d.querySelector('#categoryHeading').textContent,/Clasele 10/);
    assert.match(instructor.d.querySelector('#bookList').textContent,/Evrei/);
    assert.equal(instructor.errors.length,0);
  } finally {instructor.close();}
});

test('Student leaderboard uses one list with metric and period filters',async()=>{
  const now = new Date();
  const records = [
    {student_username:'maria',points_total:18,max_points:100,created_at:now.toISOString()},
    {student_username:'andrei',points_total:10,max_points:100,created_at:new Date(now.getTime()-86400000).toISOString()},
    {student_username:'maria',points_total:4,max_points:100,created_at:new Date(now.getFullYear()-1,5,1).toISOString()},
  ];
  const p=await page('portal/student/leaderboard.html',{records:{student_test_attempts:records}});
  try {
    assert.equal(p.d.querySelectorAll('#leaderboard').length,1);
    assert.match(p.d.querySelector('#leaderboard').textContent,/maria/);
    const metric=p.d.querySelector('#leaderboardMetric');
    const period=p.d.querySelector('#leaderboardPeriod');
    metric.value='tests';period.value='all';
    metric.dispatchEvent(new p.w.Event('change'));period.dispatchEvent(new p.w.Event('change'));
    assert.match(p.d.querySelector('#leaderboard').textContent,/2 teste/);
    assert.match(p.d.querySelector('#leaderboardSubtitle').textContent,/Teste · Total/);
    assert.equal(p.errors.length,0);
  } finally {p.close();}
});

test('Student reports tab shows status and reviewer response',async()=>{
  const p=await page('portal/student/reports.html',{records:{question_reports:[{
    id:'report-1',question_book:'Ioan',question_chapter:3,question_text:'Întrebarea semnalată',reason_code:'incorrect',status:'resolved',student_message:'Cred că răspunsul este greșit.',reviewer_message:'Întrebarea a fost corectată.',created_at:new Date().toISOString(),
  }]}});
  try {
    assert.equal(p.d.querySelectorAll('.report-card').length,1);
    assert.match(p.d.querySelector('.report-status').textContent,/Rezolvată/);
    assert.match(p.d.querySelector('.report-card').textContent,/Întrebarea a fost corectată/);
    assert.equal(p.errors.length,0);
  } finally {p.close();}
});

test('Reviewers can inspect a report, change its status, and open the question editor',async()=>{
  const queryLog=[];
  const p=await page('portal/instructor/reports.html',{queryLog,records:{question_reports:[{
    id:'report-1',question_type:'tf',question_id:'question-1',question_book:'Ioan',question_chapter:3,question_text:'Întrebarea semnalată',reason_code:'typo',status:'open',student_username:'maria',student_message:'Lipsește un cuvânt.',created_at:new Date().toISOString(),
  }]}});
  try {
    assert.equal(p.d.querySelectorAll('.report-card').length,1);
    assert.match(p.d.querySelector('.report-card').textContent,/maria/);
    assert.match(p.d.querySelector('.report-card a').getAttribute('href'),/type=tf.*edit=question-1/);
    const status=p.d.querySelector('.report-review-form select');
    status.value='in_review';
    p.d.querySelector('.report-review-actions .btn.primary').click();await flush();
    assert.ok(queryLog.some(entry=>entry.table==='question_reports' && entry.method==='update'));
    assert.equal(p.errors.length,0);
  } finally {p.close();}
});

test('Book filters autocomplete while typing and filter the question list immediately',async()=>{
  const questionRows = [
    {...rows[0], book:'Geneza'},
    {...rows[1], book:'Psalmii'},
  ];
  const p=await page('portal/instructor/questions/list.html?type=tf',{records:{questions_tf:questionRows}});
  try {
    const filter=p.d.querySelector('#bookFilter');
    filter.value='psal';
    filter.dispatchEvent(new p.w.Event('input',{bubbles:true}));
    await flush();
    assert.ok(p.d.querySelector('.book-autocomplete-option'));
    assert.equal(p.d.querySelector('.book-autocomplete-option').textContent,'Psalmii');
    assert.equal(p.d.querySelectorAll('#tableBody tr').length,1);
    p.d.querySelector('.book-autocomplete-option').click();
    assert.equal(filter.value,'Psalmii');
    assert.equal(p.d.querySelectorAll('#tableBody tr').length,1);
    assert.equal(p.errors.length,0);
  } finally {p.close();}
});

test('Results book filter also supports instant text filtering and keyboard selection',async()=>{
  const attempt = (book, index) => ({
    created_at:new Date(Date.now() - index * 1000).toISOString(),
    points_total:10, max_points:100, total_correct_answers:1, total_questions:1, duration_seconds:60,
    tf_correct:1, tf_total:1, abc_one_correct:0, abc_one_total:0, abc_multi_correct:0, abc_multi_total:0,
    match_pairs_correct:0, breakdown:[{book}],
  });
  const p=await page('portal/student/results.html',{records:{student_test_attempts:[attempt('Geneza',0),attempt('Psalmii',1)]}});
  try {
    const filter=p.d.querySelector('#bookFilter');
    filter.value='psal';
    filter.dispatchEvent(new p.w.Event('input',{bubbles:true}));
    await flush();
    assert.equal(p.d.querySelectorAll('#resultsBody tr').length,1);
    filter.dispatchEvent(new p.w.KeyboardEvent('keydown',{key:'ArrowDown',bubbles:true}));
    filter.dispatchEvent(new p.w.KeyboardEvent('keydown',{key:'Enter',bubbles:true,cancelable:true}));
    assert.equal(filter.value,'Psalmii');
    assert.equal(p.d.querySelectorAll('#resultsBody tr').length,1);
    assert.equal(p.errors.length,0);
  } finally {p.close();}
});

test('Instructor dashboard book filter updates all category counters and links',async()=>{
  const records={};
  for(const table of ['questions_tf','questions_abc_one','questions_abc_multi','questions_match']) {
    records[table]=[{...rows[0],book:'Geneza'},{...rows[1],book:'Psalmii'}];
  }
  const p=await page('portal/instructor/dashboard.html',{records});
  try {
    await flush();
    assert.equal(p.d.querySelector('.welcome-banner'),null);
    assert.equal(p.d.querySelectorAll('.dashboard-grid .stat-card').length,4);
    assert.equal(p.d.querySelectorAll('.dashboard-grid .card-link').length,0);
    const filter=p.d.querySelector('#instructorBookFilter');
    filter.value='psal';
    filter.dispatchEvent(new p.w.Event('input',{bubbles:true}));
    await flush();
    for(const key of ['tf','abc_one','abc_multi','match']) assert.equal(p.d.querySelector(`#count_${key}`).textContent,'1',key);
    assert.match(p.d.querySelector('#instructorBookFilterInfo').textContent,/psal/);
    assert.match(p.d.querySelector('a.stat-card[data-type="tf"]').href,/book=psal/);
    assert.equal(p.errors.length,0);
  } finally {p.close();}
});

test('Instructor test generator reveals chapters only for one selected book',async()=>{
  const p=await page('portal/instructor/tests/create.html');
  try {
    const first=p.d.querySelector('#bookList input');
    first.click(); await flush();
    assert.equal(p.d.querySelector('#chaptersSection').hidden,false);
    assert.ok(p.d.querySelectorAll('#chapterList input').length >= 1);
    p.d.querySelectorAll('#bookList input')[1].click(); await flush();
    assert.equal(p.d.querySelector('#chaptersSection').hidden,true);
    assert.equal(p.d.querySelector('#generateTestBtn').disabled,false);
    assert.equal(p.errors.length,0);
  } finally {p.close();}
});

test('Instructor test generator warns about shortages and prioritizes difficulty',async()=>{
  const shortageRecords={};
  for(const table of ['questions_tf','questions_abc_one','questions_abc_multi','questions_match']) shortageRecords[table]=rows.slice(0,1);
  shortageRecords.questions_match=[{...rows[0],status:'Nou',pairs:[],options:rows[0].pairs}];
  const shortage=await page('portal/instructor/tests/create.html',{records:shortageRecords});
  try {
    shortage.d.querySelector('#bookList input').click(); await flush();
    assert.match(shortage.d.querySelector('#availabilityStatus').textContent,/Nu sunt suficiente/);
    assert.equal(shortage.d.querySelector('#generateTestBtn').disabled,true);
    assert.match(shortage.d.querySelector('#availabilityList').textContent,/1\/10/);
    assert.match(shortage.d.querySelector('#availabilityList').textContent,/Asociere\s*1\/1/);
  } finally {shortage.close();}

  const varied=Array.from({length:12},(_,index)=>({...rows[index],difficulty:(index%5)+1}));
  const records={questions_tf:varied,questions_abc_one:varied,questions_abc_multi:varied,questions_match:varied};
  let requestBody;
  let ready;
  ready=await page('portal/instructor/tests/create.html',{records,fetcher:async(_,options)=>{
    requestBody=JSON.parse(options.body);
    return {ok:true,blob:async()=>new ready.w.Blob(['test'])};
  }});
  try {
    ready.w.URL.createObjectURL=()=> 'blob:test'; ready.w.URL.revokeObjectURL=()=>{};
    ready.d.querySelector('#bookList input').click(); await flush();
    const difficulty=ready.d.querySelector('#difficultyRange'); difficulty.value='100'; difficulty.dispatchEvent(new ready.w.Event('input'));
    assert.equal(ready.d.querySelector('#difficultyValue').textContent,'100 / 100');
    assert.match(ready.d.querySelector('#difficultyHint').textContent,/mai dificile/);
    ready.d.querySelector('#generateTestBtn').click(); await flush();
    assert.equal(requestBody.difficulty,100);
    assert.equal(requestBody.sections.tf[0].difficulty,5);
    assert.equal(requestBody.sections.abc_one[0].difficulty,5);
    assert.equal(ready.d.querySelector('#generateTestBtn').disabled,false);
  } finally {ready.close();}
});
